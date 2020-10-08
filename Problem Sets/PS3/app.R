library(shiny)
ui <- fluidPage(
  titlePanel("First Shiny"),
  sidebarLayout(
    sidebarPanel(
  sliderInput(inputId = "num", 
              label = "Choose a number", 
              value = 25, min = 1, max = 100),
  textInput(inputId = "title", 
            label = "Write a title",
            value = "Histogram of Random Normal Values"),
  navlistPanel(              
    tabPanel(title = "Normal data",
             plotOutput("norm"),
             actionButton("renorm", "Resample")
    ),
  plotOutput("hist"),
  verbatimTextOutput("stats")
  )
    )
  )
)
server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num))
  })
  output$stats <- renderPrint({
    summary(rnorm(input$num))
  })
}
runApp("Shiny")
runApp("")