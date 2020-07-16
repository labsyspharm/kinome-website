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
        h3("Filters"),
        mod_filters_ui("filters_ui_1", open = TRUE),
        mod_tablevars_ui("tablevars_ui_1")
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
mod_table_server <- function(input, output, session, r){
  ns <- session$ns

  req(kinomedat)
  .data <- kinomedat
  
  observeEvent(r$proteinfold, {
  
    .data <- .data %>% dplyr::filter(Fold_Annotation %in% r$proteinfold)
    .data <- .data %>% dplyr::select(gene_id, Fold_Annotation, `HGNC ID`)
    output$kinometable <- DT::renderDT(
      .data,
      options = list(
        columnDefs = list(list(className = 'dt-center', targets = 2))
      )
    )
    })

  

  # data_filtered <- reactive({
  # 
  #   kinomedat %>% 
  #     dplyr::filter(
  #       Fold_Annotation %in% proteinfold
  #     ) %>% 
  #     select(
  #       Fold_Annotation
  #     )
  # })

  

  
}
    
## To be copied in the UI
# mod_table_ui("table_ui_1")
    
## To be copied in the server
# callModule(mod_table_server, "table_ui_1")
 
