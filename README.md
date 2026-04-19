# climate_dashboard
A dashboard for climate analysis
# Climate Intelligence Dashboard

## Overview

The Climate Intelligence Dashboard is an interactive web application developed using R Shiny to analyze global climate change trends. It enables users to explore temperature anomalies and CO₂ emissions across different countries and time periods through dynamic visualizations and key performance indicators.



## Key Features

* Country-wise filtering and analysis
* Interactive time-series visualization of temperature trends
* CO₂ emissions trend analysis
* Correlation analysis between temperature and CO₂ emissions
* Comparative analysis of country vs global trends
* Identification of top 5 hottest years
* Interactive data table for detailed exploration



## Technology Stack

* **Programming Language:** R
* **Framework:** Shiny, shinydashboard
* **Visualization:** ggplot2, plotly
* **Data Manipulation:** dplyr
* **Tables:** DT



## Dataset

The application utilizes a global climate dataset spanning from 1900 to 2023. The dataset includes the following attributes:

* Country
* Year
* Temperature Anomaly
* CO₂ Emissions


## Installation and Setup

### 1. Clone the Repository

bash
git clone https://github.com/your-username/climate-dashboard.git


### 2. Open in RStudio

Open the project folder in RStudio.

### 3. Install Required Packages

r
install.packages(c("shiny", "shinydashboard", "ggplot2", "plotly", "dplyr", "DT"))


### 4. Run the Application

r
shiny::runApp()




## Usage

* Select a country from the dropdown menu
* Adjust the year range using the slider
* Analyze trends, correlations, and insights through interactive charts and metrics



## Project Objective

The objective of this project is to provide a comprehensive and interactive platform for analyzing climate change indicators, helping users understand long-term trends and relationships between temperature variations and CO₂ emissions.



## Future Enhancements

* Integration of predictive analytics and forecasting models
* Interactive geographical visualizations (maps)
* Automated insights and anomaly detection
* Deployment as a live web application



## Author
Kartika Dhanulkar And 
Suyash Vaidya
