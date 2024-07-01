#' Allow certain filters via api
#'
#' This function adds specific tiddler to the server that later allow you to do filtering
#'
#' @export
add_filters <- function() {
  allow_filters <- c("[prefix[$:/tide]]")
  add_filter_tiddler_to_tiddlywiki(allow_filters)
}

#' Allow certain filters via api
#'
#' This function adds specific tiddler to the server that later allow you to do filtering
#'
#' @param allow_filters A vector with the filters to allow
#' @export
add_filter_tiddler_to_tiddlywiki <- function(allow_filters) {
  rtiddlywiki::tw_options(host = "http://127.0.0.1:8080/")

  for (allow_filter in allow_filters) {
    rtiddlywiki::put_tiddler(title = paste0("$:/config/Server/ExternalFilters/", allow_filter),
                text = "yes")
  }
}
