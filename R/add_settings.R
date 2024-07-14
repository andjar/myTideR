#' Add Settings to TiddlyWiki Server
#'
#' This internal function adds specific settings tiddlers to the TiddlyWiki server,
#' which configure paths and MultiWikiServer (MWS) settings.
#'
#' @param tidepath Character. The path where the tide folder is located.
#' @param mws Logical. If TRUE, sets the TiddlyWiki options to use the "tide" recipe for a MultiWikiServer. Default is FALSE.
#' @keywords internal
add_settings <- function(tidepath, mws = FALSE) {
  rtiddlywiki::put_tiddler(title = "$:/tide/settings/path",
                           text = normalizePath(file.path(getwd(), tidepath), mustWork = FALSE),
                           recipe = ifelse(mws, "tide", "default"))

  rtiddlywiki::put_tiddler(title = "$:/tide/settings/mws",
                           text = ifelse(mws, "yes", "no"),
                           recipe = ifelse(mws, "tide", "default"))
}
