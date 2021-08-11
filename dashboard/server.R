# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  # DRUGS TAB -------------------------------------------------------------
  
  # DRUG MAP SELECTINPUT CHANGES
  observe({
    # Update drug map selections based on year input
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
  
  # DRUG MAP DATA
  drugs_map_data <- reactive({
    
    # If all years is selected, filter for all years
    if(input$drug_map_year == "All") {
      drugs_map_year_selection <- sort(unique(drug_deaths$year))
    } else {
      drugs_map_year_selection <- input$drug_map_year
    }
    
    # Filter data for leaflet plot
    drugs_map_data <- drug_deaths %>%
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
  
  
  # DRUG MAP OUTPUT
  output$drug_map <- renderLeaflet({
    
    drugs_map_data <- drugs_map_data()
    
    # Labels variable for leaflet plot
    drugs_map_labels <- sprintf(
      "<strong>%s</strong><br/>%g deaths",
      drugs_map_data$council_area,
      drugs_map_data$num_deaths) %>%
      lapply(htmltools::HTML)
    
    if (input$drug_map_year == "All" & input$drug_map_name == "All drug-related deaths"){
      drugs_map_bins <- c(0, 50, 100, 200, 500, 1000, 2000, Inf)
    } else {
      drugs_map_bins <- c(0, 5, 15, 30, 50, 100, 250, Inf)
    }
    
    pal <- colorBin("Purples", domain = drugs_map_data$num_deaths, bins = drugs_map_bins)
    
    
    # Initialise plot
    drugs_map_data %>%
      leaflet() %>%
      setView(lng = -4.2026, lat = 57.8, zoom = 6, options = list()) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(fillColor = ~pal(num_deaths),
                  weight = 0.75,
                  opacity = 1,
                  color = "black",
                  dashArray = "2",
                  fillOpacity = 0.9,
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE),
                  label = drugs_map_labels,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")) %>%
      addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                position = "bottomright")
    
  })
  
  # DRUG PLOT DATA
  drug_plot_data <- reactive({
    drug_plot_data <- drug_deaths %>%
      filter(drug_name %in% input$drug_plot_name,
             council_area %in% input$drug_plot_area)
  })
  
  # DRUG PLOT OUTPUT
  output$drug_plot <- renderPlotly({
    
    min_year <- drug_plot_data() %>%
      slice_min(year) %>%
      pull(year)
    
    max_year <- drug_plot_data() %>%
      slice_max(year) %>%
      pull(year)
    
    
    ggplotly(
      drug_plot_data() %>%
        ggplot() +
        aes(x = year, y = num_deaths) +
        geom_line(colour = "#605ca8", alpha = 0.75, size = 1.5) +
        geom_point(aes(text=sprintf("Year: %g<br>Deaths: %g", year, num_deaths)),
                   colour = "black", size = 2, alpha = 0.9) +
        scale_x_continuous(breaks = c(min_year:max_year)) +
        scale_y_continuous(n.breaks = 8) +
        theme_minimal() +
        theme(panel.grid.major = element_line(colour = "grey"),
              plot.background = element_rect(fill = "#ecf0f6"),
              panel.background = element_rect(fill = "#ecf0f6")),
      tooltip = c("text")
    ) %>%
      config(displayModeBar = FALSE) %>%
      layout(xaxis = list(title = "Year"),
             yaxis = list(title = "Number of Deaths"),
             title = list(text = paste0(
               'Number of deaths in ', input$drug_plot_area, ' from ', min_year, '-', max_year,
               '<br>',
               '<sup>',
               input$drug_plot_name,
               '</sup>',
               '<br>')),
             margin = list(t = 50, b = 50, l = 50) # to fully display the x and y axis labels
      )
  })
  
  
  # ALCOHOL TAB -------------------------------------------------------------
  
  alcohol_deaths_filtered <- reactive({
    
    if(input$gender_input == "All") {
      alcohol_plot_gender_selection <- unique(alcohol_deaths$gender)
    } else {
      alcohol_plot_gender_selection <- input$gender_input
    }
    
    
    if(input$age_input == "All") {
      alcohol_plot_age_selection <- unique(alcohol_deaths$age_group)
    } else {
      alcohol_plot_age_selection <- input$age_input
    }
    
    
    alcohol_deaths %>%
      filter(age_group != "all_ages" & age_group != "average_age") %>%
      #mutate(gender = factor(gender, levels = c("Male", "Female"))) %>%
      filter(gender %in% alcohol_plot_gender_selection,
             age_group %in% alcohol_plot_age_selection) %>%
      group_by(gender, year_of_death) %>%
      summarise(count = sum(count))

    
  })
  
  #ALCOHOL MAP OUTPUT
  
  alcohol_area_filtered <- reactive({
    
    if(input$year_input == "All") {
      alcohol_map_year_selection <- sort(unique(alcohol_area$year_of_death))
    } else {
      alcohol_map_year_selection <- input$year_input
    }
    
    alcohol_area %>%
      select(-1) %>%
      filter(area != "All Scotland",
             year_of_death %in% alcohol_map_year_selection) %>%
      group_by(area) %>%
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
  
  #ALCOHOL PLOT OUTPUT
  
  output$alcohol_plot <- renderPlotly({
    
    ggplotly(
      alcohol_deaths_filtered() %>%
        ggplot() +
        aes(x = year_of_death, y = count, fill = gender) +
        geom_col(aes(text=sprintf("Year: %g<br>Deaths: %g<br>Gender: %s", year_of_death, count, gender))) +
        scale_x_continuous(breaks = c(2009:2019)) +
        scale_fill_manual(values = c("Female" = "#bae3b5",
                                     "Male" = "#73c375")) +
        theme_minimal()+
        theme(panel.grid.major = element_line(colour = "grey"),
              plot.background = element_rect(fill = "#ecf0f6"),
              panel.background = element_rect(fill = "#ecf0f6")),
      tooltip = c("text")
    ) %>%
      config(displayModeBar = FALSE) %>%
      layout(legend = list(orientation = 'h',
                           yanchor="bottom",
                           y=0.99,
                           xanchor="right",
                           x=1),
             xaxis = list(title = "Year"),
             yaxis = list(title = "Number of Deaths"),
             title = list(text = paste0(
               'Number of Alcohol Deaths per Year',
               '<br>',
               '<sup>',
               'Gender: ', input$gender_input, '  -  Age Group: ', input$age_input,
               '</sup>',
               '<br>')),
             margin = list(t = 50, b = 50, l = 50) # to fully display the x and y axis labels
      )
  })
}
