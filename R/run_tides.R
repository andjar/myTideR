#' Import and Run Tides
#'
#' This function imports and runs the tides in your TiddlyWiki environment.
#' It retrieves the tides and their associated scripts, and executes them in order,
#' with an option to force run scripts tagged with `DoNotRun`.
#'
#' @param force_run Logical. If TRUE, also runs scripts tagged with `DoNotRun`. Default is FALSE.
#' @param mws Logical. If TRUE, sets the TiddlyWiki options to use the "tides" recipe for a MultiWikiServer. Default is FALSE.
#' @export
#'
#' @examples
#' # Run tides with default settings
#' run_tides()
#'
#' # Run tides and force scripts tagged with `DoNotRun` to run
#' run_tides(force_run = TRUE)
#'
#' # Run tides in MultiWikiServer mode
#' run_tides(mws = TRUE)
run_tides <- function(force_run = FALSE, mws = FALSE) {
  library("rtiddlywiki")
  library("data.table")

  rtiddlywiki::tw_options(host = "http://127.0.0.1:8080/")

  if (mws) {
    rtiddlywiki::tw_options(recipe = "tides")
  }

  # Fetch existing tides
  tides_titles <- as.data.table(rbindlist(rtiddlywiki::get_tiddlers(filter = "[prefix[$:/tide]]"), fill = TRUE))
  tides <- rbindlist(lapply(seq_along(tides_titles$title), function(i) {
    as.data.table(rtiddlywiki::get_tiddler(tides_titles$title[i]))
  }), fill = TRUE)
  mws <- tides[title == "$:/tide/settings/mws", text] == "yes"
  if (any(colnames(tides) == "tide_order")) {
    tides[, tide_order := as.numeric(tide_order)]
  }

  # Fetch existing tiddlers
  tiddler_titles <- as.data.table(rbindlist(rtiddlywiki::get_tiddlers(), fill = TRUE))

  # Fetch existing contents
  tiddlers <- rbindlist(lapply(seq_along(tiddler_titles$title), function(i) {
    as.data.table(rtiddlywiki::get_tiddler(tiddler_titles$title[i]))
  }), fill = TRUE)

  # Run tides
  if (nrow(tides) > 0) {
    script_tiddlers <- tides[grepl("$:/tide/scripts", tides$title, fixed = TRUE), ]
    script_tiddlers <- script_tiddlers[order(script_tiddlers$tide_order), ]

    if(!force_run) {
      script_tiddlers <- script_tiddlers[!grepl("DoNotRun", script_tiddlers$tags, fixed = TRUE), ]
    }

    # Run script tiddlers
    for (i in seq_len(nrow(script_tiddlers))) {
      script_to_parse <- script_tiddlers$text[i]
      script_to_parse <- gsub('```r', '', script_to_parse)
      script_to_parse <- gsub('```', '', script_to_parse)
      eval(parse(text = script_to_parse), envir = list(tiddlers = tiddlers, tides = tides))
    }
  }

}
