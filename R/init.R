#' Initialize myTide
#'
#' This function initiates the setup
#'
#' @export
init <- function(tidepath = "myTide") {

  cat("\nGotta Tiddl' Em All!\n\n")
  add_filters()
  add_templates()
  rtiddlywiki::put_tiddler(
    title = format(Sys.Date(), "%Y-%m-%d"),
    text = "",
    tags = "Journal"
  )
  create_folders(tidepath)

}
