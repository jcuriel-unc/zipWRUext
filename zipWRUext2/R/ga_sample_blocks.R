#' @title GA block sample
#' @description A sample of 2010 demo differential privacy data for Georgia county 001
#' @format A data frame with 2010 rows and 17 variables:
#' \describe{
#'   \item{\code{gisjoin}}{character, census longform block ID}
#'   \item{\code{name}}{character block name}
#'   \item{\code{state}}{character state abbreviation}
#'   \item{\code{total_pop}}{numeric total population of census block}
#'   \item{\code{q_whi}}{numeric number of whites residing in block}
#'   \item{\code{q_bla}}{numeric number of blacks residing in block}
#'   \item{\code{q_his}}{numeric number of hispanics residing in block}
#'   \item{\code{q_asi}}{numeric number of asians residing in block}
#'   \item{\code{q_oth}}{numeric number of others residing in block}
#'   \item{\code{r_whi}}{numeric proportion of whites in state residing in block}
#'   \item{\code{r_bla}}{numeric proportion of blacks in state residing in block}
#'   \item{\code{r_his}}{numeric proportion of hispanics in state residing in block}
#'   \item{\code{r_asi}}{numeric proportion of asians in state residing in block}
#'   \item{\code{r_oth}}{numeric proportion of others in state residing in block}
#'   \item{\code{block}}{character census block 4 digit ID}
#'   \item{\code{tract}}{character census tract 6 digit ID}
#'   \item{\code{county}}{character census county fips code ID}
#'}
#' @source IPUMS NHGIS cleaned Census differential privacy demo data, 05-27-2020
"ga_sample_blocks"