#' @title Add Movie Tooltip Text
#' @description Add interactive tooltip information about each movie on a reactive movie plot.
#' @param x  A 2 dimensional data frame containing movie information in a tabular format
#' @return an html command to paste the desired information into the tooltip text output.
#' @author Dylan Shoemaker
#' @importFrom shiny isolate
#' @export
#' @examples
#' movie_info(movie_data_table)
movie_info = function(x){
  if (is.null(x)) return (NULL)
  if (is.null(x$id)) return(NULL)
  my_movies = isolate(movies())
  movie = my_movies[my_movies$id == x$id,]
  paste0('<b>', movie$movie_title, '</b><br>', movie$title_year, '<br>',
         movie$imdb_score, '<br>',
         '$', format(movie$budget, big.mark = ',', scientific=FALSE))
}
