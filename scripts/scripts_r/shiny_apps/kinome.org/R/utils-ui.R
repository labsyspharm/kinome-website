collapse_wrapper <- function(internal_html, open, collapseid, title) {

 
  div(class = "panel-group",
      div(class = "panel-heading",
          h3(
            class = "panel-title",
            tags$a(
              `data-toggle` = "collapse",
              `aria-expanded` = ifelse(open, "true", "false"),
              href = paste0("#", collapseid),
              paste(title),
              icon("chevron-right")
            )
          )),
      div(
        id = collapseid,
        class = glue::glue("panel-collapse collapse {ifelse(open, 'in', '')}"),
        internal_html
      ))
}

na_checkbox <- function(id, includeNA = TRUE){
 
 
checkboxInput(
  inline = FALSE,
  id = id,
  class="include-missing-checkbox",
  choices = "Include missing values",
  selected = ifelse(includeNA,"Include missing values", NULL)
) %>%
  active("red")
}

get_radio_collapse <- function(open = "false",
                               collapseid,
                               title,
                               label,
                               flt_id1,
                               choices1,
                               selected1, 
                               addNAcheck = FALSE,
                               na_checkid = NULL){
  
  frm <- formGroup(
    label = tags$h6(label) %>% margin(b = 0),
    input = radioInput(
      id = flt_id1,
      choices = choices1,
      selected = selected1
    ) %>%
      active("red")
  )
  
  if(addNAcheck)
    frm <- list(frm, na_checkbox(na_checkid))
  
  
    frm %>% 
      collapse_wrapper(open, collapseid, title)
  
}





get_check_collapse <- function(open = "false",

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
                               addNAcheck = FALSE,
                               na_checkid = NULL) {
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
  
  items <- list(items, addl_html)
  
  if (addNAcheck)
    items <- list(items, na_checkbox(na_checkid))
  
  
  items %>%
    collapse_wrapper(open, collapseid, title)
  
  
}