library(rgbif)

n=500000

# Download Original Data --------------------------------------------------


CA_records <- occ_search(
  scientificName = 'Chiroptera',
  hasCoordinate = T,
  country = c('ca'),
  continent = 'north_america',
  limit = n
)

MX_records <- occ_search(
  scientificName = 'Chiroptera',
  hasCoordinate = T,
  country = c('mx'),
  continent = 'north_america',
  limit = n
)

US_records <- occ_search(
  scientificName = 'Chiroptera',
  hasCoordinate = T,
  country = c('us'),
  continent = 'north_america',
  limit = n
)


save(CA_records, MX_records, US_records, file=paste0(here::here(), "/data/original/ALLSPP_records.RData"))   


# Red Bat Records ---------------------------------------------------------

LABO_records <- occ_search(
  scientificName = "Lasiurus borealis" ,
  hasCoordinate = T,
  # orderKey = 734,
  continent = 'north_america',
  fields = 'all',
  limit = n
)


save(LABO_records, file=paste0(here::here(), "/data/original/LABO_records.RData"))   

# Hoary Bat Records -------------------------------------------------------


LACI_records <- occ_search(
  scientificName = "Lasiurus cinereus" ,
  hasCoordinate = T,
  # orderKey = 734,
  continent = 'north_america',
  fields = 'all',
  limit = n
)


save(LACI_records, file=paste0(here::here(), "/data/original/LACI_records.RData"))   


# Silver-haired bat Records -----------------------------------------------

LANO_records <- occ_search(
  scientificName = "Lasionycteris noctivagans" ,
  hasCoordinate = T,
  continent = 'north_america',
  fields = 'all',
  limit = n
)


save(LANO_records, file=paste0(here::here(), "/data/original/LANO_records.RData"))   
