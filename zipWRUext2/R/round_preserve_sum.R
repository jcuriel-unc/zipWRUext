#' Round data while preserving the total
#' 
#' This function rounds numbers in a vector to the specified num of digits, while ensuring it remains equal to total.  
#' 
#' @param x The vector of the number to be rounded. 
#' @param digits The number of digits to round to.   
#' @return A vector that rounds numbers while preserving the total. 
#' }
#' 
#' @export
#' @examples 
#' ga_data <-  zipWRUext2::ga_sample_vf
#' ga_block_sample <- zipWRUext2::ga_sample_blocks
#' ga_data2 <- predict_race_any(ga_data, ga_block_sample,  c("county","tract","block"))
#' 

round_preserve_sum <- function(x, digits = 0) {
  up <- 10 ^ digits
  x <- x * up
  y <- floor(x)
  indices <- tail(order(x-y), round(sum(x)) - sum(y))
  y[indices] <- y[indices] + 1
  y2 <- y / up
  return(y2)
}
