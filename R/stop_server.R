#' Stop the TiddlyWiki Server
#'
#' This function stops the TiddlyWiki server by interrupting the process.
#'
#' @param p Process object. The process object representing the running TiddlyWiki server.
#' @export
#'
#' @examples
#' # Start the server
#' p <- start_server()
#'
#' # Stop the server
#' stop_server(p)
stop_server <- function(p) {
  p$interrupt()
}
