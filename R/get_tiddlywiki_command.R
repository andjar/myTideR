get_tiddlywiki_command <- function(tiddlywiki = NA) {
  # Determine the OS and set the command and arguments accordingly
  if (.Platform$OS.type == "windows") {
    cmd <- "cmd.exe"
    if (is.na(tiddlywiki)) {
      args <- c("/c", "tiddlywiki")
    } else {
      args <- c("/c", "node", normalizePath(file.path(tiddlywiki, "tiddlywiki.js"), mustWork = FALSE))
    }
  } else {
    if (is.na(tiddlywiki)) {
      cmd <- "tiddlywiki"
      args <- c()
    } else {
      cmd <- "node"
      args <- normalizePath(file.path(tiddlywiki, "tiddlywiki.js"), mustWork = FALSE)
    }
  }
  return(list(cmd = cmd, args = args))
}
