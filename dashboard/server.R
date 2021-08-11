# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  # LIFE EXPECTANCY TAB ---------------------------------------------------------------
  
  life_exp_map_filtered <- reactive({
    
    if (input$year_input == "All") {
      life_exp_year <- unique(life_expectancy_data$date_code)
    } else {
      life_exp_year <- input$year_input
    }
    
    if (input$gender_input == "All") {
      life_exp_gender <- unique(life_expectancy_data$gender)
    } else {
      life_exp_gender <- input$gender_input
    }
    
    life_expectancy_data %>% 
      filter(gender %in% life_exp_gender,
             measurement == "Count",
             date_code %in% life_exp_year) %>% 
      group_by(local_authority) %>%
      summarise(value = round(mean(value), 2)) %>%
      left_join(scotland_shape, by = c("local_authority" = "local_auth")) %>%
      st_as_sf() 
  })
  

  
  output$life_exp_map <- renderLeaflet({
    
    life_exp_map_filtered <- life_exp_map_filtered()
    
    bins <- c(70, 72, 74, 76, 78, 80, 82, 84, 86)
    pal <- colorBin("Blues", domain = life_exp_map_filtered$value, bins = bins)
    
    life_exp_labels <- sprintf(
      "<strong>%s</strong><br/>%g years",
      life_exp_map_filtered$local_authority, life_exp_map_filtered$value
    ) %>% 
      lapply(htmltools::HTML)
    

    life_exp_map_filtered %>%
      leaflet() %>% 
      setView(lng = -4.2026, lat = 57.8, zoom = 5.5, options = list()) %>%
      addProviderTiles(providers$CartoDB.Positron)%>% 
      addPolygons(fillColor = ~pal(value),
                  weight = 0.5,
                  opacity = 0.9,
                  color = "black",
                  fillOpacity = 0.8,
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
  
  life_exp_plot_filtered <- reactive({
    
    if (input$area_input == "All") {
      life_exp_area<- unique(life_expectancy_data$local_authority)
    } else {
      life_exp_area <- input$area_input
    }
    
    life_expectancy_data %>%
      filter(local_authority %in% life_exp_area) %>%
      pivot_wider(names_from = measurement,
                  values_from = value) %>%
      rename(lower = "95% Lower Confidence Limit", upper = "95% Upper Confidence Limit", value = "Count") %>%
      mutate(date_code = as.numeric(str_extract(date_code, "^20[0-9]{2}"))) %>%
      group_by(date_code, gender) %>%
      summarise(upper = mean(upper), lower = mean(lower), value = mean(value))
      
  })
  
  output$life_expectancy_plot <- renderPlotly({
    
    life_exp_plot_filtered <- life_exp_plot_filtered()
     ggplotly(
      ggplot(life_exp_plot_filtered) +
        aes(x = date_code, 
            y = value, 
            colour = gender, 
            fill = gender) +
        # geom_point() +
        geom_ribbon(aes(ymin = lower, ymax = upper, alpha = 0.5)) +
        geom_line() +
        ylim(70,85) +
        scale_y_continuous(n.breaks = 15) +
        scale_x_continuous(n.breaks = 10)
    )
  })
  
  
  output$all_life_expectancy_plot <- renderPlotly({
    
    ggplotly(
      ggplot(all_life_exp_filtered, 
             aes(x = reorder(local_authority, -value), 
                 y = value, 
                 fill = gender)) + 
      geom_bar(stat = "identity", color = "black", width = 0.5, position = position_dodge(width=0.7)) +
      theme(axis.text.x = element_text(angle = 60))+
      labs(title="Life Expectancy In Scotland By Local Authority Area From 2009 to 2019", 
           x="Local Authority Area", y = "Life Expectancy In Years") +
      coord_cartesian(ylim = c(70,85)) 
    ) 
  })
  
}
