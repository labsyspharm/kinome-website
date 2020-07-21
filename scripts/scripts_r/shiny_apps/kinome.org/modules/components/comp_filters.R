#' filters UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_filters_ui <- function(id, open = FALSE) {
  ns <- NS(id)

  tagList(div(
    class = "panel-group",
    
    
    get_check_collapse(
      open = "false",
      ns = ns,
      "proteinfold_collapse",
      "Protein Fold",
      "Protein Kinase Like",
      "flt_kinaselike",
      c(
        "Eukaryotic Protein Kinase (ePK)",
        "Eukaryotic Like Kinase (eLK)",
        "Atypical"
      ),
      c(
        "Eukaryotic Protein Kinase (ePK)",
        "Eukaryotic Like Kinase (eLK)",
        "Atypical"
      ),
      "flt_nokinaselike",
      choices2 = c("Unrelated to Protein Kinase Like", "Unknown"),
      selected2 = c("Unrelated to Protein Kinase Like", "Unknown")
    ),
    collapse_wrapper(internal_html = list(
      sliderInput(
        ns("compounds"),
        "Maximum number of most-selective/semi-selective compounds:",
        min = 0,
        value = 9,
        max = 10
      ),
      na_checkbox(ns)
    ), 
      ns = ns,
      open = "false",
      "compounds_collapse",
      "Compounds"
    ),
    get_radio_collapse(
      open = "false",
      ns = ns,
      collapseid = "knowledge_collapse",
      title = "Knowledge",
      label = NULL,
      flt_id1 = "flt_knowledge",
      choices = c("IDG dark kinase", "Statistically defined dark kinase", "Both", "Either", "Neither", "No filter"),
      selected = c("No filter")
    ),
    get_check_collapse(
      open = "false",
      ns = ns,
      "biological_relevance",
      "Biological Relevance",
      NULL,
      "flt_biorel",
      c("Cancer", "Alzheimer's disease", "Chronic obstructive pulmonary disease"),
      NULL,
      addl_html = sliderInput(ns("essentialcelllines"), "Essential in at least how many cell lines:",
                              min = 0, 
                              value = max(kinomedat$`Number of Essential cell lines`, na.rm = TRUE),
                              max = max(kinomedat$`Number of Essential cell lines`, na.rm = TRUE)),
      addNAcheck = TRUE
      
    ),
    get_check_collapse(
      open = "false",
      ns = ns,
      "resources",
      "Resources",
      NULL,
      "flt_resources",
      c("Structures", "Commercial assays"),
      NULL,
      addNAcheck = TRUE
    ),
    get_check_collapse(
      open = "false",
      ns = ns,
      "conventional_classification",
      "Conventional Classification",
      NULL,
      "flt_conv_class",
      c("Manning kinases", "KinHub kinases", "Both", "Neither", "No filter"),
      c("No filter")
    ),
    get_check_collapse(
      open = "false",
      ns = ns,
      collapseid = "pseudokinase",
      title = "Pseudokinase",
      label = NULL,
      flt_id1 = "flt_pseudokinase",
      choices1 = c("Pseudokinase"),
      selected1 = NULL
    ),
    get_check_collapse(
      open = "false",
      ns = ns,
      collapseid = "customlist",
      title = "Custom list",
      label = NULL,
      flt_id1 = "flt_customlist",
      choices1 = c("Custom list"),
      selected1 = NULL
    )
    
    # open = "false",
    # ns,
    # collapseid,
    # title,
    # label,
    # flt_id1,
    # choices1,
    # selected1,
    # flt_id2 = NULL,
    # choices2 = NULL,
    # selected2 = NULL,
    # addl_html = NULL,
    # addNAcheck = FALSE
    
    
    
    
  ))
  
  
}

#' filters Server Function
#'
#' @noRd
mod_filters_server <- function(input, output, session, r) {
  ns <- session$ns
  
  observeEvent(c(input$flt_kinaselike, input$flt_nokinaselike),
               {
                 proteinfold <-
                   c(input$flt_kinaselike, input$flt_nokinaselike)
                 r$proteinfold <- convert_filter_vars(proteinfold)
               },
               ignoreNULL = FALSE)
  
  observeEvent(input$flt_knowledge,
               {
                 r$knowledge_collapse <-input$flt_knowledge

               },
               ignoreNULL = FALSE)
  
  observeEvent(input$flt_resources,
               {
                 r$resources <-input$flt_resources
                 
               },
               ignoreNULL = FALSE)
  
  observeEvent(input$flt_conv_class,
               {
                 r$conventional_classification <-input$flt_conv_class
                 
               },
               ignoreNULL = FALSE)
  
  observeEvent(input$flt_pseudokinase,
               {
                 r$pseudokinase <-input$flt_pseudokinase
                 
               },
               ignoreNULL = FALSE)
  
  observeEvent(input$flt_biorel,
               {
                 r$biological_relevance <-input$flt_biorel
                 
               },
               ignoreNULL = FALSE)
  
  observeEvent(input$essentialcelllines,
               {
                 r$essential_cell_lines <-input$essentialcelllines
                 
               },
               ignoreNULL = FALSE)
  
}

## To be copied in the UI
# mod_filters_ui("filters_ui_1")

## To be copied in the server
# callModule(mod_filters_server, "filters_ui_1")
