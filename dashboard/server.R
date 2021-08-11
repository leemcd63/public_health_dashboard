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
            fill = gender
            
            ) +
        geom_point(aes(text = sprintf("Year: %g<br>Life Expectancy: %g<br>Gender: %s<br>Upper: %g<br>Lower: %g", date_code, value, gender, upper, lower))) +
        geom_ribbon(aes(ymin = lower, ymax = upper, alpha = 0.2)) +
        geom_line(colour = "black", alpha = 0.5) +
        scale_y_continuous(breaks = c(70:85), limits = c(70, 85)) +
        scale_x_continuous(n.breaks = 10) +
        scale_fill_manual(values=c("aquamarine", "cornflowerblue")) +
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
              yaxis = list(title = "Life Expectancy in Years"),
              title = list(text = paste0(
                input$area_input, ' - Life Expectancy from 2009-2019',
                '<br>',
                '<sup>',
                'Value shown with 95% Confidence Intervals',
                '</sup>',
                '<br>')),
              margin = list(t = 50, b = 50, l = 50)
       )
  })
  

  all_life_exp_filtered <- reactive({
    
    if (input$all_year_input == "All Years (average)") {
      life_exp_all<- unique(life_expectancy_data$date_code)
    } else {
      life_exp_all <- input$all_year_input
    }
    
    life_expectancy_data %>%
      filter(measurement == "Count",
             date_code %in% life_exp_all) %>%
      group_by(local_authority, gender) %>%
      summarise(value = round(mean(value), 2))
  })
  
  output$all_life_expectancy_plot <- renderPlotly({

    all_life_exp_filtered <- all_life_exp_filtered()
    
    ggplotly(
      ggplot(all_life_exp_filtered) +
        aes(x = reorder(local_authority, -value),
                 y = value,
                 fill = gender,
                 text = sprintf("Area: %s<br>Life Expectancy: %g<br>Gender: %s", local_authority, value, gender)) +
      geom_bar(stat = "identity", color = "black", width = 0.5, position = position_dodge(width=0.7)) +
      coord_cartesian(ylim = c(70,85)) +
      scale_fill_manual(values=c("aquamarine", "cornflowerblue")) +
      theme_minimal()+
      theme(axis.text.x = element_text(angle = 60),
              panel.grid.major = element_line(colour = "grey"),
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
             xaxis = list(title = ""),
             yaxis = list(title = "Life Expectancy in Years"),
             title = list(text = paste0(
               'All Areas - Life Expectancy from ', input$all_year_input,
               '<br>',
               '<sup>',
               'Arranged descending by mean value',
               '</sup>',
               '<br>')),
             margin = list(t = 50, b = 50, l = 50))

  })

}
