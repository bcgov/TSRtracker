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
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  options(warn = -1)
  options(spinner.color = "#F0F4F8")
  options(spinner.size = 1)
  options(spinner.type = 3)

  config <- config::get()

  reportList <- reactive({
    conn = getDbConnection()
    data.rationalization<-getTableQuery(
      sql = glue_sql(
        "SELECT aoi, type, aac_year, area, s8_deadline,
    in_progress, tsr_fn2025, aac, other_name, CURRENT_DATE,
	EXTRACT(MONTH FROM AGE(s8_deadline, CURRENT_DATE)) +
	EXTRACT(YEAR FROM AGE(s8_deadline, CURRENT_DATE))*12 as past_due
	FROM tsrtracker_rationalization",
        .con = conn
      ),
      conn = conn
    )
    data.schedule<-getTableQuery(
      sql = glue_sql(
        "SELECT * FROM tsrtracker_schedule",
        .con = conn
      ),
      conn = conn
    )

    list(rationalization = data.table(data.rationalization),
         schedule = data.table(data.schedule)
         )
  })



  observe({
    mod_page_dashboard_server("page_dashboard", reportList)
    #mod_page_user_inputs_server("page_user_inputs")
  })




}

