function(req) {
  list(
    htmltools::htmlDependency(
      "font-awesome",
      "5.3.1", "www/shared/fontawesome", package = "shiny",
      stylesheet = c("css/all.min.css", "css/v4-shims.min.css")
    ),
    tags$head(
      tags$title("Kinome.org"),
      tags$link(href="https://fonts.googleapis.com/css?family=Lato:400,700&display=swap", rel="stylesheet"),
      tags$link(rel = "stylesheet", type = "text/css", href = "kinome/css/slider.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "kinome/css/main.css"),
      tags$script(src = "kinome/js/main.js"),
      tags$link(rel = "icon", type = "image/png", href = "kinome/assets/img/favicon.png")
    ),
    webpage(
      nav = navbar(
        tags$a(
          class = "navbar-brand",
          href="http://sorger.med.harvard.edu/",
          tags$img(style = "height: 2rem;", src = "kinome/assets/img/logo.png")
        ) %>%
          padding(0),
        navInput(
          appearance = "pills",
          id = "nav",
          choices = list(
            list(icon("home"), "Home"),
            list("Data")
          ),
          values = c(
            "home",
            "data"
          )
        ) %>%
          margin(left = "auto"),
        tags$ul(
          buttonInput(
            id = "about",
            label = "About",
            class = "nav-link"
          ) %>%
            padding(0) %>%
            tags$li(class = "nav-link"),
          buttonInput(
            id = "funding",
            label = "Funding",
            class = "nav-link"
          ) %>%
            padding(0) %>%
            tags$li(class = "nav-link"),
          class = "nav navbar-nav"
        ),
        tags$a(
          href = "https://github.com/labsyspharm/kinome-website",
          target = "_blank",
          icon("github", class = "fa-lg")
        ) %>%
          margin(l = 3)
      ) %>%
        # active("red") %>%
        background("dark") %>%
        tagAppendAttributes(class = "navbar-dark") %>%
        padding(0, r = 3, l = 3) %>%
        margin(b = 4) %>%
        shadow(),
      container(
        navContent(
          # home ----
          navPane(
            id = "page_home",
            fade = FALSE,
            class = "active",
            columns(
              column(
                width = 6,
                tags$a(
                  href = "kinome/assets/img/kinome_tree_v10.png",
                  target = "_blank",
                  tags$img(
                    class = 'img-fluid mt-2',
                    src = "kinome/assets/img/kinome_tree_v10.png"
                  )
                )
              ),
              column(
                width = 6,
                h3("Kinome.org") %>%
                  font(align = "left"),
                p("Welcome to Kinome.org!"),
                p("This site is maintained by scientists in the HMS Laboratory of Systems Pharmacology",
                "It is intended to assist in studying the human kinome based on data-driven criteria and information that can be accessed from curated databases or using machine reading and knowledge assembly systems.",
                a(
                  class = "btn-link",
                  `data-toggle` = "collapse",
                  href = "#more_info",
                  role = "button",
                  `aria-expanded` = "false",
                  `aria-controls` = "more_info",
                  "More information..."
                )),
                p(
                  tags$a(
                    id = "explore",
                    href = "JavaScript:void(0)",
                    onclick = '$(".navbar-nav > li:eq(1) > button").click()',
                    "Start exploring the human kinome",
                    icon("arrow-circle-right"),
                  ) %>%
                    font(size = "lg", weight = "bold")
                ),
                div(
                  class = "collapse",
                  id = "more_info",
                  p("While the kinome is conceptually simple to understand as the full collection of human",
                    "protein kinases, the practice of classifying a protein as protein kinase is not straightforward.",
                    "Classifying a protein as protein kinase implies that its main function is the transfer",
                    "of a phosphoryl group from ATP to a protein substrate or peptide. However, it is almost",
                    "impossible to verify the main function of any protein because most proteins have multiple",
                    "domains and could therefore have multiple functions. Even if phosphoryl transfer is one",
                    "function of a protein, it can be one of many and not necessarily the most important one."),
                  p("In", a("our work", href = "https://www.biorxiv.org/content/10.1101/2020.04.02.022277v2", target = "_blank"),
                    "we therefore took an approach that describes the kinome from multiple viewpoints.",
                    "We compare proteins with a kinase domain on",
                    tags$ol(
                      type = "i",
                      tags$li("their 3D fold and structure;"),
                      tags$li("the knowledge on them in the public domain;"),
                      tags$li("reagents available to study their function",
                              "(biochemical reagents and small molecules);"),
                      tags$li("evidence that they might be involved in pathophysiology.")
                    )
                  )
                ),
                p("The site is in active development with funding from NIH grants U24-DK116204 and DARPA grants W911NF-15-1-0544 and W911NF018-1-0124."),
                p("LICENSE:", a(href = "https://creativecommons.org/licenses/by/4.0/", "Creative Commons Attribution 4.0 International (CC BY 4.0)", target = "_blank")),
                h4("Newly developed web tools"),
                tags$dl(
                  tags$dt("Membership in the human kinome"),
                  tags$dd(
                    "This tool provides tools for sorting human kinases",
                    tags$a(
                      href = "JavaScript:void(0)",
                      onclick = '$(".navbar-nav > li:eq(1) > button").click()',
                      "based on multiple criteria."
                    )
                  ),
                  tags$dt("Dark Kinase Knowledgebase"),
                  tags$dd("This portal curates information on the understudied kinome as part of the NIH Illuminating the Druggable Genome project.",
                          tags$a(href = "https://www.darkkinome.org", "darkkinome.org", target = "_blank")),
                  tags$dt("Small Molecule Suite"),
                  tags$dd("This tool makes it possible to identify selective inhibitors of kinases and other ligandable proteins using data-driven criteria.",
                          tags$a(href = "https://www.smallmoleculesuite.org", "smallmoleculesuite.org", target = "_blank"))
                ),
                h3("Existing Resources"),
                tags$ul(
                  style = "line-style-type:'-'",
                  tags$li(
                    a(href = "http://vulcan.cs.uga.edu/prokino/about/browser", "ProKino", target = "_blank")
                  ),
                  tags$li(
                    a(href = "http://www.kinhub.org/", "Kinhub", target = "_blank")
                  ),
                  tags$li(
                    a(href = "https://pharos.nih.gov/", "Pharos", target = "_blank")
                  ),
                  tags$li(
                    a(href = "https://schurerlab.shinyapps.io/CKIApp/", "Clinical Kinase Index", target = "_blank")
                  ),
                  tags$li(
                    a(href = "http://www.kinase-screen.mrc.ac.uk/kinase-inhibitors", "Dundee Kinase Resource", target = "_blank")
                  ),
                  tags$li(
                    a(href = "https://bioinfo.uth.edu/kmd/index.html?csrt=3252186118630041327", "KinaseMD", target = "_blank")
                  ),
                  tags$li(
                    a(href = "https://klifs.net/", "KLIFs", target = "_blank")
                  ),
                  tags$li(
                    a(href = "http://www.kinasenet.ca/", "KinaseNet", target = "_blank")
                  ),
                  tags$li(
                    a(href = "http://phanstiel-lab.med.unc.edu/CORAL/", "CORAL", target = "_blank")
                  )
                )
              )
            )
          ),
          navPane(
            id = "page_data",
                mod_table_ui("table_ui_1")
          ),
          navPane(
            id = "page_download",
            card(
              header = h4("Download Kinome.org data"),
              p(
                "Some text needed"
              ),
              a(
                h4("Table documentation", class = "btn btn-default btn-grey"),
                href = "XYZZZZZZZZZZZZZZZ",
                target = "_blank"
              )
            ) %>%
              margin(bottom = 3)
          )
        )
      )
    )
  )
}
