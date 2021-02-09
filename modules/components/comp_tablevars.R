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

  tags$div(
    tags$h2("Select columns"),
    groupedCheckbarInput(
      id = ns("checkboxes"),
      choices = COLUMN_SPECS,
      selected = DEFAULT_COLUMNS,
      col_id = "column_id",
      col_title = "column_title",
      col_description = "column_description",
      col_group = "button_group"
    )
  ) %>%
    margin(b = 4)
}

mod_tablevars_server <- function(input, output, session, r_data, table_proxy){
  ns <- session$ns

  observe({
    showCols(
      table_proxy,
      match(input$checkboxes, colnames(r_data())) - 1L,
      reset = TRUE
    )
  })
}

map_checkbuttons_tooltip <- function (choices, values, selected, tooltips) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }
  selected <- values %in% selected
  Map(choice = choices, value = values, select = selected, tooltip = tooltips,
      function(choice, value, select, tooltip) {
        tags$label(
          class = yonder:::str_collate(
            "btn",
            if (select) "active"
          ),
          `data-toggle` = "tooltip",
          title = tooltip,
          tags$input(
            type = "checkbox",
            # class = "btn-check",
            autocomplete = "off",
            value = value,
            checked = if (select) NA
          ),
          choice
        )
      })
}

groupedCheckbarInput <- function (
  id,
  selected,
  choices,
  col_id,
  col_title,
  col_description,
  col_group
)
{
  col_group_sym <- sym(col_group)
  button_groups <- choices %>%
    mutate(
      across(!!col_group_sym, forcats::fct_inorder)
    ) %>%
    group_by(!!col_group_sym) %>%
    group_map(
      ~{
        map_checkbuttons_tooltip(
          choices = .x[[col_title]],
          values = .x[[col_id]],
          selected = selected[selected %in% .x[[col_id]]],
          tooltips = .x[[col_description]]
        ) %>%
          tags$div(
            class = "btn-group btn-group-toggle btn-group-secondary btn-group-sm mb-2"
          )
      }
    )

  tagList(
    yonder:::dep_attach({
      tags$div(
        class = "yonder-checkbar btn-toolbar flex flex-wrap",
        id = id,
        `data-toggle` = "buttons",
        button_groups
      )
    }) %>%
      yonder:::s3_class_add(c("yonder_checkbar", "yonder_input")),
    tags$script(HTML(
      "$('[data-toggle=\"tooltip\"]').tooltip();"
    ))
  )
}
