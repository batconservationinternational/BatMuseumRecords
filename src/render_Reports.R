

source(paste0(here::here(), "/src/get_GBIFdata.R"))
       
source(paste0(here::here(), "/src/process_GBIFdata.R"))



for(thisSPP in c('ALLSPP', "LABO", 'LACI', 'LANO')){

rmarkdown::render(paste0(here::here(), "/reports/MuseumRecords_report.Rmd"), 
                  params=list(SPP = thisSPP), 
                  output_file=paste0(here::here(), "/reports/", thisSPP, "_report.html"))
}