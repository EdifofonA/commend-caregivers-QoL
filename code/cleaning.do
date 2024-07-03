quietly{
**# Clean variables for descriptive statistics
lab define yesno 1 "Yes" 0 "No", replace

* Generate indicator variable for female sex
gen ppt_female   = ppt_sex==2 if !missing(ppt_sex)
gen carer_female = carer_sex==2 if !missing(carer_sex)
lab var ppt_female   "Female sex (patient)"
lab var carer_female "Female sex (caregiver)"
label values ppt_female carer_female yesno

* Age of carer and patient
lab var calc_age_p "Patient's age in years"
lab var calc_age_c "Caregiver's age in years"

* Marital status of carer and patient
recode relationship (1 4 5 = 0) (2 3 = 1) 
recode carer_relationship (1 4 5 = 0) (2 3 = 1) 

lab var relationship "Patient is married/partnership"
lab var carer_relationship "Caregiver is married/partnership"
lab values carer_relationship yesno

* Carer relationship with patient (categorical)
gen rel2pptCat = rel2ppt
recode rel2pptCat 3/7 = 3
lab define rel2pptCat 1 "Spouse/partner" 2 "Child" 3 "Other family/friend", replace
lab values rel2pptCat rel2pptCat
lab var rel2pptCat "Relationship with patient"

* Carer relationship with patient
lab var rel2ppt "Relationship with patient"
recode rel2ppt (1/2 = 1) (3/7 = 2)
lab define rel2ppt 1 "Spouse/partner/child" 2 "Other family/friend", replace
lab values rel2ppt rel2ppt

* Employment status of carer and patient
gen ppt_employed   = (occ==1 | occ==2) if !missing(occ)
gen carer_employed = (carer_occ==1 | carer_occ==2) if !missing(carer_occ)

lab var ppt_employed   "Patient in paid employment"
lab var carer_employed "Caregiver in paid employment"

lab values ppt_employed carer_employed yesno

* Comorbidity in patient
gen oth_anydx_yn = (oth_phys_yn==1 | oth_mental_yn==1)  if !missing(oth_phys_yn, oth_mental_yn)

label values oth_anydx_yn yesno

lab var oth_anydx_yn   "Patient comorbidity (any)"
lab var oth_phys_yn    "Patient comorbidity (physical)"
lab var oth_mental_yn  "Patient comorbidity (mental)"

* Number of comorbidities in patient
egen temp = concat(oth_phys_spcfy oth_mental_spcfy) if (oth_phys_yn==1 | oth_mental_yn==1), punct(,) // combine physical and mental comorbidity variables
replace temp = subinstr(temp, ",,", ",",.)  // remove double commas
replace temp = subinstr(temp, ".,", ",",.)  // remove double commas

gen ppt_numdx = length(temp) - length(subinstr(temp, ",", "", .)) // counts
replace ppt_numdx = 2 in 8
replace ppt_numdx = 2 in 15
replace ppt_numdx = 3 in 25
replace ppt_numdx = 3 in 27
replace ppt_numdx = 2 in 50
replace ppt_numdx = 2 in 54
replace ppt_numdx = 2 in 58
replace ppt_numdx = 3 in 84
replace ppt_numdx = 2 in 103
replace ppt_numdx = 2 in 126
replace ppt_numdx = 3 in 131
replace ppt_numdx = 2 in 141
replace ppt_numdx = 2 in 173
replace ppt_numdx = 2 in 174
replace ppt_numdx = 2 in 181

drop temp // drop temporary variable created
lab var ppt_numdx "Number of comorbidities"

* Years since diagnosis for patient
gen years_diag = time_s_diag_mn / 12
lab var years_diag "Years since diagnosis"

* Years spent as primary caregiver
gen years_care =  caring_duration / 12
lab var years_care "Years as primary caregiver"

* Hours per week spent caregiving
lab var caring_average "Hours per week in caregiving"

* Rate of deterioration
lab var prebase_det_tert "Rate of deterioration"

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

* ALSFRS scores
lab var als_score0 "ALSFRS-R score (0-48)"
lab var als_score1 "ALSFRS-R score (0-48)"
lab var als_score2 "ALSFRS-R score (0-48)"

lab var carer_eq_vas_score0 "EQ-VAS score (0-100)"
lab var carer_eq_vas_score1 "EQ-VAS score (0-100)"
lab var carer_eq_vas_score2 "EQ-VAS score (0-100)"

lab var carer_eq5d_score0 "EQ-5D index score (0-1)"
lab var carer_eq5d_score1 "EQ-5D index score (0-1)"
lab var carer_eq5d_score2 "EQ-5D index score (0-1)"

lab var zarit_score0 "ZBI score (0-88)"
lab var zarit_score1 "ZBI score (0-88)"
lab var zarit_score2 "ZBI score (0-88)"

lab var stage0 "King's stage"
lab var stage1 "King's stage"
lab var stage2 "King's stage"

* 
gen stageBin0 = (stage0==1 | stage0==2) if !missing(stage0)
gen stageBin1 = (stage1==1 | stage1==2) if !missing(stage1)
gen stageBin2 = (stage2==1 | stage2==2) if !missing(stage2)

gen zarit_prop0 = zarit_score0/88 if !missing(zarit_score0)
gen zarit_prop1 = zarit_score1/88 if !missing(zarit_score1)
gen zarit_prop2 = zarit_score2/88 if !missing(zarit_score2)

gen caring_averageBin = (caring_average>21) if !missing(caring_average)

* University degree
gen carer_university = (carer_education_lvl>4) if !missing( carer_education_lvl)
lab var carer_university "Caregiver has university degree"

* Following Get et al
gen als_scoreBin0 = (als_score0<=36) if !missing(als_score0)
gen als_scoreBin1 = (als_score1<=36) if !missing(als_score1)
gen als_scoreBin2 = (als_score2<=36) if !missing(als_score2)

gen mhads_anx_scoreBin0 = (mhads_anx_score0 >= 7) if !missing(mhads_anx_score0)
gen mhads_anx_scoreBin1 = (mhads_anx_score1 >= 7) if !missing(mhads_anx_score1)
gen mhads_anx_scoreBin2 = (mhads_anx_score2 >= 7) if !missing(mhads_anx_score2)

* See https://link.springer.com/article/10.1007/s00415-019-09615-3
gen mhads_dep_scoreBin0 = (mhads_dep_score0 >= 5) if !missing(mhads_dep_score0)
gen mhads_dep_scoreBin1 = (mhads_dep_score1 >= 5) if !missing(mhads_dep_score1)
gen mhads_dep_scoreBin2 = (mhads_dep_score2 >= 5) if !missing(mhads_dep_score2)

lab var mq_psychol_score0  "MQOL psychological (0-10)"
lab var mq_exist_score0    "MQOL existential (0-10)"
lab var mhads_anx_score0   "MHADS anxiety (0-18)"
lab var mhads_dep_score0   "MHADS depression (0-18)"


* Drop if missing baseline variables
drop if missing(zarit_score0) | missing(carer_eq_vas_score0) | missing(carer_eq5d_score0)

* Drop one influential observation where EQ-5D score was negative but EQ-VAS score was high
drop if carer_eq5d_score0 < 0 | carer_eq5d_score0 < 0 | carer_eq5d_score2 < 0

* Drop variables not needed
cap drop zb_* act_* alsfrs_* sess_* pp_* aaq_* stts_* hads_* *complete* *_date*


**# Create pooledLong frame (long data format)

* Copy the default frame into a new frame
frame copy default pooledLong
frame change pooledLong

* Reshape data from wide to long format
reshape long zarit_score carer_eq_vas_score carer_eq5d_score carer_mobility carer_self_care carer_usual_activ carer_pain carer_anxiety stage stageBin als_score als_scoreBin zarit_prop mq_psychol_score mq_exist_score mhads_anx_score mhads_anx_scoreBin  mhads_dep_score mhads_dep_scoreBin participant_eq_vas_score participant_eq5d_score participant_mobility participant_self_care participant_usual_activ participant_pain participant_anxiety, i(screening) j(timepoint)

* Rename variables
lab var carer_mobility    "Carer EQ-5D mobility"
lab var carer_self_care   "Carer EQ-5D self-care"
lab var carer_usual_activ "Carer EQ-5D usual activity"
lab var carer_pain        "Carer EQ-5D pain/discomfort"
lab var carer_anxiety     "Carer EQ-5D anxiety/depression"
lab var zarit_score       "ZBI score (0-88)"
lab var zarit_prop        "ZBI score scaled (0-1)"
lab var carer_eq5d_score  "Carer EQ-5D index score"
lab var als_score         "ALSFRS-Revised (0-48)"
lab var mq_psychol_score  "MQOL psychological (0-10)"
lab var mq_exist_score    "MQOL existential (0-10)"
lab var mhads_anx_score   "MHADS anxiety (0-18)"
lab var mhads_dep_score   "MHADS depression (0-18)"

lab var participant_mobility    "Patient EQ-5D mobility"
lab var participant_self_care   "Patient EQ-5D self-care"
lab var participant_usual_activ "Patient EQ-5D usual activity"
lab var participant_pain        "Patient EQ-5D pain/discomfort"
lab var participant_anxiety     "Patient EQ-5D anxiety/depression"
lab var participant_eq5d_score  "Patient EQ-5D index score"

gen carer_eq5d_100       = carer_eq5d_score * 100
lab var carer_eq5d_100  "Carer EQ-5D index (x 100)"

gen participant_eq5d_100 = participant_eq5d_score * 100
lab var participant_eq5d_100  "Patient EQ-5D index (x 100)"

**# Create catplotLong frame (long data format)

* Copy the default frame into a new frame
frame copy default catplotLong
frame change catplotLong

* Reshape data from wide to long format
reshape long carer_mobility carer_self_care carer_usual_activ carer_pain carer_anxiety, i(screening) j(time)

* Keep only needed variables
keep time carer_mobility carer_self_care carer_usual_activ carer_pain carer_anxiety time
lab define TIMEPOINT 0 "Baseline" 1 "6 months" 2 "9 months"
lab values time TIMEPOINT



**# CSRI data cleaning
cap frame create csri
cap frame change csri

use "/Volumes/HAR_WG/WG/WELLCOME_COMMEND/data/csri_equip.dta", clear
keep screening event_name csri_equip

merge m:m screening using "/Volumes/HAR_WG/WG/WELLCOME_COMMEND/data/csri_home.dta"
rename csri_adapt csri_home
keep screening event_name csri_equip csri_home

merge m:m screening using "/Volumes/HAR_WG/WG/WELLCOME_COMMEND/data/csri_inpatient.dta"
rename csri_inpat_service csri_inpat
keep screening event_name csri_equip csri_home csri_inpat

merge m:m screening using "/Volumes/HAR_WG/WG/WELLCOME_COMMEND/data/csri_outpatient.dta"
rename csri_outpat_service csri_outpat
keep screening event_name csri_equip csri_home csri_inpat csri_outpat

merge m:m screening using "/Volumes/HAR_WG/WG/WELLCOME_COMMEND/data/csri_psych.dta"
rename csri_therp csri_psych
keep screening event_name csri_equip csri_home csri_inpat csri_outpat csri_psych

merge m:m screening using "/Volumes/HAR_WG/WG/WELLCOME_COMMEND/data/csri_service_use.dta"
rename csri_service_name csri_service
keep screening event_name csri_equip csri_home csri_inpat csri_outpat csri_psych csri_service

//drop if event_name == "9 months"
//drop event_name

label drop _all

foreach var of varlist csri* {
    replace `var' = 1 if !missing(`var')
		replace `var' = 0 if  missing(`var')
}

//cap frame change csri


// collapse (sum) csri*, by(screening)
// format csri* %10.0g
// cap frame change pooledLong
// frlink m:1 screening, frame(csri)
// frget csri*, from(csri)

collapse (sum) csri*, by(screening event_name)

replace event_name = "0" if event_name == "Baseline"
replace event_name = "1" if event_name == "6 months"
replace event_name = "2" if event_name == "9 months"
destring event_name, replace


foreach var of varlist csri_* {
	gen `var'Bin = `var' > 0
}

rename event_name timepoint

cap frame change pooledLong
frlink m:1 screening timepoint, frame(csri)
frget csri*, from(csri)

format csri* %12.0g


lab var csri_equip   "Received equipment"
lab var csri_home    "Had home adaptations"
lab var csri_inpat   "Received inpatient care"
lab var csri_outpat  "Received outpatient care"
lab var csri_psych   "Had psychological therapy"
lab var csri_service "Mental health service"



}
