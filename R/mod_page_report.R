#' page_report UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_page_report_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' page_report Server Functions
#'
#' @noRd 
mod_page_report_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_page_report_ui("page_report_1")
    
## To be copied in the server
# mod_page_report_server("page_report_1")
