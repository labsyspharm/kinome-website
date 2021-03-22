collapse_wrapper <- function(internal_html, open, collapseid, title, description = NULL) {


  div(class = "panel-group",
      div(class = "panel-heading",
        tags$a(
          `data-toggle` = "collapse",
          `aria-expanded` = ifelse(open, "true", "false"),
          href = paste0("#", collapseid),
          paste(title),
          icon("chevron-right")
        )
      ),
      div(
        id = collapseid,
        class = glue::glue("panel-collapse collapse {ifelse(open, 'in', '')}"),
        if (!is.null(description)) p(description, class = "font-weight-bold"),
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
    active("crimson")
}

get_radio_collapse <- function(label,
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
      active("crimson")
  )

  if(addNAcheck)
    frm <- list(frm, na_checkbox(na_checkid))

  frm
}





get_check_collapse <- function(label,
                               flt_id1,
                               choices1,
                               selected1,
                               flt_id2 = NULL,
                               label2 = NULL,
                               choices2 = NULL,
                               selected2 = NULL,
                               addl_html = NULL,
                               addNAcheck = FALSE,
                               na_checkid = NULL) {
  second <- NULL
  # Check if chioces and values are different
  ch <- names(choices2) %||% choices2
  vals <- if (is.null(names(choices2))) ch else unname(choices2)
  if (!is.null(flt_id2)) {
    second <- formGroup(
      label = if (!is.null(label2)) tags$h6(label2) %>% margin(b = 0),
      input = checkboxInput(
        inline = FALSE,
        id = flt_id2,
        choices = ch,
        values = vals,
        selected = selected2
      ) %>%
        active("crimson")
    )
  }


  # Check if chioces and values are different
  ch <- names(choices1) %||% choices1
  vals <- if (is.null(names(choices1))) ch else unname(choices1)
  items <- tagList(formGroup(
    label = tags$h6(label) %>% margin(b = 0),
    input = checkboxInput(
      inline = FALSE,
      id = flt_id1,
      choices = ch,
      values = vals,
      selected = selected1
    ) %>%
      active("crimson")
  ),
  second)

  items <- list(items, addl_html)

  if (addNAcheck)
    items <- list(items, na_checkbox(na_checkid))


  items
}


formGroup <- function (label, input, ..., help = NULL, width = NULL)
{

  label_start <- label
  yonder:::assert_found(label)
  yonder:::assert_found(input)

  if (!yonder:::is_tag(input) && !yonder:::is_strictly_list(input)) {
    stop("invalid argument in `formGroup()`, `input` must be a tag element or list",
         call. = FALSE)
  }
  col_classes <- if (!is.null(width))
    column(width = width)$attribs$class
  yonder:::dep_attach({
    if (yonder:::is_tag(label) && yonder:::tag_name_is(label, "label")) {
    }
    else {

      label <- tags$label(yonder:::coerce_content(label))
    }
    if (is.character(help)) {
      help <- yonder:::coerce_content(help)
    }



    if(!is.null(label_start) && !is.null(label_start$children[[1]])){
      res <- tags$div(class = yonder:::str_collate("form-group", col_classes),
               ..., label, input, if (!is.null(help)) {
                 tags$small(class = "form-text text-muted", help)
               })

    } else {
      res <- tags$div(class = yonder:::str_collate("form-group", col_classes),
                      ...,  input, if (!is.null(help)) {
                        tags$small(class = "form-text text-muted", help)
                      })
    }

    res


  })
}

active <- function (tag, color)
{
  #assert_possible(color, possible_colors)
  tag <- yonder:::tag_class_add(tag, paste0("active-", color))
  tag
}
