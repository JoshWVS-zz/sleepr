library(ggplot2)
library(reshape2)
library(dplyr)

load("sleep.data.RData")


shinyServer(
  function(input, output) {
    
    update.sleep <- reactive({
      
      # filter data based on user selections
      sleep %>% 
        filter(date > input$dates[1], date < input$dates[2]) %>%
        filter(term %in% input$terms) %>%
        group_by(day) %>%
        mutate(average_hours = mean(hours))
    })
  
  output$main <- renderPlot({
    ggplot(update.sleep(), aes(x = day, y = hours)) +
      geom_boxplot() +
      facet_wrap(~term, nrow = 1)
  })
  
  }
)
