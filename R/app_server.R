#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import xml2
#' @import DBI
#' @import RPostgreSQL
#' @import glue
#' @import leaflet.extras
#' @import data.table
#' @import forcats
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  options(warn = -1)
  options(spinner.color = "#F0F4F8")
  options(spinner.size = 1)
  options(spinner.type = 3)

  config <- config::get()
  reportList <- reactiveValues(schedule = NULL, rationalization =NULL)
  getReportList(reportList)

  observe({
    mod_page_dashboard_server("page_dashboard", reportList)
    mod_page_user_inputs_server("page_user_inputs", reportList)
  })




}

