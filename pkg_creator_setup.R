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
?zip_all_census2
?zip_wru
?wi_data
wi_data <- zipWRUext2::wi_data
wi_data4 <- zipWRUext2::zip_wru(wi_data, state="WISCONSIN", type1="census", year1="2010", zip_col="zcta5", surname_field = "lastname")
