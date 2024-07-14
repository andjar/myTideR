#' Initialize myTide Setup
#'
#' This function initializes the setup for the myTide project. It sets up the required folders and configurations,
#' and optionally starts a TiddlyWiki server either in MultiWikiServer (MWS) mode or regular mode.
#'
#' @param tidepath Character. The path where the tide folder will be created. Default is "myTide".
#' @param mws Logical. Whether to set up the TiddlyWiki server in MultiWikiServer mode. Default is FALSE.
#' @param tiddlywiki Character. The path to the TiddlyWiki installation. Default is NA. Only required for MWS.
#' @param start_date Character. The start date for journal creation in YYYY-MM-DD format. Default is the current date.
#' @param end_date Character. The end date for journal creation in YYYY-MM-DD format. Default is the current date.
#' @param wikipath Character. The path where the wiki data will be stored. Default is NA.
#'
#' @return This function does not return a value but sets up the myTide environment.
#' @export
#'
#' @examples
#' \dontrun{
#' init()
#' init(tidepath = "customPath", mws = TRUE, tiddlywiki = "path/to/tiddlywiki")
#' }
init <- function(tidepath = "myTide",
                 mws = FALSE,
                 tiddlywiki = NA,
                 start_date = format(Sys.Date(), "%Y-%m-%d"),
                 end_date = format(Sys.Date(), "%Y-%m-%d"),
                 wikipath = NA) {
  library("processx")

  cat("\nGotta Tiddl' Em All!\n\n")

  run_txt <- make_run_txt(tidepath = tidepath, mws = mws, tiddlywiki = tiddlywiki, wikipath = wikipath)

  # Create tide folder
  create_folders(tidepath)

  if(is.na(wikipath)) {
    wikipath <- normalizePath(file.path(getwd(), tidepath, ".wiki"), mustWork = FALSE)
  } else {
    wikipath <- normalizePath(file.path(getwd(), wikipath), mustWork = FALSE)
  }

  if(!is.na(tiddlywiki)) {
    tiddlywiki <- normalizePath(file.path(getwd(), tiddlywiki), mustWork = FALSE)
  }

  if (mws) {
    if (file.exists(wikipath)) {
      make_bag_command <- function(bag) {
        paste0(
          '--mws-create-bag tide-', bag, ' "A tide bag for ', bag, '" --mws-create-recipe tide-', bag, ' "tide-', bag, '"', ' "A tide recipe for ', bag, '"',
          collapse = ' '
        )
      }

      bags <- c("RSS", "files", "youtube", "mail", "hook", "web", "journal")

      system(
        paste0("node ", tiddlywiki, "/tiddlywiki.js ", wikipath,
               make_bag_command(bags),
               ' --mws-create-bag tide "A general tide bag" --mws-create-recipe tide tide  "A general tide recipe"',
               ' --mws-create-recipe tides "tide ', paste0('tide-', paste0(bags, collapse = ' tide-')), '"  "A recipe containing all tides"',
               ' --mws-create-bag default "A default bag"',
               ' --mws-create-recipe default "tide ', paste0('tide-', paste0(bags, collapse = ' tide-')), ' default"  "A default recipe"')
      )
    } else {
      create_mws_server(wikipath, tiddlywiki)
    }

    prc_args <- get_tiddlywiki_command(tiddlywiki)
    prc_args[["args"]] <- append(prc_args[["args"]], c(wikipath, "--mws-listen"))
    p <- process$new(prc_args[["cmd"]], prc_args[["args"]])
  } else {
    if (!file.exists(wikipath)) {
      create_ordinary_server(wikipath, tiddlywiki)
    }
    prc_args <- get_tiddlywiki_command(tiddlywiki)
    prc_args[["args"]] <- append(prc_args[["args"]], c(wikipath, "--listen"))
    p <- process$new(prc_args[["cmd"]], prc_args[["args"]])
  }

  add_filters(mws = mws)
  add_templates(mws = mws)
  add_settings(tidepath, mws = mws)
  add_journals(start_date = start_date, end_date = end_date, mws = mws)

  pp <- p$interrupt()
  cat("\nSuccess! You can now start and stop your TiddlyWiki server with:\n\n", run_txt, "\nstop_server(p)", "\n\n")

}
