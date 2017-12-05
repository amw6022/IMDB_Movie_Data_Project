#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Tara's changes - take 3.

library(stat297)
library(shiny)
library(DT)

axis_vars <- c(
  "Duration (by minute)" = "length",
  "Year Produced" = "timeline",
  "Gross Income" = "gross"
)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Movie Picking Tool (Prototype)"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      checkboxInput('header', 'Header', TRUE),
      textInput("title", "Movie Name:",""),
      checkboxGroupInput("genres","Genres", choices = list("Action" = 1, "Adventure" = 2,
                                                           "Animation" = 3, "Drama" = 4, "Family" = 5, "Sci-Fi" = 6, "Crime" = 7, "Comedy" = 8,
                                                           "Fantasy" = 9, "Biography" = 10, "Mystery" = 11, "Romance" = 12, "Thriller" = 13, "War" = 14,
                                                           "Horror" = 15, "History" = 16, "Musical" = 17, "Western" = 18, "Sport" = 19, "Music" = 20, "Documentary" = 21)
                         ,selected = 1),
      sliderInput("length",
                  "Duration (by minute)",
                  min = 7,
                  max = 511,
                  value = 300),
      checkboxGroupInput("rate", "Viewer Rating", choices = list("G" = 1, "PG" = 2,
                                                                 "PG-13" = 3, "R" = 4, "TV-MA" = 5, "TV-14" = 6, "Not Rated" = 7, "Unrated" = 8, "Approved" = 9,
                                                                 "TV-Y7" = 10, "GP" = 11, "NC-17" = 12, "Passed" = 13, "TV-G" = 14, "TV-PG" = 15, "TV-Y" = 16,
                                                                 "X" = 17)),
      sliderInput("timeline", "Year Produced",
                  min = 1950,
                  max = 2020,
                  value = 1980),
      textInput("direct", "Director Name:", value = "", width = NULL, placeholder = "Steven Spielberg"),
      textInput("actor", "Actor Name:", value = "", width = NULL, placeholder = "Jim Carrey"),
      sliderInput("gross", "Gross Income:",
                  min = 150,
                  max = 800000000,
                  value = c(250000000, 500000000)),
      selectInput("xvar", "X-axis variable", axis_vars, selected = "Meter"),
      selectInput("yvar", "Y-axis variable", axis_vars, selected = "Reviews"),
      tags$small(paste0(
        "Optional: User may upload their own CSV file containing movie data. "
      )),
      fileInput('file1', 'Choose CSV File', multiple = TRUE,
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv'))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      DT::dataTableOutput("contents")
      # plotOutput("Plot", width = "100%", height = "400px", click = NULL,
      # dblclick = NULL, hover = NULL, hoverDelay = NULL,
      # hoverDelayType = NULL, brush = NULL, clickId = NULL, hoverId = NULL,
      # inline = FALSE)
    )
  )
)

# -------server function------------------------------------------------------------------------------------------------

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output,session){
  
  data <- reactive({
    
    inFile <- input$file1 
    
    if (is.null(inFile)) {
      # Read movie_data
      movie_data <- read.csv("C:\\Users\\tarap\\Documents\\Academics\\SEMESTER 7\\STAT 297\\group4_project\\movie_metadata.csv")
    } else {
      # Read user csv input data
      inFile <- input$file1 
      movie_data <- read.csv(inFile$datapath, header = input$header, sep = input$sep,
                             quote = input$quote)
    }
    
    # Update inputs (you could create an observer with both updateSel...)
    # You can also constraint your choices. If you wanted select only numeric
    # variables you could set "choices = sapply(df, is.numeric)"
    # It depends on what you want to do later on.
    
    updateSelectInput(session, inputId = 'xcol', label = 'X Variable',
                      choices = names(movie_data), selected = names(movie_data))
    updateSelectInput(session, inputId = 'ycol', label = 'Y Variable',
                      choices = names(movie_data), selected = names(movie_data)[2])
    
    return(movie_data)
    
    
    # Define side panel categories
    # categories <- names(movie_data)
    
    # output$Plot <- renderPlot({
    
    # plot(movie_data$genres, movie_data$duration)
    
  })
  
  output$contents <- renderDataTable({
    data()
  })
  
})


# Run the application
shinyApp(ui = ui, server = server)

