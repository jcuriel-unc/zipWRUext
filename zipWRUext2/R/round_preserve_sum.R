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
