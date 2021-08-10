# Loading in packages 
library(tidyverse)
library(shiny)
library(DT)
library(shinydashboard)
library(sf)
library(here)
library(plotly)
library(leaflet)

# Loading in alcohol data
alcohol_deaths <- read_csv(here("clean_data/alcohol_deaths_clean.csv"))
alcohol_area <- read_csv(here("clean_data/alcohol_deaths_area.csv"))
# Loading in Scotland shape file 
scotland_shape <- st_read(here("clean_data/shape_data/pub_las.shp")) %>% 
  st_simplify(dTolerance = 1000)


#Launch App
shinyApp(ui = ui, server = server)