library(glue)

mod_ui_modal_column <- function(id) {
  ns <- NS(id)

  tags$div(
    id = ns("modal"),
    `aria-labelledby` = ns("modal-title"),
    `aria-hidden` = "true",
    class = "modal", role = "dialog",
    tags$div(
      class = "modal-content",
      tags$div(
        class = "modal-header",
        tags$h5(
          id = ns("modal-title"),
          class = "modal-title",
          "Title"
        ),
        tags$button(
          type = "button",
          class = "close",
          `data-dismiss` = "modal",
          `aria-label` = "Close",
          tags$span(
            `aria-hidden` = "true",
            "&times;"
          )
        )
      ),
      tags$div(
        id = ns("modal-body"),
        class = "modal-body",
        "Body"
      ),
      tags$div(
        class = "modal-footer",
        tags$button(
          class = "btn btn-primary",
          type = "button",
          `data-dismiss` = "modal",
          "Close"
        )
      )
    )
  ) %>%
    tagList(
      htmltools::htmlDependency(
        "modal_column_js", "1.0",
        c(href="kinome/js"),
        script = "modal_column.js"
      )
    )
}

RENDER_COLUMN_JS <- r"--{
  function(data, type, row, meta) {
    const row_split = data.split(";");
    const button = $("<button type=\"button\" class=\"btn btn-link\" \
      data-toggle=\"modal\" data-target=\"#`modal_id`\" onClick >`button_text`</button>"
    ).on("click", {
      modal_id: "`modal_id`",
      header_content: row_split[0],
      body_content: row_split[1]
    }, column_modal_click_callback);
    asdf();
    return button.outerHTML;
  }
}--"

mod_server_modal_column <- function(
  input, output, session, button_text
) {
  ns <- session$ns

  glue(
    RENDER_COLUMN_JS,
    modal_id = ns("modal"),
    button_text = button_text %>%
      str_replace_all(fixed('"'), '\\"') %>%
      str_replace_all(fixed("\n"), "\\\n"),
    .open = "`", .close = "`"
  )
}
