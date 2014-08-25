library(shiny)

shinyUI(navbarPage("Counting Sheep", id = "tab",
                    
  tabPanel("Boxplots", value = "boxplot",
           
           h3("Counting Sheep: A Year's Worth of Sleep"),
           
           plotOutput("boxplot"),
           
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
  
  tabPanel("Histogram", value = "histogram",
           
           plotOutput("histogram"),
           
           hr(),
           
           sliderInput("bins", "Bin Size (Hours)", 
                       min = 0.1, max = 3,
                       value = 1, step = 0.1)
           
           ),
  
  tabPanel("Scatterplot", value = "scatterplot",
           
           plotOutput("scatterplot"),
           
           hr(),
           
           checkboxInput("smooth", "Show trend ribbon", TRUE),
           
           selectInput("ribbon_method", "Trend ribbon method", 
                       c("loess", "lm", "glm", "rlm", "gam"),
                       selectize = FALSE)
           )
))
