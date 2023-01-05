#' BISG confidence intervals
#' 
#' This function takes the BISG dataframe output and computes confidence intervals for a given grouped level of geography 
#' 
#' @param df The data frame outputted by zip_wru or a related BISG command  
#' @param group_var The geographic grouping variable that will be aggregated to; string input and defaults to zcta5
#' @param predNames The vector of pred. names that reflect the BISG race estimates. Defaults to "pred.whi", pred.bla, etc. 
#' @param ci_vec The vector of probabilities that will be used to create the confidence intervals. Defaults to the 95% CI range
#' @return A dataframe with the pred.race + confidence intervals %s in the aggregated format. 
#' }
#' 
#' @export
#' @examples 
#' wi_data <-  zipWRUext2::wi_data
#' wi_data2 <- zip_wru(wi_data, state="WISCONSIN",  year1="2010", zip_col="zcta5", surname_field = "lastname")
#' wi_data2_cis <- wru_cis(wi_data2, group_var = "zcta5")
#' 


wru_cis <- function(df,group_var="zcta5",predNames = c("pred.whi", 
                                                       "pred.bla", "pred.his", "pred.asi", "pred.oth"),
                    ci_vec=c(0.025,0.5,0.975)){
  list.of.packages <- c("tidyverse")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  library(tidyverse)
  colnames(df)[colnames(df) == group_var] <- "group_n"
  ## collapse the data by the grouping var and sum for the pred name vec
  df_col <- df %>% group_by(group_n) %>% select(all_of(predNames)) %>% 
    summarise(across(where(is.numeric), ~sum(.x, na.rm = T)))
  ## get the total pop 
  df_col$total_pop <- rowSums(df_col[predNames]) # get total pop of area 
  df_col$sample_size = 1000 ## draw 1000 time 
  ## get position of columns 
  pop_col <- match("total_pop",names(df_col))
  samp_size_col = match("sample_size", names(df_col))
  pred_name_cols <- match(predNames, names(df_col))
  ## now get the random sample 
  output_rmnom <- apply(df_col, 1, function(x) rmultinom(x[samp_size_col], x[pop_col], x[pred_name_cols]))
  ### now slice by race 
  df.whi <-  output_rmnom[seq(1, nrow(output_rmnom), 5), ]
  df.bla <- output_rmnom[seq(2, nrow(output_rmnom), 5), ]
  df.his <- output_rmnom[seq(3, nrow(output_rmnom), 5), ]
  df.asi <- output_rmnom[seq(4, nrow(output_rmnom), 5), ]
  df.oth <- output_rmnom[seq(5, nrow(output_rmnom), 5), ]
  ### now, get the confidence intervals 
  test_whi_ci <- apply(df.whi, 2, quantile, probs=ci_vec)
  test_whi_ci <- t(test_whi_ci) #good, seems to have worked 
  ## bla 
  test_bla_ci <- apply(df.bla, 2, quantile, probs=ci_vec)
  test_bla_ci <- t(test_bla_ci) #good, seems to have worked 
  #his
  test_his_ci <- apply(df.his, 2, quantile, probs=ci_vec)
  test_his_ci <- t(test_his_ci) #good, seems to have worked 
  #asi
  test_asi_ci <- apply(df.asi, 2, quantile, probs=ci_vec)
  test_asi_ci <- t(test_asi_ci) #good, seems to have worked 
  # oth 
  test_oth_ci <- apply(df.oth, 2, quantile, probs=ci_vec)
  test_oth_ci <- t(test_oth_ci) #good, seems to have worked 
  ### rename the cols 
  colnames(test_whi_ci) <- paste0("pred.whi",sep="_",colnames(test_whi_ci)) # good, this worked; now repeat 
  colnames(test_bla_ci) <- paste0("pred.bla",sep="_",colnames(test_bla_ci))
  colnames(test_his_ci) <- paste0("pred.his",sep="_",colnames(test_his_ci))
  colnames(test_asi_ci) <- paste0("pred.asi",sep="_",colnames(test_asi_ci))
  colnames(test_oth_ci) <- paste0("pred.oth",sep="_",colnames(test_oth_ci))
  ### now I should be ready to merge these 
  df_col <- cbind(df_col,test_whi_ci,test_bla_ci,test_his_ci,test_asi_ci,test_oth_ci)
  colnames(df_col)[colnames(df_col)=="group_n"] <- group_var
  ### return the df 
  return(df_col)
}

