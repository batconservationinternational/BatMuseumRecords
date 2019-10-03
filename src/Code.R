library("spocc")
library("scrubr")
# library("mapr")
library(dplyr)
library(ggplot2)
library(gganimate)

if( file.exists(paste0(here::here(), "/data/LABO_df.RData"))) {
  load(file=paste0(here::here(), "/data/LABO_df.RData"))
}else{


if (file.exists(paste0(here::here(), "/data/LABO_records.RDS"))){
  
  LABO_records <- readRDS(paste0(here::here(), "/data/LABO_records.RDS"))  
  LABO_df <- occ2df(LABO_records)

}else {
  LABO_records <- occ(query = 'Lasiurus borealis',
                    from = c('gbif'),
                    limit=10000,
                    has_coords = T)

  saveRDS(LABO_records, paste0(here::here(), "/data/LABO_records.RDS"))   
  LABO_df <- occ2df(LABO_records)
}

rm(LABO_records)

LABO_df_c <- LABO_df%>% dedup()

LABO_df_c <-   LABO_df_c %>%  
  coord_impossible() %>%
  coord_incomplete() %>% 
  coord_unlikely()%>% 
  date_missing()




save(LABO_df_c, file=paste0(here::here(), "/data/LABO_df.RData"))
}


LABO_df_c <- LABO_df_c %>% 
  filter(longitude<0, latitude>25, # restrict to NA
         #remove western red bat
         longitude>-110,
         date>lubridate::ymd('1816-01-01')) %>% 
  mutate(week = lubridate::week(date),
         month = as.integer(lubridate::month(date)),
         Fmonth = lubridate::month(date, label=T))

# pdiowa <- ggplot(giowa) +
#   geom_polygon(aes(long, lat, group = group), fill = NA, color = "grey") +
#   stat_contour(aes(Lon, Lat, z = dens, fill = ..level..),
#                color = "black", alpha = 0.2, na.rm = TRUE, data = srfci,
#                geom = "polygon")
# pdiowa + coord_quickmap()

# sp <- ggplot(faithful, aes(x=eruptions, y=waiting)) +
#   geom_point()
# sp + geom_density_2d()
# # Gradient color
# sp + stat_density_2d(aes(fill = ..level..), geom="polygon")
# # Change the gradient color
# sp + stat_density_2d(aes(fill = ..level..), geom="polygon")+
#   scale_fill_gradient(low="blue", high="red")
wmap <- suppressMessages(ggplot2::map_data('world'))

map <- ggplot(LABO_df_c, aes(longitude, latitude)) +
  stat_density_2d(aes(fill = ..level..), geom="polygon")+
  geom_point()+
  geom_polygon(
    aes(long, lat, group = group), fill = NA, colour = "black", data = wmap)+
  coord_quickmap(xlim=c(-115,-60), ylim=c(20, 55) )+
  labs(title = 'Red Bat Records by Month')

map

ggsave(file=paste0(here::here(), "/output/LABO_allYear.jpg"), plot=map)

ggsave(file=paste0(here::here(), "/output/LABO_month.jpg"), plot=map+facet_wrap(~Fmonth))

ggplot(LABO_df_c, aes(longitude, latitude, group=month)) +
  stat_density_2d(aes(fill = ..level..), geom="polygon")+
  geom_point()+
  geom_polygon(
    aes(long, lat, group = group), fill = NA, colour = "black", data = wmap)+
  transition_time(month)+
  labs(title = 'Montht: {frame_time}')
  


