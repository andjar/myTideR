#' Add Daily Journal Tiddlers to TiddlyWiki Server
#'
#' This internal function adds daily journal tiddlers to the TiddlyWiki server for a specified date range.
#' Each journal entry is represented as a tiddler with the date as the title and tagged as "Journal".
#'
#' @param start_date Character. The start date in "YYYY-MM-DD" format. Defaults to today's date.
#' @param end_date Character. The end date in "YYYY-MM-DD" format. Defaults to today's date.
#' @param mws Logical. If TRUE, sets the TiddlyWiki options to use the "tide-journal" recipe for a MultiWikiServer. Default is FALSE.
#' @keywords internal
add_journals <- function(start_date = format(Sys.Date(), "%Y-%m-%d"), end_date = format(Sys.Date(), "%Y-%m-%d"), mws = FALSE) {
  # Define the start and end dates
  start_date <- as.Date(start_date)
  end_date <- as.Date(end_date)

  # Generate a sequence of dates from start_date to end_date
  dates <- seq.Date(start_date, end_date, by = "day")
  dates <- format(dates, "%Y-%m-%d")

  # Loop over each date and create a tiddler
  for (date in dates) {
    rtiddlywiki::put_tiddler(
      title = date,
      text = "",
      tags = "Journal",
      recipe = ifelse(mws, "tide-journal", "default")
    )
  }
}
