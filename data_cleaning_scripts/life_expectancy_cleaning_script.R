library(tidyverse)

life_expectancy <- read_csv("raw_data/life_expectancy.csv") %>% 
  janitor::clean_names() 

life_expectancy_clean <- life_expectancy %>% 
  select(-simd_quintiles, -urban_rural_classification, -units) %>% 
  filter(date_code > 2009) %>% 
  mutate(age = factor(x = age, levels = c("0 years", "1-4 years", "5-9 years", "10-14 years", "15-19 years", "20-24 years", "25-29 years", "30-34 years", "35-39 years", "40-44 years", "45-49 years", "50-54 years", "55-59 years", "60-64 years", "65-69 years", "70-74 years", "75-79 years", "80-84 years", "85-89 years", "90 years"))) %>% 
  arrange(feature_code, date_code, age) 

write_csv(life_expectancy_clean, "clean_data/life_expectancy_clean.csv")