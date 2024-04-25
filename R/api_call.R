#' Get a codelist based on an identifier
#'
#' @param identifier the codelist's identifier
#' @param environment environment on which to query API
#' Available are 'PRD', 'ABN', 'TEST', 'QA' and 'DEV'.
#' @param language string for language(s) to return.
#' Available are 'all', 'fr', 'de', 'it', 'en'.
#' If 'all' (default), all languages are returned.
#' @param export_format the export's format
#' Available are CSV, XLSX, SDMX-ML or JSON.
#' @param version_format the export format's version
#' (2.0 or 2.1 when format is SDMX-ML).
#' @param annotations flag to include annotations
#'
#' @return response based on the export format
#' @export
get_codelist <- function(identifier,
                         environment = "PRD",
                         language = "all",
                         export_format = "SDMX-ML",
                         version_format = 2.1,
                         annotations = FALSE) {
  api <- api_class(
    api_type = "codelist",
    environment = environment,
    id = identifier,
    language = language,
    export_format = export_format,
    parameters = glue::glue("annotations={tolower(annotations)}")
  )
  api$get_response()
}


#' Get one level of a nomenclature
#'
#' @param identifier nomenclature's identifier
#' @param environment environment on which to query API
#' Available are 'PRD', 'ABN', 'TEST', 'QA' and 'DEV'.
#' @param filters additionnal filters
#' @param level_number level to export
#' @param language  the language of the response data
#' Available are 'fr', 'de', 'it', 'en'.
#' @param annotations flag to include annotations
#'
#' @return dataframe with 3 columns
#' (Code, Parent and Name in the selected language)
#' @export
get_nomenclature_one_level <- function(identifier,
                                       environment = "PRD",
                                       filters = list(),
                                       level_number = 1,
                                       language = "all",
                                       annotations = FALSE) {
  parameters <- glue::glue(
    "level={level_number}",
    "&annotations={tolower(annotations)}",
    "&{list_to_string(filters)}"
  )
  api <- api_class(
    api_type = "nomenclature_one_level",
    environment = environment,
    id = identifier,
    language = language,
    parameters = parameters,
    export_format = "CSV"
  )
  api$get_response()
}


#' Get multiple levels of a nomenclature (from `level_from` to `level_to`)
#'
#' @param identifier nomenclature's identifier
#' @param environment environment on which to query API
#' Available are 'PRD', 'ABN', 'TEST', 'QA' and 'DEV'.
#' @param filters additionnal filters
#' @param level_from the 1st level to include
#' @param level_to the last level to include
#' @param language  the language of the response data
#' Available are 'fr', 'de', 'it', 'en'.
#' @param annotations flag to include annotations
#'
#' @return dataframe columns
#' from `level_from` to `level_to` codes
#' @export
get_nomenclature_multiple_levels <- function(identifier,
                                             environment = "PRD",
                                             filters = list(),
                                             level_from = 1,
                                             level_to = 2,
                                             language = "fr",
                                             annotations = FALSE) {
  parameters <- glue::glue(
    "language={language}",
    "&levelFrom={level_from}",
    "&levelTo={level_to}",
    "&annotations={tolower(annotations)}",
    "&{list_to_string(filters)}"
  )
  api <- api_class(
    api_type = "nomenclature_multiple_levels",
    environment = environment,
    id = identifier,
    parameters = parameters,
    export_format = "CSV"
  )
  res <- api$get_response()
}
