install.packages("remotes")
remotes::install_gitlab("DSCC/fso-metadata")

library(fso.metadata)


### 1. Get a codelist ###
# All languages
codelist <- get_codelist(identifier = "CL_NOGA_DIVISION")
head(codelist, 3)

### 1. Get a codelist ###
# In french
codelist_fr <- get_codelist(identifier = "CL_NOGA_SECTION", language = "fr")
head(codelist_fr, 3)

# In german
codelist_de <- get_codelist(identifier = "CL_NOGA_SECTION", language = "de")
head(codelist_de, 3)


### 2. Get a nomenclature of multiple levels ###
# In italian
multi_nomenclature_it <- get_nomenclature_multiple_levels(
  identifier = "HCL_CH_ISCO_19_PROF",
  level_from = 1,
  level_to = 6,
  language = "it"
)
head(multi_nomenclature_it, 8)


### 3. Concrete example from Mr. van Nieuwkoop with Noga Data
# For this example, you need Noga data in a data/ folder
library(ggplot2)
library(tidyverse)

# Load the production account data for the agriculture divisions
load("data/pk_agr.Rdata")
pk_agr <- rename(pk_agr, Component = Komponent, Year = Jahr)
head(pk_agr)

# Load the descriptions of the NOGA divisions
noga2 <- as_tibble(
  get_codelist(identifier='CL_NOGA_DIVISION', language='fr')
)
names(noga2) <- c("id", "label", "name")
head(noga2)

# Join the production account data with the noga2 descriptions
pk <- pk_agr %>%
  left_join(noga2, by = c("Code" = "id")) %>%
  select(-name) %>%
  relocate(label, .after = Code) %>%
  rename(Department = label)
head(pk)

# Plot the intermediate consumption (CI), the value added (VA), and the
# production value (VP) for the section A (agriculture)
pk %>%
  select(Code, Department, Component, Year, Nominal) %>%
  filter(Nominal > 0 & !is.na(Department)) %>%
  ggplot(aes(Year, Nominal, color = Component)) +
  geom_line() +
  ylab("in Mio. CHF") +
  facet_wrap(~Department,  scales = "free")




plot_agriculture <- function(pk_agr, language) {
  # Load the descriptions of the NOGA divisions
  noga2 <- as_tibble(
    get_codelist(
      identifier='CL_NOGA_DIVISION', 
      language=language,
      environment='ABN') # for the demo, only available within network
  )
  names(noga2) <- c("id", "label", "name")
  
  # Join the production account data with the noga2 descriptions
  pk <- pk_agr %>%
    left_join(noga2, by = c("Code" = "id")) %>%
    select(-name) %>%
    relocate(label, .after = Code) %>%
    rename(Department = label)
  
  # Plot the intermediate consumption (CI), the value added (VA), and the
  # production value (VP) for the section A (agriculture)
  pk %>%
    select(Code, Department, Component, Year, Nominal) %>%
    filter(Nominal > 0 & !is.na(Department)) %>%
    ggplot(aes(Year, Nominal, color = Component)) +
    geom_line() +
    ylab("in Mio. CHF") +
    facet_wrap(~Department,  scales = "free")
}

plot_agriculture(pk_agr, language='fr')
plot_agriculture(pk_agr, language='de')
plot_agriculture(pk_agr, language='it')
plot_agriculture(pk_agr, language='en')
