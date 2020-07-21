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
  
  
  filtered_data <- reactive({
    

      print(paste("start:", nrow(.data)))
      .data <- filter_proteinfold(.data, r$proteinfold)
      print(paste("protein:", nrow(.data)))
        .data <- filter_compounds(.data, r$compounds, r$na_compounds)
        print(paste("compounds:", nrow(.data)))
    #if(!is.null(r$knowledge_collapse) && !r$knowledge_collapse == "No filter")
      .data <- filter_knowledge_collapse(.data, r$knowledge_collapse)
      print(paste("knowledge:", nrow(.data)))
      
      .data <- filter_biological_relevance(.data, r$biological_relevance)
      print(paste("biological:", nrow(.data)))
      
      .data <- filter_essential_cell_lines(.data, r$essential_cell_lines, r$na_essential_cell_lines)
      print(paste("essential:", nrow(.data)))
    #if(!is.null(r$resources))
      .data <- filter_resources(.data, r$resources, r$na_resources)
      print(paste("resources:", nrow(.data)))
      

    #if(!is.null(r$conventional_classification))
      .data <- filter_conv_class(.data, r$conventional_classification)
      print(paste("conventional:", nrow(.data)))

      .data <- filter_pseudokinase(.data, r$pseudokinase)
      print(paste("pseudokinase:", nrow(.data)))
    #if(!is.null(r$biological_relevance))

    #if(!is.null(r$essential_cell_lines))

    
    
    .data
  })
  
    output$kinometable <- DT::renderDT(filtered_data() %>% dplyr::select(r$tablevars),
                                       options = list(columnDefs = list(
                                         list(className = 'dt-center', targets = 2)
                                       )))
  
  
  
  
}

## To be copied in the UI
# mod_table_ui("table_ui_1")

## To be copied in the server
# callModule(mod_table_server, "table_ui_1")
