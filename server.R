library(ggplot2)
library(reshape2)
library(dplyr)

load("sleep.data.RData")


shinyServer(
  function(input, output) {
    
    update.sleep.boxplot <- reactive({
      
      # filter data based on user selections
      sleep %>% 
        filter(date > input$dates[1], date < input$dates[2]) %>%
        filter(term %in% input$terms) %>%
        group_by(day) %>%
        mutate(average_hours = mean(hours))
    })
    
    update.sleep.histogram <- reactive({
      sleep
    })
    
    output$boxplot <- renderPlot({
                      ggplot(update.sleep.boxplot(), aes(x = day, y = hours)) + 
                        geom_boxplot() +
                        facet_wrap(~term, nrow=1)
                                })
    
    output$histogram <- renderPlot({
                        ggplot(update.sleep.histogram(), aes(x = hours)) +
                          geom_histogram(binwidth = input$bins)
                                  })
  
  }
)
