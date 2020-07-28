filter_proteinfold <- function(.data, fltinfo){
  if(is.null(fltinfo)) return(.data)
  fltinfo[fltinfo == "Unrelated to Protein Kinase Like"] <- "Unrelated to Protein Kinase"
  .data %>% dplyr::filter(Fold_Annotation %in% fltinfo)
}

filter_compounds <- function(.data, fltinfo, na_info){
  if(is.null(fltinfo)) return(.data)
  
  if(is.null(na_info)){
    .data <- .data %>% 
      dplyr::filter(`Number of MS/SS cmpds` >= fltinfo)
  } else {
    .data <- .data %>% 
      dplyr::filter(`Number of MS/SS cmpds` >= fltinfo | is.na(`Number of MS/SS cmpds`))
  }
    
  .data
}


filter_knowledge_collapse <- function(.data, fltinfo){
  if(is.null(fltinfo) || fltinfo == "No filter") return(.data)

  
  idg <- c(0,1)
  statdef <- c(0,1)
  idg_or_statdef<-c(0,1,2)
  
  if(fltinfo == "IDG dark kinase") {idg <- 1;statdef<-0;idg_or_statdef <-1}
  if(fltinfo == "Statistically defined dark kinase") {idg<-0;statdef <- 1;idg_or_statdef <-1}
  if(fltinfo == "Both") {idg <- 1; statdef <- 1;idg_or_statdef <-2}
  if(fltinfo == "Either") {idg<-c(0,1);statdef<-c(0,1);idg_or_statdef <-c(1,2)}
  if(fltinfo == "Neither") {idg <- 0; statdef <- 0;idg_or_statdef <-0}

  .data %>%
    dplyr::mutate(sum_idg_statdef= `IDG dark kinase` + `Statistically defined dark kinase`)%>%
    dplyr::filter(`IDG dark kinase` %in% idg) %>%
    dplyr::filter(`Statistically defined dark kinase` %in% statdef)%>%
    dplyr::filter(sum_idg_statdef %in% idg_or_statdef)
  
  

}


filter_resources <- function(.data, fltinfo, na_info){
  
  # Note that this requires that the NA vals in num_pdb
  # and commercial_assay are the same which seems to be
  # true
  
  if(is.null(fltinfo)){
    if(is.null(na_info)) .data <- .data %>% dplyr::filter(!is.na(num_pdb))
  }
  
  if("Structures" %in% fltinfo){
    if(is.null(na_info)) .data <- .data %>% dplyr::filter(num_pdb > 0)
    .data <- .data %>% dplyr::filter(num_pdb > 0 | is.na(num_pdb))
  }
    
    
  
  if("Commercial assays" %in% fltinfo){
    if(is.null(na_info)) .data <- .data %>% dplyr::filter(commercial_assay == 1)
    .data <- .data %>% dplyr::filter(commercial_assay == 1 | is.na(commercial_assay))
  }

  
  .data
}




filter_conv_class <- function(.data, fltinfo){
  
  if(fltinfo == "No filter") return(.data)

  
  mk <- c(0,1)
  kk <- c(0,1)
  mk_or_kk<-c(0,1,2)
  
  if(fltinfo == "Manning kinases") {mk <- 1;kk<-0;mk_or_kk <-1}
  if(fltinfo == "KinHub kinases") {mk<-0;kk <- 1;mk_or_kk <-1}
  if(fltinfo == "Both") {mk <- 1; kk <- 1;mk_or_kk <-2}
  if(fltinfo == "Either") {mk<-c(0,1);kk<-c(0,1);mk_or_kk <-c(1,2)}
  if(fltinfo == "Neither") {mk <- 0; kk <- 0;mk_or_kk <-0}
  #if(fltinfo == "No filter") {mk<-c(0,1);kk<-c(0,1);mk_or_kk <-c(0,1,2)}
  

  .data %>%
    dplyr::mutate(sum_mk_kk= `Manning Kinase` + `Kinhub Kinase`)%>%
    dplyr::filter(`Manning Kinase` %in% mk) %>%
    dplyr::filter(`Kinhub Kinase` %in% kk) %>%
    dplyr::filter(sum_mk_kk %in% mk_or_kk)
  
}

filter_pseudokinase <- function(.data, fltinfo){
  
  if(fltinfo == "No filter") return(.data)
  
  val <- 1
  if(fltinfo == "Exclude pseudokinases") val <- 0
  
  .data %>% 
    dplyr::filter(`Pseudokinase` == val)
  
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
    dplyr::filter(Cancer %in% cancer) %>% 
    dplyr::filter(`Alzeheimer’s disease` %in% alzheimers) %>% 
    dplyr::filter(`Chronic obstructive pulmonary disease` %in% copd)
  
}


  
filter_essential_cell_lines <- function(.data, fltinfo, na_info){

  if(is.null(fltinfo)) return(.data)
  
  if(is.null(na_info)){
    .data <- .data %>% 
      dplyr::filter(`Number of Essential cell lines` >= fltinfo)
  } else {
    .data <- .data %>% 
      dplyr::filter(`Number of Essential cell lines` >= fltinfo | is.na(`Number of Essential cell lines`))
  }
  
  .data
}


filter_custom_HGNC <- function(.data, fltinfo){
  if(is.null(fltinfo)) return(.data)
  
  vals <- trimws(strsplit(fltinfo, ",")[[1]])
  
  .data %>% 
    dplyr::filter(HGNC_Symbol %in% toupper(vals))
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