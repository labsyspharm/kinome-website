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
            list( "Setting"),
            # list(icon("circle", class = "similarity--green"), "Similarity"),
            # list(icon("circle", class = "library--orange"), "Library"),
            "Download"
          ),
          values = c(
            "home",
            "selectivity",
            #"similarity",
            #"library",
            "download"
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
        # tags$a(
        #   href = "https://forms.gle/dSpCJSsbaavTbCkP6",
        #   target = "_blank",
        #   icon("comments", class = "fa-lg"),
        #   " Feedback"
        # ) %>%
        #   font(color = "white") %>%
        #   margin(l = 2),
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
                  #class = "navbar-brand",
                  #href="http://sorger.med.harvard.edu/",
                  tags$img(class = 'kinome-tree', src = "kinome/assets/img/kinome_tree.png")
                ),
              ),
              column(
                d3("Kinome.org") %>%
                  font(align = "left"),
                p("Welcome to Kinome.org!"),
                p("Kinome.org is designed by the Laboratory of Systems Pharmacology to help researchers",
                  "understand which proteins are members of the kinome under varying criteria."
                ), #%>%
                  #font(align = "justify") %>%
                  #margin(l = "auto", r = "auto", b = 5)
                div(
                  tags$a(
                    id = "explore",
                    href = "#page_selectivity",
                    #onclick = "'$( \"#tabs\" ).tabs({ active: 2 });'",
                    # $('#explore').click(function () {
                    #   $('#page_home').removeClass('active');
                    #   //$('input[type="button"][value="home"]').removeClass('active');
                    #   //$('input[type="button"][value="selectivity"]').addClass('active');
                    #   $('#page_selectivity').addClass('active show');
                    # });
                    "Start exploring the human kinome",
                    icon("arrow-circle-right", class = "fa-lg"),
                  ) %>%
                    font(color = "black")
                )
      
              )
            )
          ),
          # selectivity ----
          navPane(
            id = "page_selectivity",
                mod_table_ui("table_ui_1")
          ),
          # similarity ----
          # navPane(
          #   id = "page_similarity"#,
          #   # similarityUI(
          #   #   id = "sim"
          #   # )
          # ),
          # library ----
          # navPane(
          #   id = "page_library"#,
          #   # libraryUI(
          #   #   id = "lib"
          #   # )
          # ),
          # downloads ----
          navPane(
            id = "page_download",
            card(
              header = h4("Download Small Molecule Suite data"),
              p(
                "The entire Small Molecule Suite dataset is available for download.", tags$br(),
                "The data are organized in separate normalized tables. Documentation",
                "for each table and their relationship is available."
              ),
              a(
                h4("Table documentation", class = "btn btn-default btn-grey"),
                href = "https://dbdocs.io/clemenshug/sms_db",
                target = "_blank"
              )
            ) %>%
              margin(bottom = 3)#,
            # columns(
            #   column(
            #     width = 6,
            #     card(
            #       header = h4("SQL download"),
            #       p(
            #         "Gzip compressed SQL dump of the Small Molecule Suite database",
            #         "in PostgreSQL format."
            #       ),
            #       p("Based on ChEMBL v25, size 799.9 MB"),
            #       a(
            #         h4("SQL database", class = "btn btn-default btn-grey"),
            #         href = "sms/assets/downloads/sms_db_chembl_v25.sql.gz",
            #         target = "_blank"
            #       )
            #     )
            #   ),
            #   column(
            #     width = 6,
            #     card(
            #       header = h4("CSV download"),
            #       p(
            #         "Tarball of gzip compressed CSV files."
            #       ),
            #       p("Based on ChEMBL v25, size 782.7 MB"),
            #       a(
            #         h4("CSV files", class = "btn btn-default btn-grey"),
            #         href = "sms/assets/downloads/sms_tables_chembl_v25.tar"
            #       )
            #     )
            #   )
            # )
          )
        )
      )
    )
  )
}
