# Loading in packages 
library(tidyverse)
library(shiny)
library(DT)
library(shinydashboard)
library(leaflet)
library(here)
library(sf)


drug_deaths <- read_csv(here("clean_data/drug_deaths_clean.csv"))

scotland_shape <- st_read(here("clean_data/shape_data/pub_las.shp")) %>%
  st_simplify(dTolerance = 1000) %>%
  st_transform("+proj=longlat +datum=WGS84")






#Launch App
#shinyApp(ui = ui, server = server)
