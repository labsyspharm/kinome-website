
mod_kinase_trees_ui <- function(id) {
  ns <- NS(id)
  container(
    centered = TRUE,
    card(
      header = h5("Eukaryotic protein kinases (ePK)"),
      p("Kinases from the curated kinome are visualized on the Coral kinase dendrogram. The recomputed understudied kinome is shown in blue and well-studied kinases are shown in yellow. The atypical kinase group (AGC; denoted by a blue dashed line) as previously defined by Manning and KinHub lies to the right of the dendogram; this set includes multiple genes that are not considered to be members of the curated kinase family as described in this paper (labelled in gray). "),
      a(
        href = "kinome/assets/img/tree_epk.pdf",
        target = "_blank",
        img(src = "kinome/assets/img/tree_epk-01.svg")
      )
    ) %>% margin(bottom = 3),
    card(
      header = h5("Additional curated kinases"),
      p("The 46 kinases in the curated kinome but not on the Coral dendrogram are listed separately to the right and organized by protein fold. Red dashed lines denote regions of the dendogram in which all kinases are understudied."),
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

# font-family:'Arial', sans-serif; font-weight:bold;
