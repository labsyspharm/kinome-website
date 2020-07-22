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
    chipInput(
      id = ns("tablevars"),
      inline = TRUE,
      placeholder = "Make a selection",
      choices = COLUMNS,
      selected = DEFAULT_COLUMNS
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

    if(is.null(input$tablevars)) r$tablevars <- DEFAULT_COLUMNS
    if(!is.null(input$tablevars)){
      r$tablevars <- COLUMNS[COLUMNS%in%input$tablevars] %>% names()
      if("Commercial assays available" %in% input$tablevars){
        r$tablevars <- c(r$tablevars, TWO_COLUMNS)
        r$tablevars <- r$tablevars[r$tablevars!="TWO_COLUMNS"]
      }
        
      
    }
  }, ignoreNULL = FALSE)
 
}
    
## To be copied in the UI
# mod_tablevars_ui("tablevars_ui_1")
    
## To be copied in the server
# callModule(mod_tablevars_server, "tablevars_ui_1")
 
