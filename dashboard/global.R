# Loading in packages 
library(tidyverse)
library(shiny)
library(DT)
library(shinydashboard)
library(leaflet)
library(sf)
library(here)
library(plotly)

life_expectancy_data <- read_csv("~/public_health_dashboard/clean_data/life_expectancy_clean.csv")
life_expectancy_data_2 <- life_expectancy_data %>%
  filter(age == "0 years" & date_code == "2017-2019")


life_expectancy_data_2[life_expectancy_data_2=="Na h-Eileanan Siar"]<- "Eilean Siar"

life_expectancy_round <- round(life_expectancy_data_2$value, 2)
life_expectancy_data_2 <- life_expectancy_data_2 %>%
  mutate(value = life_expectancy_round)

colnames(life_expectancy_data)[which(names(life_expectancy_data) == "sex")] <- "gender"
colnames(life_expectancy_data_2)[which(names(life_expectancy_data_2) == "sex")] <-"gender"

scotland_shape <- st_read(here("~/public_health_dashboard/clean_data/shape_data/pub_las.shp")) %>% 
 st_transform("+proj=longlat +datum=WGS84")





#Launch App
#shinyApp(ui = ui, server = server)