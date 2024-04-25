install.packages(c(
  "devtools", "roxygen2", "document", "styler", "httr", "jsonlite", "glue",
  "pkgdown"
))
install.packages("ggplot")
devtools::install_github("opensdmx/rsdmx")

## Load and test library
# pkgload::load_all('.', TRUE)
# styler::style_pkg('.')
# devtools::check('.')
# testthat::test_file("tests/testthat.R")

## Use pkgdown for documentation
# pkgdown::build_site()
# pkgdown::preview_site(pkg = ".", path = ".")