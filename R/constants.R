
#c90016

KINOME_COLORS <- c(`crimson` = "#A41034", `2` = "#ef8a62", `3` = "#fddbc7", `10` = "#d9d9d9")
DT_DOM <- '<"row justify-content-between"<"col-sm-12 col-md-auto"B><"col-sm-12 col-md-auto"l><"col-sm-12 col-md-auto ml-md-auto"f>><"row"<"col-sm-12"t>><"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>'

# Use display name
COLUMN_SPECS <- read_csv(here("data", "column_specs.csv"))

COLUMN_TITLE_MAP <- with(COLUMN_SPECS, set_names(column_title, column_id))

DEFAULT_COLUMNS <- c(
  "hgnc_symbol",
  "fold_code",
  "indra_network",
  "pdb_structure_ids",
  "compounds"
)

MULTISELECT_COLUMNS <- list(
  has_commercial_assay = c("kinaseform_in_reaction_biology", "kinaseform_in_discoverx")
)

INIT <- list(
  flt_kinaselike = c(
    "Eukaryotic Protein Kinase (ePK)" = "ePK",
    "Eukaryotic Like Kinase (eLK)" = "eLK",
    "Atypical" = "Atypical"
  ),
  flt_nokinaselike = c(
    "Unrelated to Protein Kinase Like" = "uPK",
    "Unknown" = "Unknown"
  ),
  flt_compounds = 0,
  na_compounds = "Include missing values",
  flt_knowledge = "No filter",
  flt_biorel = "NULL",
  essentialcelllines = 0,
  na_biorel = "Include missing values",
  flt_resources = "NULL",
  na_resources = "Include missing values",
  flt_conv_class = "No filter",
  flt_pseudokinase = "No filter",
  flt_custom = ""
)
