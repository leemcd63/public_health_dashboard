# Loading in packages
library(tidyverse)
library(shiny)
library(DT)
library(shinydashboard)
library(leaflet)
library(here)
library(sf)
library(plotly)

# Loading in drug data
drug_deaths <- read_csv(here("clean_data/drug_deaths_clean.csv"))

# Loading in alcohol data
alcohol_deaths <- read_csv(here("clean_data/alcohol_deaths_clean.csv")) %>%
  mutate(gender = case_when(gender == "male" ~ "Male",
                            gender == "female" ~ "Female"))
alcohol_area <- read_csv(here("clean_data/alcohol_deaths_area.csv"))

#Launch App
#shinyApp(ui = ui, server = server)
