#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Movie Picking Tool (Prototype)"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
      sidebarPanel(
         textInput("title", "Movie Name:",""),
         selectInput("genres","Genres", choices = list("Action" = 1, "Adventure" = 2,
                     "Animation" = 3, "Drama" = 4, "Family" = 5, "Sci-Fi" = 6, "Crime" = 7, "Comedy" = 8,
                     "Fantasy" = 9, "Biography" = 10, "Mystery" = 11, "Romance" = 12, "Thriller" = 13, "War" = 14,
                     "Horror" = 15, "History" = 16, "Musical" = 17, "Western" = 18, "Sport" = 19, "Music" = 20, "Documentary" = 21)
                     ,selected = 1),

         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 50,
                     value = 30)
      ),

      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2]
      bins <- seq(min(x), max(x), length.out = input$bins + 1)

      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application
shinyApp(ui = ui, server = server)

