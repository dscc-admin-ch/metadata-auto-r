
#' API query for SDMX output
#'
#' @param url url to query
#'
#' @return dataframe response
sdmx_request <- function(url) {
  as.data.frame(rsdmx::readSDMX(url))
}

#' API query for JSON output
#'
#' @param url url to query
#'
#' @return response: dataframe or list of dataframes
json_request <- function(url) {
  jsonlite::fromJSON(rawToChar(httr::GET(url)$content))
}

#' API query for CSV output
#'
#' @param url url to query
#' @importFrom utils read.csv
#'
#' @return dataframe response
csv_request <- function(url) {
  read.csv(url, encoding = "UTF-8")
}

# Request function based on expected response
REQUEST_FUNCTION_MAPPING <- list(
  "SDMX-ML" = sdmx_request,
  "JSON" = json_request,
  "CSV" = csv_request
)


#' Transform a list into a string of parameters
#' list("a" = list("1"), "b" = list("2", "3"))
#' becomes "a=1&b=2&b=3"
#'
#' @param filters named list
#'
#' @return formatted string of parameters
list_to_string <- function(filters) {
  string <- ""
  for (prop in ls(filters)) {
    for (value in filters[[prop]]) {
      if (string == "") {
        string <- glue::glue("{prop}={value}")
      } else {
        string <- paste(string, glue::glue("{prop}={value}"), sep = "&")
      }
    }
  }
  string
}
