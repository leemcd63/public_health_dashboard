# Loading in packages 
library(tidyverse)
library(shiny)
library(DT)
library(shinydashboard)
library(leaflet)
library(sf)
library(here)
library(plotly)
library(lubridate)

# life_expectancy_data <- read_csv("~/public_health_dashboard/clean_data/life_expectancy_clean.csv")
# life_expectancy_data_2 <- life_expectancy_data %>%
#   filter(age == "0 years") %>%
#   filter(measurement == "Count")
# 
# life_expectancy_data_2[life_expectancy_data_2=="Na h-Eileanan Siar"]<- "Eilean Siar"
# 
# life_expectancy_round <- round(life_expectancy_data_2$value, 2)
# life_expectancy_data_2 <- life_expectancy_data_2 %>%
#   mutate(value = life_expectancy_round)
# 
# colnames(life_expectancy_data)[which(names(life_expectancy_data) == "sex")] <- "gender"
# colnames(life_expectancy_data_2)[which(names(life_expectancy_data_2) == "sex")] <-"gender"

scotland_shape <- st_read(here("~/public_health_dashboard/clean_data/shape_data/pub_las.shp")) %>% 
  st_simplify(dTolerance = 1000) %>%
  st_transform("+proj=longlat +datum=WGS84")

# use this
life_expectancy_data <- read_csv(here("clean_data/life_expectancy_clean.csv")) %>%
  mutate(local_authority = if_else(local_authority == "Na h-Eileanan Siar", "Eilean Siar", local_authority),
         value = round(value, 2)) %>%
  rename(gender = sex) %>%
  filter(age == "0 years")


#Launch App
#shinyApp(ui = ui, server = server)