# library("jsonlite")
# library("data.table")
# #df <- jsonlite::read_json("../Takeout/Posisjonslogg (tidslinje)/Records.json")
#
# df <- jsonlite::read_json("../Takeout/Posisjonslogg (tidslinje)/Semantic Location History/2015/2015_AUGUST.json")
#
# file_list <- list.files(path = "../Takeout/Posisjonslogg (tidslinje)/Semantic Location History/",
#                         recursive = TRUE,
#                         pattern = "*.json",
#                         full = TRUE)
# k <- rbindlist(lapply(file_list, function(f) {
#   df <- jsonlite::read_json(f)
#   rbindlist(lapply(df$timelineObjects, function(x) {
#     data.table(
#       address  = x$placeVisit$location$address,
#       place_id = x$placeVisit$location$placeId,
#       name     = x$placeVisit$location$name,
#       start    = x$placeVisit$duration$startTimestamp,
#       end      = x$placeVisit$duration$endTimestamp
#     )
#   }), fill = TRUE)
# }), fill = TRUE)
#
# for (i in 1:nrow(k)) {
#   s <- strsplit(k[i, address], ",")[[1]]
#   set(k, i, "country", ifelse(length(s) > 0, s[length(s)], ""))
#   set(k, i, "city", ifelse(length(s) > 0, s[length(s)-1], ""))
# }
# k[, country := gsub("^\\s*|\\d+", "", country)]
# k[, city := gsub("^\\s*|\\d+", "", city)]
# k[, country := gsub("^\\s*|\\d+", "", country)]
# k[, city := gsub("^\\s*|\\d+", "", city)]
