## code to prepare `all_zip_census2` dataset goes here

zip_all_census2 <- readRDS("data-raw/master_zcta_bisg_data.rds")

usethis::use_data(zip_all_census2, overwrite = TRUE)
