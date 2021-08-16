#' Predict race via BISG with user provided data
#' 
#' This function predicts race via BISG with user provided data, and makes use of the merge_bisg_geo command to do so. 
#' 
#' @param df The data frame for the voter file. 
#' @param geo_df The demographic data with census/other geographic identifiers, and r_eth fields that all sum to 1 by column 
#' (i.e. the proportion of a given race that lives in the geographic unit relative to the rest of the state.)   
#' @param vec_merge The vector with the character fields necessary to merge. Should be identical in both 
#' @return A dataframe with pred.eth values of the predicted probability for a given race. These rowsum to 1. 
#' }
#' 
#' @export
#' @examples 
#' ga_data <-  zipWRUext2::ga_sample_vf
#' ga_block_sample <- zipWRUext2::ga_sample_blocks
#' ga_data2 <- predict_race_any(ga_data, ga_block_sample,  c("county","tract","block"))
#' 

predict_race_any <- function(df, geo_df, vec_merge){
  list.of.packages <- c("wru","gtools")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  library(wru)
  orig_column_length <- ncol(df)
  eth <- c("whi", "bla", "his", "asi", "oth")
  df <- merge_surnames(df)
  ## run the merge geog command 
  df2 <- merge_bisg_geo(df, geo_df, vec_merge)
  
  ## now run the BISG multiplications 
  for (k in 1:length(eth)) {
    df2[paste("u", eth[k], sep = "_")] <- df2[paste("p",eth[k], sep = "_")] * df2[paste("r", eth[k],sep = "_")]
  }
  #sum the cols with the prexix "u", the product of surname probs * geog props 
  df2$u_tot <- apply(df2[paste("u", eth, 
                               sep = "_")], 1, sum, na.rm = T)
  #get the u_eth divided by the sum of all u_eths ; exactly equal to pred; might as well take out 
  for (k in 1:length(eth)) {
    df2[paste("pred", eth[k], sep = "_")] <- df2[paste("u",eth[k], sep = "_")]/df2$u_tot
  }
  
  pred <- paste("pred", eth, sep = ".")
  start_col <- ncol(df2) - 4
  end_col <- ncol(df2)
  df2 <- df2[,c(1:orig_column_length,start_col:end_col)]
  return(df2)
}

