#' table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_table_ui <- function(id) {
  ns <- NS(id)
  tagList(sidebarLayout(
    # Sidebar with a slider input
    sidebarPanel(
      width = 3,
      h2("Filters"),
      mod_filters_ui("filters_ui_1", open = TRUE),
      h2("Add information on") %>%
        margin(top = 5),
      mod_tablevars_ui("tablevars_ui_1")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      width = 9,
      DT::DTOutput(ns("kinometable"), width = "90%"),
      mod_ui_download_button(ns("output_table_csv_dl"), "Download CSV"),
      mod_ui_download_button(ns("output_table_xlsx_dl"), "Download Excel")
      )
  ))
}

#' table Server Function
#'
#' @noRd
mod_table_server <- function(input, output, session, r) {
  ns <- session$ns
  
  req(kinomedat)
  data <- kinomedat
  
  
  filtered_data <- reactive({

      data <- filter_proteinfold(data, r$proteinfold)
      data <- filter_compounds(data, r$compounds, r$na_compounds)
      data <- filter_knowledge_collapse(data, r$knowledge_collapse)
      data <- filter_biological_relevance(data, r$biological_relevance)
      data <- filter_essential_cell_lines(data, r$essential_cell_lines, r$na_essential_cell_lines)
      data <- filter_resources(data, r$resources, r$na_resources)
      data <- filter_conv_class(data, r$conventional_classification)
      data <- filter_pseudokinase(data, r$pseudokinase)
      data <- filter_custom_HGNC(data, r$custom)
      
      data
  })
  
    output$kinometable <- DT::renderDT(filtered_data() %>% dplyr::select(r$tablevars),
                                       options = list(
                                         scrollX = TRUE,
                                         columnDefs = list(
                                         list(className = 'dt-center', targets = 2)
                                       )))
  
  
    callModule(mod_server_download_button, "output_table_xlsx_dl", filtered_data, "excel", "kinase_data")
    callModule(mod_server_download_button, "output_table_csv_dl", filtered_data, "csv", "kinase_data")
  
}

