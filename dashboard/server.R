# server ------------------------------------------------------------------

server <- function(input, output) {
  
  # OVERVIEW TAB ---------------------------------------------------------------
  
overview_data <- reactive({
    [WRANGLE DATA FOR LIFE EXPECTANCY]
    
    output$life_expectancy_map({
      [LEAFLET MAP CODE]
    }),
    
    output$life_expectancy_plot({
      [GGPLOT FOR LIFE EXPECTANCY]
    })
  })
  
  # DRUGS TAB -------------------------------------------------------------
  
  
drugs_data <- reactive({
    [WRANGLE DATA FOR DRUGS]
    
    output$drug_map({
      [LEAFLET MAP CODE]
    }),
    
    output$drug_plot({
      [GGPLOT FOR DRUGS]
    })
  })
  
  
  # ALCOHOL TAB -------------------------------------------------------------
  
alcohol_deaths_filtered <- reactive({
    
  alcohol_deaths %>% 
    filter(age_group != "all_ages" & age_group != "average_age") %>%
    filter(gender == input$gender_input,
           age == input$age_input)
  })
    
alcohol_area_filtered <- reactive({
  
  
  alcohol_area %>% 
    select(-...1) %>% 
    filter(area != "All Scotland") %>% 
    group_by(area) %>%
    filter(year_of_death == input$year_input) %>% 
    summarise(area, 
              num_deaths = count) 
})
  
    output$alcohol_map({
      scotland_shape <- st_transform(scotland_shape, "+proj=longlat +datum=WGS84")
      
      
      bins <- c(0, 25, 50, 100, 150, 200)
      pal <- colorBin("Greens", domain = alcohol_area_clean$num_deaths, bins = bins)
      
      death_labels <- sprintf(
        "<strong>%s</strong><br/>%g deaths",
        alcohol_area$area, alcohol_area$num_deaths
      ) %>% 
        lapply(htmltools::HTML)
      
      alcohol_area %>% 
        left_join(scotland_shape, by = c("area" = "local_auth")) %>% 
        st_as_sf() %>% 
        leaflet() %>% 
        addPolygons(fillColor = ~pal(num_deaths),
                    weight = 0.5,
                    opacity = 0.5,
                    color = "black",
                    fillOpacity = 0.5,
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE),
                    label = death_labels,
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "3px 8px"),
                      textsize = "15px",
                      direction = "auto")) %>%
        addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                  position = "bottomright")
    })
    
    output$alcohol_plot({
      
      alcohol_deaths_filtered() %>% 
        ggplot() +
        aes(x = year_of_death, y = count, fill = gender) +
        geom_col() +
        scale_x_continuous(breaks = c(2009:2019))
    })
}