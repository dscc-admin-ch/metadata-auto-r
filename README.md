# FSO Metadata Auto R Package

## Introduction

This repository aims to simplify the access to the [Swiss Federal Statistical Office](https://www.bfs.admin.ch/bfs/en/home.html) metadata. 
Following the implementation in the [interoperability platform](https://www.i14y.admin.ch) and the [SIS portal](https://sharepoint.admin.ch/edi/bfs/fr-ch/News/Pages/go-life-neues-sis-portals.aspx), the APIs are made available here in R.
This public library is made available for the internal FSO staff, the federal administration and for external actors.

## Installation

You can install the library with
```
install.packages("remotes")
remotes::install_gitlab("DSCC/fso-metadata")
```

then at the beginning of your R script, you will need to 
```
library("fso.metadata")
```
Sometimes when you try to install a package, you get an error like this "ERROR: loading failed for 'i386' when using the `install_gitlab` function from `remotes`. Currently, if 32-bit and 64-bit versions of R are installed, it seems `devtools tries` to build for both of them. This yields a loading failed for 'i386' error. To force building the package for your currently running R version use the `INSTALL_opts` argument of `install_github`:
```
remotes::install_gitlab("DSCC/fso-metadata",  INSTALL_opts=c("--no-multiarch"))
```
Now you can install a function with 
```
install.packages64("fso-metada")
```
For more information, visit [Confluence](https://intranet.confluence.bfs.admin.ch/confluence/pages/viewpage.action?pageId=303270710).


#### In case of ERROR: loading failed for 'i386'


## Functionnalities
Based on the metadata that you want, you will call certain functions and parameters. 

### Codelists
1. Export a codelist based on an identifier
```
codelist <- get_codelist(identifier, environment, language, export_format, version_format, annotations)
```

    Parameters:
        - identifier ("character"): the codelist's identifier
        - environment ("character", default="PRD" for production)
            Available are 'PRD', 'ABN', 'TEST', 'QA' and 'DEV'.
        - language ("character", default="all" for all languages, no filtering)
            Available are 'all', 'fr', 'de', 'it', 'en'.
        - export_format ("character", default="SDMX-ML"): the export's format. 
            Available are CSV, XLSX, SDMX-ML or SDMX-JSON.
        - version_format ("numeric", default=2.1): the export format's version 
            (2.0 or 2.1 when format is SDMX-ML).
        - annotations (bool, default=FALSE): flag to include annotations
    Returns:
        - codelist (data.frame) based on the export format
            - a data.frame if export_format was CSV or XLSX
            - a json if export_format was SDMX-ML or SDMX-JSON.


### Nomenclatures
   
1. Export one level of a nomenclature
```
one_level_df <- get_nomenclature_one_level(identifier, environment, level_number, filters, language, annotations)
```

    Parameters:
        - identifier ("character"): nomenclature's identifier
        - environment ("character", default="PRD" for production)
            Available are 'PRD', 'ABN', 'TEST', 'QA' and 'DEV'.
        - level_number ("numeric"): level to export
        - filter (list): additionnal filters in form of named list
        - language ("character", default='fr'): response data's language 
            Available are 'fr', 'de', 'it', 'en'.
        - annotations (bool, default=FALSE): flag to include annotations
    Returns:
        - response (data.frame): dataframe with 3 columns 
            (Code, Parent and Name in the selected language)


2. Export multiple levels of a nomenclature (from `level_from` to `level_to`)
```
multiple_levels_df = get_nomenclature_multiple_levels(identifier, environment, level_from, level_to, filters, language, annotations)
```

    Parameters:
        - identifier ("character"): nomenclature's identifier
        - environment ("character", default="PRD" for production)
            Available are 'PRD', 'ABN', 'TEST', 'QA' and 'DEV'.
        - level_from ("numeric"): the 1st level to include
        - level_to ("numeric"): the last level to include
        - filter (list): additionnal filters in form of named list
        - language ("character", default='fr'): response data's language 
            Available are 'fr', 'de', 'it', 'en'.
        - annotations (bool, default=FALSE): flag to include annotations
    Returns:
        - multiple_levels_df (data.frame): dataframe columns from `level_from` to `level_to` codes


As the APIs continue to be implemented, further functionnalities will be added.


### Upcoming function: Data Structures
1. Get the data structure (not available yet)
```
data_structure <- get_data_structure(identifier, language)
```

    Parameters:
        - identifier ("character"): the nomenclature's identifier
        - language ("character", default='fr'): the language of the response data. 
            Available are 'fr', 'de', 'it', 'en'.
    Returns:
        - data_structure: data structure
        

## Background
All the APIs made available in this library are also documented in Swagger UI should you want to do more experiments through a UI.
- [Here](https://www.i14y.admin.ch/api/index.html) for APIs of the interoperability platform (public).
- [Here](https://dcat.app.cfap02.atlantica.admin.ch/api/index.html) for dcat APIs (internal to configuration).

## Example

Examples for each API are provided in the [R Markdown](https://renkulab.io/gitlab/dscc/metadata-auto-r-library/-/blob/master/example.Rmd).

Practical [demo](https://renkulab.io/gitlab/dscc/metadata-auto-r-library/-/blob/master/demo.R).

A documentation page is also available [here](https://DSCC.gitlab.io/fso-metadata/).
