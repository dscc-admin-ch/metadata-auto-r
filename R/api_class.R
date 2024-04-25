
#' Api class to make appropriate request based on parameters
#'
#' @field api_type character. The name of the api to call (see url_mapping)
#' @field environment environment on which to query API
#' Available are 'PRD', 'ABN', 'TEST', 'QA' and 'DEV'.
#' @field export_format character (default = "JSON"). The export's format
#' Available are CSV, XLSX, SDMX-ML and JSON
#' @field parameters character. Additional request parameters
#' @field id character. The identifier or id of the request's object
#' @field language character (default = "all"). Language of the response data.
#' Available are 'all', 'fr', 'de', 'it', 'en'
#' @field version_format numeric (default = 2.1). The export format's version
#' (2.0 or 2.1 when format is SDMX-ML)
#' (for 'codelist')
#' @field api_url character. The url to make the request to.
#'
#' @importFrom methods new
api_class <- setRefClass(
  "Api",
  fields = list(
    api_type = "character",
    environment = "character",
    export_format = "character",
    parameters = "character",
    id = "character",
    language = "character",
    version_format = "numeric",
    api_url = "character"
  ),
  methods = list(
    initialize = function(...,
                          environment = "PRD",
                          export_format = "JSON",
                          parameters = "",
                          id = "",
                          language = "all",
                          version_format = 2.1) {
      callSuper(
        ...,
        environment = environment,
        export_format = export_format,
        parameters = parameters,
        id = id,
        language = language,
        version_format = version_format
      )
      get_url(id, export_format, version_format, language)
    },
    get_url = function(id, export_format, version_format, language) {
      # Map function names to specific API URL
      url_mapping <- list(
        "codelist" =
          glue::glue("CodeLists/{id}/exports/{export_format}/{version_format}"),
        "nomenclature_one_level" =
          glue::glue("Nomenclatures/{id}/levelexport/CSV"),
        "nomenclature_multiple_levels" =
          glue::glue("Nomenclatures/{id}/multiplelevels/CSV")
      )
      api_url <<- url_mapping[[api_type]]
    },
    get_response = function() {
      # API call to url
      url <- glue::glue("{ENVIRONMENTS[[environment]]}/api/{api_url}?{parameters}")
      res <- REQUEST_FUNCTION_MAPPING[[export_format]](url)

      # If specified language, keep only language specific columns
      if (language != "all") {
        res <- remove_other_languages(res, language)
      }

      res
    }
  )
)


#' Remove columns that belong to other languages than the selected one
#'
#' @param df data.frame returned from API with columns for all languages
#' @param language language to keep
#'
#' @return dataframe with columns relevant to selected language only
remove_other_languages <- function(df, language) {
  to_remove <- glue::glue(
    "[.|_]+({paste(LANGUAGES[LANGUAGES != language], collapse = '|')})$"
  )
  df[, !names(df) %in% names(df)[stringr::str_detect(names(df), to_remove)]]
}
