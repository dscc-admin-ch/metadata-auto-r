testthat::test_that("list_to_string", {
  expect_equal(
    list_to_string(list("a" = list("1"), "b" = list("2", "3"))),
    "a=1&b=2&b=3"
  )
})


testthat::test_that("nomenclature_one_level", {
  expect_equal(
    names(get_nomenclature_one_level(
      identifier = "HCL_CH_ISCO_19_PROF",
      level_number = 2,
      language = "fr"
    )),
    c("Code", "Parent", "Name_fr")
  )
})


testthat::test_that("nomenclature_multiple_levels", {
  expect_equal(
    names(
      get_nomenclature_multiple_levels(
        identifier = "HCL_CH_ISCO_19_PROF",
        level_from = 1,
        level_to = 6,
        language = "en"
      )
    ),
    c(
      "Major_groups",
      "Sub.major_groups",
      "Minor_groups",
      "Unit_groups",
      "Type",
      "Occupations",
      "Code",
      "Name_en"
    )
  )
})
