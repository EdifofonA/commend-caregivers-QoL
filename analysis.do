**# Preambles

* Remove objects from Stata memory
clear all

* Load dataset (from "data" subfolder)
use "data/commend_master240405.dta"

* Some data management
do "code/cleaning.do"

* Create king stages
do "code/kingstage.do"


**# Table of descriptive statistics
quietly{
* For caregivers
dtable calc_age_c 1.carer_female 1.carer_relationship 1.carer_employed i.rel2ppt years_care caring_average, nosample name(Caregivers) replace // nosample prevents sample frequency statistic

* For patients
dtable calc_age_p 1.ppt_female 1.relationship 1.ppt_employed 1.ppt_otherDx ppt_numDx years_diag i.stage0, nosample name(Patients) replace // nosample prevents sample frequency statistic

* Combine the two tables
collect combine table1 = Patients Caregivers, replace
collect layout (collection#var) (result)

* Format mean and SD one decimal place
collect style cell result[mean sd], nformat(%8.1fc)
collect label levels result _dtable_stats "Mean (SD) or n (%)", modify

* Hide levels of indicator variables
collect style header ppt_otherDx ppt_female ppt_employed relationship carer_female carer_employed carer_relationship, level(hide)

* Style the table
collect style cell, border( all, width(0.5) ) font(Arial, size(10)) valign(center) 
collect style cell result[_dtable_stats], halign(center)

* Add sample sizes
collect label levels collection Patients "Patients, N=85" Caregivers "Caregivers, N=85", modify
}

* Preview and export to LaTeX
collect preview
collect export output/table1.docx, replace



**# Descriptive visualizations
// nodraw option prevents the graph from popping up

* Carer EQ-VAS by stage
graph bar carer_eq_vas_score0 if stage0 !=5, over(stage0) name(A2, replace) ytitle(EQ-VAS score) nodraw ylabel(0(20)100)
graph bar carer_eq_vas_score1 if stage1 !=5, over(stage1) name(B2, replace) ytitle(EQ-VAS score) nodraw ylabel(0(20)100)
graph bar carer_eq_vas_score2 if stage2 !=5, over(stage2) name(C2, replace) ytitle(EQ-VAS score) nodraw ylabel(0(20)100)

* Carer EQ-5D by stage
graph bar carer_eq5d_score0 if stage0 !=5, over(stage0) name(A1, replace) ytitle(EQ-5D score) nodraw ylabel(0(0.2)1)
graph bar carer_eq5d_score1 if stage1 !=5, over(stage1) name(B1, replace) ytitle(EQ-5D score) nodraw ylabel(0(0.2)1)
graph bar carer_eq5d_score2 if stage2 !=5, over(stage2) name(C1, replace) ytitle(EQ-5D score) nodraw ylabel(0(0.2)1)

* Carer ZBI by stage
graph bar zarit_score0 if stage0 !=5, over(stage0) name(A3, replace) ytitle(ZBI score) b1title("Stage at baseline") nodraw ylabel(0(5)25)
graph bar zarit_score0 if stage1 !=5, over(stage1) name(B3, replace) ytitle(ZBI score) b1title("Stage at 6 months") nodraw ylabel(0(5)25)
graph bar zarit_score0 if stage2 !=5, over(stage2) name(C3, replace) ytitle(ZBI score) b1title("Stage at 9 months") nodraw ylabel(0(5)25)

graph combine A1 B1 C1 A2 B2 C2 A3 B3 C3, rows(3) xsize(8) ysize(6) iscale(0.6) imargin(0 3 1 1)
graph export output/outcomeKings.png, width(8000) height(6000) replace


**# Correlations between ZBI, EQ-5D, and EQ-VAS
quietly{
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



**# Create another data frame to enable analysis of long data


capture frame create long
capture frame change long // change to long frame

quietly{
	use "data/commend_master240405.dta", clear
	do "code/cleaning.do"
	do "code/kingstage.do"
	reshape long zarit_score carer_eq_vas_score ///
	carer_eq5d_score carer_mobility carer_self_care ///
	carer_usual_activ carer_pain carer_anxiety stage, ///
	i(screening) j(timepoint)
}	
	
**# Pooled carer scores by King's stage

tabstat zarit_score carer_eq_vas_score ///
carer_eq5d_score carer_mobility carer_self_care ///
carer_usual_activ carer_pain carer_anxiety if stage!=5, ///
by(stage) stat(mean) nototal format(%8.3fc)


foreach var of varlist zarit_score carer_eq5d_score carer_eq_vas_score carer_mobility carer_self_care carer_usual_activ carer_pain carer_anxiety {
	quietly anova `var' stage
	di "P-value for `var': 0" round(Ftail(e(df_m), e(df_r), e(F)), 0.0001)
}


capture frame change default // return to default frame




regress zarit_score0 i.carer_female caring_average i.ppt_female i.relationship ppt_numDx carer_anxiety0


foreach var of varlist calc_age_c carer_female carer_relationship carer_employed rel2ppt years_care caring_average calc_age_p ppt_female relationship ppt_employed ppt_otherDx ppt_numDx years_diag carer_mobility0 carer_self_care0 carer_usual_activ0 carer_pain0 carer_anxiety0 {
	regress zarit_score0  `var', noheader 
}


regress zarit_score0 carer_anxiety0



regress zarit_score0 calc_age_c

regress carer_eq5d_score0 calc_age_c 1.carer_female i.carer_relationship i.carer_employed i.rel2ppt years_care caring_average calc_age_p i.ppt_female i.relationship i.ppt_employed i.ppt_otherDx ppt_numDx years_diag









