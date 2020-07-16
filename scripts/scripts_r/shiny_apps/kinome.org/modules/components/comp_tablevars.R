#' tablevars UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_tablevars_ui <- function(id){
  ns <- NS(id)
  tagList(
    h3("Select table variables"),
    chipInput(
      id = "tablevars",
      inline = TRUE,
      placeholder = "Make a selection",
      choices = COLUMNS
    ) %>%
      active("grey") %>%
      shadow()
  )
}
    
#' tablevars Server Function
#'
#' @noRd 
mod_tablevars_server <- function(input, output, session, r){
  ns <- session$ns
  
  
  observeEvent(input$tablevars, {
    print("in filter server")

  }, ignoreNULL = FALSE)
 
}
    
## To be copied in the UI
# mod_tablevars_ui("tablevars_ui_1")
    
## To be copied in the server
# callModule(mod_tablevars_server, "tablevars_ui_1")
 
