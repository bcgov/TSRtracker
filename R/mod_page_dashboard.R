#' page_dashboard UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom bsplus bs_embed_tooltip
#' @importFrom leaflet.extras2 addWMS
#' @import leaflet
#' @importFrom geojsonsf sf_geojson
#' @import sf
#' @import rmapshaper
#' @importFrom scales date_format
#' @import xfun
#'
#'
mod_page_dashboard_ui <- function(id) {
  ns <- NS(id)
  userName <- Sys.getenv("SHINYPROXY_USERNAME")

  available_aois <- getAvailableStudyAreas()
  tagList(
    fluidRow(
      valueBoxOutput(ns("num_in_progress")),
      valueBoxOutput(ns("num_past_due")),
      valueBoxOutput(ns("num_upcoming"))
    ),
    sidebarLayout(
      sidebarPanel(width = 2, position = "left",
        fluidRow(
          radioButtons(inputId = ns("aoi_type"),
                       label="Select an area",
                       choices =c("Province", "TSA", "TFL", "FLP"),
                       inline =T,
                       selected = "Province"),
          selectizeInput(inputId = ns("selected_aoi"),
                  label = NULL,
                  selected = "",
                  choices = c(list("Select an area" = ""), available_aois),
                  multiple = TRUE)
        )
      ),
      mainPanel(width = 10,
        tabsetPanel(
          tabPanel(title = "Map",
              fluidRow(
                  leafletOutput(ns("map"), width = "80%", height = "800px")
              )
          ),
          tabPanel(title = "Gantt",
              fluidRow(
                plotOutput(ns("plotGantt"))
              )
          )
        )
      )

    )

  )
}

#' page_dashboard Server Functions
#'
#' @noRd
mod_page_dashboard_server <- function(id, reportList){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    lastClickedAOI<-reactiveValues(aoi= NULL)

    output$num_in_progress <-renderValueBox({
      valueBoxSpark(nrow(data.table(selectAOI())[in_progress=='Y',]), icon = icon("bars-progress") , subtitle = "In Progress", width = 2)
    })
    output$num_past_due <- renderValueBox({
      valueBoxSpark(nrow(data.table(selectAOI())[past_due <0,]), icon = icon("thumbs-down"), subtitle = "Past Due", width =2)
    })
    output$num_upcoming <- renderValueBox({
      valueBoxSpark(nrow(data.table(selectAOI())[in_progress=='N',]), icon = icon("calendar"), subtitle = "Upcoming", width =2)
    })

    #Based on the radio button aoi_type determine the selection
    observeEvent(c(input$aoi_type, input$map_shape_click), {
      #browser()
      if(input$aoi_type == 'TSA'){
        if(any(is.null(input$map_shape_click$id) & is.null(lastClickedAOI$aoi),input$map_shape_click$id == lastClickedAOI$aoi)){
          updateSelectizeInput(session, inputId = "selected_aoi", selected = NULL,
                               choices = unique(data.tsrTracker[data.tsrTracker$type == 'TSA', ]$aoi))
        }else{
          updateSelectizeInput(session, inputId = "selected_aoi",
                               choices = input$map_shape_click$id, selected = input$map_shape_click$id)
          lastClickedAOI$aoi <- input$map_shape_click$id
        }
      }else if (input$aoi_type == 'TFL'){
        if(any(is.null(input$map_shape_click$id) & is.null(lastClickedAOI$aoi),input$map_shape_click$id == lastClickedAOI$aoi)){
          updateSelectizeInput(session, inputId = "selected_aoi", selected = NULL,
                               choices = unique(data.tsrTracker[data.tsrTracker$type == 'TFL', ]$aoi))
        }else{
          updateSelectizeInput(session, inputId = "selected_aoi",
                               choices = input$map_shape_click$id, selected = input$map_shape_click$id)
          lastClickedAOI$aoi <- input$map_shape_click$id
        }
      } else{
        if(any(is.null(input$map_shape_click$id) & is.null(lastClickedAOI$aoi),input$map_shape_click$id == lastClickedAOI$aoi)){
          updateSelectizeInput(session, inputId = "selected_aoi", selected = NULL,
                               choices = unique(data.tsrTracker$aoi))
        }else{
          updateSelectizeInput(session, inputId = "selected_aoi",
                               choices = input$map_shape_click$id, selected = input$map_shape_click$id)
          lastClickedAOI$aoi <- input$map_shape_click$id
        }
      }
    })




    #Query the data
    selectAOI <-reactive({

      data<-merge(data.tsrTracker,reportList()[["rationalization"]], by = c("aoi", "type"))

      if(is.null(input$selected_aoi)){
          if(input$aoi_type == 'TSA'){
            outSf<-data[data$type == 'TSA', ]
          }else if(input$aoi_type == 'TFL'){
            outSf<-data[data$type == 'TFL', ]
          }else{
            outSf<-data
          }
        }else{
          outSf<-data[data$aoi %in% input$selected_aoi,]
        }
      outSf
    })


    ## render the base leaflet map
    output$map = leaflet::renderLeaflet({
      labels <- sprintf(
        "<strong>%s</strong><br/>Due in %g months",
        selectAOI()$aoi, selectAOI()$past_due
      ) %>% lapply(htmltools::HTML)

      leaflet(data =selectAOI()) %>%
        setView(-121.7476, 53.7267, 5) %>%
        addTiles() %>%
        addPolygons(group = 'TSR',
                    layerId = ~aoi,
                    fillColor = ~pal(past_due), stroke =TRUE, weight =1,
                    fillOpacity = ~factop(in_progress),
                    highlightOptions=highlightOptions(color = 'white', weight =2),
                    label=labels,
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "3px 8px"),
                      textsize = "15px",
                      direction = "auto")) %>%
        addLegend( position = "topright",
                   pal = pal, opacity = 1,
                   values = c(50,10,0,-10,-50),
                   title = "Months To Deadline"
        )%>%
        addScaleBar(position = "topleft")

    })


    # Change the choropleth
    observeEvent(input$aoi_type, {

      labels <- sprintf(
        "<strong>%s</strong><br/>Due in %g months",
        selectAOI()$aoi, selectAOI()$past_due
      ) %>% lapply(htmltools::HTML)


      leafletProxy(mapId = ns('map'), data =selectAOI())  %>%
        clearGroup('TSR') %>%
        addPolygons( layerId =~aoi,
                     group = 'TSR', stroke =TRUE, weight =1,
                    fillColor = ~pal(past_due),
                    fillOpacity = ~factop(in_progress),
                    highlightOptions= highlightOptions(color = 'white',
                                                       weight =2,
                                                       fillOpacity = 0.7,
                                                       bringToFront = TRUE),
                    label=labels,
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "3px 8px"),
                      textsize = "15px",
                      direction = "auto")
                    )
    })

    observeEvent(input$map_shape_click, {
      message(paste0("clicked",input$map_shape_click ))
    } )

    output$plotGantt <- renderPlot({
      data<-data.table(reportList()[["schedule"]])
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

    })

  })
}

