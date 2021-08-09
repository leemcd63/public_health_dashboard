library(tidyverse)
library(here)

# Read in drug death data sets, rename columns and drop NA values

dd_2009 <- read_csv(here("raw_data/drug_deaths/drug_deaths_2009.csv"), 
                    col_names = c("council_area", "All drug-related deaths", "Heroin/Morphine", "Methadone", 
                                  "Any Benzodiazepine", "Diazepam", "Temazepam", 
                                  "Cocaine", "Ecstasy", "Amphetamines", "Alcohol"), 
                    skip = 16) %>%
  drop_na()

dd_2010 <- read_csv(here("raw_data/drug_deaths/drug_deaths_2010.csv"), 
                    col_names = c("council_area", "All drug-related deaths", "Heroin/Morphine", "Methadone", 
                                  "Any Benzodiazepine", "Diazepam", "Temazepam", 
                                  "Cocaine", "Ecstasy", "Amphetamines", "Alcohol"), 
                    skip = 15) %>%
  drop_na()

dd_2011 <- read_csv(here("raw_data/drug_deaths/drug_deaths_2011.csv"), 
                    col_names = c("council_area", "All drug-related deaths", "Heroin/Morphine", 
                                  "Methadone", "Any Benzodiazepine", "Diazepam", "Temazepam", 
                                  "Cocaine", "Ecstasy", "Amphetamines", "Alcohol"), 
                    skip = 13) %>%
  drop_na()

dd_2012 <- read_csv(here("raw_data/drug_deaths/drug_deaths_2012.csv"), 
                    col_names = c("council_area", "All drug-related deaths", "Heroin/Morphine", 
                                  "Methadone", "Any Benzodiazepine", "Diazepam", "Temazepam", 
                                  "Cocaine", "Ecstasy", "Amphetamines", "Alcohol"), 
                    skip = 13) %>%
  drop_na()

dd_2013 <- read_csv(here("raw_data/drug_deaths/drug_deaths_2013.csv"), 
                    col_names = c("council_area", "All drug-related deaths", "Heroin/Morphine", 
                                  "Methadone", "Any Benzodiazepine", "Diazepam", "Temazepam", 
                                  "Cocaine", "Ecstasy", "Amphetamines", "Alcohol"), 
                    skip = 13) %>%
  drop_na()

dd_2014 <- read_csv(here("raw_data/drug_deaths/drug_deaths_2014.csv"), 
                    col_names = c("council_area", "All drug-related deaths", "Heroin/Morphine", 
                                  "Methadone", "Heroin/morphine, methadone or bupren-orphine", 
                                  "Codeine", "Dihydro-codeine", "Any opiate or opioid", "Any Benzodiazepine", 
                                  "Diazepam", "Cocaine", "Ecstasy", "Amphetamines", "Alcohol"), 
                    skip = 12) %>%
  drop_na()

dd_2015 <- read_csv(here("raw_data/drug_deaths/drug_deaths_2015.csv"), 
                    col_names = c("council_area", "All drug-related deaths", "Heroin/Morphine", 
                                  "Methadone", "Heroin/morphine, methadone or bupren-orphine", 
                                  "Codeine", "Dihydro-codeine", "Any opiate or opioid", "Any Benzodiazepine", 
                                  "Diazepam", "Cocaine", "Ecstasy", "Amphetamines", "Alcohol"), 
                    skip = 12) %>%
  drop_na()

dd_2016 <- read_csv(here("raw_data/drug_deaths/drug_deaths_2016.csv"), 
                    col_names = c("council_area", "All drug-related deaths", "Heroin/Morphine", 
                                  "Methadone", "Heroin/morphine, methadone or bupren-orphine", 
                                  "Codeine", "Dihydro-codeine", "Any opiate or opioid", "Any Benzodiazepine", 
                                  "Diazepam", "Cocaine", "Ecstasy", "Amphetamines", "Alcohol"), 
                    skip = 12) %>%
  drop_na()

dd_2017 <- read_csv(here("raw_data/drug_deaths/drug_deaths_2017.csv"), 
                    col_names = c("council_area", "All drug-related deaths", "Heroin/Morphine", 
                                  "Methadone", "Heroin/morphine, methadone or bupren-orphine", 
                                  "Codeine", "Dihydro-codeine", "Any opiate or opioid", "Any Benzodiazepine", 
                                  "Diazepam", "Cocaine", "Ecstasy", "Amphetamines", "Alcohol"), 
                    skip = 7) %>%
  drop_na()

dd_2018 <- read_csv(here("raw_data/drug_deaths/drug_deaths_2018.csv"), 
                    col_names = c("council_area", "All drug-related deaths", "Heroin/Morphine", 
                                  "Methadone", "Heroin/morphine, methadone or bupren-orphine", 
                                  "Codeine", "Dihydro-codeine", "Any opiate or opioid", "Any Benzodiazepine",
                                  "Any Prescribable Benzodiazepine", "Diazepam", "Any Street Benzodiazepine", 
                                  "Etizolam", "Gabapentin and/or Pregabalin", "Cocaine", "Ecstasy", 
                                  "Amphetamines", "Alcohol"), 
                    skip = 10) %>%
  drop_na()

dd_2019 <- read_csv(here("raw_data/drug_deaths/drug_deaths_2019.csv"), 
                    col_names = c("council_area", "All drug-related deaths", "Heroin/Morphine", 
                                  "Methadone", "Heroin/morphine, methadone or bupren-orphine", 
                                  "Codeine", "Dihydro-codeine", "Any opiate or opioid", "Any Benzodiazepine",
                                  "Any Prescribable Benzodiazepine", "Diazepam", "Any Street Benzodiazepine", 
                                  "Etizolam", "Gabapentin and/or Pregabalin", "Cocaine", "Ecstasy", 
                                  "Amphetamines", "Alcohol"), 
                    skip = 10) %>%
  drop_na()


# Create empty data frame for long format
drug_deaths_long <- data_frame()

# For each year, convert to long format and bind rows to one dataset
for (i in 2009:2019) {
  df_name <- paste0("dd_", i)
  df_input <- as.name(df_name)
  
  df_long <- eval(df_input) %>%
    # Rename area names for consistency
    mutate(council_area = case_when(
            str_detect(council_area, "Eilean") ~ "Eilean Siar",
            str_detect(council_area, "Edinburgh") ~ "City of Edinburgh",
            TRUE ~ council_area
          ),
          council_area = str_replace(council_area, "&", "and")) %>%
    # Pivot to long format
    pivot_longer(-council_area, names_to = "drug_name", values_to = "num_deaths") %>%
    # Add year column
    mutate(year = i)
  
  # Bind rows into complete dataset
  drug_deaths_long <- bind_rows(drug_deaths_long, df_long)
}


write_csv(drug_deaths_long, here("clean_data/drug_deaths_clean.csv"))
