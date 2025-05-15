#' page_user_inputs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import xml2
#' @import vroom
#' @import DT

mod_page_user_inputs_ui <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(width = 4, position = "left",
        fluidRow(
          fileInput(ns("upload"), NULL, accept = c(".csv", ".tsv"))
        )
      ),
      mainPanel(
        tabsetPanel(
          tabPanel(title = "Gantt"
          ),
          tabPanel(title = "Workplan",
                   DTOutput(ns("workplan"))
          )
        )
      )
    )
  )
}

#' page_user_inputs Server Functions
#'
#' @noRd
mod_page_user_inputs_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    workplan_rv <- reactiveValues(data = NULL)

    observeEvent(input$upload, {
      ext <- tools::file_ext(input$upload$name)
      workplan_uploaded <- switch(ext,
             csv = vroom::vroom(input$upload$datapath, delim = ","),
             tsv = vroom::vroom(input$upload$datapath, delim = "\t"),
             validate("Invalid file; Please upload a .csv or .tsv file")
      )

      workplan_rv$data<- workplan_uploaded
    })

    output$workplan <- renderDT({
      datatable( head(workplan_rv$data, 100), editable = TRUE)
    })

    observeEvent(input$workplan_cell_edit, {
      browser()
      row  <- input$workplan_cell_edit$row
      clmn <- input$workplan_cell_edit$col
      workplan_rv$data[row, clmn] <- as.Date(input$workplan_cell_edit$value, tryFormats = c("%Y-%m-%d", "%Y/%m/%d"))
    })

  })
}

## To be copied in the UI
# mod_page_user_inputs_ui("page_user_inputs_1")

## To be copied in the server
# mod_page_user_inputs_server("page_user_inputs_1")
