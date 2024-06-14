**# Preambles

* Remove objects from Stata memory
clear all
cls

* Load dataset (from "data" subfolder)
use "/Volumes/HAR_WG/WG/WELLCOME_COMMEND/data/commend_master240405.dta"

* Create king stages
do "code/kingstage.do"

* Some data management
do "code/cleaning.do"

**# Table of descriptive statistics
quietly{
* For caregivers
dtable calc_age_c 1.carer_female 1.carer_relationship 1.carer_employed i.rel2ppt years_care caring_average carer_eq_vas_score0 carer_eq5d_score0 zarit_score0, nosample name(Caregivers) replace // nosample prevents sample frequency statistic

* For patients
dtable calc_age_p 1.ppt_female 1.relationship 1.ppt_employed 1.oth_phys_yn 1.oth_mental_yn ppt_numDx years_diag als_score0 i.stage0, nosample name(Patients) replace // nosample prevents sample frequency statistic

* Combine the two tables
collect combine table1 = Patients Caregivers, replace
collect layout (collection#var) (result)

* Format mean and SD one decimal place
collect style cell result[mean sd], nformat(%8.1fc)
collect label levels result _dtable_stats "Mean (SD) or n (%)", modify

* Hide levels of indicator variables
collect style header oth_phys_yn oth_mental_yn ppt_female ppt_employed relationship carer_female carer_employed carer_relationship, level(hide)

* Add sample sizes
collect label levels collection Patients "Patients, N=85" Caregivers "Caregivers, N=85", modify
}

* Preview and export to LaTeX
collect preview
collect export output/table1.tex, replace  tableonly


**# Bar charts of carer outcomes by king's stages
quietly{

set scheme stmono2

* EQ-5D
graph bar carer_eq5d_score0 if stage0 !=5, over(stage0) name(A1, replace) ytitle(EQ-5D score) nodraw ylabel(0(0.2)1) bar(1, fcolor(khaki%40)) 
graph bar carer_eq5d_score1 if stage1 !=5, over(stage1) name(B1, replace) ytitle(EQ-5D score) nodraw ylabel(0(0.2)1) bar(1, fcolor(khaki%40)) 
graph bar carer_eq5d_score2 if stage2 !=5, over(stage2) name(C1, replace) ytitle(EQ-5D score) nodraw ylabel(0(0.2)1) bar(1, fcolor(khaki%40)) 

* EQ-VAS
graph bar carer_eq_vas_score0 if stage0 !=5, over(stage0) name(A2, replace) ytitle(EQ-VAS score) nodraw ylabel(0(20)100) bar(1, fcolor(erose%40)) 
graph bar carer_eq_vas_score1 if stage1 !=5, over(stage1) name(B2, replace) ytitle(EQ-VAS score) nodraw ylabel(0(20)100) bar(1, fcolor(erose%40)) 
graph bar carer_eq_vas_score2 if stage2 !=5, over(stage2) name(C2, replace) ytitle(EQ-VAS score) nodraw ylabel(0(20)100) bar(1, fcolor(erose%40)) 

* ZBI
graph bar zarit_score0 if stage0 !=5, over(stage0) name(A3, replace) ytitle(ZBI score) b1title("Stage at baseline") nodraw ylabel(0(5)25) bar(1, fcolor(teal%20)) 
graph bar zarit_score0 if stage1 !=5, over(stage1) name(B3, replace) ytitle(ZBI score) b1title("Stage at 6 months") nodraw ylabel(0(5)25) bar(1, fcolor(teal%20)) 
graph bar zarit_score0 if stage2 !=5, over(stage2) name(C3, replace) ytitle(ZBI score) b1title("Stage at 9 months") nodraw ylabel(0(5)25) bar(1, fcolor(teal%20)) 

* Combined
graph combine A1 B1 C1 A2 B2 C2 A3 B3 C3, rows(3) xsize(8) ysize(6) iscale(0.6) imargin(0 3 1 1)
graph export output/figures/outcome-kings-stage.png, width(8000) height(6000) replace
}


**# Pooled carer scores by patient's functional status

* First, create another data frame for long data
capture frame create long
capture frame change long // change to long frame

* reshape data to long format
quietly{
	use "/Volumes/HAR_WG/WG/WELLCOME_COMMEND/data/commend_master240405.dta", clear
  do "code/kingstage.do"
	do "code/cleaning.do"
	reshape long zarit_score carer_eq_vas_score ///
	carer_eq5d_score carer_mobility carer_self_care ///
	carer_usual_activ carer_pain carer_anxiety stage /// 
	stageBin als_score als_scoreBin zarit_prop ///
	mq_psychol_score mq_exist_score ///
	mhads_anx_score mhads_anx_scoreBin ///
	mhads_dep_score mhads_dep_scoreBin, ///
	i(screening) j(timepoint)
}	

* Summary statistics for carer scores by King's stage
tabstat zarit_score carer_eq_vas_score ///
carer_eq5d_score carer_mobility carer_self_care ///
carer_usual_activ carer_pain carer_anxiety if stage!=5, ///
by(stage) stat(mean sd) nototal format(%8.3fc)

* ANOVA statistics for carer scores by King's stage
foreach var of varlist zarit_score carer_eq5d_score carer_eq_vas_score carer_mobility carer_self_care carer_usual_activ carer_pain carer_anxiety {
	quietly anova `var' stage
	di "P-value for `var': 0" round(Ftail(e(df_m), e(df_r), e(F)), 0.0001)
}


**# Correlation between functional status and outcomes
// ALSFRS-R maximum score of 48 (best) and a minimum score of 0 (worst)
* Using pooled data
capture frame change long // change to long frame
pwcorr als_score carer_eq5d_score, sig obs
// coef  0.216; pvalue 0.002
pwcorr als_score carer_eq_vas_score, sig obs
// coef  0.043; pvalue 0.535
pwcorr als_score zarit_score, sig obs
// coef -0.208; pvalue 0.002

* Using baseline data
capture frame change default // return to default frame
pwcorr als_score0 carer_eq5d_score0, sig obs
// coef  0.151; pvalue 0.171
pwcorr als_score0 carer_eq_vas_score0, sig obs
// coef -0.106; pvalue 0.339
pwcorr als_score0 zarit_score0, sig obs
// coef -0.243; pvalue 0.026



**# Relationships between ZBI, EQ-5D, and EQ-VAS

quietly{
* Set Excel workbook for results
putexcel set "output/results.xlsx", sheet(pwcorr, replace) modify
putexcel A3="Baseline score" A4="9 months score" A5="Change in score"
putexcel B1="ZBI vs EQ-5D" D1="ZBI vs EQ-VAS" F1="EQ-5D vs EQ-VAS"
putexcel B2="Coefficient" C2="P-value" D2="Coefficient" E2="P-value" F2="Coefficient" G2="P-value"

* Correlation between ZBI and EQ-5D
pwcorr zarit_score0 carer_eq5d_score0, obs sig
putexcel B3=(r(C)[1,2]) C3=(r(sig)[1,2])
pwcorr zarit_score2 carer_eq5d_score2, obs sig
putexcel B4=(r(C)[1,2]) C4=(r(sig)[1,2])
pwcorr zarit_scoreD carer_eq5d_scoreD, obs sig
putexcel B5=(r(C)[1,2]) C5=(r(sig)[1,2])

* Correlation between ZBI and EQ-VAS
pwcorr zarit_score0 carer_eq_vas_score0, obs sig
putexcel D3=(r(C)[1,2]) E3=(r(sig)[1,2])
pwcorr zarit_score2 carer_eq_vas_score2, obs sig
putexcel D4=(r(C)[1,2]) E4=(r(sig)[1,2])
pwcorr zarit_scoreD carer_eq_vas_scoreD, obs sig
putexcel D5=(r(C)[1,2]) E5=(r(sig)[1,2])

* Correlation between EQ-5D and EQ-VAS
pwcorr carer_eq5d_score0 carer_eq_vas_score0, obs sig
putexcel F3=(r(C)[1,2]) G3=(r(sig)[1,2])
pwcorr carer_eq5d_score2 carer_eq_vas_score2, obs sig
putexcel F4=(r(C)[1,2]) G4=(r(sig)[1,2])
pwcorr carer_eq5d_scoreD carer_eq_vas_scoreD, obs sig
putexcel F5=(r(C)[1,2]) G5=(r(sig)[1,2])

putexcel B3:G5, overwritefmt nformat(0.000)
}


	


**# Regressions for ZBI score using Baseline data
cls
capture frame change default // return to default frame


* Create list of independent variables (Baseline data)
cap vl drop varZarit0
vl create varZarit0 = (calc_age_c carer_female carer_relationship carer_university carer_employed rel2ppt years_care caring_averageBin carer_mobility0 carer_self_care0 carer_usual_activ0 carer_pain0 carer_anxiety0 calc_age_p ppt_female relationship stageBin0 als_score0 als_scoreBin0 ppt_otherDx oth_phys_yn oth_mental_yn mq_psychol_score0 mq_exist_score0 mhads_anx_score0 mhads_anx_scoreBin0 mhads_dep_score0 mhads_dep_scoreBin0 prebase_det_tert)

* add eq5d score in univariate regression

* Run univariate OLS regression and export (Baseline data)
collect clear
foreach var of varlist $varZarit0 {
	qui collect _r_b _r_ci _r_p, tag(model[`var']): ///
	regress zarit_score0 `var' 
}
collect style cell, nformat(%5.2f)
collect style cell result[_r_p], nformat(%5.3f)
collect style cell result[_r_ci], sformat("(%s)")
collect style cell result[_r_ci], cidelimiter(,)
collect style cell result, halign(center)
collect layout (coleq#colname) (result[_r_b _r_ci _r_p])

* Keep continuous for ALS-FRS, MQOL

* Run univariate Beta regression and export (Baseline data)
collect clear
foreach var of varlist $varZarit0 {
	qui collect _r_b _r_ci _r_p, tag(model[`var']): ///
	betareg zarit_prop0 `var' if zarit_prop0 > 0
}
collect style cell, nformat(%5.2f)
collect style cell result[_r_p], nformat(%5.3f)
collect style cell result[_r_ci], sformat("(%s)")
collect style cell result[_r_ci], cidelimiter(,)
collect style cell result, halign(center)
collect layout (coleq#colname) (result[_r_b _r_ci _r_p])

* Run multivariate OLS regression and export (Baseline data)
*do one set with mqol and one set with mhads

regress zarit_score0 calc_age_c carer_female carer_relationship carer_university carer_employed rel2ppt years_care caring_averageBin carer_usual_activ0 carer_pain0 carer_anxiety0 als_score0 oth_phys_yn oth_mental_yn mhads_anx_score0 mhads_dep_score0
//mq_psychol_score0 mq_exist_score0 
**# Regressions for EQ-5D score

//regress carer_eq5d_score0 calc_age_c 1.carer_female i.carer_relationship carer_university i.carer_employed i.rel2ppt years_care caring_average calc_age_p i.ppt_female i.relationship i.ppt_employed i.ppt_otherDx ppt_numDx years_diag i.stage0

// table (colname result) (command), command(_r_b _r_se: regress zarit_score0 calc_age_c 1.carer_female i.carer_relationship carer_university i.carer_employed i.rel2ppt years_care caring_averageBin calc_age_p i.ppt_female relationship ppt_employed ppt_otherDx oth_phys_yn oth_mental_yn ppt_numDx years_diag i.stage0 carer_mobility0 carer_self_care0 carer_usual_activ0 carer_pain0 carer_anxiety0) nformat(%6.2f) sformat("(%s)" _r_se) style(table-reg2)



**# Regressions for ZBI score using Pooled data

capture frame change long // change to long frame

/*
* Create list of independent variables (Pooled data)
cap vl drop varZarit
vl create varZarit = (calc_age_c carer_female carer_relationship carer_university carer_employed rel2ppt years_care caring_averageBin carer_mobility carer_self_care carer_usual_activ carer_pain carer_anxiety calc_age_p ppt_female relationship stageBin als_score als_scoreBin ppt_otherDx oth_phys_yn oth_mental_yn mq_psychol_score mq_exist_score mhads_anx_score mhads_anx_scoreBin mhads_dep_score mhads_dep_scoreBin prebase_det_tert)

* Run univariate OLS regression and export (Pooled data)
cls
collect clear
foreach var of varlist $varZarit {
	qui collect _r_b _r_ci _r_p, tag(model[`var']): ///
	reg zarit_score  `var' 
}
collect style cell, nformat(%5.2f)
collect style cell result[_r_p], nformat(%5.3f)
collect style cell result[_r_ci], sformat("(%s)")
collect style cell result[_r_ci], cidelimiter(,)
collect style cell result, halign(center)
collect layout (coleq#colname) (result[_r_b _r_ci _r_p])
*/

* Run multivariate OLS regression and export (Pooled data)
regress zarit_score calc_age_c carer_female carer_relationship carer_university carer_employed rel2ppt years_care caring_averageBin carer_usual_activ carer_pain carer_anxiety als_score oth_phys_yn oth_mental_yn mhads_anx_score mhads_dep_score, vce(cluster screening)

regress zarit_score calc_age_c carer_female carer_relationship carer_university carer_employed rel2ppt years_care caring_averageBin carer_usual_activ carer_pain carer_anxiety als_score oth_phys_yn oth_mental_yn mhads_anx_score mhads_dep_score, vce(cluster screening)

*interaction between carer_rel and rel2ppt???

* Run multivariate Beta regression and export (Pooled data)
betareg zarit_prop calc_age_c carer_female carer_relationship carer_university carer_employed rel2ppt years_care caring_averageBin carer_usual_activ carer_pain carer_anxiety als_scoreBin oth_mental_yn mq_psychol_score mq_exist_score mhads_anx_scoreBin mhads_dep_score if zarit_prop > 0


capture frame change default // return to default frame

