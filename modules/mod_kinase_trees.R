
mod_kinase_trees_ui <- function(id) {
  ns <- NS(id)
  container(
    centered = TRUE,
    card(
      header = h5("Eukaryotic protein kinases (ePK)"),
      a(
        href = "kinome/assets/img/tree_epk.pdf",
        target = "_blank",
        img(src = "kinome/assets/img/tree_epk-01.svg")
      )
    ) %>% margin(bottom = 3),
    card(
      header = h5("Additional curated kinases"),
      a(
        href = "kinome/assets/img/tree_additional.pdf",
        target = "_blank",
        img(src = "kinome/assets/img/tree_additional-01.svg")
      )
    ) %>% margin(bottom = 3),
    card(
      header = h5("Extended kinome"),
      a(
        href = "kinome/assets/img/tree_extended.pdf",
        target = "_blank",
        img(src = "kinome/assets/img/tree_extended-01.svg")
      )
    )
  )
}
