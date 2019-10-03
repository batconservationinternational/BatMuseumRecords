library(rgbif)
library(scrubr)
library(dplyr)
library(ggplot2)
library(spocc)
library(gganimate)

SPP = "Lasiurus borealis"


# Download Original Data --------------------------------------------------


LABO_records <- occ_search(
  scientificName = SPP ,
  hasCoordinate = T,
  # orderKey = 734,
  continent = 'north_america',
  fields = 'all',
  # fields = c(
  #   "genus",
  #   "genericName",
  #   "sex",
  #   "year",
  #   "month",
  #   "day",
  #   "basisOfRecord",
  #   "decimalLatitude",
  #   "decimalLongitude",
  #   "country",
  #   "stateProvince"
  # ),
  limit = 500000
)


save(LABO_records, file=paste0(here::here(), "/data/original/LABO_records.RData"))   
  

# Process and Clean Data --------------------------------------------------

load(paste0(here::here(), "/data/original/LABO_records.RData"))


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

# Graph -------------------------------------------------------------------
LABO_df <- readRDS(paste0(here::here(), "/data/processed/LABO_records.RDS"))

wmap <- suppressMessages(ggplot2::map_data('world'))

myBreaks <- function(x){
  breaks <- c(min(x),max(x))
  names(breaks) <- attr(breaks,"labels")
  breaks
}

map <- ggplot(LABO_df, aes(decimalLongitude, decimalLatitude, group = month)) +
  geom_polygon(
    aes(long, lat, group = group), fill = 'grey', colour = "black", data = wmap)+
  stat_density_2d(aes(fill = ..level..), geom="polygon", alpha = 0.25)+
  geom_point(size=0.1)+
  coord_quickmap(xlim=c(-130,-60), ylim=c(10, 60) )+
  labs(x=element_blank(), y = element_blank(), 
       title = 'Red Bat Records',
       fill = element_blank())+
  # scale_fill_viridis_c(breaks = pretty_breaks(n=3),labels = c('','less', "",'more',''))+
  scale_fill_viridis_c(breaks = myBreaks, expand=expand_scale(),labels = c('Fewer Records','More Records') )+
  theme_minimal()+
  theme(legend.position="bottom")

# map

map+
  facet_wrap(~Fmonth)+
  ggsave(file=paste0(here::here(), "/output/LABO_month.jpg"), width = 8, height = 10.5)




anim <- map+
  transition_time(month)+
  labs(subtitle = 'Month: {frame_time}')+
  ease_aes('linear')+
  enter_fade() +
  exit_fade()

animate(anim, duration = 24, width=1024, height=1024)

anim_save(paste0(here::here(), "/output/LABO_anim.gif"))
