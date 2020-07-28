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
      INIT$flt_kinaselike,
      INIT$flt_kinaselike,
      ns("flt_nokinaselike"),
      choices2 = INIT$flt_nokinaselike,
      selected2 = INIT$flt_nokinaselike
    ),
    collapse_wrapper(internal_html = list(
      sliderInput(
        ns("flt_compounds"),
        "Maximum number of most-selective/semi-selective compounds:",
        min = min(kinomedat$`Number of MS/SS cmpds`, na.rm=TRUE),
        value = INIT$flt_compounds,
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
      selected = INIT$flt_knowledge
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
    buttonInput(ns('reset_all'), label = "Reset filters"),
    buttonInput(ns('collapse_all'), label = "Collapse all", onclick = "$('.panel-title a').attr('aria-expanded', false); $('.panel-collapse').removeClass('show')")
    
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
  observe(r$essential_cell_lines <-input$essentialcelllines)
  observe(r$na_essential_cell_lines <-input$na_essentialcelllines)
  observe(r$custom <-input$flt_custom)
  
  
  observeEvent(input$reset_all, {
    
    # don't need session for yonder
    updateCheckboxInput("flt_kinaselike", selected = INIT$flt_kinaselike)
    updateCheckboxInput("flt_nokinaselike", selected = INIT$flt_nokinaselike)
    
    updateSliderInput(session, "flt_compounds",  value = INIT$flt_compounds)
    updateCheckboxInput("na_compounds", selected = INIT$na_compounds)
    updateRadioInput("flt_knowledge", selected = INIT$flt_knowledge)
    yonder::updateCheckboxInput("flt_biorel", selected = "NULL")
    updateSliderInput(session, "essentialcelllines",  value = INIT$essentialcelllines)
    
    updateCheckboxInput("na_essentialcelllines", selected = INIT$na_essentialcelllines)
    
    updateCheckboxInput("flt_resources", selected = INIT$flt_resources)
    updateCheckboxInput("na_resources", selected = INIT$na_resources)
    
    updateCheckboxInput("flt_conv_class", selected = INIT$flt_conv_class)
    updateCheckboxInput("flt_pseudokinase", selected = INIT$flt_pseudokinase)
    
    
    updateTextInput("flt_custom", value = INIT$flt_custom)

  })
  
}

