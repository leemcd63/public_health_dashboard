# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
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
  
alcohol_data <- reactive({
    [WRANGLE DATA FOR ALCOHOL]
    
    output$alcohol_map({
      [LEAFLET MAP CODE]
    }),
    
    output$alcohol_plot({
      [GGPLOT FOR ALCOHOL]
    })
    
  })