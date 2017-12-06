library(shiny)
library(maps) 
library(mapproj) 


source("helpers.R") 


counties<-readRDS("data/counties.rds") 


ui <- fluidPage(
  
  titlePanel("censusVis"),
  
  sidebarLayout(
      
    sidebarPanel(
      helpText(
      "Create demographic maps with information from the 2010 US Census."
    ),
    
    selectInput(
      "var",     # will be called after by using input$var in the output function 
      label = "Choose a variable to display",
      choices = list("Percent White", "Percent Black", "Percent Hispanic", "Percent Asian"),
      selected = "Percent White"
    ),
    
    sliderInput(
      "range",   # will be called after by using input$range in the output function (a sliderInput contains two values [min,max])
      label = "Range of interest:",
      min = 0, max = 100, value = c(0, 100))
    ),
  
    mainPanel(
#     textOutput("selected_var"),
#     textOutput("min_max"),
      
      plotOutput("map")
      #The functions have to be defined in the sever part
    )
  )
)

server <- function(input, output) {
  
  # Definition des fonctions render qui permettent un affichage en temps reel
  
#  output$selected_var <- renderText({ 
#    paste("You have selected", input$var)
#  })
  
#  output$min_max <- renderText({ 
#    paste("You have chosen a range that goes from",
#          input$range[1], "to", input$range[2])
#  })
  
  
  output$map <- renderPlot({ 
    
    data <- switch(input$var, 
                   "Percent White" = counties$white, 
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian) 
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    
    #percent_map(counties$white, "darkgreen", "% White")
    percent_map(data, color, input$var, input$range[1], input$range[2]) 
    
  })
}

shinyApp(ui, server)