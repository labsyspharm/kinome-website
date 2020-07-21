collapse_wrapper <- function(internal_html, open, ns, collapseid, title) {

  div(class = "panel-group",
      div(class = "panel-heading",
          h3(
            class = "panel-title",
            tags$a(
              `data-toggle` = "collapse",
              `aria-expanded` = ifelse(open, "true", "false"),
              href = paste0("#", ns(collapseid)),
              paste(title),
              icon("chevron-right")
            )
          )),
      div(
        id = ns(collapseid),
        class = glue::glue("panel-collapse collapse {ifelse(open, 'in', '')}"),
        internal_html
      ))
}

na_checkbox <- function(id, ns){
  
checkboxInput(
  inline = FALSE,
  id = id,
  choices = "Include missing values",
  selected = "Include missing values"
) %>%
  active("red")
}

get_radio_collapse <- function(open = "false",
                               ns,
                               collapseid,
                               title,
                               label,
                               flt_id1,
                               choices1,
                               selected1, 
                               addNAcheck = FALSE){
  
  frm <- formGroup(
    label = tags$h6(label) %>% margin(b = 0),
    input = radioInput(
      id = ns(flt_id1),
      choices = choices1,
      selected = selected1
    ) %>%
      active("red")
  )
  
  if(addNAcheck)
    frm <- frm %>% na_checkbox()
  
  
    frm %>% 
      collapse_wrapper(open, ns = ns, collapseid, title)
  
}





get_check_collapse <- function(open = "false",
                               ns,
                               collapseid,
                               title,
                               label,
                               flt_id1,
                               choices1,
                               selected1,
                               flt_id2 = NULL,
                               choices2 = NULL,
                               selected2 = NULL,
                               addl_html = NULL,
                               addNAcheck = FALSE) {
  second <- div()
  if (!is.null(flt_id2)) {
    second <- formGroup(
      label = NULL,
      input = checkboxInput(
        inline = FALSE,
        id = ns(flt_id2),
        choices = choices2,
        selected = selected2
      ) %>%
        active("red")
    )
  }
  
  
  
  items <- list(formGroup(
    label = tags$h6(label) %>% margin(b = 0),
    input = checkboxInput(
      inline = FALSE,
      id = ns(flt_id1),
      choices = choices1,
      selected = selected1
    ) %>%
      active("red")
  ),
  second)
  
  items <- list(items, addl_html)
  
  if (addNAcheck)
    items <- items %>% na_checkbox()
  
  
  items %>%
    collapse_wrapper(open, ns, collapseid, title)
  
  
}