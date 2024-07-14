#' Start the TiddlyWiki Server
#'
#' This function starts the TiddlyWiki server with the specified configurations.
#' It can start the server either in MultiWikiServer (MWS) mode or regular mode.
#'
#' @param tidepath Character. The path where the tide folder is located. Default is "myTide".
#' @param mws Logical. Indicates whether to set up the TiddlyWiki server in MultiWikiServer mode. Default is FALSE.
#' @param tiddlywiki Character. The path to the TiddlyWiki installation. Default is NA.
#' @param wikipath Character. The path where the wiki data will be stored. Default is NA.
#'
#' @return An object representing the process running the TiddlyWiki server.
#' @export
#'
#' @examples
#' # Start the server with default settings
#' p <- start_server()
#'
#' # Start the server with custom settings
#' p <- start_server(tidepath = "customPath", mws = TRUE, tiddlywiki = "path/to/tiddlywiki", wikipath = "path/to/wiki")
start_server <- function(tidepath = "myTide", mws = FALSE, tiddlywiki = NA, wikipath = NA) {
  library("processx")

  if(is.na(wikipath)) {
    wikipath <- normalizePath(file.path(getwd(), tidepath, ".wiki"), mustWork = FALSE)
  } else {
    wikipath <- normalizePath(file.path(getwd(), wikipath), mustWork = FALSE)
  }

  if(!is.na(tiddlywiki)) {
    tiddlywiki <- normalizePath(file.path(getwd(), tiddlywiki), mustWork = FALSE)
  }

  if (mws) {
    prc_args <- get_tiddlywiki_command(tiddlywiki)
    prc_args[["args"]] <- append(prc_args[["args"]], c(wikipath, "--mws-listen"))
    p <- process$new(prc_args[["cmd"]], prc_args[["args"]])
  } else {
    prc_args <- get_tiddlywiki_command(tiddlywiki)
    prc_args[["args"]] <- append(prc_args[["args"]], c(wikipath, "--listen"))
    p <- process$new(prc_args[["cmd"]], prc_args[["args"]])
  }
  return(p)
}
