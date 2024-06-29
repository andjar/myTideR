#' Create Folders
#'
#' This function creates a folder structure at the specified relative path.
#'
#' @param mypath A relative path from the current working directory where the folders should be created.
#' @export
create_folders <- function(mypath) {
  folders_to_create <- c("file-archive", "inbox", "outbox", "web-archive")

  put_tiddler(title = "$:/tide/settings/path",
              text = normalizePath(file.path(getwd(), mypath), mustWork = FALSE))

  for (folder_to_create in folders_to_create) {

    full_path_to_create <- normalizePath(file.path(getwd(), mypath, folder_to_create), mustWork = FALSE)

    # Create the directory if it doesn't exist
    if (!dir.create(full_path_to_create, recursive = TRUE, showWarnings = FALSE)) {
      if (!file.exists(full_path_to_create)) {
        stop("Failed to create the directory.")
      }
    }
  }

}
