import excel "dhs1_wide_dem.xlsx", sheet("Sheet1") firstrow clear
save dhs1_wide_dem.dta, replace
use dhs1_wide_dem.dta, clear
export delimited using "dhs1_wide_dem.csv", replace

import excel "dhs1_wide_hb.xlsx", sheet("Sheet1") firstrow clear
save dhs1_wide_hb.dta, replace
use dhs1_wide_hb.dta, clear
export delimited using "dhs1_wide_hb.csv", replace

import excel "dhs2_wide_dem.xlsx", sheet("Sheet1") firstrow clear
save dhs2_wide_dem.dta, replace
use dhs2_wide_dem.dta, clear
export delimited using "dhs2_wide_dem.csv", replace

import excel "dhs2_wide_hb.xlsx", sheet("Sheet1") firstrow clear
save dhs2_wide_hb.dta, replace
use dhs2_wide_hb.dta, clear
export delimited using "dhs2_wide_hb.csv", replace


*** Lessons from this assignment ***
* Always use clear option when there is data in your Stata memory and you want to load another dataset
* Always use replace option when you want to save a Stata dataset and there is another Stata dataset with the same name in your folder





















