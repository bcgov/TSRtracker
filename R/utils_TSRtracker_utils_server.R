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

#' Set the results of a workplan upload to a PostgreSQL database
#'
#' @param sql The SQL query
#'
#' @return void
#' @export
setScheduleQuery<-function(wrkpln, reportList){
  conn = getDbConnection()
  DBI::dbExecute(conn,
                 glue::glue("delete from tsrtracker_schedule where aoi = {single_quote(wrkpln$aoi[1])};"))
  dbWriteTable(conn, name = c("public","tsrtracker_schedule"), value = wrkpln,append=TRUE,row.names=FALSE,overwrite=FALSE)
  dbDisconnect(conn)

  getReportList(reportList = reportList)
}

getReportList <- function(reportList) {
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

  dbDisconnect(conn)
  reportList$rationalization<-data.table(data.rationalization)
  reportList$schedule<-data.table(data.schedule)
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
getWordDocx <- function(word_doc) {

  tmpd <- tempdir()
  tmpf <- tempfile(tmpdir=tmpd, fileext=".zip")

  file.copy(word_doc, tmpf)
  unzip(tmpf, exdir=sprintf("%s/docdata", tmpd))

  doc <- read_xml(sprintf("%s/docdata/word/document.xml", tmpd))

  unlink(tmpf)
  unlink(sprintf("%s/docdata", tmpd), recursive=TRUE)

  ns <- xml_ns(doc)

  tbls <- xml_find_all(doc, ".//w:tbl", ns=ns)

  raw_tbls<-lapply(tbls, function(tbl) {

    cells <- xml_find_all(tbl, "./w:tr/w:tc", ns=ns)
    rows <- xml_find_all(tbl, "./w:tr", ns=ns)
    dat <- data.frame(matrix(xml_text(cells),
                             ncol=(length(cells)/length(rows)),
                             byrow=TRUE),
                      stringsAsFactors=FALSE)
    colnames(dat) <- dat[1,]
    if(nrow(dat)<2) {
      dat
    }else{
      dat <- dat[-1,]
    }
    rownames(dat) <- NULL
    dat

  })

  validate_workplan<- data.table(aoi = raw_tbls[[1]][[1]], analyst = raw_tbls[[7]][1,3],
             project =c ("Start-Up Meeting",
                         "Initial Engagement Letters",
                         "Data Preparation",
                         "Data Package",
                         "Analysis",
                         "Discussion Paper",
                         "Rationale"),
             task ="Milestone",
             planned_date =c(raw_tbls[[3]][2,4],
                             raw_tbls[[3]][10,4],
                             raw_tbls[[7]][4,4],
                             raw_tbls[[7]][7,4],
                             raw_tbls[[7]][22,4],
                             raw_tbls[[9]][4,4],
                             raw_tbls[[11]][2,4]),
             completion_date=c(raw_tbls[[3]][2,5],
                               raw_tbls[[3]][10,5],
                               raw_tbls[[7]][4,5],
                               raw_tbls[[7]][7,5],
                               raw_tbls[[7]][22,5],
                               raw_tbls[[9]][4,5],
                               raw_tbls[[11]][2,5]
                               )
             )

  validate_workplan<-validate_workplan[, start_date:= as.Date(completion_date)][completion_date=='', start_date:= as.Date(planned_date)][, end_date:=start_date]
  validate_workplan<-validate_workplan[, planned_date:=NULL][, completion_date:=NULL]

  #Important dates
  data_prep_milestone<-validate_workplan[project == "Data Preparation" & task == 'Milestone', ]$start_date
  analysis_milestone<-validate_workplan[project == "Analysis" & task == 'Milestone', ]$start_date
  discussion_paper_milestone<-validate_workplan[project == "Discussion Paper" & task == 'Milestone', ]$start_date

  #Add in mock time lines
  mock_workplan<-rbindlist(list(data.table(aoi = raw_tbls[[1]][[1]], analyst = raw_tbls[[7]][1,3], project ="Data Preparation",
                                              task = c("write Up", "Constraints/Yields", "Review"),
                                              start_date = c(data_prep_milestone-50, data_prep_milestone-100, data_prep_milestone-20),
                                              end_date =c(data_prep_milestone, data_prep_milestone-50, data_prep_milestone-5)),
                                   data.table(aoi = raw_tbls[[1]][[1]], analyst = raw_tbls[[7]][1,3], project ="Analysis",
                                              task = c("Model building", "Finalize base-case", "sensitivities", "write Up"),
                                              start_date = c(analysis_milestone-300,analysis_milestone-150, analysis_milestone-100, analysis_milestone-40),
                                              end_date =c(analysis_milestone-200,analysis_milestone-100, analysis_milestone-30, analysis_milestone)),
                                   data.table(aoi = raw_tbls[[1]][[1]], analyst = raw_tbls[[7]][1,3], project ="Discussion Paper",
                                              task = c("Binder Prep", "Consultation", "Dry-run"),
                                              start_date = c(discussion_paper_milestone-70,discussion_paper_milestone-60,discussion_paper_milestone-20),
                                              end_date =c(discussion_paper_milestone-40,discussion_paper_milestone-20,discussion_paper_milestone-5))
                                   ))
  rbindlist(list(validate_workplan, mock_workplan))
}
