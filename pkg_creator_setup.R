install.packages(c("devtools", "roxygen2"))  # installations can be `c`ombined
library("devtools")
library("roxygen2")
library(usethis)
parentDirectory <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(parentDirectory)
### read in the zip code data from ACS 
zip_acs2019 <- readRDS("zcta_acs2015_2019.rds")
zip_acs2020 <- readRDS("zcta_acs2016_2020.rds")
zip_acs2021 <- readRDS("zcta_acs2017_2021.rds")


#create("zipWRUext2")
setwd("zipWRUext2")
###proceed to create data in the raw folder
usethis::use_data_raw(name = 'all_zip_census2')
usethis::use_data_raw(name = 'wi_voterfile_sample')
usethis::use_data_raw(name = 'sources_dataframe')
usethis::use_data_raw(name = 'ga_sample_blocks')
usethis::use_data_raw(name = 'ga_sample_vf')

## read in the raw data 

ga_sample_blocks <- readRDS("data-raw/ga_sample_blocks.rds")
ga_sample_vf <- readRDS("data-raw/ga_sample_vf.rds")

### new data for master zip file 
master_zcta_df <- readRDS("data-raw/master_zcta_bisg_data.rds")
### now combine 
master_zcta_df <- rbind(master_zcta_df,zip_acs2019,zip_acs2020,zip_acs2021)
zip_all_census2 <- master_zcta_df
## save to the data folder 
save(ga_sample_blocks, file = "data/ga_sample_blocks.rda")
save(ga_sample_vf, file = "data/ga_sample_vf.rda")
##saving new master data 
save(zip_all_census2, file = "data/zip_all_census2.rda")



## These create empty files to be filled with user entered data 
file.create("R/wivoterfile.R")
file.create("R/zipWRUdata.R")
file.create("R/ga_sample_blocks.R")
file.create("R/ga_sample_vf.R")


# Create skelton if title, description, import, etc. 
sinew::makeOxygen(zip_all_census2)
sinew::makeOxygen(wi_data)
sinew::makeOxygen(ga_sample_blocks) # these simply allow one to copy and paste; not really needed 

document()

setwd(parentDirectory)
install("zipWRUext2")
library(zipWRUext2)


?predict_race_any
ga_data <-  zipWRUext2::ga_sample_vf
ga_block_sample <- zipWRUext2::ga_sample_blocks
ga_data2 <- predict_race_any(ga_data, ga_block_sample,  c("county","tract","block"))

###testing how to install pkgs from github 

devtools::install_github("https://github.com/jcuriel-unc/zipWRUext", subdir="zipWRUext2")


library(zipWRUext2)
library(wru)
?zip_all_census2
?zip_wru
?wru_cis
?wi_data
## test tutorial script 
wi_data <-  zipWRUext2::wi_data
wi_data2 <- zip_wru(wi_data, state="WISCONSIN",  year1="2010", zip_col="zcta5", surname_field = "lastname")
wi_data2_cis <- wru_cis(wi_data2, group_var = "zcta5")



if(any(colnames(wi_data4)=="pred.whi2")==T){
  print("Present")
}else{
  print("Not present")
}
predNames <- c("pred.whi","pred.bla","pred.his","pred.asi","pred.oth")

colnamus1 <- which(colnames(wi_data4)==predNames)
rowSums(wi_data4[,colnamus1])

wi_data <- zipWRUext2::wi_data
wi_data4 <- zip_wru(wi_data, state="WISCONSIN",  year1="2010", zip_col="zcta5", surname_field = "lastname")
wi_data4col <- wru_aggregate_pres(wi_data4, group_var = "zcta5")
head(wi_data4col)
## test out the new cmd 

  

wi_data4<- race_herfindahl_scores(wi_data4)
wi_data4col <- wru_aggregate_pres(wi_data4, group_var = "zcta5")

head(wi_data4)
View(wi_data3)
sum(wi_data4$pred.whi)/nrow(wi_data4)


