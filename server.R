
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny, dplyr)

load("sleep.data.RData")

shinyServer(
  function(input, output) {
    
    update.sleep <- reactive({
      
      # filter data based on user selections
      sleep %>% filter(Date > input$dates[1], Date < input$dates[2])
    })
  
  output$test <- renderPlot({
    qplot(x=Day, y=Hours, data=update.sleep(), geom="bar", stat="identity")})
})
