#' Command to merge surname dictionary from wru onto data 
#' 
#' This function is grandfathered in from a previous version of	Kabir Khanna and Kosuke Imai's wru package from 2021; necessary to 
#' operate the predict_race_any and zip_wru commands.
#' 
#' @param voter.file The data frame for the voter file. 
#' @param surname.year The year for the surname dictionary; takes form of 2000 or 2010; defaults to 2010 
#' @param clean.surname Triggers script to clean the surname field
#' @param impute.missing Tells script to impute missing surnames
#' @return A dataframe with pred.eth values of the predicted probability for a given race. These rowsum to 1. 
#' }
#' 
#' @export
#' @examples 
#' surname <- c("RUSSELL", "JONES", "SMITH", "ALLEN")
#' y <- c("31302", "30339", "30040", "30030")
#' df <- data.frame(surname,y)
#' merge_surnames(df)
#'   surname     y surname.match  p_whi  p_bla  p_his  p_asi  p_oth
#' 3 RUSSELL 31302       RUSSELL 0.7705 0.1669 0.0246 0.0057 0.0323
#' 2   JONES 30339         JONES 0.5519 0.3848 0.0229 0.0044 0.0361
#' 4   SMITH 30040         SMITH 0.7090 0.2311 0.0240 0.0050 0.0308
#' 1   ALLEN 30030         ALLEN 0.6759 0.2617 0.0247 0.0054 0.0324
#' 
#' 

