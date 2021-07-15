# zipWRUext2
A ZIP code extension for the WRU R package

________________________________________________________________________________________________________________________________


NOTE: Efforts pending to host on CRAN. In meantime, please install with the devtools pkg, with the following command: 

devtools::install_github("https://github.com/jcuriel-unc/zipWRUext", subdir="zipWRUext2")

________________________________________________________________________________________________________________________________

This package acts as an extension to the WRU package by Imai and Khanna (2016) in performing Bayesian Inference with Surname and Geography (BISG). The package does this 
by drawing upon ZIP code Tabulation Area (ZCTA) tabulated demographics from the US 2010 Census and American Community Survey (ACS) from 2011 -- 2018. This information is stored 
in the package as an internal data frame for the package, ``zip_all_census2", which has the relevant populations and demographics for each ZIP code by state. Importantly, 
the r_whi, r_bla, r_his, r_asi, and r_oth contain the probabilities that a voter lives in a ZCTA if they are of a given race, i.e. pr(race | ZCTA). These in combination with the
surname2010 dictionary provided by wru can in turn be used to identify the joint probabilities that an individual is of a given race. 

The primary command to conduct this ZIP code level BISG is zip_wru(). All the user need do is provide the voterfile (dataframe1), state name in capital letters 
(i.e. ``WISCONSIN", ``NORTH CAROLINA", etc.), type of data (``census" or ``acs"), year of data (``2010" for census, ``2011" to ``2018" for ACS), name of the zip code 
column name within the data (i.e. ``zipcode"), and surname field (i.e. ``surname", ``lastname", ``last_name", etc.). 

Please ensure that the zip code field is character, padded, and no more than five digits long. Warnings will be added in future versions, but numeric ZIP codes 
are especially problematic for states with leading zeroes. Further, nine digit ZIP codes refer to points, not polygons, so these should be subsetted to the first five digits. 

Update 10/21/2020: The internal loop present within the old zip_wru function has been removed. The speed is now 16 times quicker, and out of state ZIP codes no longer cause the function to report an error. 

In order to test the data, please be sure to make  use of the wi_data, which is part of the package. 

Finally, an important substantive note: This package extension, much like the original WRU package, treats race as zero sum, and Hispanic as a race. Therefore, keep this in mind
in the event for substantive work. While there are good reasons why this might lead to complications, its the case that to correct this would require more than just an 
extension of WRU to correct, which is beyond the scope of this project as of now. 
