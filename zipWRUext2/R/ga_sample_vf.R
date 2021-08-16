#' @title GA Voterfile sample
#' @description A sample of observations from the Georiga voterfile with block level identifiers
#' @format A data frame with 1000 rows and 10 variables:
#' \describe{
#'   \item{\code{county_code}}{integer, internal GA county code}
#'   \item{\code{surname}}{character lastname/surname of the voter}
#'   \item{\code{race}}{character race code for voter}
#'   \item{\code{race_desc}}{character race for voter detailed}
#'   \item{\code{gender}}{character voter's gender}
#'   \item{\code{block}}{character census block 4 digit ID}
#'   \item{\code{tract}}{character census tract 6 digit ID}
#'   \item{\code{county}}{character census county fips code ID}
#'   \item{\code{state}}{character state postal abbreviation}
#'   \item{\code{residence_zipcode}}{character the five digit zip code for the voter}
#'}
#' @source Georgia Election Commission 2020
"ga_sample_vf"