library(dplyr)
#library(data.table)
library(readr)
#library(fst)
library(here)
library(plotly)
library(crosstalk)
library(markdown)
library(glue)
library(fs)
library(purrr)
#library(morgancpp)
library(yonder)
library(stringr)
library(DT)
library(writexl)
#requireNamespace("DT")

source("R/constants.R", local = TRUE)
source("R/utils.R", local = TRUE)
source("R/utils-ui.R", local = TRUE)
source("R/utils-filter.R", local = TRUE)
# source("awspass.config")

# Components used in multiple apps
source("modules/components/comp_filters.R", local = TRUE)
source("modules/components/comp_tablevars.R", local = TRUE)
source("modules/components/comp_tableview.R", local = TRUE)
source("modules/components/download_buttons.R", local = TRUE)
# # Modules
source("modules/mod_table.R", local = TRUE)

# source("modules/similarity.R", local = TRUE)
# source("modules/library.R", local = TRUE)
# source("modules/binding.R", local = TRUE)
# 
source("data/load.R", local = TRUE)
# 
# source("utils.R", local = TRUE)


# enableBookmarking(store = "url")

