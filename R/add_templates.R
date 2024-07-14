add_templates <- function(mws = FALSE) {
  parse_tiddler_from_file <- function(file_path) {
    # Read the entire file
    lines <- readLines(file_path)

    # Find the index of the empty line separating header and text
    separator_index <- which(lines == "")

    if (length(separator_index) == 0) {
      stop("No empty line found separating header and text")
    }

    # Split header and text sections
    header_lines <- lines[1:(separator_index - 1)]
    text_lines <- lines[(separator_index + 1):length(lines)]

    # Initialize the tiddler list
    tiddler <- list(fields = list())

    # Parse the header lines
    for (line in header_lines) {
      parts <- strsplit(line, ": ", fixed = TRUE)[[1]]
      if (length(parts) != 2) {
        stop("Header line does not contain a key and a value separated by ': '")
      }
      key <- trimws(parts[1])
      value <- trimws(parts[2])

      if (key == "title") {
        tiddler$title <- value
      } else if (key == "type") {
        tiddler$type <- value
      } else {
        tiddler$fields[[key]] <- value
      }
    }

    # Combine text lines into a single string
    tiddler$text <- paste(text_lines, collapse = "\n")

    return(tiddler)
  }

  files_to_add <- system.file("extdata", package = "myTideR") |> list.files(pattern = "*.tid", full.names = TRUE)

  for (file_to_add in files_to_add) {
    tiddler <- parse_tiddler_from_file(file_to_add)

    if (!is.null(tiddler$fields[["tags"]])) {
      all_tags <- tiddler$fields[["tags"]]
      tiddler$fields[["tags"]] <- NULL
      rtiddlywiki::put_tiddler(title = tiddler$title,
                               text = tiddler$text,
                               tags = all_tags,
                               type = tiddler$type,
                               fields = tiddler$fields,
                               recipe = ifelse(mws, "tide", "default"))
    } else {
      rtiddlywiki::put_tiddler(title = tiddler$title,
                               text = tiddler$text,
                               type = tiddler$type,
                               fields = tiddler$fields,
                               recipe = ifelse(mws, "tide", "default"))
    }
    }

}
