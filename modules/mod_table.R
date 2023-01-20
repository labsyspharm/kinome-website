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
      h2("Row filters"),
      mod_filters_ui("filters_ui_1", open = TRUE)
    ),
    mainPanel(
      width = 9,
      h2("Column filters "),
      textOutput(ns("selected_columns_text_out"), inline = FALSE),
      DT::DTOutput(ns("kinometable"), width = "90%"),
      mod_ui_download_button(ns("output_table_csv_dl"), "Download CSV"),
      mod_ui_download_button(ns("output_table_xlsx_dl"), "Download Excel"),
      mod_ui_modal_column(ns("pdb_structures"))
      )
  ))
}

DT_DOM <- '<"row justify-content-between"<"col-sm-12 col-md-auto"B><"col-sm-12 col-md-auto ml-md-auto"f>><"row"<"col-sm-12"t>><"row"<"col-sm-12 col-md-3"l><"col-sm-12 col-md-3"i><"col-sm-12 col-md-6"p>>'

DT_DRAW_CALLBACK_JS = r'[
function(settings, json) {
  function show_tooltip_header(e, settings, column, state) {
    const tooltip_map = {<<tooltip_map>>};
    const api = $(this).DataTable();
    const header = $(api.table().header());
    header.find(
    "th:not(:has(span.contains-tooltip))"
    ).append(
    "<i class=\'fa fa-info-circle\ ml-1\' role=\'presentation\' aria-label=\'info-circle icon\'></i>"
    ).wrapInner(
    "<span class=\'contains-tooltip\', data-toggle=\'tooltip\'></span>"
    );
    const spans = header.find("span");
    spans.attr({"class": "contains-tooltip", "data-toggle": "tooltip"});
    spans.each(
      function(i) {
        $(this).attr("title", tooltip_map[$(this).text()]);
      }
    );
    spans.tooltip();
  }
  function send_n_cols(e, settings, column, state) {
    const api = $(this).DataTable();
    var cols = api.columns();
    var ncols = cols.count();
    var nvisible = cols.visible().filter(Boolean).count();
    console.log(ncols);
    console.log(nvisible);
    Shiny.setInputValue("<<table_id>>_ncols", ncols);
    Shiny.setInputValue("<<table_id>>_nvisible]", nvisible);
  }
  this.api().on('column-visibility.dt', send_n_cols);
  this.api().on('init.dt', send_n_cols)
  this.api().on('column-visibility.dt', show_tooltip_header);
  this.api().on('init.dt', show_tooltip_header)
}
]'

#' table Server Function
#'
#' @noRd
mod_table_server <- function(input, output, session, r_data, r_filters) {
  ns <- session$ns

  pdb_modal_display_js <- callModule(
    mod_server_modal_column,
    "pdb_structures",
    button_text = tagList(
      icon("link"),
      " PDB structures"
    ) %>%
      as.character()
  )

  r_data_processed <- reactive({
    r_data() %>%
      mutate(
        pdb_structure_ids = pdb_structure_ids %>%
          str_split(fixed(";")) %>%
          map2_chr(
            hgnc_symbol,
            ~if (is.na(.x[1]))
              ""
            else
              paste(
                .y,
                paste(
                  "<a href='https://www.rcsb.org/structure/", .x,
                  "' target='_blank'>", .x, "</a>",
                  sep = "", collapse = "<br>"
                ),
                sep = ";"
              )
          ),
        compounds = paste0(
          "<a href = \"https://labsyspharm.shinyapps.io/smallmoleculesuite/?_inputs_&tab=%22binding%22&binding-select_target=%22",
          hgnc_symbol, "%22&binding-query-select_compound=%22%22\" target=\"_blank\">",
          as.character(icon("link")), " Compounds</a>"
        ),
        across(
          any_of("indra_network"),
          ~paste0("<a href=\"", .x, "\" target=\"_blank\">", as.character(icon("link")), " Network</a>")
        )
      )
  })

  r_row_filter <- reactive({
    r_data() %>%
      mutate(idx = seq_len(n())) %>%
      filter_proteinfold(r_filters$proteinfold) %>%
      filter_compounds(r_filters$compounds, isTruthy(r_filters$na_compounds)) %>%
      filter_knowledge_collapse(r_filters$knowledge_collapse) %>%
      filter_biological_relevance(r_filters$biological_relevance, isTruthy(r_filters$na_biorel)) %>%
      filter_essential_cell_lines(r_filters$essential_cell_lines, isTruthy(r_filters$na_biorel)) %>%
      filter_resources(r_filters$resources, isTruthy(r_filters$na_resources)) %>%
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

    draw_callback_js <- glue(
      DT_DRAW_CALLBACK_JS,
      table_id = ns("kinometable"),
      tooltip_map= with(
        COLUMN_SPECS,
        paste('"', column_title, '" : "', column_description, '"', sep = "", collapse = ",")
      ),
      .open = "<<",
      .close = ">>"
    )
    cat(draw_callback_js)

    DT::datatable(
      .data,
      rownames = FALSE,
      selection = "none",
      style = "bootstrap4",
      extensions = c("Buttons"),
      escape = grep("^indra_network|pdb_structure_ids|compounds$", names(.data), invert = TRUE, value = TRUE),
      options = list(
        scrollX = TRUE,
        dom = DT_DOM,
        autoWidth = TRUE,
        buttons = make_column_selection_buttons(
          choices = COLUMN_SPECS,
          cols = names(.data),
          col_id = "column_id",
          col_title = "column_title",
          col_description = "column_description",
          col_group = "button_group"
        ),
        # buttons = list(
        #   list(
        #     extend = "colvis",
        #     text = "Additional columns",
        #     className = "btn-outline-black"
        #   )
        # ),
        initComplete = JS(draw_callback_js),
        columnDefs = list(
          list(className = 'dt-center', targets = 2),
          list(
            targets = which(
              !names(.data) %in% DEFAULT_COLUMNS
            ) - 1L,
            visible = FALSE
          ),
          list(
            targets = which(
              names(.data) == "pdb_structure_ids"
            ) - 1L,
            createdCell = JS(pdb_modal_display_js)
          )
        ) %>%
          # c(
          #   imap(names(.data), ~list(name = .x, targets = .y - 1L))
          # ) %>%
          add_column_title_defs(colnames(.data))
      )
    )
  })

  output$kinometable <- DT::renderDT(
    r_table(),
    server = TRUE
  )

  output$selected_columns_text_out <- renderText({
    paste("Showing", input$kinometable_nvisible, "out of", input$kinometable_ncols, "columns", sep = " ")
  })

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

  table_proxy
}

