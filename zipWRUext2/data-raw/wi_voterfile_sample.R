## code to prepare `wi_voterfile_sample` dataset goes here
wi_data <- readRDS("data-raw/wi_voterfile_sample.rds")
wi_data <- subset(wi_data, select=c(lastname,county,zcta5))
usethis::use_data(wi_data, overwrite = TRUE)
