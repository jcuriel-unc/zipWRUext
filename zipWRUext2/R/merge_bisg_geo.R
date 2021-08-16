#' Merge geographic tabular data command
#' 
#' This function merges on user provided demographic data with geographic codes, and is incorporated into the predict_race_any cmd
#' 
#' @param df The data frame for the voter file. 
#' @param geo_df The demographic data with census/other geographic identifiers, and r_eth fields that all sum to 1 by column 
#' (i.e. the proportion of a given race that lives in the geographic unit relative to the rest of the state.)   
#' @param vec_merge The vector with the character fields necessary to merge. Should be identical in both 
#' @return A dataframe with the merged voterfile and geographic demographic data necessary to run BISG via predict_race_any 
#' }
#' 
#' @export
#' @examples 
#' ga_data <-  zipWRUext2::ga_sample_vf
#' ga_block_sample <- zipWRUext2::ga_sample_blocks
#' ga_data2 <- zip_wru(ga_data, ga_block_sample,  c("county","tract","block"))
#' 

merge_bisg_geo <- function(df, geo_df, vec_merge){
  eth <- c("whi", "bla", "his", "asi", "oth")
  if("r_whi" %in% colnames(geo_df) & "r_bla" %in% colnames(geo_df) & "r_his" %in% colnames(geo_df) &
     "r_asi" %in% colnames(geo_df) & "r_oth" %in% colnames(geo_df)){
    print("All r_eth fields present.")
  }else{
    stop("All of the r_eth fields not present")
  }
  test_sum <- apply(geo_df[paste("r", eth,sep = "_")], 2, sum, na.rm = T)
  test_sum2 <- sum(test_sum)
  if(test_sum2 != 5){
    warning("The r_eth fields do not colsum to 1; recalculate fields (or subset by state) to fix; ignore if using internal test data.")
  }
  df <- merge(df, geo_df, vec_merge, all.x=TRUE)
  missing_geogs <- sum(is.na(df$pred.whi))
  print(paste0("A total of",sep=" ", missing_geogs,sep=" ", "observations saw a failed geographic merge."))
  return(df)
  
}
