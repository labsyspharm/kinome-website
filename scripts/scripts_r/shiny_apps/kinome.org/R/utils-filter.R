filter_proteinfold <- function(.data, fltinfo){
  .data %>% dplyr::filter(Fold_Annotation %in% fltinfo)
}

filter_knowledge_collapse <- function(.data, fltinfo){
  
  idg <- c(0,1)
  statdef <- c(0,1)
  idg_or_statdef<-c(0,1,2)
  
  if(fltinfo == "IDG dark kinase") {idg <- 1;statdef<-0;idg_or_statdef <-1}
  if(fltinfo == "Statistically defined dark kinase") {idg<-0;statdef <- 1;idg_or_statdef <-1}
  if(fltinfo == "Both") {idg <- 1; statdef <- 1;idg_or_statdef <-2}
  if(fltinfo == "Either") {idg<-c(0,1);statdef<-c(0,1);idg_or_statdef <-c(1,2)}
  if(fltinfo == "Neither") {idg <- 0; statdef <- 0;idg_or_statdef <-0}
  if(fltinfo == "No filter") {idg<-c(0,1);statdef<-c(0,1);idg_or_statdef <-c(0,1,2)}
  
  .data %>%
    dplyr::mutate(sum_idg_statdef= `IDG dark kinase` + `Statistically defined dark kinase`)%>%
    dplyr::filter(`IDG dark kinase` %in% idg) %>%
    dplyr::filter(`Statistically defined dark kinase` %in% statdef)%>%
    dplyr::filter(sum_idg_statdef %in% idg_or_statdef)
  
  # I tested it on the demo data 
  # data=data.frame("IDG dark kinase"=c(1,0,1,0),
  #                 "Statistically defined dark kinase"=c(0,1,1,0))
  
  # idg <- c(0,1)
  # statdef <- c(0,1)
  # 
  # if(fltinfo == "IDG dark kinase") idg <- 1
  # if(fltinfo == "Statistically defined dark kinase") statdef <- 1
  # if(fltinfo == "Both") {idg <- 1; statdef <- 1}
  # if(fltinfo == "Neither") {idg <- 0; statdef <- 0}
  # 
  # 
  # .data <- .data %>%
  #   dplyr::filter(`IDG dark kinase` %in% idg) %>%
  #   dplyr::filter(`Statistically defined dark kinase` %in% statdef)
  
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

filter_pseudokinase <- function(.data, fltinfo){
  .data %>% dplyr::filter(Pseudokinase == 1)
}


filter_biological_relevance <- function(.data, fltinfo){
  
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

filter_essential_cell_lines <- function(.data, essential_cell){
  
  .data %>% 
    dplyr::filter(`Number of Essential cell lines` <= essential_cell)
  
}
  


