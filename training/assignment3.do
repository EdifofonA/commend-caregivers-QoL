***Exercise 1
Import dhs1_wide_dem, dhs1_wide_hb, dhs2_wide_dem and dhs2_wide_hb and save as stata file
merge the dhs1 files and name it as dhs1_wide.dta
merge the dhs2 files and name it as dhs2_wide.dta
append dhs1_wide and dhs2_wide and save it as dhs_wide.dta
reshape  dhs_wide.dta to long format and save it as dhs.dta





**Solutions**

*Import
import excel "dhs1_wide_dem.xlsx", sheet("Sheet1") firstrow clear
save dhs1_wide_dem
import excel "dhs1_wide_hb.xlsx", sheet("Sheet1") firstrow clear
save dhs1_wide_hb
import excel "dhs2_wide_dem.xlsx", sheet("Sheet1") firstrow clear
save dhs2_wide_dem
import excel "dhs2_wide_hb.xlsx", sheet("Sheet1") firstrow clear
save dhs2_wide_hb

*Merge
use dhs1_wide_dem
merge 1:1 hv001 hv002 using dhs1_wide_hb
drop _merge
save dhs1_wide

use dhs2_wide_dem
merge 1:1 hv001 hv002 using dhs2_wide_hb
drop _merge
save dhs2_wide

use dhs1_wide, clear
destring, replace
save dhs1_wide,replace
use dhs2_wide
destring, replace
save dhs2_wide, replace

use dhs1_wide
append using dhs2_wide
save dhs_wide,replace









***Exercise 2
import act3a.csv data and save it with the same name as a stata file. import with the variable names in lowercase
convert category from string to values that are labelled
create value labels and use it to label values of the variable gender
generate a body mass index variable
generate a FVC/FEV1 variable
convert all dates to stata dates (you can do this before import or after import)
Generate the age of the respondent in stata from the date of birth and the date of collection
Label all variables appropriately

