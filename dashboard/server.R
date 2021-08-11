# server ------------------------------------------------------------------

server <- function(input, output) {
  
  output$value <- renderText({ input$about })
  
  
  output$avg_m <- renderValueBox({
    
    valueBox(
      value = 
        tags$p(     ,
               style = "font-size: 80%;"),
      subtitle = "Most Popular Game",
      icon = icon("heart"),
      color = "blue"
    )
  })
  
  output$avg_f <- renderValueBox({
    
    valueBox(
      value = 
        tags$p(    ,
               style = "font-size: 80%;"),
      subtitle = "Most Popular Game",
      icon = icon("heart"),
      color = "blue"
    )
  })
  
  output$life_exp_area <- renderValueBox({
    
    valueBox(
      value = 
        tags$p(    ,
               style = "font-size: 80%;"),
      subtitle = "Most Popular Game",
      icon = icon("heart"),
      color = "blue"
    )
  })
  
  output$most_drug_death <- renderValueBox({
    
    valueBox(
      value = 
        tags$p(drug_deaths %>% 
                 filter(drug_name != "All drug-related deaths" & year == 2019) %>% 
                 slice_max(num_deaths) %>% 
                 pull(drug_name),
               style = "font-size: 80%;"),
      subtitle = "Most Lethal Drug 2019",
      icon = icon("pills"),
      color = "purple"
    )
  })
  
  output$total_drug_death <- renderValueBox({
    
    valueBox(
      value = 
        tags$p(drug_deaths %>% 
                 filter(council_area == "Scotland" &
                          drug_name == "All drug-related deaths" &
                          year == 2019) %>%
                 pull(num_deaths),
               style = "font-size: 80%;"),
      subtitle = "Drug Deaths 2019",
      icon = icon("pills"),
      color = "purple"
    )
  })
  
  output$worst_drug_area <- renderValueBox({
    
    valueBox(
      value = 
        tags$p(drug_deaths %>% 
                 filter(drug_name == "All drug-related deaths" &
                          year == 2019 &
                          council_area != "Scotland") %>%
                 slice_max(1) %>% 
                 pull(council_area),
               style = "font-size: 80%;"),
      subtitle = "Council Area with Most Drug Deaths 2019",
      icon = icon("home"),
      color = "purple"
    )
  })
  
  output$alcohol_age <- renderValueBox({
    
    valueBox(
      value = 
        tags$p(alcohol_deaths %>% 
                 drop_na(age_group) %>% 
                 filter(year_of_death == 2019) %>% 
                 slice_max(count, n = 1, with_ties = FALSE) %>% 
                 pull(age_group),
               style = "font-size: 80%;"),
      subtitle = "Age of Most Alcohol-related Mortality in 2019",
      icon = icon("wine-glass"),
      color = "green"
    )
  })
  
  output$total_alc_death <- renderValueBox({
    
    valueBox(
      value = 
        tags$p(alcohol_deaths %>% 
                 drop_na(age_group) %>% 
                 filter(year_of_death == 2019) %>% 
                 summarise(count = sum(count)) %>% 
                 pull(count),
               style = "font-size: 80%;"),
      subtitle = "Total Alcohol Deaths 2019",
      icon = icon("wine-glass"),
      color = "green"
    )
  })
  
  output$worst_alcohol_area <- renderValueBox({

    valueBox(
      value = 
        tags$p(alcohol_area %>% 
                 filter(area != "All Scotland" &
                          year_of_death == 2009) %>% 
                 slice_max(count, n = 1) %>% 
                 pull(count),
               style = "font-size: 80%;"),
      subtitle = "Area with Most Alcohol Deaths 2019",
      icon = icon("home"),
      color = "green"
    )
  })
  
}
