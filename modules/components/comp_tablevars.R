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
      choices = COLUMN_TITLE_MAP,
      values = names(COLUMN_TITLE_MAP),
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
    tablevars <- input$tablevars %||% DEFAULT_COLUMNS
    multivars <- intersect(tablevars, names(MULTISELECT_COLUMNS))
    if (length(multivars) > 0) {
      tablevars <- tablevars %>%
        setdiff(multivars) %>%
        c(MULTISELECT_COLUMNS[multivars])
    }
    r$tablevars <- tablevars
  }, ignoreNULL = FALSE)

}

## To be copied in the UI
# mod_tablevars_ui("tablevars_ui_1")

## To be copied in the server
# callModule(mod_tablevars_server, "tablevars_ui_1")