merge_surnames <- function (voter.file, surname.year = 2010, clean.surname = T, 
                            impute.missing = T) 
{
  if ("surname" %in% names(voter.file) == F) {
    stop("Data does not contain surname field.")
  }
  if (surname.year == 2000) {
    surnames2000$surname <- as.character(surnames2000$surname)
    surnames <- surnames2000
  }
  else {
    surnames2010$surname <- as.character(surnames2010$surname)
    surnames <- surnames2010
  }
  p_eth <- c("p_whi", "p_bla", "p_his", "p_asi", "p_oth")
  df <- voter.file
  df$caseid <- 1:nrow(df)
  df$surname.match <- df$surname.upper <- toupper(as.character(df$surname))
  df <- merge(df[names(df) %in% p_eth == F], surnames[c("surname", 
                                                        p_eth)], by.x = "surname.match", by.y = "surname", all.x = TRUE)
  if (nrow(df[df$surname.upper %in% surnames$surname == F, 
              ]) == 0) {
    return(df[order(df$caseid), c(names(voter.file), "surname.match", 
                                  p_eth)])
  }
  df[df$surname.upper %in% surnames$surname == F, ]$surname.match <- ""
  df1 <- df[df$surname.upper %in% surnames$surname, ]
  df2 <- df[df$surname.upper %in% surnames$surname == F, ]
  if (clean.surname) {
    df2$surname.match <- gsub("[^[:alnum:] ]", "", df2$surname.upper)
    df2 <- merge(df2[names(df2) %in% p_eth == F], surnames[c("surname", 
                                                             p_eth)], by.x = "surname.match", by.y = "surname", 
                 all.x = TRUE)
    if (nrow(df2[df2$surname.match %in% surnames$surname, 
                 ]) > 0) {
      df1 <- rbind(df1, df2[df2$surname.match %in% surnames$surname, 
                            ])
      df2 <- df2[df2$surname.match %in% surnames$surname == 
                   F, ]
      if (nrow(df2[df2$surname.match %in% surnames$surname, 
                   ]) > 0) {
        df2$surname.match <- ""
      }
    }
    df2$surname.match <- gsub(" ", "", df2$surname.match)
    df2 <- merge(df2[names(df2) %in% p_eth == F], surnames[c("surname", 
                                                             p_eth)], by.x = "surname.match", by.y = "surname", 
                 all.x = TRUE)
    if (nrow(df2[df2$surname.match %in% surnames$surname, 
                 ]) > 0) {
      df1 <- rbind(df1, df2[df2$surname.match %in% surnames$surname, 
                            ])
      df2 <- df2[df2$surname.match %in% surnames$surname == 
                   F, ]
      if (nrow(df2[df2$surname.match %in% surnames$surname, 
                   ]) > 0) {
        df2$surname.match <- ""
      }
    }
    suffix <- c("JUNIOR", "SENIOR", "THIRD", "III", "JR", 
                " II", " J R", " S R", " IV")
    for (i in 1:length(suffix)) {
      df2$surname.match <- ifelse(substr(df2$surname.match, 
                                         nchar(df2$surname.match) - (nchar(suffix)[i] - 
                                                                       1), nchar(df2$surname.match)) == suffix[i], 
                                  substr(df2$surname.match, 1, nchar(df2$surname.match) - 
                                           nchar(suffix)[i]), df2$surname.match)
    }
    df2$surname.match <- ifelse(nchar(df2$surname.match) >= 
                                  7, ifelse(substr(df2$surname.match, nchar(df2$surname.match) - 
                                                     1, nchar(df2$surname.match)) == "SR", substr(df2$surname.match, 
                                                                                                  1, nchar(df2$surname.match) - 2), df2$surname.match), 
                                df2$surname.match)
    df2 <- merge(df2[names(df2) %in% p_eth == F], surnames[c("surname", 
                                                             p_eth)], by.x = "surname.match", by.y = "surname", 
                 all.x = TRUE)
    if (nrow(df2[df2$surname.match %in% surnames$surname, 
                 ]) > 0) {
      df1 <- rbind(df1, df2[df2$surname.match %in% surnames$surname, 
                            ])
      df2 <- df2[df2$surname.match %in% surnames$surname == 
                   F, ]
      if (nrow(df2[df2$surname.match %in% surnames$surname, 
                   ]) > 0) {
        df2$surname.match <- ""
      }
    }
    df2$surname2 <- df2$surname1 <- NA
    df2$surname1[grep("-", df2$surname.upper)] <- sapply(strsplit(grep("-", 
                                                                       df2$surname.upper, value = T), "-"), "[", 1)
    df2$surname2[grep("-", df2$surname.upper)] <- sapply(strsplit(grep("-", 
                                                                       df2$surname.upper, value = T), "-"), "[", 2)
    df2$surname1[grep(" ", df2$surname.upper)] <- sapply(strsplit(grep(" ", 
                                                                       df2$surname.upper, value = T), " "), "[", 1)
    df2$surname2[grep(" ", df2$surname.upper)] <- sapply(strsplit(grep(" ", 
                                                                       df2$surname.upper, value = T), " "), "[", 2)
    df2$surname.match <- as.character(df2$surname1)
    df2 <- merge(df2[names(df2) %in% c(p_eth) == F], surnames[c("surname", 
                                                                p_eth)], by.x = "surname.match", by.y = "surname", 
                 all.x = TRUE)[names(df2)]
    if (nrow(df2[df2$surname.match %in% surnames$surname, 
                 ]) > 0) {
      df1 <- rbind(df1, df2[df2$surname.match %in% surnames$surname, 
                            names(df2) %in% names(df1)])
      df2 <- df2[df2$surname.match %in% surnames$surname == 
                   F, ]
      if (nrow(df2[df2$surname.match %in% surnames$surname, 
                   ]) > 0) {
        df2$surname.match <- ""
      }
    }
    df2$surname.match <- as.character(df2$surname2)
    df2 <- merge(df2[names(df2) %in% c(p_eth, "surname1", 
                                       "surname2") == F], surnames[c("surname", p_eth)], 
                 by.x = "surname.match", by.y = "surname", all.x = TRUE)[names(df2) %in% 
                                                                           c("surname1", "surname2") == F]
    if (nrow(df2[df2$surname.match %in% surnames$surname, 
                 ]) > 0) {
      df1 <- rbind(df1, df2[df2$surname.match %in% surnames$surname, 
                            names(df2) %in% names(df1)])
      df2 <- df2[df2$surname.match %in% surnames$surname == 
                   F, ]
      if (nrow(df2[df2$surname.match %in% surnames$surname, 
                   ]) > 0) {
        df2$surname.match <- ""
      }
    }
  }
  if (impute.missing) {
    if (nrow(df2) > 0) {
      df2$surname.match <- ""
      df2$p_whi <- 0.6665
      df2$p_bla <- 0.0853
      df2$p_his <- 0.1367
      df2$p_asi <- 0.0797
      df2$p_oth <- 0.0318
      warning(paste("Probabilities were imputed for", nrow(df2), 
                    ifelse(nrow(df2) == 1, "surname", "surnames"), 
                    "that could not be matched to Census list."))
    }
  }
  else warning(paste(nrow(df2), ifelse(nrow(df2) == 1, "surname was", 
                                       "surnames were"), "not matched."))
  df <- rbind(df1, df2)
  return(df[order(df$caseid), c(names(voter.file), "surname.match", 
                                p_eth)])
}
