## code to prepare `wi_voterfile_sample` dataset goes here
wi_data <- readRDS("data-raw/wi_voterfile_sample.rds")

usethis::use_data(wi_data, overwrite = TRUE)
