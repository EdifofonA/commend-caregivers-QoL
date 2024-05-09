* Drop if missing baseline variables
keep if !missing(calc_age_c) & !missing(carer_eq5d_score0)



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
recode relationship (1 4 5 = 0) (2 3 = 1) 
recode carer_relationship (1 4 5 = 0) (2 3 = 1) 

lab var carer_relationship "Marital status"

lab define relationship 1 "Married or in partnership" 0 "Single or previously married", replace
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



**# Variables for relationship between outcomes
* Change in ZBI score
gen zarit_scoreD = (zarit_score0 - zarit_score2)
lab var zarit_scoreD "Change in ZBI between baseline and 9 months"

* Change in EQ-VAS score
gen carer_eq_vas_scoreD = (carer_eq_vas_score0) - (carer_eq_vas_score2)
lab var carer_eq_vas_scoreD "Change in EQ-VAS between baseline and 9 months"

* Change in EQ-5D index score
gen carer_eq5d_scoreD = (carer_eq5d_score0) - (carer_eq5d_score2)
lab var carer_eq5d_scoreD "Change in EQ-5D between baseline and 9 months"

