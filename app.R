#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)


# CODE

# 1. Load libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)
library(DT)
library(shinythemes)
library(slider)
# 2. Load data
data <- read.csv("archive (13)/global_warming_dataset.csv")
library(shiny)
library(shinydashboard)
library(plotly)
library(DT)
library(ggplot2)
library(shinythemes)
library(slider)

ui <- dashboardPage(
  
  # =========================
  # HEADER
  # =========================
  dashboardHeader(title = "🌍 Climate Intelligence Dashboard"),
  
  # =========================
  # SIDEBAR
  # =========================
  dashboardSidebar(
    
    selectInput(
      "country",
      "Select Country:",
      choices = unique(data$Country)
    ),
    
    sliderInput(
      "year",
      "Select Year Range:",
      min = min(data$Year),
      max = max(data$Year),
      value = c(2000, 2020)
    ),
    
    hr(),
    
    helpText("Analyze temperature, CO2 emissions, and climate trends interactively.")
  ),
  
  # =========================
  # BODY
  # =========================
  dashboardBody(
    
    # ---- KPI ROW 1 ----
    fluidRow(
      valueBoxOutput("avgTemp"),
      valueBoxOutput("maxTemp"),
      valueBoxOutput("minTemp"),
      valueBoxOutput("yoY")
    ),
    
    # ---- KPI ROW 2 ----
    fluidRow(
      valueBoxOutput("corrBox")
    ),
    
    # ---- MAIN GRAPHS ----
    fluidRow(
      box(
        title = "Temperature Trend (Smoothed)",
        plotlyOutput("tempPlot"),
        width = 6
      ),
      
      box(
        title = "CO2 Emissions Trend",
        plotlyOutput("co2Plot"),
        width = 6
      )
    ),
    
    # ---- RELATIONSHIP + GLOBAL ----
    fluidRow(
      box(
        title = "CO2 vs Temperature (Regression)",
        plotlyOutput("comparePlot"),
        width = 6
      ),
      
      box(
        title = "Country vs Global Trend",
        plotlyOutput("globalCompare"),
        width = 6
      )
    ),
    
    # ---- DATA TABLE ----
    fluidRow(
      box(
        title = "Top 5 Hottest Years",
        DTOutput("topYears"),
        width = 6
      ),
      
      box(
        title = "Full Filtered Dataset",
        DTOutput("table"),
        width = 6
      )
    )
  )
)


server <- function(input, output) {
  
  # =========================
  # FILTERED DATA
  # =========================
  filtered_data <- reactive({
    data %>%
      dplyr::filter(
        Country == input$country,
        Year >= input$year[1],
        Year <= input$year[2]
      )
  })
  
  # =========================
  # KPI 1: Average Temperature
  # =========================
  output$avgTemp <- renderValueBox({
    valueBox(
      round(mean(filtered_data()$Temperature_Anomaly, na.rm = TRUE), 2),
      "Avg Temperature",
      icon = icon("thermometer-half"),
      color = "yellow"
    )
  })
  
  # =========================
  # KPI 2: Max Temperature
  # =========================
  output$maxTemp <- renderValueBox({
    valueBox(
      max(filtered_data()$Temperature_Anomaly, na.rm = TRUE),
      "Max Temperature",
      icon = icon("arrow-up"),
      color = "red"
    )
  })
  
  # =========================
  # KPI 3: Min Temperature
  # =========================
  output$minTemp <- renderValueBox({
    valueBox(
      min(filtered_data()$Temperature_Anomaly, na.rm = TRUE),
      "Min Temperature",
      icon = icon("arrow-down"),
      color = "blue"
    )
  })
  
  # =========================
  # KPI 4: Year-over-Year Change
  # =========================
  output$yoY <- renderValueBox({
    
    df <- filtered_data() %>% arrange(Year)
    
    change <- tail(df$Temperature_Anomaly, 1) -
      head(df$Temperature_Anomaly, 1)
    
    valueBox(
      round(change, 2),
      "Temp Change (Start → End)",
      icon = icon("chart-line"),
      color = "green"
    )
  })
  
  # =========================
  # KPI 5: Correlation
  # =========================
  output$corrBox <- renderValueBox({
    
    corr <- cor(
      filtered_data()$CO2_Emissions,
      filtered_data()$Temperature_Anomaly,
      use = "complete.obs"
    )
    
    valueBox(
      round(corr, 2),
      "CO2 vs Temperature Correlation",
      icon = icon("link"),
      color = "purple"
    )
  })
  
  # =========================
  # TEMPERATURE TREND (SMOOTHED)
  # =========================
  output$tempPlot <- renderPlotly({
    
    df <- filtered_data() %>%
      arrange(Year) %>%
      mutate(
        MA = slider::slide_dbl(
          Temperature_Anomaly,
          mean,
          .before = 2,
          .after = 2,
          .complete = TRUE
        )
      )
    
    p <- ggplot(df, aes(x = Year)) +
      geom_line(aes(y = Temperature_Anomaly), color = "gray") +
      geom_line(aes(y = MA), color = "blue") +
      labs(title = "Temperature Trend (Smoothed)")
    
    ggplotly(p)
  })
  # =========================
  # CO2 TREND
  # =========================
  output$co2Plot <- renderPlotly({
    
    p <- ggplot(filtered_data(), aes(Year, CO2_Emissions)) +
      geom_line(color = "red") +
      labs(title = "CO2 Emissions Trend")
    
    ggplotly(p)
  })
  
  # =========================
  # RELATIONSHIP + REGRESSION
  # =========================
  output$comparePlot <- renderPlotly({
    
    df <- filtered_data()
    
    p <- ggplot(df, aes(Temperature_Anomaly, CO2_Emissions)) +
      geom_point(color = "purple") +
      geom_smooth(method = "lm", color = "black") +
      labs(title = "CO2 vs Temperature Relationship")
    
    ggplotly(p)
  })
  
  # =========================
  # GLOBAL COMPARISON
  # =========================
  output$globalCompare <- renderPlotly({
    
    global <- data %>%
      group_by(Year) %>%
      summarise(Global_Temp = mean(Temperature_Anomaly, na.rm = TRUE))
    
    country <- filtered_data()
    
    p <- ggplot() +
      geom_line(data = global, aes(Year, Global_Temp), color = "black") +
      geom_line(data = country, aes(Year, Temperature_Anomaly), color = "blue") +
      labs(title = "Country vs Global Temperature Trend")
    
    ggplotly(p)
  })
  
  # =========================
  # TOP 5 HOTTEST YEARS
  # =========================
  output$topYears <- renderDT({
    filtered_data() %>%
      arrange(desc(Temperature_Anomaly)) %>%
      head(5)
  })
  
  # =========================
  # FULL TABLE
  # =========================
  output$table <- renderDT({
    filtered_data()
  })
}
# 5. Run app
shinyApp(ui = ui, server = server)
