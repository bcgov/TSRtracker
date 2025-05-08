#' page_user_inputs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_page_user_inputs_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' page_user_inputs Server Functions
#'
#' @noRd 
mod_page_user_inputs_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_page_user_inputs_ui("page_user_inputs_1")
    
## To be copied in the server
# mod_page_user_inputs_server("page_user_inputs_1")
