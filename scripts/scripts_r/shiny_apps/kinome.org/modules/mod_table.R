#' table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    sidebarLayout(
      
      # Sidebar with a slider input
      sidebarPanel(
        h3("--- Filters ---"),
        mod_filters_ui(ns("filters_ui_1")),
        mod_tablevars_ui(ns("tablevars_ui_1"))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        h1("Table goes here"),
        DT::DTOutput(ns("kinometable"))
      )
    )
  )
}
    
#' table Server Function
#'
#' @noRd 
mod_table_server <- function(input, output, session){
  ns <- session$ns
 
  req(kinomedat)
  
  kinomedat_lim <- kinomedat[,START_COLUMNS]
  
  
  output$kinometable <- DT::renderDT(
    kinomedat_lim,
    options = list(
      columnDefs = list(list(className = 'dt-center', targets = 2))
    )
    ) 
  
}
    
## To be copied in the UI
# mod_table_ui("table_ui_1")
    
## To be copied in the server
# callModule(mod_table_server, "table_ui_1")
 
