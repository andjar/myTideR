#' Create Folder Structure
#'
#' This internal function creates a specific folder structure at the specified relative path.
#'
#' @param mypath Character. A relative path from the current working directory where the folders should be created.
#' @keywords internal
create_folders <- function(mypath) {
  folders_to_create <- c("file-archive", "inbox", "outbox", "web-archive")

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
