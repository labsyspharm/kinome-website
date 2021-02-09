#' tablevars UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_tablevars_ui <- function(id, table_id){
  ns <- NS(id)

  tags$div(
    tags$h2("Select columns"),
    groupedCheckbarInput(
      id = ns("tablevars"),
      choices = COLUMN_SPECS,
      selected = DEFAULT_COLUMNS,
      col_id = "column_id",
      col_title = "column_title",
      col_description = "column_description",
      col_group = "button_group",
      ns = ns,
      table_id = table_id
    )
  ) %>%
    margin(b = 4)
}

DT_COLUMN_SELECT_JS <- r"---(
    $('.{-toggle_class-}').on( 'change', function (e) {
        // e.preventDefault();

        var table = $('#{-table_id-} div.dataTables_scrollBody table').DataTable();

        // Get the column API object
        var column = table.column( $(this).attr('data-value') + ':name' );

        // Toggle the visibility
        column.visible( this.checked );
    } );
)---"

map_checkbuttons_tooltip <- function (choices, values, selected, tooltips, ns) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }
  selected <- values %in% selected
  Map(choice = choices, value = values, select = selected, tooltip = tooltips,
      function(choice, value, select, tooltip) {
        input_id <- ns(paste0("toggle-button", value))
        tags$label(
          class = "btn",
          `data-toggle` = "tooltip",
          title = tooltip,
          `for` = input_id,
          tags$input(
            type = "checkbox",
            class = paste("btn-check", ns("toggle-button")),
            autocomplete = "off",
            `data-value` = value,
            id = input_id,
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
  col_group,
  ns,
  table_id
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
          tooltips = .x[[col_description]],
          ns = ns
        ) %>%
          tags$div(
            class = "btn-group btn-group-toggle btn-group-secondary btn-group-sm mb-2"
          )
      }
    )

  tagList(
    tags$div(
      class = "btn-toolbar flex flex-wrap",
      id = id, `data-toggle` = "buttons",
      button_groups
    ),
    tags$script(HTML(
      "$('[data-toggle=\"tooltip\"]').tooltip();",
      glue(
        DT_COLUMN_SELECT_JS,
        table_id = table_id,
        toggle_class = ns("toggle-button"),
        .open = r"({-)",
        .close = r"(-})"
      )
    ))
  )
}
