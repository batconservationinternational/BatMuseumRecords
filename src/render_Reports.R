

source(paste0(here::here(), "/src/get_GBIFdata.R"))
       
source(paste0(here::here(), "/src/process_GBIFdata.R"))



for(thisSPP in c('ALLSPP', "LABO", 'LACI', 'LANO')){

  
# for(thisSPP in c('LANO')){  
  
rmarkdown::render(paste0(here::here(), "/src/MuseumRecords_report.Rmd"), 
                  params=list(SPP = thisSPP), 
                  output_file=paste0(here::here(), "/docs/", thisSPP, "_report.html"))
}
