

source(paste0(here::here(), "/src/get_GBIFdata.R"))
       
source(paste0(here::here(), "/src/process_GBIFdata.R"))
# mySPP="LABO"

mySPP = c('ALLSPP', "LABO", 'LACI', 'LANO')


for(thisSPP in mySPP){

rmarkdown::render(paste0(here::here(), "/src/MuseumRecords_report.Rmd"), 
                  params=list(SPP = thisSPP), 
                  output_file=paste0(here::here(), "/reports/", thisSPP, "_report.html"))
}