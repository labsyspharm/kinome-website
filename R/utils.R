convert_filter_vars <- function(.vect){
  .vect[.vect == "Unrelated to Protein Kinase Like"] <- "Unrelated to Protein Kinase"
  .vect
}

# Add DT column title defs to existing list of defs
add_column_title_defs <- function(defs, cols, col_map = COLUMN_TITLE_MAP) {
  COLUMN_TITLE_MAP %>%
    enframe(name = "col_id", value = "col_title") %>%
    mutate(
      idx = match(col_id, cols) - 1L
    ) %>%
    drop_na() %>%
    pmap(
      function(col_id, col_title, idx) {
        list(
          list(targets = idx, title = col_title),
          list(targets = idx, name = col_id)
        )
      }
    ) %>%
    unlist(recursive = FALSE) %>%
    unname() %>%
    c(defs)
}
