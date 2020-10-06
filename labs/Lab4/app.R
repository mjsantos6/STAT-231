library(fivethirtyeight)
library(shinythemes)
library(tidyverse)

# define vectors for choice values and labels 
# can then refer to them in server as well (not just in defining widgets)
# for selectInput, needs to be named list
nfl_suspensions$games = as.integer(nfl_suspensions$games)
nfl_suspensions[c(0:6),3] = 40
x_choices <- as.list(names(nfl_suspensions)[c(2,6)])
x_choice_names <- c("team"
                    , "year")
              
names(x_choices) <- x_choice_names

# for radio button, can be separate (have choiceValues and choiceNames options, 
# rather than just choices)
y_choice_values = names(nfl_suspensions)[3]
y_choice_names <- c("games")

# for checkboxGroupInput (only have "choices" option, but these labels are fine)
div_choices <- (nfl_suspensions %>%
                  count(category))$category

# for selectInput choices, needs to be named list
st_choices <- as.list(c(nfl_suspensions$name))
names(st_choices) <- c(nfl_suspensions$name)


# ui 
ui <- fluidPage(
  
  
  h1("NFL Suspensions"),
  h2("Note: Indefinite suspensions were set to 40 games."),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput(inputId = "x"
                  , label = "Choose a predictor variable of interest:"
                  , choices = x_choices
                  , selected = "year"),
      radioButtons(inputId = "y"
                   , label = "Choose an outcome variable of interest:"
                   , choiceValues = y_choice_values
                   , choiceNames = y_choice_names
                   , selected = "games"),
      selectInput(inputId = "name"
                  , label = "Identify a player in the scatterplot:"
                  , choices = st_choices
                  , selected = "R. Rice")
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs"
                  , tabPanel("Histogram of the outcome"
                             , plotOutput(outputId = "hist"))
                  , tabPanel("Scatterplot", plotOutput(outputId = "scatter"))
                  , tabPanel("Table", tableOutput(outputId = "table"))
      )
    )
  )
)

# server
server <- function(input,output){
  
  use_data <- reactive({
    data <- filter(nfl_suspensions)
  })
  
  output$hist <- renderPlot({
    ggplot(data = use_data(), aes_string(x = input$y)) +
      geom_histogram(color = "#00215c", fill = "#00215c", alpha = 0.7) +
      labs(x = y_choice_names[y_choice_values == input$y]
           , y = "Number of Suspensions")
  })
  
  output$scatter <- renderPlot({
    ggplot(data = use_data(), aes_string(x = input$x, y = input$y)) +
      geom_point() +
      labs(x = names(x_choices)[x_choices == input$x]
           , y = y_choice_names[y_choice_values == input$y]) +
      geom_label(data = filter(nfl_suspensions, name == input$name)
                 , aes(label = name))
  })
  
  output$table <- renderTable({
    dplyr::select(use_data(), team, input$x, input$y)
  })
}

# call to shinyApp
shinyApp(ui = ui, server = server)


# Your turn.  Copy this code as a template into a new app.R file (WITHIN A FOLDER
# named something different than your other Shiny app folders).  Then, either 
# (1) update this template to still explore the hate_crimes dataset, but with
#     different app functionality (e.g. different widgets, variables, layout, theme...); 
#   OR
# (2) use this as a template to create a Shiny app for a different dataset:
#      either mad_men (tv performers and their post-show career), 
#             ncaa_w_bball_tourney (women's NCAA div 1 basketball tournament, 1982-2018), 
#             nfl_suspensions (NFL suspensions, 1946-2014), 
#             or candy_rankings (candy characteristics and popularity)
#      these four datasets are also part of the fivethirtyeight package
#      and their variable definitions are included in pdfs posted to the Moodle course page
