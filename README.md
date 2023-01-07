# zipWRUext2
A ZIP code extension for the WRU R package

________________________________________________________________________________________________________________________________


NOTE: Efforts pending to host on CRAN. In meantime, please install with the devtools pkg, with the following command: 

devtools::install_github("https://github.com/jcuriel-unc/zipWRUext", subdir="zipWRUext2")

________________________________________________________________________________________________________________________________

This package acts as an extension to the WRU package by Imai and Khanna (2016) in performing Bayesian Inference with Surname and Geography (BISG). The package does this 
by drawing upon ZIP code Tabulation Area (ZCTA) -- or other user provided data -- tabulated demographics from the US 2010 Census and American Community Survey (ACS) from 2011 -- 2021. This information is stored 
in the package as an internal data frame for the package, ``zip_all_census2", which has the relevant populations and demographics for each ZIP code by state. Importantly, 
the r_whi, r_bla, r_his, r_asi, and r_oth contain the probabilities that a voter lives in a ZCTA if they are of a given race, i.e. pr(race | ZCTA). These in combination with the
surname2010 dictionary provided by wru can in turn be used to identify the joint probabilities that an individual is of a given race. The following is a guide on how to use. 

## ZIP WRU -- Using ZIP Code Tabulation Areas (ZCTAs) to estimate race 


The primary command to conduct this ZIP code level BISG is zip_wru(). All the user need do is provide the voterfile or similar data frame with surname information and ZIP code residency. The user must provide dataframe (dataframe1), state name in capital letters (i.e. ``WISCONSIN", ``NORTH CAROLINA", etc.), type of data (``census" or ``acs"), year of data (``2010" for census, ``2011" to ``2021" for ACS), name of the zip code column name within the data (i.e. ``zipcode"), and surname field (i.e. ``surname", ``lastname", ``last_name", etc.). 

![wi_data in package](sample_voterfile.png)

The above figure presents data internal to the zipWRUext2 package. As a 900 X 3 dataframe, it contains the lastname and zipcode fields. These shall be used to provide the necessary information to conduct BISG. Running the command zip_wru, we see the following output. 


![zip_wru in practice](sample_zipwru_cmd.png)

The command takes the user inputted field and renames them to zcta5 and surname. The internal surname data dictionary imported from wru then matches names as part of the merge. Where the names do not match, an naive prior is used. The state name, type of data, and year then subsets the master ZCTA dataframe needed to estimate the racial category probabilities. These are seen in the fields "pred.whi", "pred.bla", "pred.his", "pred.asi", and "pred.oth", which reflect the categories of white, black, hispanic, asian/pacific islander and other, respectively. Note that these five columns all range from 0 -- 1, and sum to 1. These columns reflect the degree of certainty that an observation is of a given race. Where the surname and zip code are missing, an estimate shall not be produced. 

To ensure that the command runs correctly, please ensure that the zip code field is character, padded, and no more than five digits long. Leading zeroes can be added in R with the command, 

library(stringr)
df$zcta5 <- str_pad(df$zcta5, width=5, pad="0", side="left") 

Also note that nine digit ZIP codes refer to points, not polygons, so these should be subsetted to the first five digits.

## User created data frames 

Beyond ZIP codes and standard Census geographies, there might be others that the user would like to provide. These might consist of precincts, wards, districts, Census Block Groups (CBGs), etc. These can be implemented with some basic cleaning and the predict_race_any command. 

First, the user will need to have some type of geographic data with totals by the five racial categories of interest. All that the user will need to do 

## Version notes 

Update 10/21/2020: The internal loop present within the old zip_wru function has been removed. The speed is now 16 times quicker, and out of state ZIP codes no longer cause the function to report an error. 

In order to test the data, please be sure to make  use of the wi_data, which is part of the package. 

Finally, an important substantive note: This package extension, much like the original WRU package, treats race as zero sum, and Hispanic as a race. Therefore, keep this in mind
in the event for substantive work. While there are good reasons why this might lead to complications, its the case that to correct this would require more than just an 
extension of WRU to correct, which is beyond the scope of this project as of now. 
