library(shiny)

shinyUI(navbarPage("Counting Sheep",
                    
  tabPanel("Boxplots", 
           
           h3("Counting Sheep: A Year's Worth of Sleep"),
           
           plotOutput("main"),
           
           hr(),
           
           
           
           fluidRow(
             
             column(5, 
                    dateRangeInput("dates", "Date Range", 
                                   start = min(sleep$date), 
                                   end = max(sleep$date), 
                                   min = min(sleep$date), 
                                   max = max(sleep$date))
                    ),
             
             column(7, 
                    checkboxGroupInput("terms", "Terms to Display", 
                                       choices = levels(sleep$term), 
                                       selected = levels(sleep$term), 
                                       inline = FALSE)
                    )

            )
  ),
  
  tabPanel("Histogram",
           
           plotOutput("main"),
           
           hr(),
           
           sliderInput("bins", "Bin Size (Hours)", 
                       min = 0, max = max(sleep$hours),
                       value = 1, step = 0.5)
           
           )
))
