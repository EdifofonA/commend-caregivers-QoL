use dhs

**rename
rename hv001 cluster
rename hv002 household
rename hv005 weight
rename hv006 month
rename hv007 year
rename hv270 wealth
rename shstate state

**label variable
label variable cluster "Cluster Number"
label variable household "Household Number"
label variable weight "Household Sample Weight"
label variable month "Month of Interview"
label variable year "Year of Interview"
label variable wealth "Wealth Index Combined"
label variable state "State"
label variable id "Line Number"
label variable sex "Sex of Household Member"
label variable age "Ae of Household Member"
label variable age "Age of Household Member"
label variable hemoglobin "Hemoglobin Level (g/dl)"


**destring
destring state, replace
destring sex, replace
destring wealth, replace
destring age, replace
destring hemoglobin, replace



**label values
label define STATE 100 "Location 1" 90 "Location 2" 180 "Location 3" 360 "Location 4" 260 "Location 5" 330 "Location 6"
label values state STATE
label define SEX 1 "Male" 2 "Female"
label values sex SEX
label define WEALTH 1 "Poorest" 2 "Poor" 3 "Average" 4 "Rich" 5 "Richest"
label values wealth WEALTH

gen anemia = .

* for males
replace anemia = 0 if sex==1 & hemoglobin >= 130 & hemoglobin < .
replace anemia = 1 if sex==1 & hemoglobin >= 110 & hemoglobin <= 129
replace anemia = 2 if sex==1 & hemoglobin >= 80 & hemoglobin <= 109
replace anemia = 3 if sex==1 & hemoglobin < 80

* for females
replace anemia = 0 if sex==2 & hemoglobin >= 120 & hemoglobin < .
replace anemia = 1 if sex==2 & hemoglobin >= 110 & hemoglobin <= 119
replace anemia = 2 if sex==2 & hemoglobin >= 80 & hemoglobin <= 109
replace anemia = 3 if sex==2 & hemoglobin < 80


label define ANEMIA_male 0 "No Anemia" 1 "Mild Anemia" 2 "Moderate Anemia" 3 "Severe Anemia"
label values anemia ANEMIA
tab anemia

*Location
generate location=.
replace location=1 if state==90
replace location=1 if state==100
replace location=1 if state==180
replace location=2 if state==330
replace location=2 if state==260
replace location=2 if state==360
label define LOCATION 1"North" 2 "South"
label values location LOCATION

***alternatively (shorter)
generate location=.
replace location=1 if state <= 180
replace location=1 if state >= 330











*********** END OF CORRECTION**********
