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
      width = 3,
      h2("Filters"),
      mod_filters_ui("filters_ui_1", open = TRUE),
      h2("Table columns") %>%
        margin(top = 5)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      width = 9,
      mod_tablevars_ui("tablevars_ui_1"),
      DT::DTOutput(ns("kinometable"), width = "90%"),
      mod_ui_download_button(ns("output_table_csv_dl"), "Download CSV"),
      mod_ui_download_button(ns("output_table_xlsx_dl"), "Download Excel")
      )
  ))
}

DT_HEADER_FORMAT_JS = paste0(
'
  function(thead, data, start, end, display) {
    const tooltip_map = {',
      with(
        COLUMN_SPECS,
        paste('"', column_title, '" : "', column_description, '"', sep = "", collapse = ",")
      ),
    '};
    const headers = $(thead).find(
      "th:not(:has(span.contains-tooltip))"
    ).append(
      "<i class=\'fa fa-info-circle\ ml-1\' role=\'presentation\' aria-label=\'info-circle icon\'></i>"
    ).wrapInner(
      "<span class=\'contains-tooltip\', data-toggle=\'tooltip\'></span>"
    );
    const spans = $(thead).find("span");
    spans.attr({"class": "contains-tooltip", "data-toggle": "tooltip"});
    spans.each(
      function(i) {
        $(this).attr("title", tooltip_map[$(this).text()]);
      }
    );
    spans.tooltip();
  }
')

#' table Server Function
#'
#' @noRd
mod_table_server <- function(input, output, session, r) {
  ns <- session$ns

  req(kinomedat)
  data <- kinomedat

  filtered_data <- reactive({
    data %>%
      filter_proteinfold(r$proteinfold) %>%
      filter_compounds(r$compounds, r$na_compounds) %>%
      filter_knowledge_collapse(r$knowledge_collapse) %>%
      filter_biological_relevance(r$biological_relevance) %>%
      filter_essential_cell_lines(r$essential_cell_lines, r$na_essential_cell_lines) %>%
      filter_resources(r$resources, r$na_resources) %>%
      filter_conv_class(r$conventional_classification) %>%
      filter_pseudokinase(r$pseudokinase) %>%
      filter_custom_HGNC(r$custom)
  })

  r_table_data <- reactive({
    .data <- filtered_data() %>%
      dplyr::select(r$tablevars) %>%
      mutate(
        across(
          any_of("indra_network"),
          ~paste0("<a href=\"", .x, "\" target=\"_blank\">Network ", as.character(icon("link")), "</a>")
        )
      )

    if ("pdb_structure_ids" %in% names(.data)) {
      r_data <- callModule(mod_server_reference_modal, "", reactive(.data), reference_col = "pdb_structure_ids")
      .data <- r_data()
    }

    .data
  })

  output$kinometable <- DT::renderDT(
    r_table_data(),
    rownames = FALSE,
    selection = "none",
    style = "bootstrap4",
    escape = grep("^indra_network|pdb_structure_ids$", names(r_table_data()), invert = TRUE, value = TRUE),
    options = list(
      scrollX = TRUE,
      headerCallback = JS(DT_HEADER_FORMAT_JS),
      columnDefs = list(
        list(className = 'dt-center', targets = 2)
      ) %>%
        add_column_title_defs(r$tablevars)
    )
  )

  callModule(mod_server_download_button, "output_table_xlsx_dl", filtered_data, "excel", "kinase_data")
  callModule(mod_server_download_button, "output_table_csv_dl", filtered_data, "csv", "kinase_data")

}

