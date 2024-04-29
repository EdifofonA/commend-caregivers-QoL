* Remove objects from Stata memory
clear all

* Load dataset (from "data" subfolder)
use "data/commend_master240405.dta"


**# Clean variables for descriptive statistics
lab define yesno 1 "Yes" 0 "No", replace

* Generate indicator variable for female sex
gen ppt_female   = ppt_sex==2 if !missing(ppt_sex)
gen carer_female = carer_sex==2 if !missing(carer_sex)
lab var ppt_female   "Female sex"
lab var carer_female "Female sex"
label values ppt_female carer_female yesno

* Age of carer and patient
lab var calc_age_p "Age in years"
lab var calc_age_c "Age in years"

* Marital status of carer and patient
recode relationship (1 4 5 = 1) (2 3 = 2) 
recode carer_relationship (1 4 5 = 1) (2 3 = 2) 

lab var carer_relationship "Marital status"

lab define relationship 1 "Married or in partnership" 2 "Single or previously married", replace
lab values carer_relationship relationship

* Carer relationship with patient
lab var rel2ppt "Relationship with patient"
recode rel2ppt (3/7 = 3)
lab define rel2ppt 1 "Spouse/partner" 2 "Child" 3 "Other family/friend", replace

* Employment status of carer and patient
gen ppt_employed   = (occ==1 | occ==2) if !missing(occ)
gen carer_employed = (carer_occ==1 | carer_occ==2) if !missing(carer_occ)

lab var ppt_employed   "In paid employment"
lab var carer_employed "In paid employment"

lab values ppt_employed carer_employed yesno

* Comorbidity in patient
gen ppt_otherDx = (oth_phys_yn==1 | oth_mental_yn==1)  if !missing(oth_phys_yn, oth_mental_yn)

label values ppt_otherDx yesno
lab var ppt_otherDx "Patient with comorbidity"

* Number of comorbidities in patient
egen temp = concat(oth_phys_spcfy oth_mental_spcfy) if (oth_phys_yn==1 | oth_mental_yn==1), punct(,) // combine physical and mental comorbidity variables
replace temp = subinstr(temp, ",,", ",",.)  // remove double commas
gen ppt_numDx = length(temp) - length(subinstr(temp, ",", "", .)) // counts
drop temp // drop temporary variable created
lab var ppt_numDx "Number of comorbidities"

* Years since diagnosis for patient
gen years_diag = time_s_diag_mn / 12
lab var years_diag "Years since diagnosis"

* Years spent as primary caregiver
gen years_care =  caring_duration / 12
lab var years_care "Years as primary caregiver"

* Hours per week spent caregiving
lab var caring_average "Hours per week in caregiving"


**# Table of descriptive statistics
keep if !missing(calc_age_c) & !missing(carer_eq5d_score0)

* For patients
dtable calc_age_p 1.ppt_female i.relationship 1.ppt_employed 1.ppt_otherDx ppt_numDx years_diag, ///
nosample /// prevents sample frequency statistic
name(Patients) replace

* For caregivers
dtable calc_age_c 1.carer_female i.carer_relationship 1.carer_employed i.rel2ppt years_care caring_average, ///
nosample /// prevents sample frequency statistic
name(Caregivers) replace

* Combine the two tables
collect combine table1 = Patients Caregivers, replace
collect layout (collection#var) (result)

* Format mean and SD one decimal place
collect style cell result[mean sd], nformat(%8.1fc)
collect label levels result _dtable_stats "Mean (SD) or n (%)", modify

* Hide levels of indicator variables
collect style header ppt_otherDx ppt_female ppt_employed carer_female carer_employed, level(hide)

* Add table title and notes
collect title "Characteristics of patients with motor neuron disease and their caregivers at baseline"
collect notes "Data are based on participants with non-missing baseline caregiver burden and quality of life data. n, number; SD, standard deviation."

* Preview and export to LaTeX
collect preview
collect export table1.tex, replace
