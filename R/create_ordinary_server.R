create_ordinary_server <- function(wiki_path, tiddlywiki = NA) {
  # Create the wiki directory if it doesn't exist
  if (!dir.create(wiki_path, recursive = TRUE, showWarnings = FALSE)) {
    if (!file.exists(wiki_path)) {
      stop("Failed to create the directory.")
    }
  }

  prc_args <- get_tiddlywiki_command(tiddlywiki)

  if(is.na(tiddlywiki)) {
    prc_args[["args"]] <- append(prc_args[["args"]], c(wiki_path, "--init", "server"))
  } else {
    prc_args[["args"]] <- append(prc_args[["args"]], c(wiki_path, "--init", "server"))
  }

  processx::run(prc_args[["cmd"]], prc_args[["args"]])
}
