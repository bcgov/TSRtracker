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
#' @import DT

mod_page_user_inputs_ui <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(width = 4, position = "left",
        fluidRow(
          h2(paste0("Welcome, ", Sys.getenv("SHINYPROXY_USERNAME"))),
          h3("Upload workplan"),
          fileInput(ns("upload"), NULL, accept = c(".docx"))
        )
      ),
      mainPanel(
       fluidRow(
         h3("Gantt"),
          plotOutput(ns("plotWorkplanGantt"))
       ),
       fluidRow(
         h3("Edit workplan dates"),
          DTOutput(ns("workplan"))
       )
      )
    )
  )
}

#' page_user_inputs Server Functions
#'
#' @noRd
mod_page_user_inputs_server <- function(id, reportList){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    workplan_rv <- reactiveValues(data = data.table(aoi =as.character(), analyst =as.character(), project = as.character(), task = as.character(), start_date = as.Date(NULL), end_date = as.Date(NULL) ))

    observeEvent(input$upload, {
      ext <- tools::file_ext(input$upload$name)
      workplan_uploaded <- switch(ext,
             docx = getWordDocx(input$upload$datapath),
             validate("Invalid file; Please upload a .docx file")
      )
      workplan_rv$data<-workplan_uploaded
      setScheduleQuery(workplan_rv$data, reportList)
    })

    output$workplan <- renderDT({
      datatable(workplan_rv$data[,c("project", "task", "start_date", "end_date")], editable = TRUE)
    })

    observeEvent(input$workplan_cell_edit, {
      row  <- input$workplan_cell_edit$row
      clmn <- input$workplan_cell_edit$col + 2 #I removed the aoi and anlyst columns so add 2 here
      if(clmn %in% c(5,6)){
        workplan_rv$data[row, 5] <- as.Date(input$workplan_cell_edit$value, tryFormats = c("%Y-%m-%d", "%Y/%m/%d"))
        workplan_rv$data[row, 6] <- as.Date(input$workplan_cell_edit$value, tryFormats = c("%Y-%m-%d", "%Y/%m/%d"))
      }else{
        workplan_rv$data[row, clmn] <- input$workplan_cell_edit$value
      }
      setScheduleQuery(workplan_rv$data, reportList) #write to database and update the reportList
    })

    output$plotWorkplanGantt <- renderPlot({
      data<-data.table(workplan_rv$data)
      if(nrow(data) == 0 ){
        NULL
      }else{

        ggplot(data[!task == 'Milestone',], aes(x = start_date, xend = end_date, y = fct_rev(fct_inorder(task)),
                                                yend = task, color = project, shape = project)) +
          geom_segment(linewidth =10) +
          labs(x = NULL, y = NULL) +
          geom_point(data=data[task == 'Milestone',], aes(shape = project), size = 4) +
          scale_shape_manual(values=c('Start-Up Meeting'=17, 'Initial Engagement Letters'=17,  'Data Preparation'=18,
                                      'Data Package'=19, 'Analysis'=19,'Discussion Paper'=19, 'Rationale'=17)) +
          scale_color_manual(values=c('Start-Up Meeting'=17, 'Initial Engagement Letters'=16,  'Data Preparation'=18,
                                      'Data Package'=18, 'Analysis'=15, 'Discussion Paper'=19, 'Rationale'=19)) +
          geom_hline(yintercept=unique(data$task), colour="grey80", linetype="dotted") +
          geom_hline(yintercept='Milestone', colour="black", linetype="dashed") +
          theme_gantt() +
          theme(axis.text.x=element_text(angle=45, hjust=1), legend.title=element_blank())
      }
    })


  })
}

## To be copied in the UI
# mod_page_user_inputs_ui("page_user_inputs_1")

## To be copied in the server
# mod_page_user_inputs_server("page_user_inputs_1")
