#' Generate Command Text to Start the TiddlyWiki Server
#'
#' This internal function constructs the command text needed to start the TiddlyWiki server
#' based on the provided parameters. The generated command text can be used to start the server
#' with specific configurations.
#'
#' @param tidepath Character. The path where the tide folder is located. Default is "myTide".
#' @param mws Logical. Indicates whether to set up the TiddlyWiki server in Multi-User Server mode. Default is FALSE.
#' @param tiddlywiki Character. The path to the TiddlyWiki installation. Default is NA.
#' @param wikipath Character. The path where the wiki data will be stored. Default is NA.
#'
#' @return A character string that contains the command to start the TiddlyWiki server with the specified settings.
#' @keywords internal
#'
#' @examples
#' # Example usage:
#' make_run_txt()
#' make_run_txt(tidepath = "customPath", mws = TRUE, tiddlywiki = "path/to/tiddlywiki")
make_run_txt <- function(tidepath = "myTide", mws = FALSE, tiddlywiki = NA, wikipath = NA) {
  qargs <- c()
  if(tidepath != "myTide") {
    qargs <- append(qargs, paste0('tidepath="', tidepath, '"'))
  }
  if(mws) {
    qargs <- append(qargs, "mws=TRUE")
  }
  if (!is.na(tiddlywiki)) {
    qargs <- append(qargs, paste0('tiddlywiki="', tiddlywiki, '"'))
  }
  if (!is.na(wikipath)) {
    qargs <- append(qargs, paste0('wikipath="', wikipath, '"'))
  }
  return(paste0("p <- start_server(", paste0(qargs, collapse=","), ")"))
}
