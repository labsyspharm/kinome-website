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
      mod_filters_ui("filters_ui_1", open = TRUE)
    ),
    mainPanel(
      width = 9,
      mod_tablevars_ui("tablevars_ui_1", table_id = ns("kinometable")),
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
mod_table_server <- function(input, output, session, r_filters) {
  ns <- session$ns

  req(kinomedat)

  r_data <- reactive(kinomedat)

  r_data_processed <- reactive({
    callModule(mod_server_reference_modal, "", r_data, reference_col = "pdb_structure_ids")() %>%
      mutate(
        across(
          any_of("indra_network"),
          ~paste0("<a href=\"", .x, "\" target=\"_blank\">Network ", as.character(icon("link")), "</a>")
        )
      )
  })

  r_row_filter <- reactive({
    r_data() %>%
      mutate(idx = seq_len(n())) %>%
      filter_proteinfold(r_filters$proteinfold) %>%
      filter_compounds(r_filters$compounds, r_filters$na_compounds) %>%
      filter_knowledge_collapse(r_filters$knowledge_collapse) %>%
      filter_biological_relevance(r_filters$biological_relevance) %>%
      filter_essential_cell_lines(r_filters$essential_cell_lines, r_filters$na_essential_cell_lines) %>%
      filter_resources(r_filters$resources, r_filters$na_resources) %>%
      filter_conv_class(r_filters$conventional_classification) %>%
      filter_pseudokinase(r_filters$pseudokinase) %>%
      filter_custom_HGNC(r_filters$custom) %>%
      pull(idx)
  })

  r_table_data <- reactive({
    r_data_processed()[r_row_filter(),]
  })

  r_download_data <- reactive({
    r_data()[r_row_filter(),]
  })

  r_table <- reactive({
    .data <- isolate(r_table_data())

    DT::datatable(
      .data,
      rownames = FALSE,
      selection = "none",
      style = "bootstrap4",
      escape = grep("^indra_network|pdb_structure_ids$", names(.data), invert = TRUE, value = TRUE),
      options = list(
        scrollX = TRUE,
        headerCallback = JS(DT_HEADER_FORMAT_JS),
        columnDefs = list(
          list(className = 'dt-center', targets = 2),
          list(
            targets = which(
              !names(.data) %in% DEFAULT_COLUMNS
            ) %>%
              magrittr::subtract(1),
            visible = FALSE
          )
        ) %>%
          c(
            imap(names(.data), ~list(name = .x, targets = .y - 1L))
          ) %>%
          add_column_title_defs(colnames(.data))
      )
    )
  })

  output$kinometable <- DT::renderDT(
    r_table(),
    server = TRUE
  )

  table_proxy <- dataTableProxy("kinometable")

  observe({
    replaceData(
      table_proxy,
      r_table_data(),
      resetPaging = FALSE,
      rownames = FALSE
    )
  })

  callModule(mod_server_download_button, "output_table_xlsx_dl", r_download_data, "excel", "kinase_data")
  callModule(mod_server_download_button, "output_table_csv_dl", r_download_data, "csv", "kinase_data")
}

