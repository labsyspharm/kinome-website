collapse_piece <- function(stuff, open, id, title) {
  div(class = "panel-group",
      div(class = "panel-heading",
          h3(
            class = "panel-title",
            tags$a(
              `data-toggle` = "collapse",
              `aria-expanded` = ifelse(open, "true", "false"),
              href = paste0("#", id),
              paste(title),
              icon("chevron-right")
            )
          )),
      div(
        id = id,
        class = glue::glue("panel-collapse collapse {ifelse(open, 'in', '')}"),
        stuff
      ))
}



get_collapse <- function(open = "false",
                               id,
                               title,
                               label,
                               flt_id1,
                               choices1,
                               selected1,
                               flt_id2 = NULL,
                               choices2 = NULL,
                               selected2 = NULL,
                               radio = FALSE) {
  

  
  second <- div()
  if (!is.null(flt_id2)) {
    second <- formGroup(
      label = NULL,
      input = checkboxInput(
        inline = FALSE,
        id = flt_id2,
        choices = choices2,
        selected = selected2
      ) %>%
        active("red")
    )
  }
  
  
  if (!radio) {
    items <- list(formGroup(
      label = tags$h6(label) %>% margin(b = 0),
      input = checkboxInput(
        inline = FALSE,
        id = flt_id1,
        choices = choices1,
        selected = selected1
      ) %>%
        active("red")
    ),
    second)
  } else{
    items <- formGroup(
      label = tags$h6(label) %>% margin(b = 0),
      input = radioInput(
        id = flt_id1,
        choices = choices1,
        selected = selected1
      ) %>%
        active("red")
    )
  }
  
  items %>%
    collapse_piece(open, id, title)
  
  
  
}