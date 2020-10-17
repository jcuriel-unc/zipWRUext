install.packages(c("devtools", "roxygen2"))  # installations can be `c`ombined
library("devtools")
library("roxygen2")
library(usethis)
parentDirectory <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(parentDirectory)
create("zipWRUext")
setwd("zipWRUext")
###proceed to create data 
usethis::use_data_raw(name = 'all_zip_census2')
usethis::use_data_raw(name = 'wi_voterfile_sample')
file.create("R/wivoterfile.R")
file.create("R/zipWRUdata.R")
sinew::makeOxygen(zip_all_census2)
sinew::makeOxygen(wi_data)



document()

setwd(parentDirectory)
install("zipWRUext")
library(zipWRUext)
?zip_all_census2
?zip_wru
?wi_data
wi_data <- zipWRUext::wi_data
wi_data4 <- zip_wru(wi_data, state="WISCONSIN", type1="census", year1="2010", zip_col="zcta5", surname_field = "lastname")
###testing how to install pkgs from github 
devtools::install_github("https://github.mit.edu/MEDSL/medslCleanR2/", subdir = "medslcleanR2")
devtools::install_github("https://github.mit.edu/MEDSL/medslCleanR2", subdir = "medslcleanR2" , ref='master')
install_github("https://github.com/jcuriel-unc/medslCleanR2", "medslcleanR2")
install_github("https://github.mit.edu/MEDSL/competition", subdir = "medslCompetition")
# e40f5f2aa49156352629f346e5b59bec9027ae3e
#put agbove under the auth token pparam 
?install_github
git remote add origin https://github.com/jcuriel-unc/arealOverlap2
