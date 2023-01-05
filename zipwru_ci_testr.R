### Confidence interval tester script ###
library(foreign)
library(wru)
devtools::install_github("https://github.com/jcuriel-unc/zipWRUext", subdir="zipWRUext2")

library(zipWRUext2)
library(stringi)
library(stringr)
library(tidyverse)
library(gtools)
options(stringsAsFactors = FALSE)

######################################
### set working directory 
main_wd <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(main_wd)
##### follow the tutorial script for now 
wi_data <- zipWRUext2::wi_data
wi_data4 <- zip_wru(wi_data, state="WISCONSIN",  year1="2010", zip_col="zcta5", surname_field = "lastname")
wi_data4col <- wru_aggregate_pres(wi_data4, group_var = "zcta5")

### now get the cis ready; try the rdirichlet? 
wi_data4col <- wi_data4 %>% group_by(zcta5) %>% 
  summarise(across(where(is.numeric), ~sum(.x, na.rm = T)))
## with the above, we should be able to dirichlet 
total_pop_vec <- rowSums(wi_data4col[,2:6])
##make into a matrix 
total_pop_mat <- as.matrix(nrow=1560,ncol=3,cbind(rep(total_pop_vec,5),rep(total_pop_vec,5),rep(total_pop_vec,5)))
dim(total_pop_mat)
View(total_pop_mat)

test_vec1 <- as.vector( as.matrix(wi_data4col[,2:6]))
test_vec1

### new attempt with rmultinom fxn 
wi_data4col$total_pop <- rowSums(wi_data4col[,2:6])
wi_data4col$total_pop <- rowSums(wi_data4col[predNames])
wi_data4col$sample_size = 1000
### now, try to get df dist 
prob_vec = as.matrix(wi_data4col[,2:6])
test_rmnom <- rmultinom(1000,size=wi_data4col$total_pop ,prob=prob_vec)
dim(test_rmnom) # 1560 1000; means that the cols reflect the random draw; means that the colsums should sum to pop of 
# the zipcode 
agg_check <- colSums(test_rmnom)
head(agg_check)
head(wi_data4col$total_pop)
summary(agg_check)
## not working; might have to try apply 
temp_vec<-match(predNames,names(wi_data4col))

normalize <- apply(wi_data4col, 1, function(x) rmultinom(x[8], x[7], x[temp_vec]))
dim(normalize) # 5000  312; num of zip codes preserved; means that the cols are zip codes; should colsum to pop 
head(normalize[,1:10])
head(wi_data4col)
## ok, the way that this works is that the the rows are repeats of pred.whi, pred.bla, pred.his, pred.asi, and pred.oth. 
# the columns reflect the zip code. I will need to first slice by every nth row to get sep by race 
df.whi <-  normalize[seq(1, nrow(normalize), 5), ]
dim(df.whi) # this gives me 1000 rows (1 for every sim) and 312 cols, one for each zip code ; I think I am getting somewhere
df.bla <- normalize[seq(2, nrow(normalize), 5), ]
df.his <- normalize[seq(3, nrow(normalize), 5), ]
df.asi <- normalize[seq(4, nrow(normalize), 5), ]
df.oth <- normalize[seq(5, nrow(normalize), 5), ]
### now get the cis 
test_whi_ci <- apply(df.whi, 2, quantile, probs=c(0.025,0.5,0.975))
test_whi_ci <- t(test_whi_ci) #good, seems to have worked 
## bla 
test_bla_ci <- apply(df.bla, 2, quantile, probs=c(0.025,0.5,0.975))
test_bla_ci <- t(test_bla_ci) #good, seems to have worked 
#his
test_his_ci <- apply(df.his, 2, quantile, probs=c(0.025,0.5,0.975))
test_his_ci <- t(test_his_ci) #good, seems to have worked 
#asi
test_asi_ci <- apply(df.asi, 2, quantile, probs=c(0.025,0.5,0.975))
test_asi_ci <- t(test_asi_ci) #good, seems to have worked 
# oth 
test_oth_ci <- apply(df.oth, 2, quantile, probs=c(0.025,0.5,0.975))
test_oth_ci <- t(test_oth_ci) #good, seems to have worked 

