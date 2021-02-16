
make_column_selection_buttons <- function(
  choices,
  cols,
  col_id,
  col_title,
  col_description,
  col_group
) {
  col_group_sym <- sym(col_group)
  button_groups <- choices %>%
    mutate(
      idx = match(.[[col_id]], cols) - 1L,
      across(!!col_group_sym, forcats::fct_inorder)
    ) %>%
    drop_na() %>%
    group_by(!!col_group_sym) %>%
    group_map(
      ~{
        list(
          extend = "colvis",
          text = as.character(.y[[1]]),
          # className = "btn-outline-secondary",
          columns = .x[["idx"]]
        )
      }
    )
}
