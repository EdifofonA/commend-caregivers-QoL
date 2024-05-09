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
graph bar carer_eq_vas_score0 if stage0 !=5, over(stage0) name(A2, replace) ytitle(EQ-VAS score) ylabel(0(20)100)
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

//graph combine eqvasKings eq5dKings zbiKings, rows(3) xsize(7) ysize(6) iscale(0.75) imargin(0 0 1 1)



collect clear

quietly table (result coleq) (colname), command(obs=(vech(r(Nobs))') corr=(vech(r(C))') sig=(vech(r(sig))'): pwcorr carer_eq5d_score0 zarit_score0, obs sig) nformat(%5.2f corr) nformat(%5.3f sig) name(A)
collect label levels colname zarit_score0 "Baseline vs Baseline", modify
collect label levels coleq carer_eq5d_score0 "EQ-5D", modify
collect layout (colname[zarit_score0]) (coleq[carer_eq5d_score0]#result[obs corr sig])

quietly table (result coleq) (colname), command(obs=(vech(r(Nobs))') corr=(vech(r(C))') sig=(vech(r(sig))'): pwcorr carer_eq5d_score2 zarit_score2, obs sig) nformat(%5.2f corr) nformat(%5.3f sig) name(B)
collect label levels colname zarit_score2 "9 months vs 9 months", modify
collect label levels coleq carer_eq5d_score2 "EQ-5D", modify
collect layout (colname[zarit_score2]) (coleq[carer_eq5d_score2]#result[obs corr sig])

quietly table (result coleq) (colname), command(obs=(vech(r(Nobs))') corr=(vech(r(C))') sig=(vech(r(sig))'): pwcorr carer_eq5d_scoreD zarit_scoreD, obs sig) nformat(%5.2f corr) nformat(%5.3f sig) name(C)
collect label levels colname zarit_scoreD "Change vs Change", modify
collect label levels coleq carer_eq5d_scoreD "EQ-5D", modify
collect layout (colname[zarit_scoreD]) (coleq[carer_eq5d_scoreD]#result[obs corr sig])


quietly table (result coleq) (colname), command(obs=(vech(r(Nobs))') corr=(vech(r(C))') sig=(vech(r(sig))'): pwcorr carer_eq_vas_score0 zarit_score0, obs sig) nformat(%5.2f corr) nformat(%5.3f sig) name(D)
collect label levels colname zarit_score0 "Baseline vs Baseline", modify
collect label levels coleq carer_eq_vas_score0 "EQ-VAS", modify
collect layout (colname[zarit_score0]) (coleq[carer_eq_vas_score0]#result[obs corr sig])

quietly table (result coleq) (colname), command(obs=(vech(r(Nobs))') corr=(vech(r(C))') sig=(vech(r(sig))'): pwcorr carer_eq_vas_score2 zarit_score2, obs sig) nformat(%5.2f corr) nformat(%5.3f sig) name(E)
collect label levels colname zarit_score2 "9 months vs 9 months", modify
collect label levels coleq carer_eq_vas_score2 "EQ-VAS", modify
collect layout (colname[zarit_score2]) (coleq[carer_eq_vas_score2]#result[obs corr sig])

quietly table (result coleq) (colname), command(obs=(vech(r(Nobs))') corr=(vech(r(C))') sig=(vech(r(sig))'): pwcorr carer_eq_vas_scoreD zarit_scoreD, obs sig) nformat(%5.2f corr) nformat(%5.3f sig) name(F)
collect label levels colname zarit_scoreD "Change vs Change", modify
collect label levels coleq carer_eq_vas_scoreD "EQ-VAS", modify
collect layout (colname[zarit_scoreD]) (coleq[carer_eq_vas_scoreD]#result[obs corr sig])





**# Pairwise correlations
// * At baseline
// pwcorr zarit_score0 carer_eq_vas_score0, obs sig listwise
// collect preview
// collect get result
//
// pwcorr zarit_score0 carer_eq5d_score0, sig listwise
//
// * At 9 months
// pwcorr zarit_score2 carer_eq_vas_score2, obs sig listwise
// pwcorr zarit_score2 carer_eq5d_score2, obs sig listwise
//
// * Change
// pwcorr zarit_scoreD carer_eq_vas_scoreD, obs sig listwise
// pwcorr zarit_scoreD carer_eq5d_scoreD, obs sig listwise


//collect style cell result[mean_base mean_6mo diff pvalue], nformat(%8.3f)





// * At baseline
pwcorr carer_eq5d_score0 carer_eq_vas_score0, obs sig listwise
gen carer_eq5d_scoreD = carer_eq5d_score0 carer_eq5d_score2
gen carer_eq_vas_scoreD = carer_eq_vas_score0 carer_eq_vas_score2

// collect preview
// collect get result
//
// pwcorr zarit_score0 carer_eq5d_score0, sig listwise
//
// * At 9 months
// pwcorr zarit_score2 carer_eq_vas_score2, obs sig listwise
// pwcorr zarit_score2 carer_eq5d_score2, obs sig listwise
//
// * Change
// pwcorr zarit_scoreD carer_eq_vas_scoreD, obs sig listwise
// pwcorr zarit_scoreD carer_eq5d_scoreD, obs sig listwise





**# Bookmark #6

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


**# Bookmark #5

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


**# Bookmark #7

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



//preserve

keep screening zarit_score* carer_eq_vas_score* carer_eq5d_score* carer_mobility* carer_self_care* carer_usual_activ* carer_pain* carer_anxiety* stage*

reshape long zarit_score carer_eq_vas_score carer_eq5d_score carer_mobility carer_self_care carer_usual_activ carer_pain carer_anxiety stage, i(screening) j(timepoint)

tabstat zarit_score carer_eq_vas_score carer_eq5d_score carer_mobility carer_self_care carer_usual_activ carer_pain carer_anxiety if stage!=5, by(stage) stat(mean) nototal format(%8.3fc)


anova zarit_score stage
anova carer_eq_vas_score stage
anova carer_eq5d_score stage
anova carer_mobility stage
anova carer_self_care stage
anova carer_usual_activ stage
anova carer_pain stage
anova carer_anxiety stage

//restore






