install.packages(c("devtools", "roxygen2"))  # installations can be `c`ombined
library("devtools")
library("roxygen2")
library(usethis)
parentDirectory <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(parentDirectory)
create("zipWRUext2")
setwd("zipWRUext2")
###proceed to create data 
usethis::use_data_raw(name = 'all_zip_census2')
usethis::use_data_raw(name = 'wi_voterfile_sample')
file.create("R/wivoterfile.R")
file.create("R/zipWRUdata.R")
sinew::makeOxygen(zip_all_census2)
sinew::makeOxygen(wi_data)



document()

setwd(parentDirectory)
install("zipWRUext2")

###testing how to install pkgs from github 

devtools::install_github("https://github.com/jcuriel-unc/zipWRUext", subdir="zipWRUext2")


library(zipWRUext2)
library(wru)
?zip_all_census2
?zip_wru
?wi_data
if(any(colnames(wi_data4)=="pred.whi2")==T){
  print("Present")
}else{
  print("Not present")
}
predNames <- c("pred.whi","pred.bla","pred.his","pred.asi","pred.oth")

colnamus1 <- which(colnames(wi_data4)==predNames)
rowSums(wi_data4[,colnamus1])

wi_data <- zipWRUext2::wi_data
wi_data4 <- zip_wru(wi_data, state="WISCONSIN", type1="census", year1="2010", zip_col="zcta5", surname_field = "lastname")
head(wi_data4)

wi_data3 <- wi_data4[, -grep("p_", colnames(wi_data4))]
wi_data3 <- wi_data3[, -grep("u_", colnames(wi_data3))]
head(wi_data3)

wi_data4<- race_herfindahl_scores2(wi_data4)
head(wi_data4[,26:28])
View(wi_data4)
sum(wi_data4$pred.whi)/nrow(wi_data4)




