#' @title WI Voterfile sample
#' @description A sample of observations from the Wisconsin voterfile in order to run BISG 
#' @format A data frame with 900 rows and 13 variables:
#' \describe{
#'   \item{\code{voterregnumber}}{integer, voter registration number for voters}
#'   \item{\code{lastname}}{character lastname/surname of the voter}
#'   \item{\code{firstname}}{character firstname of the voter}
#'   \item{\code{voterstatus}}{character status of voter}
#'   \item{\code{voterstatusreason}}{character reason for voter status}
#'   \item{\code{address1}}{character address field 1}
#'   \item{\code{address2}}{character address field 2}
#'   \item{\code{ballotdeliverymethod}}{character ballot delivery method}
#'   \item{\code{ballotstatusreason}}{character reason of ballot status}
#'   \item{\code{ballotreasontype}}{character reason for ballot}
#'   \item{\code{electionname}}{character name for the election file from}
#'   \item{\code{county}}{character county of voter}
#'   \item{\code{zcta5}}{character the five digit zip code for the voter
#'}
#' @source Wisconsin Election Commission 2020
"wi_data"