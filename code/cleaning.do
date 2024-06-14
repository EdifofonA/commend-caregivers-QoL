* Drop if missing baseline variables
drop if missing(zarit_score0) | missing(carer_eq_vas_score0) | missing(carer_eq5d_score0)

* Drop one influential observation where EQ-5D score was negative but EQ-VAS score was high
drop if carer_eq5d_score0 < 0 | carer_eq5d_score0 < 0 | carer_eq5d_score2 < 0


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

lab var relationship "Married or in partnership"
lab var carer_relationship "Married or in partnership"

lab define relationship 1 "Married or in partnership" 0 "Single or previously married", replace
lab values carer_relationship relationship

* Carer relationship with patient
lab var rel2ppt "Relationship with patient"
recode rel2ppt (1/2 = 1) (3/7 = 2)
lab define rel2ppt 1 "Spouse/partner/child" 2 "Other family/friend", replace

* Employment status of carer and patient
gen ppt_employed   = (occ==1 | occ==2) if !missing(occ)
gen carer_employed = (carer_occ==1 | carer_occ==2) if !missing(carer_occ)

lab var ppt_employed   "In paid employment"
lab var carer_employed "In paid employment"

lab values ppt_employed carer_employed yesno

* Comorbidity in patient
gen ppt_otherDx = (oth_phys_yn==1 | oth_mental_yn==1)  if !missing(oth_phys_yn, oth_mental_yn)

label values ppt_otherDx yesno
lab var ppt_otherDx "Patient has comorbidity"

* Number of comorbidities in patient
egen temp = concat(oth_phys_spcfy oth_mental_spcfy) if (oth_phys_yn==1 | oth_mental_yn==1), punct(,) // combine physical and mental comorbidity variables
replace temp = subinstr(temp, ",,", ",",.)  // remove double commas
gen ppt_numDx = length(temp) - length(subinstr(temp, ",", "", .)) // counts
drop temp // drop temporary variable created
lab var ppt_numDx "Number of comorbidities"
lab var oth_mental_yn "Other mental condition"
lab var oth_phys_yn   "Other physical condition"

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
lab var als_score0 "ALSFRS-R score (0–48)"
lab var als_score1 "ALSFRS-R score (0–48)"
lab var als_score2 "ALSFRS-R score (0–48)"

lab var carer_eq_vas_score0 "EQ-VAS score (0–100)"
lab var carer_eq_vas_score1 "EQ-VAS score (0–100)"
lab var carer_eq_vas_score2 "EQ-VAS score (0–100)"

lab var carer_eq5d_score0 "EQ-5D index score (0–1)"
lab var carer_eq5d_score1 "EQ-5D index score (0–1)"
lab var carer_eq5d_score2 "EQ-5D index score (0–1)"

lab var zarit_score0 "ZBI score (0–88)"
lab var zarit_score1 "ZBI score (0–88)"
lab var zarit_score2 "ZBI score (0–88)"

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

gen carer_university = (carer_education_lvl>4) if !missing( carer_education_lvl)

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



/* Useful codes

//dtable, continuous(calc_age_c, statistics(meansd q2 iq)) define(iq = q1 q3, delimiter(", ")) define(meansd = mean sd, delimiter("±")) nformat(%8.1fc) sformat("(IQR: %s)" iq) sformat("%s" sd) nosample  

//dtable, continuous(calc_age_c years_care caring_average, statistics(iq2 q2)) factor(carer_female carer_relationship carer_employed rel2ppt) define(iq2 = mean sd) nosample nformat(%8.1fc) sformat("(%s);" sd) sformat("Median-%s" q2) 


**# T-tests
* ZBI score: Baseline to 6 months
collect clear
quietly: collect mean_base=r(mu_1) sd_base=r(sd_1) mean_6mo=r(mu_2) sd_6mo=r(sd_2) diff=r(mu_1)-r(mu_2) pvalue=r(p): ttest zarit_score0 == zarit_score1 //if !missing(zarit_score0) & !missing(zarit_score1) & !missing(zarit_score2) 
collect layout () (result[mean_base sd_base mean_6mo sd_6mo diff pvalue])

* ZBI score: 6 months to 9 months
collect clear
quietly: collect mean_6mo=r(mu_1) sd_6mo=r(sd_1) mean_9mo=r(mu_2) sd_9mo=r(sd_2) diff=r(mu_1)-r(mu_2) pvalue=r(p): ttest zarit_score1 == zarit_score2 
collect layout () (result[mean_6mo sd_6mo mean_9mo sd_9mo diff pvalue])

* ZBI score: Baseline to 9 months
collect clear
quietly: collect mean_base=r(mu_1) sd_base=r(sd_1) mean_9mo=r(mu_2) sd_9mo=r(sd_2) diff=r(mu_1)-r(mu_2) pvalue=r(p): ttest zarit_score0 == zarit_score2
collect layout () (result[mean_base sd_base mean_9mo sd_9mo diff pvalue])

* EQ-VAS: Baseline to 6 months
collect clear
quietly: collect mean_base=r(mu_1) sd_base=r(sd_1) mean_6mo=r(mu_2) sd_6mo=r(sd_2) diff=r(mu_1)-r(mu_2) pvalue=r(p): ttest carer_eq_vas_score0 == carer_eq_vas_score1
collect layout () (result[mean_base sd_base mean_6mo sd_6mo diff pvalue])

* EQ-VAS: 6 months to 9 months
collect clear
quietly: collect mean_6mo=r(mu_1) sd_6mo=r(sd_1) mean_9mo=r(mu_2) sd_9mo=r(sd_2) diff=r(mu_1)-r(mu_2) pvalue=r(p): ttest carer_eq_vas_score1 == carer_eq_vas_score2
collect layout () (result[mean_6mo mean_9mo diff pvalue])

* EQ-VAS: Baseline to 9 months
collect clear
quietly: collect mean_base=r(mu_1) sd_base=r(sd_1) mean_9mo=r(mu_2) sd_9mo=r(sd_2) diff=r(mu_1)-r(mu_2) pvalue=r(p): ttest carer_eq_vas_score0 == carer_eq_vas_score2
collect layout () (result[mean_base mean_9mo diff pvalue])

* EQ-5D: Baseline to 6 months
collect clear
quietly: collect mean_base=r(mu_1) sd_base=r(sd_1) mean_6mo=r(mu_2) sd_6mo=r(sd_2) diff=r(mu_1)-r(mu_2) pvalue=r(p): ttest carer_eq5d_score0 == carer_eq5d_score1
collect layout () (result[mean_base mean_6mo diff pvalue])

* EQ-5D: 6 months to 9 months
collect clear
quietly: collect mean_6mo=r(mu_1) sd_6mo=r(sd_1) mean_9mo=r(mu_2) sd_9mo=r(sd_2) diff=r(mu_1)-r(mu_2) pvalue=r(p): ttest carer_eq5d_score1 == carer_eq5d_score2
collect layout () (result[mean_6mo mean_9mo diff pvalue])

* EQ-5D: Baseline to 9 months
collect clear
quietly: collect mean_base=r(mu_1) sd_base=r(sd_1) mean_9mo=r(mu_2) sd_9mo=r(sd_2) diff=r(mu_1)-r(mu_2) pvalue=r(p): ttest carer_eq5d_score0 == carer_eq5d_score2
collect layout () (result[mean_base mean_9mo diff pvalue])
