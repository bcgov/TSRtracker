#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import leaflet
#' @import shinydashboard
#' @import shinycssloaders
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
      tags$link(rel = "shortcut icon", href = "favicon.ico")
    ),
    # Your application UI logic
    dashboardPage(
      skin = "black",
      dashboardHeader(
        title = tags$span(
          tags$img(src = 'www/img/gov3_bc_logo.png'),
          'TSR Tracker'
        ),
        titleWidth = 400
      ),
      dashboardSidebar(
        tags$style(
          "@import url(https://use.fontawesome.com/releases/v5.15.3/css/all.css);"
        ),
        #introjsUI(),
        sidebarMenu(
          menuItem(
            "Dashboard",
            tabName = "dashboard",
            icon = icon("tachometer-alt")
          ),
          menuItem("Input", tabName = "user_inputs", icon = icon("cogs")),
          menuItem("Rationalization", tabName = "rationalization", icon = icon("balance-scale")),
          menuItem("Generate Report", tabName = "report", icon = icon("file-pdf"))
        )
      ),
      dashboardBody(
        tags$head(tags$style(
          HTML(
            '.small-box.bg-blue {background-color: rgba(192,192,192,0.2) !important; color: #000000 !important; } .small_icon_test { font-size: 50px; } .info-box {min-height: 75px;} .info-box-icon {height: 75px; line-height: 75px;} .info-box-content {padding-top: 0px; padding-bottom: 0px; font-size: 110%;}
                           #fisher_map_control {background-color: rgba(192,192,192,0.2);}'
          )
        )
       )
    )
  ),
  tags$footer(
    class = 'footer',
    tags$div(
      class = 'container',
      tags$ul(
        tags$li(tags$a(href = '.', 'Home')),
        tags$li(
          tags$a(href = 'https://www2.gov.bc.ca/gov/content/home/disclaimer', 'Disclaimer')
        ),
        tags$li(
          tags$a(href = 'https://www2.gov.bc.ca/gov/content/home/privacy', 'Privacy')
        ),
        tags$li(
          tags$a(href = 'https://www2.gov.bc.ca/gov/content/home/accessibility', 'Accessibility')
        ),
        tags$li(
          tags$a(href = 'https://www2.gov.bc.ca/gov/content/home/copyright', 'Copyright')
        ),
        tags$li(
          tags$a(href = 'https://github.com/bcgov/devhub-app-web/issues', 'Contact Us')
        )
      )
    )
  )
 )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path('www', app_sys('app/www'))

  shiny::tags$head(
    golem::favicon(),
    golem::bundle_resources(path = app_sys('app/www'),
                            app_title = 'CLUS Explorer'),
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
    golem::activate_js(),
    golem::favicon()
  )
}
