#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggvis)
library(dplyr)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Movie Picking Tool (Prototype)"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
      sidebarPanel(
         textInput("title", "Movie Name:",""),
         sliderInput("imscore", "iMDB Score",
                     min = 0,
                     max = 10,
                     value = c(5,8)),
         sliderInput("timeline", "Produced (by Year)",
                     min = 1950,
                     max = 2020,
                     value = c(1975, 2015)),
         
         sliderInput("length",
                     "Duration (by minute)",
                     min = 7,
                     max = 511,
                     value = c(90, 200)),
         checkboxGroupInput("genres","Genres", choices = list("Action" = 1, "Adventure" = 2,
                     "Animation" = 3, "Drama" = 4, "Family" = 5, "Sci-Fi" = 6, "Crime" = 7, "Comedy" = 8,
                     "Fantasy" = 9, "Biography" = 10, "Mystery" = 11, "Romance" = 12, "Thriller" = 13, "War" = 14,
                     "Horror" = 15, "History" = 16, "Musical" = 17, "Western" = 18, "Sport" = 19, "Music" = 20, "Documentary" = 21)
                     ),
         radioButtons("rate", "Viewer Rating", choices = list("Any" = 0, "G" = 1, "PG" = 2,
                        "PG-13" = 3, "R" = 4, "TV-MA" = 5, "TV-14" = 6, "Not Rated" = 7, "Unrated" = 8, "Approved" = 9,
                        "TV-Y7" = 10, "GP" = 11, "NC-17" = 12, "Passed" = 13, "TV-G" = 14, "TV-PG" = 15, "TV-Y" = 16,
                        "X" = 17)),
         textInput("direct", "Director Name:", value = "", width = NULL, placeholder = "Steven Spielberg"),
         textInput("actor", "Actor Name:", value = "", width = NULL, placeholder = "Jim Carrey"),
         sliderInput("gross", "Gross Income:",
                     min = 150,
                     max = 800000000,
                     value = c(250000000, 500000000))
),

      # Show a plot of the generated distribution
      mainPanel(
         ggvisOutput("distPlot"),
         wellPanel(
          DT::dataTableOutput('mytable')
          #textOutput('txt')
         )
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output,session){
  
  data = data = read.csv('movie_metadata.csv', header=TRUE)
  y = c(rep(NA, dim(data)[1]))
  for (i in 1:dim(data)[1]){
    x = as.character(data[i, 'movie_title'])
    x = trimws(x, which='both')
    y[i] = x
  }
  data$movie_title = y
  data$id = 1:nrow(data)
  genre_list = c('Action', 'Adventure', 'Animation', 'Drama', 'Family', 'Sci-Fi', 'Crime',
                 'Comedy', 'Fantasy', 'Biography', 'Mystery', 'Romance', 'Thriller', 'War',
                 'Horror', 'History', 'Musical', 'Western', 'Sport', 'Music', 'Documentary')
  movies = reactive({
    minDuration = input$length[1]
    maxDuration = input$length[2]
    minYear = input$timeline[1]
    maxYear = input$timeline[2]
    minGross = input$gross[1]
    maxGross = input$gross[2]
    minRating = input$imscore[1]
    maxRating = input$imscore[2]
    
    filter_data = filter(data,
                         duration >= minDuration,
                         duration <= maxDuration,
                         title_year >= minYear,
                         title_year <= maxYear,
                         gross >= minGross,
                         gross <= maxGross,
                         imdb_score >= minRating,
                         imdb_score <= maxRating)
    
    if(!is.null(input$actor) && input$actor !=''){
      actor = paste0('%', input$actor, '%')
      filtered_data = filter(filtered_data, actor_1_name %like% actor |
                               actor_2_name %like% actor | actor_3_name %like% actor)
    }
    filter_data = as.data.frame(filter_data)
    filter_data
      })
  
  movie_info = function(x){
    if (is.null(x)) return (NULL)
    if (is.null(x$id)) return(NULL)
    my_movies = isolate(movies())
    movie = my_movies[my_movies$id == x$id,]
    paste0('<b>', movie$movie_title, '</b><br>', movie$title_year, '<br>',
           movie$imdb_score, '<br>',
           '$', format(movie$budget, big.mark = ',', scientific=FALSE))
  }
  
  intervis = reactive({
    #s1 = input$x1_rows_current
    #new_movies = movies()
    #new_movies$selected=c(rep(NA, nrow(new_movies)))
    #for (i in 1:nrow(new_movies)){
    #  new_movies[i,'selected'] = (new_movies[i,'id'] %in% s1)
    #}
    vis = ggvis(movies(), x=~imdb_score, y=~budget, key:=~id) %>%
      layer_points(size:=50, size.hover:=200, 
                   fillOpacity:=0.2, fillOpacity.hover:=0.5, key:=~id, fill:='#9932CC') %>%
      add_tooltip(movie_info, 'hover') %>%
      add_tooltip(movie_link, 'click') %>%
      add_axis('x', title='iMDB Rating') %>%
      add_axis("y", title = 'Budget ($)', properties=axis_props(title=list(dy=-50)))%>%
#      scale_nominal('stroke', domain = c(TRUE, FALSE),
#                    range = c('#1db954','#fd5c63')) %>%
      set_options(width=500, height=500)
  })
  
  #myvars = names(isolate(movies())) %in% c('movie_title', 'duration', 'gross', 'title_year', 'imdb_score')
  #new = isolate(movies())[myvars]
  #colnames(new) = c('Title', 'Duration (mins)', 'Gross ($)', 'Year', 'Rating')
  
  new_table = reactive({
    temp = movies()
    new = cbind(temp$movie_title, temp$duration, temp$gross, temp$title_year, temp$imdb_score)
    new = as.data.frame(new)
    colnames(new) = c('Title', 'Duration (mins)', 'Gross ($)', 'Year', 'Rating')
    new$Title = paste0("<a href='",temp$movie_imdb_link,"' target='_blank'>",new$Title,"</a>")
    new
  })
  output$mytable = DT::renderDataTable({
    new_data = new_table()
    DT::datatable(new_data, escape=FALSE)
  })
  bind_shiny(intervis, 'distPlot')
  
#  output$txt = renderText({
#    as.character(reactiveValuesToList(input)[16])
#  })
}

# Run the application
shinyApp(ui = ui, server = server)
