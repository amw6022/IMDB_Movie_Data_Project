#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)


# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Movie Picking Tool (Prototype)"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
      sidebarPanel(
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
         radioButtons("rate", "Viewer Rating", choices = list("G" = 1, "PG" = 2,
                        "PG-13" = 3, "R" = 4, "TV-MA" = 5, "TV-14" = 6, "Not Rated" = 7, "Unrated" = 8, "Approved" = 9,
                        "TV-Y7" = 10, "GP" = 11, "NC-17" = 12, "Passed" = 13, "TV-G" = 14, "TV-PG" = 15, "TV-Y" = 16,
                        "X" = 17)),
         sliderInput("timeline", "Produced (by Year)",
                     min = 1950,
                     max = 2020,
                     value = 1980),
         textInput("direct", "Director Name:", value = "", width = NULL, placeholder = "Steven Spielberg"),
         textInput("actor", "Actor Name:", value = "", width = NULL, placeholder = "Jim Carrey"),
         sliderInput("gross", "Gross Income:",
                     min = 150,
                     max = 800000000,
                     value = c(250000000, 500000000)),
         sliderInput("imscore", "iMDB Score",
                     min = 0,
                     max = 10,
                     value = c(3,5))


      ),

      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  db <- read.csv("movie_metadata.csv")

}
# Run the application
shinyApp(ui = ui, server = server)

