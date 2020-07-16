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
      ns("proteinfold_collapse"),
      "Protein fold",
      "Protein Kinase Like",
      ns("flt_kinaselike"),
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
      ns("flt_nokinaselike"),
      choices2 = c("Unrelated to Protein Kinase Like", "Unknown"),
      selected2 = c("Unrelated to Protein Kinase Like", "Unknown")
    ),
    get_check_collapse(
      open = "false",
      ns("compounds_collapse"),
      "Compounds",
      "Compounds",
      ns("flt_compounds"),
      c("With at least [1] most selective/semi-selective compounds"),
      c("A")
    ),
    get_check_collapse(
      open = "false",
      ns("knowledge_collapse"),
      "Knowledge",
      NULL,
      ns("flt_knowledge"),
      c("IDG dark kinase", "Statistically defined dark kinase", "Both", "Either"),
      c("IDG dark kinase", "Statistically defined dark kinase", "Both", "Either")
    ),
    get_check_collapse(
      open = "false",
      ns("biological_relevance"),
      "Biological Relevance",
      NULL,
      ns("flt_biolrel"),
      c("Cancer", "Alzheimer's disease", "Chronic obstructive pulmonary disease", "Essential in at least [1] cell lines"),
      c("Cancer", "Alzheimer's disease", "Chronic obstructive pulmonary disease", "Essential in at least [1] cell lines")
    ),
    get_check_collapse(
      open = "false",
      ns("resources"),
      "Resources",
      NULL,
      ns("flt_resources"),
      c("Structures", "Commercial assays"),
      c("Structures", "Commercial assays")
    ),
    get_check_collapse(
      open = "false",
      ns("conventional_classification"),
      "Conventional Classification",
      NULL,
      ns("flt_convclass"),
      c("Manning kinases", "KinHub kinases", "Both", "Either"),
      c("Manning kinases", "KinHub kinases", "Both", "Either")
    )
    
    
    
    
    
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
                 print("in filter server")
                 r$knowledge_collapse <-input$flt_knowledge

               },
               ignoreNULL = FALSE)
  
  
}

## To be copied in the UI
# mod_filters_ui("filters_ui_1")

## To be copied in the server
# callModule(mod_filters_server, "filters_ui_1")
