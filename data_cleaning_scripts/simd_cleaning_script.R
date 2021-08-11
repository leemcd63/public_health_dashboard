llibrary(tidyverse)
library(janitor)
library(readxl)
library(here)

simd_2020 <- read_excel(here("raw_data/simd_2020.xlsx"), sheet = 3)

simd_trimmed <- simd_2020 %>%
  select(DZ, SIMD2020v2_Vigintile, SIMD2020v2_Decile, SIMD2020v2_Quintile, LAcode, LAname) %>%
  rename(data_zone = DZ,
         vigintile = SIMD2020v2_Vigintile,
         decile = SIMD2020v2_Decile,
         quintile = SIMD2020v2_Quintile,
         la_code = LAcode,
         la_name = LAname)

simd_long <- simd_trimmed %>%
  pivot_longer(vigintile:quintile, names_to = "band", values_to = "rank") %>%
  group_by(la_name, la_code, band, rank) %>%
  summarise(count = n())

