#' @title American Community Survey links to ZCTA Demographic information
#' @description A dataframe with 81 rows and 5 rows with the links and descriptions to the JSON files scrapped 
#' @format A data frame with 81 rows and 5 variables:
#' \describe{
#'   \item{\code{table_geog}}{integer, geographic level of table}
#'   \item{\code{table_acs}}{character, B01001 series table name for demographic information}
#'   \item{\code{demographic}}{character, name for demographic}
#'   \item{\code{year}}{character, year of the ACS information}
#'   \item{\code{link}}{character, the link to the ACS JSON file to pull information}
#'}
#' @source  U.S. Census Bureau. (2011--2018). 2011-2018 American Community Survey (ACS) 5-year Detailed ZCTA Level Data. 
"sources_dataframe"
