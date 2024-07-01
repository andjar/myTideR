#' Import and run tides
#'
#' This function runs the tides in your tiddlywiki
#'
#' @param force_run Also run scripts tagged with `DoNotRun`
#' @export
run_tides <- function(force_run = FALSE) {
  library("rtiddlywiki")
  library("data.table")

  rtiddlywiki::tw_options(host = "http://127.0.0.1:8080/")

  # Fetch existing tiddlers
  tiddlers <- as.data.table(rbindlist(rtiddlywiki::get_tiddlers(), fill = TRUE))

  if (nrow(tiddlers) > 0) {
    for (i in seq_len(nrow(tiddlers))) {
      t_text <- rtiddlywiki::get_tiddler(tiddlers$title[i])$text
      if (is.character(t_text)) {
        set(tiddlers, i, "text", t_text)
      }
    }
  }

  # Fetch existing tides
  tides <- as.data.table(rbindlist(rtiddlywiki::get_tiddlers(filter = "[prefix[$:/tide]]"), fill = TRUE))

  if (nrow(tides) > 0) {
    for (i in seq_len(nrow(tides))) {
      t_text <- rtiddlywiki::get_tiddler(tides$title[i])$text
      if (is.character(t_text)) {
        set(tides, i, "text", t_text)
      }
    }
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
