#' Get database connection
#'
#' @return a database connection
#' @export
getDbConnection <- function() {

  config <- config::get()

  conn <- DBI::dbConnect(
    DBI::dbDriver("PostgreSQL"),
    host = config$db$host,
    dbname = config$db$dbname,
    port = config$db$port,
    user = config$db$user,
    password = config$db$password
  )
}

#' Get the results of an SQL query from the database
#'
#' @param sql The SQL query
#' @param params The SQL query parameters
#' @param conn Optional database connection which can be reused
#'
#' @return result set as a data.frame
#' @export
getTableQuery <- function(sql, params = list(), conn = NULL) {
  if (is.null(conn)) {
    new_conn <- getDbConnection()
    data <- dbGetQuery(conn = new_conn, statement = sql, params = params)
    dbDisconnect(new_conn)
  } else {
    data <- dbGetQuery(conn = conn, statement = sql, params = params)
  }
  data
}

#' Get the results of a spatial query from the PostgreSQL database
#'
#' @param sql The SQL query
#'
#' @return a result set as a sf object
#' @export
getSpatialQuery <- function(sql) {
  conn <- getDbConnection()
  data <- st_read(conn, query = sql)
  dbDisconnect(conn)
  data
}

#' Get schema tables from information_schema database
#'
#' @param schema
#'
#' @return the table of schemas
#' @export
getInformationSchemaTables <- function(schema) {
  query <- "SELECT * FROM information_schema.tables
WHERE table_schema = ?"

  getTableQuery(sql = query, params = schema)
}


#' Get available study areas to populate the "Area of interest" dropdown
#'
#' @return available area of interests
#' @export
getAvailableStudyAreas <- function() {
  available_study_areas <- unique(data.tsrTracker$aoi)
}

