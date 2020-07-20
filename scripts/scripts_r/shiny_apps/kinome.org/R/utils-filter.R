filter_proteinfold <- function(.data, fltinfo){
  .data %>% dplyr::filter(Fold_Annotation %in% fltinfo)
}

filter_knowledge_collapse <- function(.data, fltinfo){
  
  idg <- c(0,1)
  statdef <- c(0,1)
  
  if(fltinfo == "IDG dark kinase") idg <- 1
  if(fltinfo == "Statistically defined dark kinase") statdef <- 1
  if(fltinfo == "Both") {idg <- 1; statdef <- 1}
  if(fltinfo == "Neither") {idg <- 0; statdef <- 0}


  .data <- .data %>%
    dplyr::filter(`IDG dark kinase` %in% idg) %>%
    dplyr::filter(`Statistically defined dark kinase` %in% statdef)
  
  .data
}


filter_resources <- function(.data, fltinfo){
  
  
  if("Structures" %in% fltinfo)
    .data <- .data %>% dplyr::filter(num_pdb > 0)
  
  if("Commercial assays" %in% fltinfo)
    .data <- .data %>% dplyr::filter(commercial_assay == 1)
  
  .data
}




filter_conv_class <- function(.data, fltinfo){
  


  mk <- c(0,1)
  kk <- c(0,1)

  if(fltinfo == "Manning kinases") mk <- 1
  if(fltinfo == "KinHub kinases") kk <- 1
  if(fltinfo == "Both") {mk <- 1; kk <- 1}
  if(fltinfo == "Neither") {mk <- 0; kk <- 0}
  

  .data <- .data %>%
    dplyr::filter(`Manning Kinase` %in% mk) %>%
    dplyr::filter(`Kinhub Kinase` %in% kk)
  
  .data
}