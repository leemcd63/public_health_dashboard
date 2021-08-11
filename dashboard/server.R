# server ------------------------------------------------------------------

server <- function(input, output) {
  
  # OVERVIEW TAB ---------------------------------------------------------------
  
  life_exp_filtered <- reactive({
    
    life_expectancy_data_2 %>% 
      filter(gender %in% input$gender_input,
             measurement == "Count") %>% 
      left_join(scotland_shape, by = c("local_authority" = "local_auth")) %>%
      st_as_sf() 
  })
  
  
  output$life_exp_map <- renderLeaflet({
    
    life_exp_filtered <- life_exp_filtered()
    
    bins <- c(70, 72, 74, 76, 78, 80, 82, 84, 86)
    pal <- colorBin("Blues", domain = life_exp_filtered$value, bins = bins)
    
    life_exp_labels <- sprintf(
      "<strong>%s</strong><br/>%g years",
      life_exp_filtered$local_authority, life_exp_filtered$value
    ) %>% 
      lapply(htmltools::HTML)
    
    life_exp_filtered %>%
      leaflet() %>% 
      setView(lng = -4.2026, lat = 57.8, zoom = 5.5, options = list()) %>%
      addTiles() %>% 
      addPolygons(fillColor = ~pal(value),
                  weight = 0.5,
                  opacity = 0.5,
                  color = "black",
                  fillOpacity = 0.5,
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE),
                  label = life_exp_labels,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")) %>%
      addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                position = "bottomright")
  })
  
  
  
  
  
  output$life_expectancy_plot <- renderPlotly({
    ggplot(life_expectancy_data_2, aes(x=local_authority, y=value, fill=gender)) + 
      geom_bar(stat="identity", color="black", width=0.7, position=position_dodge(width=0.9)) +
      geom_errorbar(aes(ymin=value, ymax=value), width=.2,
                    position=position_dodge(.9)) +
      theme(axis.text.x = element_text(angle = 90))+
      labs(title="Life Expectancy In Scotland By Local Authority Area From 2009 to 2019", 
           x="Local Authority Area", y = "Life Expectancy In Years")
  })
  
}
