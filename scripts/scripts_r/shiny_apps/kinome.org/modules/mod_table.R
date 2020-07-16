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
      h2("Filters"),
      mod_filters_ui("filters_ui_1", open = TRUE),
      h2("Select table variables") %>%
        margin(top = 5),
      mod_tablevars_ui("tablevars_ui_1")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(DT::DTOutput(ns("kinometable")))
  ))
}

#' table Server Function
#'
#' @noRd
mod_table_server <- function(input, output, session, r) {
  ns <- session$ns
  
  req(kinomedat)
  .data <- kinomedat
  
  observeEvent(c(r$proteinfold, r$tablevars, r$knowledge_collapse), {
    
    if(!is.null(r$proteinfold)){
      .data <- .data %>% dplyr::filter(Fold_Annotation %in% r$proteinfold)
    }

    if(!is.null(r$knowledge_collapse)){
      
      idg <- ifelse("IDG dark kinase" %in% r$knowledge_collapse, 1, 0)
      statdef <- ifelse("Statistically defined dark kinase" %in% r$knowledge_collapse, 1, 0)
      .data <- .data %>% 
        dplyr::filter(`IDG dark kinase` == idg) %>% 
        dplyr::filter(`Statistically defined dark kinase` == statdef)
    }
    
    .data <- .data %>% dplyr::select(r$tablevars)
    output$kinometable <- DT::renderDT(.data,
                                       options = list(columnDefs = list(
                                         list(className = 'dt-center', targets = 2)
                                       )))
  })
  
  
  
  
}

## To be copied in the UI
# mod_table_ui("table_ui_1")

## To be copied in the server
# callModule(mod_table_server, "table_ui_1")
