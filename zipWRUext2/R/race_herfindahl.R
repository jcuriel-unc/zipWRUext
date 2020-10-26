#' Race Confidence Scorer
#' 
#' This function takes the predicted race scores, finds the plurality race, then finds the degree of confidence that the user can have in race via 
#' the herfindahl index. 
#' 
#' @param dataframe1 The data frame with the predicted race fields 
#' @return A dataframe with the herfindahl scores to measure certainty of individual estimate, highest race estimate, and plurality race.  
#' }
#' 
#' @export
#' @examples 
#' wi_data <- zipWRUext2::wi_data
#' wi_data2 <- zip_wru(wi_data, state="WISCONSIN", type1="census", year1="2010", zip_col="zcta5", surname_field = "lastname")
#' wi_data2 <- race_herfindahl_scores(wi_data2)
#' head(wi_data4[,26:28])
#'   herf_weight max_race_prob plural_race
#'1   0.9898037     0.9948803       white
#'2   0.9407473     0.9696928       white
#'3   0.9858093     0.9928664       white
#'4   0.9471131     0.9730675       white
#'5   0.8995676     0.9480736       white
#'6   0.9725417     0.9861357       white
#' 

race_herfindahl_scores <- function(dataframe1){
  if(any(colnames(dataframe1)=="pred.whi")==FALSE){
    stop("Predicted race variable not present.")
  }
  predNames <- c("pred.whi","pred.bla","pred.his","pred.asi","pred.oth")
  #pred_col_nums <- which(colnames(dataframe1)==predNames)
  #dataframe1$herf_weight <- (dataframe1[,predNames[1] ]^2)+(dataframe1[,predNames[2] ]^2)+(dataframe1[,predNames[3] ]^2)+
  #  (dataframe1[,predNames[4] ]^2) +(dataframe1[,predNames[5] ]^2)
  dataframe1$herf_weight <- (dataframe1$pred.whi)^2 + (dataframe1$pred.bla)^2 + (dataframe1$pred.his)^2 + (dataframe1$pred.asi)^2 +
    (dataframe1$pred.oth)^2
   ##### now onto get plurality race 
  dataframe_sub <- subset(dataframe1, select=c(pred.whi,pred.bla,pred.his,pred.asi,pred.oth))
  prob_matrix <- as.matrix(dataframe_sub)
  prob_matrix2 <- apply(prob_matrix,1,max)
  dataframe1 <- cbind(dataframe1,prob_matrix2)
  colnames(dataframe1)[colnames(dataframe1)=="prob_matrix2"] <- "max_race_prob"
  ###assign race 
  dataframe1$plural_race[dataframe1$pred.whi==dataframe1$max_race_prob] <- "white"
  dataframe1$plural_race[dataframe1$pred.bla==dataframe1$max_race_prob] <- "black"
  dataframe1$plural_race[dataframe1$pred.his==dataframe1$max_race_prob] <- "hispanic"
  dataframe1$plural_race[dataframe1$pred.asi==dataframe1$max_race_prob] <- "asian"
  dataframe1$plural_race[dataframe1$pred.oth==dataframe1$max_race_prob] <- "other"
  return(dataframe1)
}
