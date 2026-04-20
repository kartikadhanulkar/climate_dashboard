# Climate Analytics and Prediction Dashboard

##  Project Description

The **Climate Analytics and Prediction Dashboard** is an interactive web application developed using **R Shiny**. The application is designed to analyze historical climate data and provide meaningful insights into temperature trends, CO₂ emissions, and their relationship.

In addition to descriptive and exploratory analysis, the dashboard integrates a **Machine Learning model** to forecast future temperature trends, enabling predictive analysis of climate patterns.


##  Objectives

* To analyze historical temperature variations across different countries
* To study the impact of CO₂ emissions on temperature changes
* To compare country-specific trends with global climate patterns
* To identify extreme temperature years
* To implement a Machine Learning model for future prediction



##  Tools and Technologies

* **R Programming Language**
* **Shiny** – Web application framework
* **shinydashboard** – Dashboard layout and UI design
* **ggplot2** – Data visualization
* **plotly** – Interactive visualizations
* **dplyr** – Data manipulation
* **DT** – Interactive data tables
* **caret** – Machine Learning framework



##  Key Features

### 1. Key Performance Indicators (KPIs)

* Average Temperature
* Maximum Temperature
* Minimum Temperature
* Temperature Change over selected period
* Correlation between CO₂ emissions and temperature



### 2. Trend Analysis

* Visualization of temperature trends over time
* Analysis of CO₂ emission patterns



### 3. Relationship Analysis

* Scatter plot illustrating the relationship between CO₂ emissions and temperature
* Regression line to understand correlation trends



### 4. Global Comparison

* Comparative analysis between selected country and global temperature trends


### 5. Data Exploration

* Display of top 5 hottest years
* Interactive table of filtered dataset



### 6. Machine Learning Prediction

* Implementation of **Multiple Linear Regression** using the `caret` package
* Prediction of temperature trends for the next 10 years
* Model based on:

  * Year
  * CO₂ Emissions



##  Machine Learning Methodology

The predictive component of the application uses a **Multiple Linear Regression model**, trained using historical data.

* **Dependent Variable:** Temperature Anomaly
* **Independent Variables:** Year, CO₂ Emissions

The model is trained using the `caret` package and applied to forecast future temperature values, providing insights into potential climate trends.



##  How to Run the Application

1. Install required packages:


install.packages(c("shiny", "shinydashboard", "ggplot2", "dplyr", "plotly", "DT", "slider", "caret"))


2. Ensure the dataset is placed in the project directory:


archive (13)/global_warming_dataset.csv


3. Run the application:


shinyApp(ui, server)




##  Dataset Information

The dataset contains historical climate data, including:

* Country
* Year
* Temperature Anomaly
* CO₂ Emissions



##  Results

The dashboard enables:

* Interactive filtering and visualization
* Insightful analysis of climate trends
* Identification of relationships between variables
* Prediction of future temperature patterns


##  Conclusion

This project demonstrates the integration of **data analytics and machine learning** techniques to analyze and predict climate behavior. The application provides an intuitive interface for exploring complex datasets and deriving actionable insights.



##  Author

Kartika Dhanulkar And Suyash Vaidya



##  Future Enhancements

* Integration of advanced models such as Random Forest and Time Series (ARIMA)
* Inclusion of geographical visualizations (maps)
* Multi-country comparative analysis
* Model performance evaluation metrics (R², RMSE)
