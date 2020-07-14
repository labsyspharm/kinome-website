#' tableview UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_tableview_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' tableview Server Function
#'
#' @noRd 
mod_tableview_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_tableview_ui("tableview_ui_1")
    
## To be copied in the server
# callModule(mod_tableview_server, "tableview_ui_1")
 
