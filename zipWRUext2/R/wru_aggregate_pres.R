#' Aggregate weighted racial estimates and preserve total
#' 
#' This function aggregates by the user specified grouping varaible for the weighted probabilities of the racial categories, while also 
#' ensuring that the rounded estimates adhere to the total number. 
#' 
#' @param df The data frame for the voter file. 
#' @param geo_df The grouping variable to collapse by; have in quotes to be read in as a string.    
#' @param predNames The predicted prob columns that the bisg predict commands estimated. Defaults to pred.eth, e.g. pred.whi  
#' @return A dataframe gropued by the user specified variable with whole numbers for a given racial category 
#' }
#' 
#' @export
#' @examples 
#' wi_data <- zipWRUext2::wi_data
#' wi_data4 <- zip_wru(wi_data, state="WISCONSIN",  year1="2010", zip_col="zcta5", surname_field = "lastname")
#' wi_data4col <- wru_aggregate_pres(wi_data4, group_var = "zcta5")
#' head(wi_data4col)
#' A tibble: 6 x 7
#' zcta5 pred.asi pred.bla pred.his pred.oth pred.whi total_pop
#' <chr>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>     <dbl>
#'  1 53001        0        0        0        0        1         1
#' 2 53004        0        0        0        0        1         1
#' 3 53005        0        0        0        0        3         3
#' 4 53006        0        0        0        0        1         1
#' 5 53007        0        0        0        0        1         1
#' 6 53011        0        0        0        0        1         1
#' 

wru_aggregate_pres <- function(df, group_var="zcta5", predNames=c("pred.whi","pred.bla","pred.his","pred.asi","pred.oth")){
  list.of.packages <- c("tidyverse")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  library(tidyverse)
  ## collapse the data by the groupvar 
  colnames(df)[colnames(df)==group_var] <- "group_n"
  df_col <- df %>% 
    group_by(group_n) %>% 
    select(all_of(predNames)) %>%
    summarise(across(where(is.numeric), ~sum(.x, na.rm=T)))
  ### now gather (i.e. make long) the data frame 
  df_long <- gather(df_col, race, total, -group_n)
  ### now run the preserve whol number command 
  df_long$total_new <- round_preserve_sum(df_long$total, 0)
  ## select out the old num 
  df_long <- subset(df_long, select=-c(total))
  ## now make into wide data again 
  df_wide <- spread(df_long, key=race, value=total_new)
  colnames(df_wide)[colnames(df)=="group_n"] <- group_var
  ## now total 
  df_wide$total_pop <- rowSums(df_wide[,2:6])
  return(df_wide)
}

