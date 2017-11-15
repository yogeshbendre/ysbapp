#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Author: YSB
#
# Following libraries must be installed to run this app
library(plotly)
library(shiny)
library(maps)
library(MASS)

# This server uses the data called us.cities from maps package. 
# This data containes cities in the united states, along with their lattitude, longitude and population.
data(us.cities)
us.all.cities=us.cities

# Preprocessing to classify cities into high, medium or less populated.
us.all.cities$pop_level="Medium"
us.all.cities[us.all.cities$pop<=40000,]$pop_level="Less"
us.all.cities[us.all.cities$pop>100000,]$pop_level="High"

# Create hover text to show in the map.
us.all.cities$text=with(us.all.cities,paste0(name,"<br>",pop))
cols <- c("red", "blue", "black")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  ## This server shows to types of plots:
  ## 1. Map showing citi locations and population using plotly.
  ## 2. Distribution of the population of the cities and corresponding Gaussian curve.
    
  output$geoPlot <- renderPlotly({
  
    ## Check which type of cities are requested. If none selected, we consider it as if all are selected.  
    us.cities=NULL
    if(!(input$HighPop | input$MedPop | input$LessPop)){
      us.cities=us.all.cities
    }
    if(input$HighPop){
      us.cities=rbind(us.cities,us.all.cities[us.all.cities$pop>100000,])
    }
    
    if(input$MedPop){
      us.cities=rbind(us.cities,us.all.cities[(us.all.cities$pop <= 100000) & (us.all.cities$pop > 40000),])
    }
    
    if(input$LessPop){
      us.cities=rbind(us.cities,us.all.cities[us.all.cities$pop<=40000,])
    }  
    
    dim(us.cities)
    
    ## Use plotly to plot the map of chosen cities.    
    us.cities %>%
      plot_geo(x = ~long, y = ~lat, mode = "text", text = ~text) %>%
      add_markers(color = ~us.cities$pop_level, 
                  colors = cols) %>%  layout(title = 'Populations in US Cities')
    
  })
  
  output$popDensityPlot <- renderPlot({
    ## Check which type of cities are requested. If none selected, we consider it as if all are selected.    
    us.cities=NULL
    if(!(input$HighPop | input$MedPop | input$LessPop)){
      us.cities=us.all.cities
    }
    if(input$HighPop){
      us.cities=rbind(us.cities,us.all.cities[us.all.cities$pop>100000,])
    }
    
    if(input$MedPop){
      us.cities=rbind(us.cities,us.all.cities[(us.all.cities$pop <= 100000) & (us.all.cities$pop > 40000),])
    }
    
    if(input$LessPop){
      us.cities=rbind(us.cities,us.all.cities[us.all.cities$pop<=40000,])
    }  
    
    dim(us.cities)
    
    ## Plot the histogram of chosen cities
    x    <- log(us.cities$pop)
    
    hist(x, col = "#75AADB", border = "white", prob=TRUE,
         xlab = "Population in the selected US cities (log to base e)",
         main = "Distribution of Population")
    
    curve(dnorm(x, mean=mean(x), sd=sqrt(var(x))), 
          col="darkblue", lwd=2, add=TRUE, yaxt="n")
    
    
  })
  
})
