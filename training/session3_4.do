////////////////////////////////////////////////////////////////
webuse lbw, clear

***DESCRIBE DATA
*describe - Describe data in memory or in file
describe
describe bwt

*list - List values of variables
list
list bwt

list in 1/10
list bwt in 1/10

*codebook - Describe data contents
codebook
codebook bwt

codebook, compact
codebook bwt, compact


*summarize - Summary statistics
summarize
summarize bwt

summarize, detail
summarize bwt, detail


***VARIABLE RENAMING
*syntax: rename current_name new_name
rename lwt last_wt


***VARIABLE LABELS
*syntax: label variable var_name "Var Label"
label variable race "Race of respondent"
label variable wealth "Wealth Index"

*** LABEL VALUES
// This attaches a value label to a variable. This can help with your output. Consider a table of smoking status of respondents in the data.
tabulate low

** 1. You need to first define the label before using to label values
*label define valuelabel 1 "Label 1" 2 "Label 2" .....

** 2. Then label the variable with the label
*label values var_name valuelabel

//examples
label define yesno 0 "No" 1 "Yes"
label values low yesno


//see difference to the table of smoking status of respondents when labels are added to smoke 
tabulate low

//lab dir and lab book describe the labels
label dir
labelbook

//you can drop labels
label drop low 


*VARIABLE FORMATS
//Three forms of data in Stata: numbers, string (text) and date/time

*How to Format Numbers using Menu
/// 1. Select the type of number format: There are three types of number formats. 
//general numeric (g) is the default. It will give the least number of decimal places feasible e.g. 10000
//fixed numeric (f) is used to explicitly control the number of decimal places e.g. 10000.0
//scientific or exponential (e) notation is also possible: 1.00e+04

/// 2. Select the total digits (#)
/// 3. Enter the number of decimal places (#)
/// 4. Check whether to use commas or not (c). commas are not allowed with exponential format

*How to Format Numbers using Command
//Type format
//Type variable name(s)
//Type %
//Type the number of digits
//Type dot
//Type the number of decimals
//Type g, f or e
//Type (or don't type) c


*Format Dates using Menu (Advanced)
// 1. select total characters
// 2. customize

*Format Strings using Command
//Type format
//Type variable name(s)
//Type %
//Type the number of digits
//Type s


*Format Dates using Menu (Advanced)
// 1. select the type of date format
// 2. select from one of the samples or customize

*Format Dates using Command (Advanced)
//Type format
//Type variable name(s)
//Type %
//Type unit (d, m, y)

//The units are:
//d days from 01jan1960
//m calendar months from jan1960
//y years from 1960

gen mydate =  date(dates, "DMY")

clear

