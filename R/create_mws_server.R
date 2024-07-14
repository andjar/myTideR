#' Create MultiWikiServer (MWS) for TiddlyWiki
#'
#' This internal function sets up a MultiWikiServer (MWS) for TiddlyWiki at the specified path,
#' initializing necessary configurations and plugins.
#'
#' @param mws_path Character. The path where the MWS folder should be created.
#' @param tiddlywiki Character. The path to the TiddlyWiki installation.
#' @keywords internal
create_mws_server <- function(mws_path, tiddlywiki) {

  tiddlywiki.info <- system.file("extdata", package = "myTideR") |> list.files(pattern = "tiddlywiki.info", full.names = TRUE)

  # Create the mws directory if it doesn't exist
  if (!dir.create(mws_path, recursive = TRUE, showWarnings = FALSE)) {
    if (!file.exists(mws_path)) {
      stop("Failed to create the directory.")
    }
  }

  # Copy tiddlywiki.info to the mws folder
  file.copy(from = tiddlywiki.info, to = normalizePath(file.path(mws_path, "tiddlywiki.info")))

  make_bag_command <- function(bag) {
    paste0(
      '--mws-create-bag tide-', bag, ' "A tide bag for ', bag, '" --mws-create-recipe tide-', bag, ' "tide-', bag, '"', ' "A tide recipe for ', bag, '"',
      collapse = ' '
    )
  }

  bags <- c("RSS", "files", "youtube", "mail", "hook", "web", "journal")

  system(
    paste0("node ", tiddlywiki, "/tiddlywiki.js ", mws_path,
           " --mws-load-plugin-bags ",
           make_bag_command(bags),
           ' --mws-create-bag tide "A general tide bag" --mws-create-recipe tide tide  "A general tide recipe"',
           ' --mws-create-recipe tides "tide ', paste0('tide-', paste0(bags, collapse = ' tide-')), '"  "A recipe containing all tides"',
           ' --mws-create-bag default "A default bag"',
           ' --mws-create-recipe default "tide ', paste0('tide-', paste0(bags, collapse = ' tide-')), ' default"  "A default recipe"')
  )
}
