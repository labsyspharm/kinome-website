function(input, output, session) {

  navToPage <- function(name, session = NULL) {
    if (is.null(session))
      session <- getDefaultReactiveDomain()
    showNavPane(paste0("page_", name), session = session)
  }

  observeEvent(input$nav, {
    navToPage(input$nav)
  })

  .modal_about <- modal(
    id = NULL,
    size = "lg",
    header = h5("About"),
    HTML(htmltools::includeMarkdown("inst/about.md"))
  )
  observeEvent(input$about, {
    showModal(.modal_about)
  })

  r_data <- reactive(kinomedat)

  r_filters <- callModule(mod_filters_server, "filters_ui_1")
  table_proxy <- callModule(mod_table_server, "table_ui_1", r_data = r_data, r_filters = r_filters)

  .modal_funding <- modal(
    id = NULL,
    size = "md",
    header = h5("Funding"),
    p("This work was supported by NIH grant U24-DK116204, U54-HL127624 and U54-CA225088.")
  )
  observeEvent(c(input$funding, input$funding2), {
    showModal(.modal_funding)
  })

}
