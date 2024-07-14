#' Add Specific Filters to TiddlyWiki Server
#'
#' This internal function adds a specific set of filters to the TiddlyWiki server,
#' enabling filtering functionality via the API.
#'
#' @param mws Logical. If TRUE, sets the TiddlyWiki options to use the "tide" recipe for a MultiWikiServer.. Default is FALSE.
#' @keywords internal
add_filters <- function(mws = FALSE) {
  allow_filters <- c("[prefix[$:/tide]]")
  add_filter_tiddler_to_tiddlywiki(allow_filters, mws = mws)
}

#' Add Filter Tiddlers to TiddlyWiki Server
#'
#' This internal function adds specified filter tiddlers to the TiddlyWiki server,
#' enabling the use of those filters via the API.
#'
#' @param allow_filters Character vector. A vector containing the filters to be added.
#' @param mws Logical. If TRUE, sets the TiddlyWiki options to use the "tide" recipe for a MultiWikiServer. Default is FALSE.
#' @keywords internal
add_filter_tiddler_to_tiddlywiki <- function(allow_filters, mws = FALSE) {
  rtiddlywiki::tw_options(host = "http://127.0.0.1:8080/")

  for (allow_filter in allow_filters) {
    rtiddlywiki::put_tiddler(title = paste0("$:/config/Server/ExternalFilters/", allow_filter),
                             text = "yes",
                             recipe = ifelse(mws, "tide", "default"))
  }
}
