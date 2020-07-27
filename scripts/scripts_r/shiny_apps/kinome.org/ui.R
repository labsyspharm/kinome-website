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
          tags$img(class = "h-2", src = "kinome/assets/img/logo.png")
        ),
        navInput(
          appearance = "pills",
          id = "nav",
          choices = list(
            list(icon("home"), "Home"),
            list( "Data")
          ),
          values = c(
            "home",
            "selectivity"
          )
        ) %>%
          margin(left = "auto"),
        buttonInput(
          id = "about",
          label = "About"
        ) %>%
          background("black") %>%
          font(color = "white"),

        buttonInput(
          id = "funding",
          label = "Funding"
        ) %>%
          background("black") %>%
          font("white"),
        tags$a(
          href = "https://github.com/labsyspharm/sms-website",
          target = "_blank",
          icon("github", class = "fa-lg")
        ) %>%
          font(color = "white") %>%
          margin(l = 3)
      ) %>%
        active("red") %>%
        padding(0, r = 3, l = 3) %>%
        margin(b = 4) %>%
        background("black") %>%
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
                tags$a(
                  tags$img(class = 'kinome-tree', src = "kinome/assets/img/kinome_tree.png")
                ),
              ),
              column(
                d3("Kinome.org") %>%
                  font(align = "left"),
                p("Welcome to Kinome.org!"),
                p("Kinome.org is designed by the Laboratory of Systems Pharmacology to help researchers",
                  "understand which proteins are members of the kinome under varying criteria."
                ),
                div(
                  onclick = "$('.navbar-nav > li:eq(1)').click()",
                  tags$a(
                    id = "explore",
                    href = "JavaScript:void(0)",
                    onclick = '$(".navbar-nav > li:eq(1) > button").click()',
                    "Start exploring the human kinome",
                    icon("arrow-circle-right", class = "fa-lg"),
                  ) %>%
                    font(color = "black")
                )
      
              )
            )
          ),
          navPane(
            id = "page_selectivity",
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
