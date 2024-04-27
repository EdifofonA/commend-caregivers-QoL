////////////////////////////////////////////////////////////////
// SESSION 6 & 7: DATA MANAGEMENT II
////////////////////////////////////////////////////////////////

*** COMBINING DATASETS
* Merge datasets
help merge
use merge1
merge 1:1 id using merge2
drop _merge

*Append datasets
use append1
append using append2

*** CHANGING DATA I: STRUCTURE
* sorting data by variable (sort)
// sort has already been discussed 
*to sort our data by sex
sort sex

* convert data between wide and long
//Basic syntax
//type reshape in command line
use wide

***convert from wide to long
help reshape
reshape long age_ sex_, i(household) j(member)

*when you are done, review your data and clean uo
browse
drop no_of_members
drop if age_ == .
lab define SEX 1 "Male" 2 "Female"
label values sex_ SEX

label variable household "Household ID"
label variable member "Household member number"
label variable age_ "Age of respondent"
label variable sex_ "Sex of respondent"
rename age_ age
rename sex_ sex

***alternative
* rename *_ *


*order variables
order household member sex
save wide_to_long, replace


** reshape from long to wide
reshape wide age sex, i(household) j(member)
** ... other data management tasks to clean up your data



webuse lbw

*** CREATING NEW VARIABLES
* generate (gen)
// already discussed

*Clone existing variable (clonevar)
// clonevar generates new_var as an exact copy (same type, values, format) of old_var

gen smoke2 =smoke
clonevar smoke3 =smoke
drop smoke2 smoke3

* extended generate (egen)
// egen is an extended version of “generate” to create a new variable by aggregating the existing data. 

egen hhsize = max(member), by(household)
drop hhsize

egen hhsize = count(household), by(household)
drop hhsize

*find the household size
use wide, clear
egen hhsize = rownonmiss(age*)

*generate a new variable that gives 1 if there is a male in the house or 0 is there is no male in the house
egen any_male = anymatch(sex*), values(1)

*generate a new variable that gives 1 if there is a female in the house or 0 is there is no female in the house
egen any_female = anymatch(sex*), values(2)

*generate a new variable that gives the total number of males in a household
egen num_male = anycount(sex*), values(1)

*generate a new variable that gives the total number of females in a household
egen num_female = anycount(sex*), values(2)


*generate a unique id
use long, clear
egen uniquid = concat (household member)


*put space between household and member 
egen uniquid = concat (household member), punct("   ")



*** CHANGING DATA II: CONTENTS
* changing contents of a variable (replace)
// replace is already discussed above

* recode categorical/integer variable







use dhs, clear
destring, replace
gen anemia = hemoglobin

***from assignment2***
clonevar location = shstate
recode location 90/180=1 260/360=2
tab location


*for males
recode anemia 130/1000 = 0 110/129=1 80/109=2 0/80=3 if sex ==1

*for females
recode anemia 120/1000 = 0 110/119=1 80/109=2 0/80=3 if sex ==2

* tabulate anemia with missing values 
tab anemia, missing


label define ANEMIA 0 "No Anemia" 1 "Mild Anemia" 2 "Moderate Anemia" 3 "Severe Anemia"
label values anemia ANEMIA
tab anemia

*********** END OF CORRECTION**********



* encode value labels from string variables
tostring anemia, generate(anemia_string)

encode anemia_string, generate(my_encode)

drop anemia_string my_encode 

* decode strings from labeled numerical variable
decode anemia_cat, generate(my_decode)
drop my_decode

* drop or keep observations (drop, keep)
// already discussed

