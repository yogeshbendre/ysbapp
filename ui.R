#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# Author: YSB
# You must install following libraries to use this app

library(shiny)
library(plotly)

# UI definition to plot the map and histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Populations in various cities of US"),
  
  # Sidebar with checkboxes to select the type of population 
  sidebarLayout(
    sidebarPanel(
       h3("Select appropriate population type to explore and click Refresh"),
       h5("(For better rendering of map please open in browser.)"),
       hr(),
       checkboxInput("HighPop","Highly Populated",value=TRUE),
       checkboxInput("MedPop","Medium Populated",value=TRUE),
       checkboxInput("LessPop","Less Populated",value=TRUE),
       submitButton("Refresh"),
       hr(),
       h3("Interesting Facts..."),
       hr(),
       h4("It is interesting to note that, among less populated cities, cities with very less population are very less...!!!"),
       h4("Among cities with high population, cities with very high population are..., nah, not high, very less...!!!"),
       h4("And finally, among cities with medium population, cities with medium population are, yeah, very high...!!!"),
       a("Click here for github link of code",href="http://github.com/yogeshbendre/ysbapp")
       
    ),
    
    # Show the map and plot of the chosen data
    mainPanel(
       plotlyOutput("geoPlot"),
       plotOutput("popDensityPlot")
    )
  )
))
