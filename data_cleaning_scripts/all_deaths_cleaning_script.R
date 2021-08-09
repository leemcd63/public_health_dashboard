library(tidyverse)

all_deaths <- read_csv("raw_data/all_deaths_data.csv", skip = 10) %>% 
  janitor::clean_names()

all_deaths_clean <- all_deaths %>% 
  select(-http_purl_org_linked_data_sdmx_2009_dimension_number_ref_area, -x2001:-x2011) %>%
  head(33) %>% 
  rename("2012" = x2012,
         "2013" = x2013,
         "2014" = x2014,
         "2015" = x2015,
         "2016" = x2016,
         "2017" = x2017,
         "2018" = x2018,
         "2019" = x2019,
         "Council Areas" = reference_area)

write_csv(all_deaths_clean, "clean_data/all_deaths_clean.csv")


