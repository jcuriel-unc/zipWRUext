#' WRU formatted racial demographics ZIP code data
#'
#' A dataset containing the number of each racial demographic in U.S. ZIP codes for the purpose of running the wru BISG package. Includes data
#' from the Census (2010) and every 5 year ACS up to 2021. Additionally, presents data in crosswalk format such that the data can be run by
#' state. 
#'
#' @format A data frame with 396,971 rows and 16 variables:
#' \describe{
#'   \item{state_name}{State's name, all capitalized}
#'   \item{zcta5}{The string padded 5 digit ZIP code}
#'   \item{total_pop}{Total population for the ZIP code}
#'   \item{q_whi}{The population for non-hispanic whites}
#'   \item{q_bla}{The population for non-hispanic blacks}
#'   \item{q_his}{The population for hispanics}
#'   \item{q_asi}{The population for non-hispanic Asians and pacific islanders}
#'   \item{q_oth}{The population for non-hispanic all other races}
#'   \item{r_whi}{The proportion of the non-hispanic white population that lives within a ZIP code relative to the given state}
#'   \item{r_bla}{The proportion of the non-hispanic black population that lives within a ZIP code relative to the given state}
#'   \item{r_his}{The proportion of the hispanic population that lives within a ZIP code relative to the given state}
#'   \item{r_asi}{The proportion of the non-hispanic asian and pacific islander  population that lives within a ZIP code relative to the given state}
#'   \item{r_oth}{The proportion of the non-hispanic other population that lives within a ZIP code relative to the given state}
#'   \item{type}{The source of the data to be specified for prediction purposes. Takes either the values of census or acs}
#'   \item{year}{The year for the data. The Census data is from 2010, and the acs data runs from 2011 to 2021.}
#'   \item{state_po}{The state postal code.}
#' }
#' @source U.S. Census Bureau. (2011--2021). 2011-2021 American Community Survey (ACS) 5-year Detailed ZCTA Level Data. Geographic Level 860,
#' Tables: B01001C -- B01001I. Public Use Microdata Samples [JSON Data file].  Retrieved from (see sources_dataframe for links).

"zip_all_census2"
