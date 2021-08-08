
library(tidyverse)
library(janitor)

data_zones <- read_csv("~/public_health_dashboard/raw_data/data_zones.csv")

data_zones_cleaned <- data_zones %>%
  select(LA_Code, LA_Name) %>%
  distinct()
  

write.csv(data_zones_cleaned, "~/public_health_dashboard/clean_data/data_zones_clean.csv")


