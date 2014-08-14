library(shiny, dplyr)

load("sleep.data.RData")

shinyServer(
  function(input, output) {
    
    update.sleep <- reactive({
      
      # filter data based on user selections
      sleep %>% 
        filter(date > input$dates[1], date < input$dates[2]) %>%
        group_by(day) %>%
        mutate(average_hours = mean(hours))
    })
  
  output$main <- renderPlot({
    ggplot(update.sleep(), aes(x = day, y = hours)) +
      geom_bar(stat="identity")
  })
  
  }
)
