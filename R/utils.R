convert_filter_vars <- function(.vect){
  .vect[.vect == "Unrelated to Protein Kinase Like"] <- "Unrelated to Protein Kinase"
  .vect
}

# Add DT column title defs to existing list of defs
add_column_title_defs <- function(defs, cols, col_map = COLUMN_TITLE_MAP) {
  match(names(col_map), cols) %>%
    set_names(col_map) %>%
    na.omit() %>%
    imap(~list(targets = .x - 1, title = .y)) %>%
    unname() %>%
    c(defs)
}
