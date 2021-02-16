filter_proteinfold <- function(.data, fltinfo){
  if(is.null(fltinfo)) return(.data)
  fltinfo[fltinfo == "Unrelated to Protein Kinase Like"] <- "Unrelated to Protein Kinase"
  .data %>% dplyr::filter(fold_annotation %in% fltinfo)
}

filter_compounds <- function(.data, fltinfo, na_info){
  if(is.null(fltinfo)) return(.data)

  if(is.null(na_info)){
    .data <- .data %>%
      dplyr::filter(n_selective_compounds >= fltinfo)
  } else {
    .data <- .data %>%
      dplyr::filter(n_selective_compounds >= fltinfo | is.na(n_selective_compounds))
  }

  .data
}


filter_knowledge_collapse <- function(.data, fltinfo){
  if(is.null(fltinfo) || fltinfo == "No filter") return(.data)

  .data %>%
    dplyr::filter(
      switch(
        fltinfo,
        "IDG dark kinase" = is_idg_dark_kinase == 1,
        "Statistically defined dark kinase" = is_statistically_defined_dark_kinase == 1,
        "Both" = is_idg_dark_kinase + is_statistically_defined_dark_kinase == 2,
        "Either" = is_idg_dark_kinase + is_statistically_defined_dark_kinase > 0,
        "Neither" = is_idg_dark_kinase + is_statistically_defined_dark_kinase == 0
      )
    )
}


filter_resources <- function(.data, fltinfo, na_info){
  # Note that this requires that the NA vals in n_pdb_structures
  # and has_commercial_assay are the same which seems to be
  # true

  if(is.null(fltinfo)) return(.data)

  if("at least 1 crystal structures" %in% fltinfo){
    .data <- .data %>% dplyr::filter(
      n_pdb_structures > 0 | (!is.null(na_info) & is.na(n_pdb_structures))
    )
  }

  if("at least 1 commercial assays" %in% fltinfo){
    .data <- .data %>% dplyr::filter(
      has_commercial_assay == 1 | (!is.null(na_info) & is.na(has_commercial_assay))
    )
  }


  .data
}




filter_conv_class <- function(.data, fltinfo){

  if((fltinfo %||% "No filter") == "No filter") return(.data)

  .data %>%
    dplyr::filter(
      switch(
        fltinfo,
        "Manning kinases" = is_manning_kinase == 1,
        "KinHub kinases" = is_kinhub_kinase == 1,
        "Both" = is_manning_kinase + is_kinhub_kinase == 2,
        "Either" = is_manning_kinase + is_kinhub_kinase > 0,
        "Neither" = is_manning_kinase + is_kinhub_kinase == 0
      )
    )
}

filter_pseudokinase <- function(.data, fltinfo){

  if((fltinfo %||% "No filter")  == "No filter") return(.data)

  val <- 1
  if(fltinfo == "Exclude pseudokinases") val <- 0

  .data %>%
    dplyr::filter(`is_pseudokinase` == val)

}


filter_biological_relevance <- function(.data, fltinfo){

  if(is.null(fltinfo)) return(.data)

  cancer <- c(0,1)
  alzheimers <- c(0,1)
  copd <- c(0, 1)
  #nessential <- max(.data$`Number of Essential cell lines`)

  if("Cancer" %in% fltinfo) cancer <- 1
  if("Alzheimer's disease" %in% fltinfo) alzheimers <- 1
  if("Chronic obstructive pulmonary disease" %in% fltinfo) copd <- 1
  #if("Essential in at least [100] cell lines" %in% fltinfo) nessential <- 100

  .data %>%
    dplyr::filter(significant_in_cancer %in% cancer) %>%
    dplyr::filter(significant_in_alzheimers %in% alzheimers) %>%
    dplyr::filter(significant_in_copd %in% copd)

}



filter_essential_cell_lines <- function(.data, fltinfo, na_info){

  if(is.null(fltinfo)) return(.data)

  if(is.null(na_info)){
    .data <- .data %>%
      dplyr::filter(n_essential_cell_lines >= fltinfo)
  } else {
    .data <- .data %>%
      dplyr::filter(n_essential_cell_lines >= fltinfo | is.na(n_essential_cell_lines))
  }

  .data
}


filter_custom_HGNC <- function(.data, fltinfo){
  if(is.null(fltinfo) || fltinfo == "") return(.data)

  vals <- trimws(strsplit(fltinfo, "(,|;| |\t|\n)+")[[1]])

  .data %>%
    dplyr::filter(hgnc_symbol %in% toupper(vals))
}



# count(kinomedat, Fold_Annotation)
# # A tibble: 5 x 2
# Fold_Annotation                     n
# <chr>                           <int>
#   1 Atypical                           44
# 2 Eukaryotic Like Kinase (eLK)       18
# 3 Eukaryotic Protein Kinase (ePK)   494
# 4 Unknown                            13
# 5 Unrelated to Protein Kinase       141

#filter(kinomedat, `Number of MS/SS cmpds` <= 35) %>% nrow() # 554 (not including missings)
#filter(kinomedat, `Number of MS/SS cmpds` <= 35 | is.na(`Number of MS/SS cmpds`)) %>% nrow() #707


# `IDG dark kinase` `Statistically defined dark …     n
# <dbl>                         <dbl> <int>
# 1                 0                             0   332
# 2                 0                             1    63
# 3                 0                            NA   152
# 4                 1                             0    43
# 5                 1                             1   119
# 6                 1                            NA     1

# Cancer 0=275, 1 = 282
# table(kinomedat$`Alzeheimer’s disease`)
# Alzheimer's 0 = 519, 1 = 38
# copd  0 = 537   1 = 20

# filter(kinomedat, Cancer == 1, `Number of Essential cell lines`>=50) %>% nrow() # 30
# filter(kinomedat, num_pdb > 0) %>% nrow() #297
# commercial assay 0 = 105, 1 = 452, NA 153

# `Manning Kinase` `Kinhub Kinase`     n
# <dbl>           <dbl> <int>
# 1                0               0   174
# 2                0               1    10
# 3                1               0     2
# 4                1               1   524

# Pseudokinase 0 = 655, 1 = 55

# EIF2AK4 has 2
# ACVR1C has 1
