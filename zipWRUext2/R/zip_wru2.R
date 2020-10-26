#' BISG with ZIP codes
#' 
#' This function takes voter file data set up for wru and performs BISG at teh ZIP code level, incorporating Census 2010 or ACS 2011 - 2018
#' data, as acquired from Social Explorer. 
#' 
#' @param dataframe1 The data frame for the voter file. 
#' @param state The state name for the voter file, in all upper case letters  
#' @param type1 The type of the data to use for BISG. Can be either census or acs  
#' @param year1 The year for the data to use for the demographic population data. If 2010, then type1 must be equal to census. Spans 2010 - 2018
#' @param zip_col The column name for the five digit zip code field within the dataframe. Defaults to zcta5
#' @param surname_field The column name for the surname that the wru package will use to merge on the surname probabilities. Note that they
#' must all be uppercase, and if not already, the column will be renamed to surname 
#' @return A dataframe with the pred.race fields for the probability that an individual is of a given race. These sum to 1. 
#' }
#' 
#' @export
#' @examples 
#' wi_data <- wi_data <- zipWRUext2::wi_data
#' wi_data2 <- zip_wru(wi_data, state="WISCONSIN", type1="census", year1="2010", zip_col="zcta5", surname_field = "lastname")
#' 


zip_wru <- function(dataframe1, state, type1="census", year1="2010", zip_col="zcta5", surname_field = "surname"){
  list.of.packages <- c("wru","gtools")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  library(wru)
  eth <- c("whi", "bla", "his", "asi", "oth")
  final_dataframe <- data.frame(stringsAsFactors = FALSE)
  #data("zip_all_census2", envir=environment())
  all_zip_census2 <- zipWRUext2::zip_all_census2
  ###check to make sure data is right 
  if(year1=="2010" & type1!="acs" ){
    stop("Data from 2010 is being called, but that requires census data.")
  }else if(year1!="2010" & type1=="census"){
    stop("Data after 2010 is being called, but that requires acs, not census data, type.")
  }
  
  #all_zip_census <- readRDS(paste0("data/cleaned",sep="/","master_zcta_bisg_data.rds"))
  all_zip_census2 <- subset(all_zip_census2,state_name==state & type==type1 & year==year1 )
  ###get zip code field 
  zip_num <- which(colnames(dataframe1)==zip_col)
  colnames(dataframe1)[zip_num] <- "zcta5"
  #zip_vec <- dataframe1[,zip_num]
  #zip_vec <- sort(unique(zip_vec))
  ###get surname field 
  surname_num <- which(colnames(dataframe1)==surname_field)
  colnames(dataframe1)[surname_num] <- "surname"
  surnames2010 <- wru::surnames2010
  tryCatch({
    dataframe1 <-wru::merge_surnames(dataframe1)
  },error=function(e){cat("ERROR :",conditionMessage(e), "\n")} )
  dataframe2 <- merge(dataframe1,all_zip_census2,BY="zcta5" )
  if(nrow(dataframe2)<nrow(dataframe1)){
    diff_frames <- nrow(dataframe1) - nrow(dataframe2)
    message_warn <- paste0("A total of ", sep="",diff_frames,sep=" ", " ZIP codes were not present in the master Census file.
                           Check to ensure that all ZIP codes in file are in state.")
    print(message_warn)
    dataframe2 <- merge(dataframe1,all_zip_census2,BY="zcta5",all.x=T )
    
  }
    ###now getting the pred fields 
    for (k in 1:length(eth)) {
      dataframe2[paste("u", eth[k], sep = "_")] <- dataframe2[paste("p", 
                                                                    eth[k], sep = "_")] * dataframe2[paste("r", eth[k], 
                                                                                                           sep = "_")]}
    dataframe2$u_tot <- apply(dataframe2[paste("u", eth, 
                                               sep = "_")], 1, sum, na.rm = T)
    for (k in 1:length(eth)) {
      dataframe2[paste("q", eth[k], sep = "_")] <- dataframe2[paste("u", 
                                                                    eth[k], sep = "_")]/dataframe2$u_tot
    }
    for (k in 1:length(eth)) {
      dataframe2[paste("pred", eth[k], sep = ".")] <- dataframe2[paste("q", 
                                                                       eth[k], sep = "_")]
    }
    start_col <- ncol(dataframe2)-5
    final_dataframe <- dataframe2[,c(1:ncol(dataframe1),start_col:ncol(dataframe2) )]

  return(final_dataframe)
}
