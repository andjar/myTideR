#' Initialize myTide
#'
#' This function initiates the setup
#'
#' @export
init <- function(tidepath = "myTide") {

  cat("\nGotta Tiddl' Em All!\n\n")
  add_filters()
  add_templates()
  put_tiddler(
    title = "2024-06-28",
    text = "",
    tags = "Journal"
  )
  create_folders(tidepath)

}
