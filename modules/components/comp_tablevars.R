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

  # tagList(
  #   checkbarInput(
  #     id = ns("tablevars"),
  #     choices = COLUMN_TITLE_MAP,
  #     values = names(COLUMN_TITLE_MAP),
  #     selected = DEFAULT_COLUMNS,
  #     class = "btn-group-primary"
  #   )
  # )
  groupedCheckbarInput(
    id = ns("tablevars"),
    choices = COLUMN_SPECS,
    selected = DEFAULT_COLUMNS,
    col_id = "column_id",
    col_title = "column_title",
    col_description = "column_description",
    col_group = "button_group"
  )
}
#
# groupedCheckbarInput <- function(
#   ...,
#   choices,
#   col_id,
#   col_title,
#   col_description,
#   col_group
# ) {
#   args <- rlang::list2(...)
#   button_groups <- choices %>%
#     group_by(!!sym(col_group)) %>%
#     group_map(
#       ~{
#         cb <- checkbarInput(
#           id = paste(args[["id"]], .y[[col_group]], sep = "_"),
#           choices = .x[[col_title]],
#           values = .x[[col_id]],
#           selected = args[["selected"]][args[["selected"]] %in% .x[[col_id]]],
#           class = paste(args[["class"]], "mb-1")
#         )
#         attr(cb, "class") <- c("shiny.tag")
#         cb
#       }
#     )
#   # browser()
#   tags$div(
#     button_groups,
#     id = args[["id"]],
#     class = "yonder_checkbar yonder_input shiny.tag btn-toolbar flex flex-wrap",
#     role = "toolbar",
#     `aria-label` = "Toolbar with button groups"
#   )
# }

groupedCheckbarInput <- function (
  ...,
  id,
  selected,
  choices,
  col_id,
  col_title,
  col_description,
  col_group
)
{
  button_groups <- choices %>%
    group_by(!!sym(col_group)) %>%
    group_map(
      ~{
        yonder:::map_checkbuttons(
          choices = .x[[col_title]],
          values = .x[[col_id]],
          selected = selected[selected %in% .x[[col_id]]]
        ) %>%
          tags$div(
            class = "btn-group btn-group-toggle btn-group-primary mb-2"
          )
      }
    )
  tag <- yonder:::dep_attach({
    # checkboxes <- map_checkbuttons(choices, values, selected)
    tags$div(class = "yonder-checkbar btn-toolbar flex flex-wrap",
             id = id, `data-toggle` = "buttons", button_groups, ...)
  })
  yonder:::s3_class_add(tag, c("yonder_checkbar", "yonder_input"))
}

x <- groupedCheckbarInput(
  id = "asdf",
  class = "btn-group-primary",
  choices = COLUMN_SPECS,
  col_id = "column_id",
  col_title = "column_title",
  col_description = "column_description",
  col_group = "button_group",
  selected = DEFAULT_COLUMNS
)

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
        c(MULTISELECT_COLUMNS[[multivars]])
    }
    r$tablevars <- tablevars
  }, ignoreNULL = FALSE)

}

## To be copied in the UI
# mod_tablevars_ui("tablevars_ui_1")

## To be copied in the server
# callModule(mod_tablevars_server, "tablevars_ui_1")

