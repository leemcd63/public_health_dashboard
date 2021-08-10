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
  
  
  observe({
    # Update drug selections based on year input
    if (input$drug_map_year != "All") {
      drug_choice_selection <- drug_deaths %>% 
        filter(year == input$drug_map_year) %>%
        select(drug_name) %>%
        arrange(drug_name) %>%
        pull(drug_name)
      
      updateSelectInput(session,
                        "drug_map_name",
                        label = "Select Drug:",
                        choices = drug_choice_selection,
                        selected = "All drug-related deaths")
    } else {
      drug_choice_selection <- sort(unique(drug_deaths$drug_name))
      
      updateSelectInput(session,
                        "drug_map_name",
                        label = "Select Drug:",
                        choices = drug_choice_selection,
                        selected = "All drug-related deaths")
    }
  })
  
  
  drugs_plot_data <- reactive({
    
    # If all years is selected, filter for all years
    if(input$drug_map_year == "All") {
      drugs_map_year_selection <- sort(unique(drug_deaths$year))
    } else {
      drugs_map_year_selection <- input$drug_map_year
    }
    
    # Filter data for leaflet plot
    drugs_plot_data <- drug_deaths %>%
      filter(council_area != "Scotland",
             drug_name %in% input$drug_map_name,
             year %in% drugs_map_year_selection) %>%
      group_by(council_area) %>%
      summarise(drug_name = drug_name, num_deaths = sum(num_deaths)) %>%
      # Join with shape data
      left_join(scotland_shape, by = c("council_area" = "local_auth")) %>%
      # Convert to shape data from data frame
      st_as_sf()
  })
  
  
  
  output$drug_map <- renderLeaflet({
    
    drug_death_data <- drugs_plot_data()
    
    # Labels variable for leaflet plot
    drug_death_labels <- sprintf(
      "<strong>%s</strong><br/>%g deaths",
      drug_death_data$council_area, 
      drug_death_data$num_deaths) %>% 
      lapply(htmltools::HTML)
    
    if (input$drug_map_year == "All" & input$drug_map_name == "All drug-related deaths"){
      drugs_plot_bins <- c(0, 50, 100, 200, 500, 1000, 2000, Inf)
    } else {
      drugs_plot_bins <- c(0, 5, 15, 30, 50, 100, 250, Inf)
    }
    
    
    
    pal <- colorBin("Purples", domain = drug_death_data$num_deaths, bins = drugs_plot_bins)
    
    # Initialise plot
    drug_death_data %>%
      leaflet() %>%
      setView(lng = -4.2026, lat = 57.2, zoom = 6, options = list()) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(fillColor = ~pal(num_deaths),
                  weight = 0.75,
                  opacity = 1,
                  color = "black",
                  dashArray = "2",
                  fillOpacity = 0.9,
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE),
                  label = drug_death_labels,
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
