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
#' @importFrom forcats fct_rev fct_inorder
#'
mod_page_dashboard_ui <- function(id) {
  ns <- NS(id)

  available_aois <- getAvailableStudyAreas()
  tagList(
    fluidRow(
      valueBoxOutput(ns("in_progress")),
      valueBoxOutput(ns("past_due")),
      valueBoxOutput(ns("upcoming"))
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
                plotOutput(ns("plotTasks"))
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

    output$in_progress <-renderValueBox({
      valueBoxSpark(nrow(reportList()[["rationalization"]][in_progress == 'Y',]), icon = icon("bars-progress") , subtitle = "In Progress", width = 2)
    })
    output$past_due <- renderValueBox({
      valueBoxSpark(nrow(reportList()[["rationalization"]][past_due < 0,]), icon = icon("thumbs-down"), subtitle = "Past Due", width =2)
    })
    output$upcoming <- renderValueBox({
      valueBoxSpark(nrow(reportList()[["rationalization"]][tsr_fn2025 == 'Y', ]), icon = icon("calendar"), subtitle = "Upcoming", width =2)
    })

    #Based on the radio button aoi_type determine the selection
    observeEvent(input$aoi_type, {
      if(input$aoi_type == 'TSA'){
        updateSelectizeInput(session,
                             inputId = "selected_aoi",
                             choices = unique(data.tsrTracker[data.tsrTracker$type == 'TSA', ]$aoi))
      }else if (input$aoi_type == 'TFL'){
        updateSelectizeInput(session,
                             inputId = "selected_aoi",
                             choices = unique(data.tsrTracker[data.tsrTracker$type == 'TFL', ]$aoi))
      } else{
        updateSelectizeInput(session,
                             inputId = "selected_aoi",
                             choices = unique(data.tsrTracker$aoi))
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
      list(geojsonsf::sf_geojson(outSf, simplify=TRUE), outSf)
    })


    ## render the base leaflet map
    output$map = leaflet::renderLeaflet({
      leaflet(options = leafletOptions(doubleClickZoom= TRUE)) %>%
        setView(-121.7476, 53.7267, 3) %>%
        addTiles() %>%
        addProviderTiles("Esri.WorldImagery", group ='WorldImagery' ) %>%
        addWMS(baseUrl = "https://openmaps.gov.bc.ca/geo/ows/",
               layers = c("pub:WHSE_LEGAL_ADMIN_BOUNDARIES.FNT_TREATY_AREA_SP"),
               group = 'FN_Treaty_Areas',
               options = leaflet::WMSTileOptions(
                 transparent = TRUE,
                 format = "image/png",
                 info_format = "text/html",
                 tiled = FALSE
               )) %>%
        addLayersControl(
          baseGroups = "worldImagery",
          overlayGroups = c("TSR","FN_Treaty_Areas"),
          options = layersControlOptions(collapsed = TRUE)) %>%
        addScaleBar(position = "topleft")

    })


    # Change the choropleth
    observe( {
      bbox<-st_bbox(selectAOI()[[2]])
      leafletProxy('map')  %>%
        clearGroup('TSR') %>%
        flyToBounds(bbox[[1]], bbox[[2]], bbox[[3]], bbox[[4]]) %>%
        addGeoJSONChoropleth(selectAOI()[[1]], group = 'TSR',
          valueProperty = "past_due",
          labelProperty = "aoi",
          popupProperty = propstoHTMLTable(
            props = c("aoi", "aac_year", "aac", "s8_deadline", "past_due"),
            table.attrs = list(class = "table table-striped table-bordered"),
            drop.na = TRUE
          ),
          scale = c("red", "green"),
          steps = 5,
          color = "white",
          weight = 2,
          stroke = TRUE,
          fillOpacity = 0.5,
          highlightOptions = highlightOptions(
            weight = 3, color = "black",
            fillOpacity = 0.1, opacity = 1,
            bringToFront = T, sendToBack = T),
          legendOptions =legendOptions (title = "Months Past Deadline",
                                        position = 'topright')
        )

    })


    output$plotTasks <- renderPlot({
      ggplot(reportList()[["schedule"]], aes(x = start, xend = end, y = fct_rev(fct_inorder(task)), yend = task)) +
        geom_segment(linewidth = 10, color = "#0198f9") +
        labs(
          title = "TSR Gantt Chart",
          x = "Duration",
          y = "Task"
        ) +
        theme_bw() +
        theme(legend.position = "none") +
        theme(
          plot.title = element_text(size = 20),
          axis.text.x = element_text(size = 12),
          axis.text.y = element_text(size = 12, angle = 45)
        )
    })
  })
}

