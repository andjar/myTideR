# Sys.unsetenv("GITHUB_PAT")
# devtools::install_github('byzheng/rtiddlywiki')

run_tides <- function(force_run = FALSE) {

  library("rtiddlywiki")
  library("data.table")
  tw_options(host = "http://127.0.0.1:8080/")

  # Fetch existing tiddlers
  tiddlers <- rbindlist(get_tiddlers(), fill = TRUE)
  tiddlers[, text := ""]
  for (i in seq_len(nrow(tiddlers))) {
    tiddlers$text[i] <- get_tiddler(tiddlers$title[i])$text
  }

  # Fetch existing tides
  tides <- rbindlist(get_tiddlers(filter = "[prefix[$:/tide]]", exclude = ""), fill = TRUE)
  tides[, text := ""]
  for (i in seq_len(nrow(tides))) {
    tides$text[i] <- get_tiddler(tides$title[i])$text
  }
  script_tiddlers <- tides[grepl("$:/tide/scripts", title, fixed = TRUE)]
  if(!force_run) {
    script_tiddlers <- script_tiddlers[!grepl("DoNotRun", tags, fixed = TRUE)]
  }

  # Run script tiddlers
  for (i in seq_len(nrow(script_tiddlers))) {
    script_to_parse <- script_tiddlers$text[i]
    script_to_parse <- gsub('```r', '', script_to_parse)
    script_to_parse <- gsub('```', '', script_to_parse)
    eval(parse(text = script_to_parse), envir = list(tiddlers = tiddlers, tides = tides))
  }

}
