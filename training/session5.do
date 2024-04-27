////////////////////////////////////////////////////////////////
// SESSION 5: STATA LANGUAGE
////////////////////////////////////////////////////////////////
// [prefix]: command [varlist] [=exp] [=if exp] [in range] [weight] [,options]

webuse lbw, clear
**command
//command denotes a Stata command. This is required. The rest are usually optional.
summarize 

**varlist
//varlist refers to a list of variable names
summarize low bwt

// _all refers to all the variables. It is the same as not specifying a variable
summarize _all
summarize




**exp
// =exp refers to an algebraic expression. It specifies the value to be assigned to a variable
// It is most often used with generate and replace (more on this on session 5).

* generate a new variable called bwt2 with units in kg from bwt 
generate bwt2=bwt/1000
label variable bwt2 "birthweight (kilograms)"

*do same as above but use the original variable
replace bwt= bwt/1000
replace bwt= bwt*1000


// Generate a variable of missing values. Missing values mean two things 1. No value 2. Extermely large value
generate low2 = .




**if exp
// the condition if allows ==, !=, <, >, <= and >=
replace low2 = 0 if bwt2 > 2.5 & bwt2 < .
replace low2 = 1 if bwt2 < 2.5

label variable low2 "birthweight <2.5kg"

label define LOW 0 "No" 1 "Yes"label low2 LOW
tabulate low




**in range
//range specifies the observation range
list low in 1/20

**weight
//weight specifies the weighting expression
tabulate low
*tabulate anemia [aw=hv005/1000000]

*gen wgt = hv005/1000000
*label variable wgt "Household sample weight"
*tabulate anemia [aw=wgt]

** options
// options refer to a list of options.
tabulate low, nolabel
tabulate low, summarize(age)

**prefix
//by varlist: repeat a command for each subset of the varlist. 
//by sex: summarize hemoglobin

// The dataset must be sorted on the by variables I: either sort the data before using by prefix
webuse lbw, clear
sort smoke
by smoke: summarize bwt

//The dataset must be sorted on the by variables II: or use the bys instead
webuse lbw, clear
by smoke, sort: summarize bwt
bys smoke: summarize bwt


***ABBREVIATIONS OF STATA COMMANDS
webuse lbw, clear

//Stata allows abbreviations of commands and options
summarize bwt
summ bwt
sum bwt
su bwt

//In Stata help files, underlining denotes the shortest allowed abbreviation
//help summarize

//Stata allows abbreviations of variable names
//Variable names may be abbreviated to the  shortest string of characters that uniquely identifies them given the data currently loaded in memory.


// the symbol * is used to specify groups of variable 
//1. prefixes e.g. variables starting with hv
generate bwt2=bwt/1000
summarize bwt bwt2 
summarize b*

//2. prefixes e.g. variables ending with e
summarize ht lwt bwt
summarize *t

//3. within text e.g. variables containing 00
summarize bwt bwt2 lwt low
summarize *w*

