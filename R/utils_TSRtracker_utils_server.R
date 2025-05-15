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

#' Styling for the gantt chart
#'
#' @return theme for the gantt
#' @export
theme_gantt <- function(base_size=11, base_family="Source Sans Pro Light") {
  ret <- theme_bw(base_size, base_family) %+replace%
    theme(panel.background = element_rect(fill="#ffffff", colour=NA),
          axis.title.x=element_text(vjust=-0.2), axis.title.y=element_text(vjust=1.5),
          title=element_text(vjust=1.2, family="Source Sans Pro Semibold"),
          panel.border = element_blank(), axis.line=element_blank(),
          panel.grid.minor=element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.major.x = element_line(size=0.5, colour="grey80"),
          axis.ticks=element_blank(),
          legend.position="bottom",
          axis.title=element_text(size=rel(0.8), family="Source Sans Pro Semibold"),
          strip.text=element_text(size=rel(1), family="Source Sans Pro Semibold"),
          strip.background=element_rect(fill="#ffffff", colour=NA),
          panel.spacing.y=unit(1.5, "lines"),
          legend.key = element_blank())

  ret
}

#' adjust the opacity of the polygon in leaflet
#'
#' @return opacity of polygons
#' @export
factop <- function(x) {
  ifelse(x=='N', 0.2, 1)
}

#' pallett for the polygons
#'
#' @return palett of polygons
#' @export
pal <- colorNumeric(palette = "inferno", domain = c(50,10,0,-10,-50))


#' convert word docx to data.frame
#'
#' @return list of data.frames containing workplan information
#' @export
get_word_docx <- function(word_doc) {

  tmpd <- tempdir()
  tmpf <- tempfile(tmpdir=tmpd, fileext=".zip")

  file.copy(word_doc, tmpf)
  unzip(tmpf, exdir=sprintf("%s/docdata", tmpd))

  doc <- read_xml(sprintf("%s/docdata/word/document.xml", tmpd))

  unlink(tmpf)
  unlink(sprintf("%s/docdata", tmpd), recursive=TRUE)

  ns <- xml_ns(doc)

  tbls <- xml_find_all(doc, ".//w:tbl", ns=ns)

  lapply(tbls, function(tbl) {

    cells <- xml_find_all(tbl, "./w:tr/w:tc", ns=ns)
    rows <- xml_find_all(tbl, "./w:tr", ns=ns)
    dat <- data.frame(matrix(xml_text(cells),
                             ncol=(length(cells)/length(rows)),
                             byrow=TRUE),
                      stringsAsFactors=FALSE)
    colnames(dat) <- dat[1,]
    dat <- dat[-1,]
    rownames(dat) <- NULL
    dat

  })

}
