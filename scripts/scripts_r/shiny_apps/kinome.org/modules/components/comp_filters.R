#' filters UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_filters_ui <- function(id, open = TRUE){
  ns <- NS(id)
  tagList(
    div(
      class = "panel-group",
      div(class = "panel-heading",
          h3(
            class = "panel-title",
            tags$a(
              `data-toggle` = "collapse",
              `aria-expanded` = ifelse(open, "true", "false"),
              href = paste0("#", ns("graph_collapse")),
              paste("Protein fold"),
              icon("chevron-right")
            )
          )),
      div(
        id = ns("graph_collapse"),
        class = glue::glue("panel-collapse collapse {ifelse(open, 'in', '')}"),
        div(class = "panel-body",
            
            checkboxGroupInput(ns("proteinfold1"), label = "Protein Kinase Like",
                               choices = c("Eukaryotic Protein Kinase (ePK)",
                                           "Eukaryotic Like Kinase (eLK)",
                                           "Atypical")),
            checkboxInput(ns("proteinfold2"), label ="", choices = "Unrelated to Protein"),
            checkboxInput(ns("proteinfold3"), label ="", choices = "Kinase Like"),
            checkboxInput(ns("proteinfold4"), label ="", choices = "Unknown")
        )
        
      )
    )
  )
}

#' filters Server Function
#'
#' @noRd 
mod_filters_server <- function(input, output, session){
  ns <- session$ns
  
}

## To be copied in the UI
# mod_filters_ui("filters_ui_1")

## To be copied in the server
# callModule(mod_filters_server, "filters_ui_1")

