#' page_rationalization UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_page_rationalization_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' page_rationalization Server Functions
#'
#' @noRd 
mod_page_rationalization_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_page_rationalization_ui("page_rationalization_1")
    
## To be copied in the server
# mod_page_rationalization_server("page_rationalization_1")