### now, I want to bind these as part of a df 
test_whi_ci <- as.data.frame(test_whi_ci)
colnames(test_whi_ci) <- paste0("pred.whi",sep="_",colnames(test_whi_ci)) # good, this worked; now repeat 
colnames(test_bla_ci) <- paste0("pred.bla",sep="_",colnames(test_bla_ci))
colnames(test_his_ci) <- paste0("pred.his",sep="_",colnames(test_his_ci))
colnames(test_asi_ci) <- paste0("pred.asi",sep="_",colnames(test_asi_ci))
colnames(test_oth_ci) <- paste0("pred.oth",sep="_",colnames(test_oth_ci))
### now I should be ready to merge these 
wi_data4col <- cbind(wi_data4col,test_whi_ci,test_bla_ci,test_his_ci,test_asi_ci,test_oth_ci)

## now that the basics are done, let's create a fxn 
wru_cis <- function(df,group_var="zcta5",predNames = c("pred.whi", 
                                                       "pred.bla", "pred.his", "pred.asi", "pred.oth"),
                    ci_vec=c(0.025,0.5,0.975)){
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
  df.whi <-  normalize[seq(1, nrow(normalize), 5), ]
  df.bla <- normalize[seq(2, nrow(normalize), 5), ]
  df.his <- normalize[seq(3, nrow(normalize), 5), ]
  df.asi <- normalize[seq(4, nrow(normalize), 5), ]
  df.oth <- normalize[seq(5, nrow(normalize), 5), ]
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
  ### return the df 
  return(df_col)

}

wi_data4_cis <- wru_cis(wi_data4, group_var = "zcta5")


##################### ARCHIVE ##############################
#If I get the quantile by column, I should then have the dist for a given race and such per zcta 
test_app_ci <- apply(normalize, 1, quantile, probs=c(0.025,0.5,0.975))
test_app_ci <- t(test_app_ci)
dim(test_app_ci) # 312 rows, 3 cols; not good, as no longer are races present 

agg_check <- rowSums(normalize)
head(agg_check)



### size is equal to the number of rolls; will need to equal the pop of a given area 

test_rmnom <- rmultinom(1000,size=5 ,prob=wi_data4col[1,2:6])
class(test_rmnom)

test_rdir <- rdirichlet(1000, test_vec1) ## produces a 1000 by 1560 df 
### findd length of widata collpased 
nrow(wi_data4col) # 312 columns; 
1560/312 # 5 
## so, the 5 obs per race are combined together to create the df 
### do apply to get ci 
test_app_ci <- apply(test_rdir, 2, quantile, probs=c(0.025,0.5,0.975))
test_app_ci <- t(test_app_ci) ## at this stage, we would need to get the total pop multiplied 
### matrix multip
test_app_ci <- test_app_ci * (total_pop_mat)

## create a new df 
test_app_ci2 <- cbind.data.frame(test_app_ci, race=rep(c("pred.whi","pred.bla","pred.his","pred.asi","pred.oth"),312), 
                                 zcta5=rep(wi_data4col$zcta5,5))
colnames(test_app_ci2)[1:3] <- c("ci_low","ci_med","ci_up")

### first make into long 
test_app_ci2_long <- gather(test_app_ci2, ci, value, ci_low:ci_up )

### now we want to make wide 
#?spread
#library(reshape2)
test_wide_ci <- spread(test_app_ci2_long, key=ci, value = value)

##lets mutate to check the vals by zcta 
test_wide_ci <- test_wide_ci %>%
  group_by(zcta5) %>%
  mutate(zcta_pop=sum(ci_med))
summary(test_wide_ci$zcta_pop)

### let's go with this; now, get the preserve sum 
test_wide_ci$new_low_ci <- round_preserve_sum(test_wide_ci$ci_low, 2)
test_wide_ci$new_med_ci <- round_preserve_sum(test_wide_ci$ci_med, 2)
test_wide_ci$new_up_ci <- round_preserve_sum(test_wide_ci$ci_up, 2)
## sort 
test_wide_ci <- test_wide_ci[order(test_wide_ci$zcta5), ]


## second try 
test_wide_ci2 <- spread(test_wide_ci, ci, value)

View(test_wide_ci)
stocks <- data.frame(
  time = as.Date('2009-01-01') + 0:9,
  X = rnorm(10, 0, 1),
  Y = rnorm(10, 0, 2),
  Z = rnorm(10, 0, 4)
)
stocksm <- stocks %>% gather(stock, price, -time)
stocksm %>% spread(stock, price)

df <- data.frame(month=rep(1:3,2),
                 student=rep(c("Amy", "Bob"), each=3),
                 A=c(9, 7, 6, 8, 6, 9),
                 B=c(6, 7, 8, 5, 6, 7))
df2 <- df %>% 
  gather(variable, value, -(month:student)) 

df3 <-df2 %>%
  unite(temp, student, variable) 

df4 <- df3 %>%
  spread(temp, value)
