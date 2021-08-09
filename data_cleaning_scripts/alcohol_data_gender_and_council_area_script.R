

library(tidyverse)
library(janitor)
library(here)

alcohol_data_female <- read_csv(here("public_health_dashboard/raw_data/alcohol_deaths/alcohol_deaths_female_age_group.csv"))
alcohol_data_male <- read_csv(here("public_health_dashboard/raw_data/alcohol_deaths/alcohol_deaths_male_age_group.csv"))



alcohol_data_female_2 <- subset(alcohol_data_female, select = -c(22, 24,25)) %>%
  slice(-c(1:4, 5:36, 48:91))
  
  

colnames(alcohol_data_female_2) <- c("year_of_death", "all_ages", "0-4", "5-9",
                                     "10-14","15-19", "20-24", "25-29", "30-34",
                                     "35-39", "40-44", "45-49", "50-54","55-59",
                                     "60-64", "65-69", "70-74", "75-79", 
                                     "80-84", "85-89",
                                    "90+", "average_age")

alcohol_data_female_pivoted <- alcohol_data_female_2 %>%
  pivot_longer(cols = c(2:22), names_to="age_group", values_to ="count") %>%
  mutate(gender = "female")


alcohol_data_male_2 <- subset(alcohol_data_male, select = -c(22)) %>%
  slice(-c(1:36, 48:90))
 
colnames(alcohol_data_male_2) <- c("year_of_death", "all_ages", "0-4", "5-9", "10-14", "15-19",
                                   "20-24", "25-29", "30-34", "35-39", "40-44",
                                   "45-49", "50-54", "55-59", "60-64", "65-69",
                                   "70-74", "75-79", "80-84", "85-89", "90+",
                                   "average_age")



alcohol_data_male_pivoted <- alcohol_data_male_2 %>%
  pivot_longer(cols = c(2:22), names_to="age_group", values_to ="count") %>%
  mutate(gender = "male")

alcohol_deaths_combined <- rbind(alcohol_data_female_pivoted, alcohol_data_male_pivoted)

alcohol_deaths_count <- alcohol_deaths_combined$count %>% 
  as.numeric(count)

alcohol_deaths_combined <- alcohol_deaths_combined %>%
  mutate(count = alcohol_deaths_count)
  
write.csv(alcohol_deaths_combined, "~/public_health_dashboard/clean_data/alcohol_deaths_clean.csv")
  



alcohol_deaths_council_area <- read_csv("~/public_health_dashboard/raw_data/alcohol_deaths/alcohol_deaths_council_area.csv")
  

alcohol_deaths_area <- subset(alcohol_deaths_council_area, select = -c(35)) %>%
  slice(-c(1:34, 46:94)) 


alcohol_deaths_area <- alcohol_deaths_area %>%
  mutate(count = alcohol_deaths_area_1)

#colnames(alcohol_deaths_area) <- c("year_of_death", "all_scotland", "aberdeen_city", "aberdeenshire",
#                                   "angus", "argyll_and_bute", "city_of_edinburgh",
 #                                  "clackmannanshire", "dumfries_and_galloway",
  #                                 "east_lothian", "east_renfrewshire", "falkirk",
  #                                 "dundee_city", "east_ayrshire", "east_dunbartonshire",
   #                                "midlothian", "moray", "na_h_eileanan_siar",
    #                               "north_ayrshire", "north_lanarkshire", 
    #                               "fife", "glasgow_city", "highland", "inverclyde",
     #                              "orkney_islands", "perth_and_kinross",
      #                             "renfrewshire", "scottish_borders", 
       #                            "shetland_islands", "south_ayrshire",
        #                           "south_lanarkshire", "stirling", 
         #                          "westdunbartonshire", "west_lothian")


alcohol_deaths_area_pivoted <- alcohol_deaths_area %>%
  pivot_longer(cols = c(2:34), names_to="area", values_to ="count")


alcohol_deaths_area_pivoted <- alcohol_deaths_area_pivoted %>%
  as.numeric(count)

alcohol_deaths_area_pivoted_1 <- alcohol_deaths_area_pivoted$count %>%
  str_remove_all(fixed(","))
alcohol_deaths_area_pivoted_1 <- as.numeric(alcohol_deaths_area_pivoted_1)

alcohol_deaths_area_pivoted <- alcohol_deaths_area_pivoted %>%
  mutate(count = alcohol_deaths_area_pivoted_1)

write.csv(alcohol_deaths_area, "~/public_health_dashboard/clean_data/alcohol_deaths_area.csv")


