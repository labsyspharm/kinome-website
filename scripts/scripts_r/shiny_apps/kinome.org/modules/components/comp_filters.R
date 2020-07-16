#' filters UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_filters_ui <- function(id, open = FALSE){
  ns <- NS(id)
  tagList(div(class = "panel-group",
              
              
              div(
                class = "panel-group",
                div(class = "panel-heading",
                    h3(
                      class = "panel-title",
                      tags$a(
                        `data-toggle` = "collapse",
                        `aria-expanded` = ifelse(open, "true", "false"),
                        href = paste0("#", ns("proteinfold_collapse")),
                        paste("Protein fold"),
                        icon("chevron-right")
                      )
                    )),
                div(
                  id = ns("proteinfold_collapse"),
                  class = glue::glue("panel-collapse collapse {ifelse(open, 'in', '')}"),
                  formGroup(
                    label = tags$h6("Protein Kinase Like") %>% margin(b = 0),
                    input = checkboxInput(
                      inline = TRUE,
                      id = ns("flt_kinaselike"),
                      choices = c("Eukaryotic Protein Kinase (ePK)", "Eukaryotic Like Kinase (eLK)", "Atypical"),
                      selected = c("Eukaryotic Protein Kinase (ePK)", "Eukaryotic Like Kinase (eLK)", "Atypical")
                    ) %>%
                      active("red")
                  ),
                  formGroup(
                    label = NULL,
                    input = checkboxInput(
                      inline = TRUE,
                      id = ns("flt_nokinaselike"),
                      choices = c("Unrelated to Protein Kinase Like", "Unknown"),
                      selected = c("Unrelated to Protein Kinase Like", "Unknown")
                    ) %>%
                      active("red"),
                    help = "Changchang, do you want a help statement here?"
                  ),
                )
                
                
              )))
  

}

#' filters Server Function
#'
#' @noRd 
mod_filters_server <- function(input, output, session, r){
  ns <- session$ns
  
  observeEvent(c(input$flt_kinaselike, input$flt_nokinaselike), {

    proteinfold <- c(input$flt_kinaselike, input$flt_nokinaselike)
    r$proteinfold <- convert_filter_vars(proteinfold)
  }, ignoreNULL = FALSE)
  
  
}

## To be copied in the UI
# mod_filters_ui("filters_ui_1")

## To be copied in the server
# callModule(mod_filters_server, "filters_ui_1")

