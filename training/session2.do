**************************************************************
* SESSION 2: STATA FILES AND HELP
**************************************************************

****** STATA FILE TYPES (dta, do and ado)
***dta
*The dta file contains your data in Stata readable format.
 
***do
*The do-file contains the Stata commands that you wish to execute. 

***ado
*An ado-file is a text file that contains a Stata program. You can find a user written program using findit command.

***gph
* This is a graph file

***log or smcl



***Notes
*You "use" dta files but you "import" other files

*You "save" dta files but you "export" other files
* You "do" (execute) do and ado files


****** LOADING DATA TO STATA 
*use for Stata files in your computer
*sysuse for Stata files installed with your Stata program
* webuse for Stata files from the Stata website







****** ENTERING DATA TO STATA 
*Manually: typing in the data editor



****** IMPORTING DATA TO STATA 
*Importing data from csv file (Comma Separated values)
import delimited "dhs.csv", clear
save dhs.dta

*Importing data from xlsx file (New Excel)
 import excel "dhs.xlsx", sheet("Sheet1") firstrow clear

*Importing data from xls file (Old Excel)
 import excel "dhs.xls", sheet("Sheet1") firstrow clear

*You can also import data from SPSS and from SAS. See the File Menu (File >>> Import >>>)


****** EXPORTING DATA TO OTHER PROGRAMS
*Manually: copy and paste


*Exporting to csv
use dhs, clear
export delimited using "dhs.csv", replace


*Exporting to xlsx
use dhs, clear
export excel using "dhs.xlsx", sheetreplace firstrow(variables)


*You can also import data to SPSS. See the File Menu (File >>> Export >>>)




****** HELP AND SEARCH
*use the help command when you know the specific commands
*help import

*use the search command to perform general searches
*search import


****** STATA PDF DOCUMENTATION
*Menu: Help > PDF documentation


****** ONLINE HELP AND RESOURCES
*Menu: Help > Resources
*Online: https:*stats.idre.ucla.edu/stata/




******ASSIGNMENT 1
***Write a command to load the following files, save them as a Stata file, and export them as a csv file
* 1. dhs1_wide_dem.xlsx 
* 2. dhs1_wide_hb.xlsx 
* 3. dhs2_wide_dem.xlsx
* 4. dhs2_wide_hb.xlsx





