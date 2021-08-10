# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  # OVERVIEW TAB ---------------------------------------------------------------
  
  # overview_data <- reactive({
  #   [WRANGLE DATA FOR LIFE EXPECTANCY]
  # })
  #   
  #   output$life_expectancy_map({
  #     [LEAFLET MAP CODE]
  #   })
  #   
  #   output$life_expectancy_plot({
  #     [GGPLOT FOR LIFE EXPECTANCY]
  #   })
    
    # DRUGS TAB -------------------------------------------------------------
    
    drugs_plot_bins <- reactive({
      drugs_plot_bins <- c(0,50, 100, 200, 500, 1000, 2000)
    })
    
    drugs_plot_data <- reactive({
      # Filter data for leaflet plot
      drugs_plot_data <- drug_deaths %>%
        filter(drug_name %in%  input$drugs_map_name,
               year %in% input$drugs_map_year) %>%
        group_by(council_area) %>%
        summarise(num_deaths = sum(num_deaths)) %>%
        # Join with shape data
        left_join(scotland_shape, by = c("council_area" = "local_auth")) %>%
        # Convert to shape data from data frame
        st_as_sf()
    })
    
    drugs_plot_council_area <- reactive({
      drugs_plot_data() %>%
        select(council_area)
    })
    
    drugs_plot_num_deaths <- reactive({
      drugs_plot_data() %>%
        select(num_deaths)
    })
    
    
    drug_death_labels <- reactive({
      # Labels variable for leaflet plot
      drug_death_labels <- sprintf(
        "<strong>%s</strong><br/>%g deaths",
        drugs_plot_council_area(), 
        drugs_plot_num_deaths()) %>% 
        lapply(htmltools::HTML)
    })
    

    
    
    output$drug_map <- renderLeaflet({
      # pal <- reactive({
      #   # Set colour palette for plot
      #   pal <- colorBin("Purples", domain = drugs_plot_num_deaths(), bins = drugs_plot_bins())
      # })
      # 
      # Initialise plot
      leaflet(drugs_plot_data()) %>%
        setView(lng = -4.2026, lat = 57.2, zoom = 6, options = list()) %>%
        addTiles() %>%
        addPolygons(#fillColor = ~pal(num_deaths),
                    weight = 0.75,
                    opacity = 1,
                    color = "black",
                    dashArray = "2",
                    fillOpacity = 0.9,
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE),
                    label = drug_death_labels(),
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "3px 8px"),
                      textsize = "15px",
                      direction = "auto")) %>%
        addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                  position = "bottomright")
    })
    
    #output$drug_plot({
     # [GGPLOT FOR DRUGS]
    #})
    
    
    # ALCOHOL TAB -------------------------------------------------------------
    
    # alcohol_data <- reactive({
    #   [WRANGLE DATA FOR ALCOHOL]
    #   
    # })
    # output$alcohol_map({
    #   [LEAFLET MAP CODE]
    # })
    # 
    # output$alcohol_plot({
    #   [GGPLOT FOR ALCOHOL]
    # })
    # 
    
}
