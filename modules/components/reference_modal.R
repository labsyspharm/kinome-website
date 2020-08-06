format_references <- function(references) {
  ref_split <- str_split(references, fixed(";"))[[1]]
  links <- map(
    ref_split,
    function(r) {
      tags$p(tags$a(r, href = paste0("https://www.rcsb.org/structure/", r), target = "_blank"))
    }
  )
  exec(div, !!!links)
}

mod_server_reference_modal <- function(
  input, output, session,
  r_data, reference_col = "references"
) {
  ns <- session$ns

  # References before assignment of links to reference column
  r_raw_references <- reactive({
    r_data()[[reference_col]]
  })

  r_clicked_reference_idx <- reactive({
    req(input$clicked_reference, cancelOutput = TRUE)
    input$clicked_reference %>%
      str_match("reference_link_([0-9]+)$") %>%
      {.[[1, 2]]} %>%
      as.integer()
  })

  o_reference_change <- observeEvent(r_clicked_reference_idx(), {
    req(r_clicked_reference_idx())
    # Need to isolate here, because otherwise if r_data changes
    # the modal is shown again. We only want to show modal if input$clicked_references
    # changes
    clicked_row <- isolate(r_data())[r_clicked_reference_idx(), ]
    shiny::showModal(
      modalDialog(
        format_references(isolate(r_raw_references()[r_clicked_reference_idx()])),
        title = with(
          clicked_row,
          paste0(
            "PDB structures for ", hgnc_symbol, " (", hgnc_name, ")"
          )
        ),
        easyClose = TRUE
      )
    )
  })

  r_ref_links <- reactive({
    map_chr(
      seq_along(r_raw_references()),
      ~actionLink(
        ns("clicked_reference"),
        "PDB structures",
        icon = icon("link"),
        onclick = paste0("Shiny.setInputValue('", ns("clicked_reference"), "', this.id, {priority: 'event'});"),
        # Stop selection event in column with references
        onmousedown = "event.stopPropagation();",
        id = paste0("reference_link_", .x)
      ) %>%
        as.character()
    ) %>%
      magrittr::inset(is.na(r_raw_references()), NA_character_)
  })

  r_data_with_ref <- reactive({
    if(nrow(r_data()) > 0)
      r_data() %>%
        mutate(!!quo_name(reference_col) := r_ref_links())
    else
      r_data()
  })
}
