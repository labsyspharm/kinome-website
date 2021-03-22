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
      "Protein Kinase Like",
      ns("flt_kinaselike"),
      INIT$flt_kinaselike,
      INIT$flt_kinaselike,
      ns("flt_nokinaselike"),
      label2 = "Non Protein Kinase Like",
      choices2 = INIT$flt_nokinaselike,
      selected2 = INIT$flt_nokinaselike
    ) %>%
      collapse_wrapper(
        open = "false", collapseid = ns("proteinfold_collapse"), title = "Protein Fold",
        description = "Include kinases with the following protein folds"
      ),
    tagList(
      sliderInput(
        ns("flt_compounds"),
        "Only include kinases with at least this many most-selective/semi-selective compounds",
        min = min(kinomedat$n_selective_compounds, na.rm=TRUE),
        value = INIT$flt_compounds,
        max = max(kinomedat$n_selective_compounds, na.rm=TRUE)
      ),
      na_checkbox(ns("na_compounds"), includeNA = TRUE)
    ) %>%
      collapse_wrapper(
        open = "false", collapseid = ns("compounds_collapse"), title = "Compounds"
      ),
    get_radio_collapse(
      label = NULL,
      flt_id1 = ns("flt_knowledge"),
      choices = c("IDG dark kinase", "Statistically defined dark kinase", "Both", "Either", "Neither", "No filter"),
      selected = INIT$flt_knowledge
    ) %>%
      collapse_wrapper(
        open = "false", collapseid = ns("knowledge_collapse"), title = "Knowledge",
        description = "Select kinases if they were considered to be understudied by the following metrics"
      ),
    get_check_collapse(
      NULL,
      ns("flt_biorel"),
      c("Cancer", "Alzheimer's disease", "Chronic obstructive pulmonary disease"),
      NULL,
      addl_html = sliderInput(ns("essentialcelllines"), "Essential in at least how many cell lines:",
                              min = 0,
                              value = 0,
                              max = max(kinomedat$n_essential_cell_lines, na.rm = TRUE)),
      addNAcheck = TRUE,
      na_checkid = ns("na_biorel")
    ) %>%
      collapse_wrapper(
        open = "false", collapseid = ns("biological_relevance"), title = "Biological Relevance",
        description = "Only include kinases that have been implicated in the following diseases"
      ),
    get_check_collapse(
      NULL,
      ns("flt_resources"),
      c("at least 1 crystal structures", "at least 1 commercial assays"),
      NULL,
      addNAcheck = TRUE,
      na_checkid = ns("na_resources")
    ) %>%
      collapse_wrapper(
        open = "false", collapseid = ns("resources"), title = "Resources",
        description = "Only include kinases with the following resources"
      ),
    get_radio_collapse(
      NULL,
      ns("flt_conv_class"),
      c("Manning kinases", "KinHub kinases", "Both", "Either", "Neither", "No filter"),
      c("No filter")
    ) %>%
      collapse_wrapper(
        open = "false", collapseid = ns("conventional_classification"), title = "Conventional Classification",
        description = "Select kinases if they are included in the following kinase lists"
      ),
    get_radio_collapse(
      label = NULL,
      flt_id1 = ns("flt_pseudokinase"),
      choices1 = c("Exclude pseudokinases", "Show only pseudokinases", "No filter"),
      selected1 = "No filter"
    ) %>%
      collapse_wrapper(
        open = "false", collapseid = ns("pseudokinase"), title = "Pseudokinase",
        description = "Select kinases by their classification as pseudokinases"
      ),
    formGroup(
      label = NULL,
      input = textAreaInput(ns("flt_custom"), label = NULL, placeholder = "AAK1, PRKAA1", rows = 5),
      help = "Add HGNC symbols separated by commas or lines"
    ) %>%
      collapse_wrapper(
        open = "false", collapseid = ns("custom_collapse"), title = "Custom",
        description = "Please input your list of kinases of interest"
      ),
    buttonInput(id = ns('reset_all'), label = "Reset filters"),
    buttonInput(id = ns('collapse_all'), label = "Collapse all", onclick = "$('.panel-title a').attr('aria-expanded', false); $('.panel-collapse').removeClass('show')")

  ))


}

#' filters Server Function
#'
#' @noRd
mod_filters_server <- function(input, output, session) {
  ns <- session$ns

  r_filters <- reactiveValues()

  observe({
    proteinfold <- c(input$flt_kinaselike, input$flt_nokinaselike)
    r_filters$proteinfold <- proteinfold
  })

  observe(r_filters$compounds <-input$flt_compounds)
  observe(r_filters$na_compounds <-input$na_compounds)
  observe(r_filters$knowledge_collapse <-input$flt_knowledge)
  observe(r_filters$biological_relevance <-input$flt_biorel)
  observe(r_filters$resources <-input$flt_resources)
  observe(r_filters$na_resources <-input$na_resources)
  observe(r_filters$conventional_classification <-input$flt_conv_class)
  observe(r_filters$pseudokinase <-input$flt_pseudokinase)
  observe(r_filters$essential_cell_lines <-input$essentialcelllines)
  observe(r_filters$na_biorel <-input$na_biorel)
  observe(r_filters$custom <-input$flt_custom)


  observeEvent(input$reset_all, {
    # don't need session for yonder
    updateCheckboxInput("flt_kinaselike", selected = INIT$flt_kinaselike)
    updateCheckboxInput("flt_nokinaselike", selected = INIT$flt_nokinaselike)

    updateSliderInput(session, "flt_compounds",  value = INIT$flt_compounds)
    updateCheckboxInput("na_compounds", selected = INIT$na_compounds)
    updateRadioInput("flt_knowledge", selected = INIT$flt_knowledge)
    yonder::updateCheckboxInput("flt_biorel", selected = "NULL")
    updateSliderInput(session, "essentialcelllines",  value = INIT$essentialcelllines)

    updateCheckboxInput("na_biorel", selected = INIT$na_biorel)

    updateCheckboxInput("flt_resources", selected = INIT$flt_resources)
    updateCheckboxInput("na_resources", selected = INIT$na_resources)

    updateCheckboxInput("flt_conv_class", selected = INIT$flt_conv_class)
    updateCheckboxInput("flt_pseudokinase", selected = INIT$flt_pseudokinase)


    updateTextInput("flt_custom", value = INIT$flt_custom)

  })

  r_filters
}

