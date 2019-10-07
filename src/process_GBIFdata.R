library(rgbif)
library(scrubr)
library(dplyr)

# Process All Species -----------------------------------------------------

load(paste0(here::here(), "/data/original/ALLSPP_records.RData"))

ALLSPP_df <- bind_rows(CA_records$data, MX_records$data, US_records$data)

ALLSPP_df_c <-   ALLSPP_df %>%  
  coord_impossible() %>%
  coord_incomplete() %>% 
  coord_unlikely()%>% 
  mutate(date = lubridate::ymd(paste(year, month, "1", sep="-"))) %>% 
  date_missing() %>% 
  filter(date>lubridate::ymd('1800-01-01'),
         !(basisOfRecord %in% c("FOSSIL_SPECIMEN") )) %>% 
  mutate(week = lubridate::week(date),
         month = as.integer(lubridate::month(date)),
         Fmonth = lubridate::month(date, label=T)
  )


saveRDS(ALLSPP_df_c, paste0(here::here(), "/data/processed/ALLSPP_records.RDS"))



# Proccess Red Bat Data ---------------------------------------------------

load(file=paste0(here::here(), "/data/original/LABO_records.RData"))   

LABO_df <-   LABO_records$data %>%  
  coord_impossible() %>%
  coord_incomplete() %>% 
  coord_unlikely()%>% 
  mutate(date = lubridate::ymd(paste(year, month, "1", sep="-"))) %>% 
  date_missing() %>% 
  filter(date>lubridate::ymd('1800-01-01'),
         !(basisOfRecord %in% c("FOSSIL_SPECIMEN") ),
         decimalLongitude>-110) %>% 
  mutate(week = lubridate::week(date),
         month = as.integer(lubridate::month(date)),
         Fmonth = lubridate::month(date, label=T)
  )


saveRDS(LABO_df, paste0(here::here(), "/data/processed/LABO_records.RDS"))


# Process Hoary Bat Data --------------------------------------------------

load(file=paste0(here::here(), "/data/original/LACI_records.RData"))   


LACI_df <-   LACI_records$data %>%  
  coord_impossible() %>%
  coord_incomplete() %>% 
  coord_unlikely()%>% 
  mutate(date = lubridate::ymd(paste(year, month, "1", sep="-"))) %>% 
  date_missing() %>% 
  filter(date>lubridate::ymd('1800-01-01'),
         !(basisOfRecord %in% c("FOSSIL_SPECIMEN") ) 
  ) %>% 
  mutate(week = lubridate::week(date),
         month = as.integer(lubridate::month(date)),
         Fmonth = lubridate::month(date, label=T)
  )


saveRDS(LACI_df, paste0(here::here(), "/data/processed/LACI_records.RDS"))
# Process Silver-haired bat Data ------------------------------------------

load(file=paste0(here::here(), "/data/original/LANO_records.RData"))   


LANO_df <-   LANO_records$data %>%  
  coord_impossible() %>%
  coord_incomplete() %>% 
  coord_unlikely()%>% 
  mutate(date = lubridate::ymd(paste(year, month, "1", sep="-"))) %>% 
  date_missing() %>% 
  filter(date>lubridate::ymd('1800-01-01'),
         !(basisOfRecord %in% c("FOSSIL_SPECIMEN") ) 
  ) %>% 
  mutate(week = lubridate::week(date),
         month = as.integer(lubridate::month(date)),
         Fmonth = lubridate::month(date, label=T)
  )


saveRDS(LANO_df, paste0(here::here(), "/data/processed/LANO_records.RDS"))
