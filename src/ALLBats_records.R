library(rgbif)
library(scrubr)
library(dplyr)
library(ggplot2)
library(spocc)


# Download Original Data --------------------------------------------------


CA_records <- occ_search(
  scientificName = 'Chiroptera',
  hasCoordinate = T,
  # orderKey = 734,
  country = c('ca'),
  continent = 'north_america',
  fields = c(
    "genus",
    "genericName",
    "sex",
    "year",
    "month",
    "day",
    "basisOfRecord",
    "decimalLatitude",
    "decimalLongitude",
    "country",
    "stateProvince"
  ),
  limit = 500000
)

MX_records <- occ_search(
  scientificName = 'Chiroptera',
  hasCoordinate = T,
  # orderKey = 734,
  country = c('mx'),
  continent = 'north_america',
  fields = c(
    "genus",
    "genericName",
    "sex",
    "year",
    "month",
    "day",
    "basisOfRecord",
    "decimalLatitude",
    "decimalLongitude",
    "country",
    "stateProvince"
  ),
  limit = 500000
)

US_records <- occ_search(
  scientificName = 'Chiroptera',
  hasCoordinate = T,
  # orderKey = 734,
  country = c('us'),
  continent = 'north_america',
  fields = c(
    "genus",
    "genericName",
    "sex",
    "year",
    "month",
    "day",
    "basisOfRecord",
    "decimalLatitude",
    "decimalLongitude",
    "country",
    "stateProvince"
  ),
  limit = 500000
)


save(CA_records, MX_records, US_records, file=paste0(here::here(), "/data/original/ALLSPP_records.RData"))   
  

# Process and Clean Data --------------------------------------------------

load(paste0(here::here(), "/data/original/ALLSPP_records.RData"))

ALLSPP_df <- rbind(CA_records$data, MX_records$data, US_records$data)

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
# Graph -------------------------------------------------------------------
ALLSPP_df_c <- readRDS(paste0(here::here(), "/data/processed/ALLSPP_records.RDS"))

wmap <- suppressMessages(ggplot2::map_data('world'))

myBreaks <- function(x){
  breaks <- c(min(x),max(x))
  names(breaks) <- attr(breaks,"labels")
  breaks
}

map <- ggplot(ALLSPP_df_c, aes(decimalLongitude, decimalLatitude, group = month)) +
  geom_polygon(
    aes(long, lat, group = group), fill = 'grey', colour = "black", data = wmap)+
  stat_density_2d(aes(fill = ..level..), geom="polygon", alpha = 0.25)+
  geom_point(size=0.1)+
  coord_quickmap(xlim=c(-130,-60), ylim=c(10, 60) )+
  labs(x=element_blank(), y = element_blank(), 
       title = 'ALL Chiroptera Records',
       fill = "Number of Records")+
  # scale_fill_viridis_c(breaks = pretty_breaks(n=3),labels = c('','less', "",'more',''))+
  scale_fill_viridis_c(breaks = myBreaks, expand=expand_scale(),labels = c('less','more') )+
  theme_minimal()

# map

map+
  facet_wrap(~Fmonth)+
  ggsave(file=paste0(here::here(), "/output/ALLSPP_month.jpg"), width = 12, height = 8)




