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
      "Protein Fold",
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
    collapse_wrapper(internal_html = list(
      sliderInput(
        ns("flt_compounds"),
        "Maximum number of most-selective/semi-selective compounds:",
        min = min(kinomedat$`Number of MS/SS cmpds`, na.rm=TRUE),
        value = min(kinomedat$`Number of MS/SS cmpds`, na.rm=TRUE),
        max = max(kinomedat$`Number of MS/SS cmpds`, na.rm=TRUE)
      ),
      na_checkbox(ns("na_compounds"), includeNA = TRUE)
    ), 
      open = "false",
      ns("compounds_collapse"),
      "Compounds"
    ),
    get_radio_collapse(
      open = "false",
      collapseid = ns("knowledge_collapse"),
      title = "Knowledge",
      label = NULL,
      flt_id1 = ns("flt_knowledge"),
      choices = c("IDG dark kinase", "Statistically defined dark kinase", "Both", "Either", "Neither", "No filter"),
      selected = c("No filter")
    ),
    get_check_collapse(
      open = "false",
      ns("biological_relevance"),
      "Biological Relevance",
      NULL,
      ns("flt_biorel"),
      c("Cancer", "Alzheimer's disease", "Chronic obstructive pulmonary disease"),
      NULL,
      addl_html = sliderInput(ns("essentialcelllines"), "Essential in at least how many cell lines:",
                              min = 0, 
                              value = 0,
                              max = max(kinomedat$`Number of Essential cell lines`, na.rm = TRUE)),
      addNAcheck = TRUE,
      na_checkid = ns("na_essentialcelllines")
      
    ),
    get_check_collapse(
      open = "false",
      ns("resources"),
      "Resources",
      NULL,
      ns("flt_resources"),
      c("Structures", "Commercial assays"),
      NULL,
      addNAcheck = TRUE,
      na_checkid = ns("na_resources")
    ),
    get_radio_collapse(
      open = "false",
      ns("conventional_classification"),
      "Conventional Classification",
      NULL,
      ns("flt_conv_class"),
      c("Manning kinases", "KinHub kinases", "Both", "Either", "Neither", "No filter"),
      c("No filter")
    ),
    get_radio_collapse(
      open = "false",
      collapseid = ns("pseudokinase"),
      title = "Pseudokinase",
      label = NULL,
      flt_id1 = ns("flt_pseudokinase"),
      choices1 = c("Exclude pseudokinases", "Show only pseudokinases", "No filter"),
      selected1 = "No filter"
    ),
    collapse_wrapper(internal_html = 
      formGroup(
        label = NULL,
        input = textInput(ns("flt_custom"), placeholder = "AAK1, PRKAA1"),
        help = "Add HGNC symbols separated by commas"
      ),
    open = "false",
    ns("custom_collapse"),
    "Custom"
    ),
    
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
  
  observe({ 
    proteinfold <- c(input$flt_kinaselike, input$flt_nokinaselike)
    r$proteinfold <- proteinfold
    })
  
  observe(r$compounds <-input$flt_compounds)
  observe(r$na_compounds <-input$na_compounds)
  observe(r$knowledge_collapse <-input$flt_knowledge)
  observe(r$biological_relevance <-input$flt_biorel)
  observe(r$resources <-input$flt_resources)
  observe(r$na_resources <-input$na_resources)
  observe(r$conventional_classification <-input$flt_conv_class)
  observe(r$pseudokinase <-input$flt_pseudokinase)
  observe(r$essential_cell_lines <-input$essentialcellline)
  observe(r$na_essential_cell_lines <-input$na_essentialcelllines)
  observe(r$custom <-input$flt_custom)
  
}

