
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Counting Sheep: A Year's Worth of Sleep"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      dateRangeInput("dates", "Date Range", 
                     start = min(sleep$date), end = max(sleep$date), 
                     min = min(sleep$date), max = max(sleep$date))
      ),
    
    mainPanel(
      plotOutput(outputId = "main")
    ))
  
  ))
