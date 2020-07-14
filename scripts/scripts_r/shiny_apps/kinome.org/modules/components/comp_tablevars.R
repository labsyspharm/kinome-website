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
      id = ns("columns"),
      inline = TRUE,
      placeholder = "Make a selection",
      choices = c(
        "Setting", "Year", "Indicator name", "Dimension", "Subgroup",
        "Estimate", "Population share",
        "Source", "Indicator abbreviation",
        "95% CI lower bound","95% CI upper bound", "Flag", "Setting average"
      ),
      selected = c(
        "Setting", "Year", "Indicator name", "Dimension", "Subgroup",
        "Estimate", "Population share"
      )
    ) %>%
      active("grey") %>%
      shadow()
  )
}
    
#' tablevars Server Function
#'
#' @noRd 
mod_tablevars_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_tablevars_ui("tablevars_ui_1")
    
## To be copied in the server
# callModule(mod_tablevars_server, "tablevars_ui_1")
 
