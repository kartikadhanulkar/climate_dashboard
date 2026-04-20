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

# ===============================
# 1. LIBRARIES
# ===============================
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)
library(DT)
library(slider)
library(caret)

# ===============================
# 2. LOAD DATA
# ===============================
data <- read.csv("archive (13)/global_warming_dataset.csv")

data$Year <- as.numeric(data$Year)

# ===============================
# 3. UI (ANALYTICAL + ML DASHBOARD)
# ===============================
ui <- dashboardPage(
  
  skin = "black",
  
  dashboardHeader(title = "🌍 Climate Analytics & Prediction"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dash", icon = icon("chart-line")),
      
      selectInput(
        "country",
        "🌎 Select Country:",
        choices = unique(data$Country)
      ),
      
      sliderInput(
        "year",
        "📅 Year Range:",
        min = min(data$Year),
        max = max(data$Year),
        value = c(2000, 2020)
      ),
      
      hr(),
      helpText("Analyze trends, relationships and predict future climate patterns.")
    )
  ),
  
  dashboardBody(
    
    tags$head(
      tags$style(HTML("
        body { background-color: #121212; color: white; }
        .box { border-radius: 12px; }
        .small-box { border-radius: 12px; }
      "))
    ),
    
    tabItems(
      
      tabItem(tabName = "dash",
              
              # KPI ROW
              fluidRow(
                valueBoxOutput("avgTemp", width = 3),
                valueBoxOutput("maxTemp", width = 3),
                valueBoxOutput("minTemp", width = 3),
                valueBoxOutput("yoY", width = 3)
              ),
              
              fluidRow(
                valueBoxOutput("corrBox", width = 12)
              ),
              
              # TREND
              fluidRow(
                box("Temperature Trend", plotlyOutput("tempPlot"), width = 6),
                box("CO2 Trend", plotlyOutput("co2Plot"), width = 6)
              ),
              
              # RELATIONSHIP
              fluidRow(
                box("CO2 vs Temperature", plotlyOutput("comparePlot"), width = 6),
                box("Global vs Country", plotlyOutput("globalCompare"), width = 6)
              ),
              
              # ML PREDICTION
              fluidRow(
                box("🤖 ML Prediction (Next 10 Years)", 
                    plotlyOutput("predictionPlot"), width = 12)
              ),
              
              # TABLES
              fluidRow(
                box("Top 5 Hottest Years", DTOutput("topYears"), width = 6),
                box("Dataset", DTOutput("table"), width = 6)
              )
      )
    )
  )
)

# ===============================
# 4. SERVER
# ===============================
server <- function(input, output) {
  
  # FILTER DATA
  filtered_data <- reactive({
    data %>%
      filter(
        Country == input$country,
        Year >= input$year[1],
        Year <= input$year[2]
      )
  })
  
  # KPI
  output$avgTemp <- renderValueBox({
    valueBox(round(mean(filtered_data()$Temperature_Anomaly, na.rm = TRUE),2),
             "Avg Temp", icon = icon("thermometer-half"), color = "yellow")
  })
  
  output$maxTemp <- renderValueBox({
    valueBox(max(filtered_data()$Temperature_Anomaly, na.rm = TRUE),
             "Max Temp", icon = icon("arrow-up"), color = "red")
  })
  
  output$minTemp <- renderValueBox({
    valueBox(min(filtered_data()$Temperature_Anomaly, na.rm = TRUE),
             "Min Temp", icon = icon("arrow-down"), color = "blue")
  })
  
  output$yoY <- renderValueBox({
    df <- filtered_data() %>% arrange(Year)
    change <- tail(df$Temperature_Anomaly,1) - head(df$Temperature_Anomaly,1)
    
    valueBox(round(change,2), "Temp Change", icon = icon("chart-line"), color = "green")
  })
  
  output$corrBox <- renderValueBox({
    corr <- cor(filtered_data()$CO2_Emissions,
                filtered_data()$Temperature_Anomaly,
                use="complete.obs")
    
    valueBox(round(corr,2), "Correlation", icon = icon("link"), color = "purple")
  })
  
  # TEMP PLOT
  output$tempPlot <- renderPlotly({
    df <- filtered_data()
    
    p <- ggplot(df, aes(Year, Temperature_Anomaly)) +
      geom_line(color="blue")
    
    ggplotly(p)
  })
  
  # CO2 PLOT
  output$co2Plot <- renderPlotly({
    p <- ggplot(filtered_data(), aes(Year, CO2_Emissions)) +
      geom_line(color="red")
    
    ggplotly(p)
  })
  
  # RELATIONSHIP
  output$comparePlot <- renderPlotly({
    p <- ggplot(filtered_data(), aes(Temperature_Anomaly, CO2_Emissions)) +
      geom_point() +
      geom_smooth(method="lm")
    
    ggplotly(p)
  })
  
  # GLOBAL
  output$globalCompare <- renderPlotly({
    global <- data %>%
      group_by(Year) %>%
      summarise(Global=mean(Temperature_Anomaly, na.rm=TRUE))
    
    p <- ggplot() +
      geom_line(data=global, aes(Year, Global), color="black") +
      geom_line(data=filtered_data(), aes(Year, Temperature_Anomaly), color="blue")
    
    ggplotly(p)
  })
  
  # TABLES
  output$topYears <- renderDT({
    filtered_data() %>%
      arrange(desc(Temperature_Anomaly)) %>%
      head(5)
  })
  
  output$table <- renderDT({
    filtered_data()
  })
  
  # ===============================
  # 🤖 ML MODEL (CARET)
  # ===============================
  output$predictionPlot <- renderPlotly({
    
    df <- filtered_data()
    df <- na.omit(df)
    
    model <- caret::train(
      Temperature_Anomaly ~ Year + CO2_Emissions,
      data = df,
      method = "lm"
    )
    
    future <- data.frame(
      Year = seq(max(df$Year), max(df$Year)+10),
      CO2_Emissions = mean(df$CO2_Emissions)
    )
    
    future$Predicted <- predict(model, newdata = future)
    
    p <- ggplot() +
      geom_line(data=df, aes(Year, Temperature_Anomaly), color="blue") +
      geom_line(data=future, aes(Year, Predicted), color="orange", linetype="dashed")
    
    ggplotly(p)
  })
}

# ===============================
# 5. RUN APP
# ===============================
shinyApp(ui, server)