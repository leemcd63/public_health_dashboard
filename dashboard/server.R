# server ------------------------------------------------------------------

server <- function(input, output) {

   # ALCOHOL TAB -------------------------------------------------------------
  
alcohol_deaths_filtered <- reactive({
  
  if(input$gender_input == "All") {
    alcohol_plot_gender_selection <- sort(unique(alcohol_deaths$gender))
  } else {
    alcohol_plot_gender_selection <- input$gender_input
  }  
  
  
  if(input$age_input == "All") {
    alcohol_plot_age_selection <- sort(unique(alcohol_deaths$age_group))
  } else {
    alcohol_plot_age_selection <- input$age_input
  }  
  
  
  alcohol_deaths %>% 
    filter(age_group != "all_ages" & age_group != "average_age") %>%
    filter(gender %in% alcohol_plot_gender_selection,
           age_group %in% alcohol_plot_age_selection)
  })
    
alcohol_area_filtered <- reactive({
  
  if(input$year_input == "All") {
    alcohol_map_year_selection <- sort(unique(alcohol_area$year_of_death))
  } else {
    alcohol_map_year_selection <- input$year_input
  }  
  
  alcohol_area %>% 
    select(-1) %>% 
    filter(area != "All Scotland") %>% 
    group_by(area) %>%
    filter(year_of_death %in% alcohol_map_year_selection) %>% 
    summarise(area, count) %>%
    left_join(scotland_shape, by = c("area" = "local_auth")) %>% 
    st_as_sf()
})

    output$alcohol_map <- renderLeaflet({
      
      alcohol_area_filtered <- alcohol_area_filtered()
      
      bins <- c(0, 25, 50, 100, 150, 200)
      pal <- colorBin("Greens", domain = alcohol_area_filtered$count, bins = bins)
      
      alcohol_map_labels <- sprintf(
        "<strong>%s</strong><br/>%g deaths",
        alcohol_area_filtered$area, alcohol_area_filtered$count
      ) %>% 
        lapply(htmltools::HTML)
      
      alcohol_area_filtered %>% 
        leaflet() %>% 
        setView(lng = -4.2026, lat = 57.8, zoom = 6, options = list()) %>%
        addProviderTiles(providers$CartoDB.Positron) %>% 
        addPolygons(fillColor = ~pal(count),
                    weight = 0.5,
                    opacity = 0.5,
                    color = "black",
                    fillOpacity = 0.5,
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE),
                    label = alcohol_map_labels,
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "3px 8px"),
                      textsize = "15px",
                      direction = "auto")) %>%
        addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                  position = "bottomright")
    })
    
    output$alcohol_plot <- renderPlotly({
      
      ggplotly(
      alcohol_deaths_filtered() %>%
        ggplot() +
        aes(x = year_of_death, y = count, fill = gender) +
        geom_col() +
        scale_x_continuous(breaks = c(2009:2019)) + 
        scale_fill_manual(values = c("Female" = "#bae3b5", 
                                     "Male" = "#73c375")) +
        labs(x = "Year", 
             y = "Number of Deaths",
             title = "Number of Alcohol Deaths per Year",
             fill = "Gender") +
       # theme(legend.position = "none") +
        theme_minimal()
      ) %>% 
      config(displayModeBar = FALSE)
    })
}