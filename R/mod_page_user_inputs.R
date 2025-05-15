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
        DTOutput(ns("head"))
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
    data <- reactive({
      req(input$upload)

      ext <- tools::file_ext(input$upload$name)
      switch(ext,
             csv = vroom::vroom(input$upload$datapath, delim = ","),
             tsv = vroom::vroom(input$upload$datapath, delim = "\t"),
             validate("Invalid file; Please upload a .csv or .tsv file")
      )
    })

    output$head <- renderDT({
      datatable( head(data(), 100), editable = TRUE)
    })

  })
}

## To be copied in the UI
# mod_page_user_inputs_ui("page_user_inputs_1")

## To be copied in the server
# mod_page_user_inputs_server("page_user_inputs_1")
