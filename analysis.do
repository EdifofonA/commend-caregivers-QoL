**# Preambles

* Remove objects from Stata memory
clear all
cls

* Load dataset (from "data" subfolder)
use "/Volumes/HAR_WG/WG/WELLCOME_COMMEND/data/commend_master240405.dta"
capture drop _merge

* Create king stages
do "code/kingstage.do"

* Some data management
do "code/cleaning.do"


**# Table of descriptive statistics
frame change default //using the default frame

quietly{
* For caregivers
dtable calc_age_c 1.carer_female 1.carer_relationship 1.carer_employed i.rel2pptCat years_care caring_average carer_eq_vas_score0 carer_eq5d_score0 zarit_score0, nosample name(Caregivers) replace // nosample prevents sample frequency statistic

* For patients
dtable calc_age_p 1.ppt_female 1.relationship 1.ppt_employed 1.oth_anydx_yn ppt_numdx years_diag als_score0 i.stage0 mq_psychol_score0 mq_exist_score0 mhads_anx_score0 mhads_dep_score0, nosample name(Patients) replace // nosample prevents sample frequency statistic

* Combine the two tables
collect combine table1 = Patients Caregivers, replace
collect layout (collection#var) (result)

* Format mean and SD one decimal place
collect style cell result[mean sd], nformat(%8.1fc)
collect label levels result _dtable_stats "Mean (SD) or n (%)", modify

* Hide levels of indicator variables
collect style header oth_anydx_yn ppt_female ppt_employed relationship carer_female carer_employed carer_relationship, level(hide)

* Add sample sizes
collect label levels collection Patients "Patients, N=85" Caregivers "Caregivers, N=85", modify
}

* Preview and export to LaTeX
collect preview


**# Bar charts of carer outcomes by king's stages
capture frame change default //using the default frame

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
//graph combine A1 B1 C1 A2 B2 C2 A3 B3 C3, rows(3) xsize(8) ysize(6) iscale(0.6) imargin(0 3 1 1)
//graph export output/figures/outcome-kings-stage.png, width(8000) height(6000) replace
}



capture frame change default //using the default frame

quietly{

set scheme stmono2

* EQ-5D
twoway (scatter carer_eq5d_score0 als_score0, name(A1, replace) ylabel(0(0.2)1) xlabel(0(8)48) ytitle("EQ-5D index, baseline") mcolor(brown) msize(small) msymbol(circle) mfcolor(white) mlwidth(0.4) legend(off)) (lfit carer_eq5d_score0 als_score0, legend(off)), ysc(titlegap(-0.5)) nodraw

twoway (scatter carer_eq5d_score1 als_score1, name(B1, replace) ylabel(0(0.2)1) xlabel(0(8)48) ytitle("EQ-5D index, 6 months") mcolor(brown) msize(small) msymbol(circle) mfcolor(white) mlwidth(0.4) legend(off)) (lfit carer_eq5d_score1 als_score1, legend(off)), ysc(titlegap(-0.5)) nodraw

twoway (scatter carer_eq5d_score2 als_score2, name(C1, replace) ylabel(0(0.2)1) xlabel(0(8)48) ytitle("EQ-5D index, 9 months")  mcolor(brown) msize(small) msymbol(circle) mfcolor(white) mlwidth(0.4) legend(off)) (lfit carer_eq5d_score2 als_score2, legend(off)), ysc(titlegap(-0.5)) nodraw


* EQ-VAS
twoway (scatter carer_eq_vas_score0 als_score0, name(A2, replace) ylabel(0(20)100) xlabel(0(8)48) ytitle("EQ-VAS, baseline") mcolor(sienna) msize(small) msymbol(circle) mfcolor(white) mlwidth(0.4) legend(off)) (lfit carer_eq_vas_score0 als_score0, legend(off)), ysc(titlegap(-0.5)) nodraw

twoway (scatter carer_eq_vas_score1 als_score1, name(B2, replace) ylabel(0(20)100) xlabel(0(8)48) ytitle("EQ-VAS at 6 months") mcolor(sienna) msize(small) msymbol(circle) mfcolor(white) mlwidth(0.4) legend(off)) (lfit carer_eq_vas_score1 als_score1, legend(off)), ysc(titlegap(-0.5)) nodraw

twoway (scatter carer_eq_vas_score2 als_score2, name(C2, replace) ylabel(0(20)100) xlabel(0(8)48) ytitle("EQ-VAS, 9 months") mcolor(sienna) msize(small) msymbol(circle) mfcolor(white) mlwidth(0.4) legend(off)) (lfit carer_eq_vas_score2 als_score2, legend(off)), ysc(titlegap(-0.5)) nodraw


* ZBI
twoway (scatter zarit_score0 als_score0, name(A3, replace) ylabel(0(16)88) xlabel(0(8)48) ytitle("ZBI score, baseline") mcolor(emerald) msize(small) msymbol(circle) mfcolor(white) mlwidth(0.4) legend(off)) (lfit zarit_score0 als_score0, legend(off)), ysc(titlegap(-0.5)) nodraw

twoway (scatter zarit_score1 als_score1, name(B3, replace) ylabel(0(16)88) xlabel(0(8)48) ytitle("ZBI score, 6 months") mcolor(emerald) msize(small) msymbol(circle) mfcolor(white) mlwidth(0.4) legend(off)) (lfit zarit_score1 als_score1, legend(off)), ysc(titlegap(-0.5)) nodraw

twoway (scatter zarit_score2 als_score2, name(C3, replace) ylabel(0(16)88) xlabel(0(8)48) ytitle("ZBI score, 6 months") mcolor(emerald) msize(small) msymbol(circle) mfcolor(white) mlwidth(0.4) legend(off)) (lfit zarit_score2 als_score2, legend(off)), ysc(titlegap(-0.5)) nodraw

* Combined
graph combine A1 B1 C1 A2 B2 C2 A3 B3 C3, rows(3) xsize(8) ysize(7) iscale(0.6) imargin(0 3 1 1)
graph export output/figures/outcome-als-frs.png, width(8000) height(7000) replace
}




**# T-tests comparing outcomes and change in scores
frame change default //using the default frame

* ZBI score
ttest zarit_score0 == zarit_score1 //Base vs 6mo
ttest zarit_score1 == zarit_score2 //6mo vs 9mo
ttest zarit_score0 == zarit_score2 //Base vs 9mo

* EQ-VAS
ttest carer_eq_vas_score0 == carer_eq_vas_score1 //Base vs 6mo
ttest carer_eq_vas_score1 == carer_eq_vas_score2 //6mo vs 9mo
ttest carer_eq_vas_score0 == carer_eq_vas_score2 //Base vs 9mo

* EQ-5D
ttest carer_eq5d_score0 == carer_eq5d_score1 //Base vs 6mo
ttest carer_eq5d_score1 == carer_eq5d_score2 //6mo vs 9mo
ttest carer_eq5d_score0 == carer_eq5d_score2 //Base vs 9mo


**# Correlations between ZBI, EQ-5D, and EQ-VAS
frame change default //using the default frame

quietly{
* ZBI and EQ-5D
pwcorr zarit_score0 carer_eq5d_score0, obs sig
pwcorr zarit_score2 carer_eq5d_score2, obs sig
pwcorr zarit_scoreD carer_eq5d_scoreD, obs sig

* ZBI and EQ-VAS
pwcorr zarit_score0 carer_eq_vas_score0, obs sig
pwcorr zarit_score2 carer_eq_vas_score2, obs sig
pwcorr zarit_scoreD carer_eq_vas_scoreD, obs sig

* EQ-5D and EQ-VAS
pwcorr carer_eq5d_score0 carer_eq_vas_score0, obs sig
pwcorr carer_eq5d_score2 carer_eq_vas_score2, obs sig
pwcorr carer_eq5d_scoreD carer_eq_vas_scoreD, obs sig
}



**# Exploring CSRI variables
pwcorr csri_equip csri_home csri_inpat csri_outpat csri_psych, sig




// EQ5D Preferred model (below)
reg carer_eq5d_100 calc_age_c carer_female carer_employed carer_university 1.rel2ppt zarit_score als_score mq_psychol_score mq_exist_score, vce(cluster screening)
ereturn list r2_a  //0.120

// EQ5D add csri_inpat
// Only Zarit significant as before; but R2 reduces
reg carer_eq5d_100 calc_age_c carer_female carer_employed carer_university 1.rel2ppt zarit_score als_score mq_psychol_score mq_exist_score csri_equip, vce(cluster screening)
ereturn list r2_a //0.117




//ssc install estout, replace


**# Regressions for ZBI score

** Univariate OLS regression (ZBI, Pooled data)
cls

quietly{
frame change pooledLong // change to long frame

* Create list of independent variables (Pooled data)
cap vl drop varZarit
vl create varZarit = (calc_age_c carer_female carer_employed carer_university rel2ppt years_care caring_average carer_eq5d_100 carer_mobility carer_self_care carer_usual_activ carer_pain carer_anxiety als_score prebase_det_tert oth_anydx_yn ppt_numdx mq_psychol_score mq_exist_score mhads_anx_score mhads_dep_score rand_arm participant_eq5d_100 participant_mobility participant_self_care participant_usual_activ participant_pain participant_anxiety csri_equip csri_home csri_inpat csri_outpat csri_psych)

* Run univariate OLS regression

collect clear
foreach var of varlist $varZarit {
	qui collect _r_b _r_ci _r_p, tag(model[`var']): ///
	reg zarit_score  `var', vce(cluster screening)
}
collect style cell, nformat(%5.2f)
collect style cell result[_r_p], nformat(%5.3f)
collect style cell result[_r_ci], sformat("%s")
collect style cell result[_r_ci], cidelimiter(,)
collect style cell result, halign(center)
}
collect layout (coleq#colname) (result[_r_b _r_ci _r_p])


** Multivariate OLS regression (ZBI, Pooled data)

quietly{
capture frame change pooledLong // use long frame

eststo clear //clear stored estimates

* 
qui eststo: reg zarit_score calc_age_c carer_female carer_employed carer_university 1.rel2ppt als_score mq_psychol_score mq_exist_score carer_usual_activ carer_pain carer_anxiety csri_equip csri_outpat, vce(cluster screening)

qui eststo: reg zarit_score calc_age_c carer_female carer_employed carer_university 1.rel2ppt als_score mq_psychol_score carer_eq5d_100 csri_equip csri_outpat, vce(cluster screening)

qui eststo: reg zarit_score calc_age_c carer_female carer_employed carer_university 1.rel2ppt als_score mq_psychol_score carer_usual_activ carer_pain carer_anxiety participant_mobility participant_self_care participant_usual_activ csri_equip csri_outpat, vce(cluster screening)

qui eststo: reg zarit_score calc_age_c carer_female carer_employed carer_university 1.rel2ppt mq_psychol_score carer_usual_activ carer_pain carer_anxiety participant_mobility participant_self_care participant_usual_activ csri_equip csri_outpat, vce(cluster screening) // Preferred model

qui eststo: reg zarit_score calc_age_c carer_female carer_employed carer_university 1.rel2ppt mq_psychol_score carer_usual_activ carer_pain carer_anxiety participant_eq5d_100 csri_equip csri_outpat, vce(cluster screening)
}

esttab, label varwidth(32) r2 ar2 p nostar nocon cells(`b(fmt(2)) p(fmt(3))') keep(als_score mq_psychol_score carer_usual_activ carer_pain carer_anxiety carer_eq5d_100  participant_mobility participant_self_care participant_usual_activ participant_eq5d_100 csri_equip csri_outpat) nomtitles

esttab using example.tex, label varwidth(32) r2 ar2 p nostar nocon cells(`b(fmt(2)) p(fmt(3))') keep(als_score mq_psychol_score carer_usual_activ carer_pain carer_anxiety carer_eq5d_100 participant_mobility participant_self_care participant_usual_activ participant_eq5d_100 csri_equip csri_outpat) nomtitles replace


* Check independence
// We have related independence assumption by using clustered SE

// * Check multicollinearity
// vif
//
// * Check normality
// predict  rZBI, resid
// kdensity rZBI, normal
// pnorm    rZBI
//
// * Check heteroskedasticity
// rvfplot, yline(0)
//
// * Check non-linearity
// scatter rZBI calc_age_c 
// scatter rZBI als_score 
// scatter rZBI mq_psychol_score




** Multivariate Beta regression (ZBI, Pooled data)

quietly{
capture frame change pooledLong // use long frame

eststo clear //clear stored estimates

* 
qui eststo: betareg zarit_prop calc_age_c carer_female carer_employed carer_university 1.rel2ppt als_score mq_psychol_score mq_exist_score carer_usual_activ carer_pain carer_anxiety csri_equip csri_outpat if zarit_prop>0, vce(cluster screening)

qui eststo: betareg zarit_prop calc_age_c carer_female carer_employed carer_university 1.rel2ppt als_score mq_psychol_score carer_eq5d_100 csri_equip csri_outpat if zarit_prop>0, vce(cluster screening)

qui eststo: betareg zarit_prop calc_age_c carer_female carer_employed carer_university 1.rel2ppt als_score mq_psychol_score carer_usual_activ carer_pain carer_anxiety participant_mobility participant_self_care participant_usual_activ csri_equip csri_outpat if zarit_prop>0, vce(cluster screening)

qui eststo: betareg zarit_prop calc_age_c carer_female carer_employed carer_university 1.rel2ppt mq_psychol_score carer_usual_activ carer_pain carer_anxiety participant_mobility participant_self_care participant_usual_activ csri_equip csri_outpat if zarit_prop>0, vce(cluster screening) // Preferred model

qui eststo: betareg zarit_prop calc_age_c carer_female carer_employed carer_university 1.rel2ppt mq_psychol_score carer_usual_activ carer_pain carer_anxiety participant_eq5d_100 csri_equip csri_outpat if zarit_prop>0, vce(cluster screening)
}

esttab, label varwidth(32) aic bic p nostar nocon cells(`b(fmt(2)) p(fmt(3))') keep(als_score mq_psychol_score carer_usual_activ carer_pain carer_anxiety carer_eq5d_100  participant_mobility participant_self_care participant_usual_activ participant_eq5d_100 csri_equip csri_outpat) nomtitles

esttab using example.tex, label varwidth(32)aic bic p nostar nocon cells(`b(fmt(2)) p(fmt(3))') keep(als_score mq_psychol_score carer_usual_activ carer_pain carer_anxiety carer_eq5d_100 participant_mobility participant_self_care participant_usual_activ participant_eq5d_100 csri_equip csri_outpat) nomtitles replace



**# Regressions for EQ-5D index

** Univariate OLS regression (EQ-5D, Pooled data)
cls

quietly{
frame change pooledLong // change to long frame

* Create list of independent variables (Pooled data)
cap vl drop varEQ5D
vl create varEQ5D = (calc_age_c carer_female carer_employed carer_university rel2ppt years_care caring_average zarit_score als_score prebase_det_tert oth_anydx_yn ppt_numdx mq_psychol_score mq_exist_score mhads_anx_score mhads_dep_score rand_arm participant_eq5d_100 participant_mobility participant_self_care participant_usual_activ participant_pain participant_anxiety csri_equip csri_home csri_inpat csri_outpat csri_psych)

* Run univariate OLS regression
collect clear
foreach var of varlist $varEQ5D {
	qui collect _r_b _r_ci _r_p, tag(model[`var']): ///
	reg carer_eq5d_100  `var', vce(cluster screening)
}
collect style cell, nformat(%5.2f)
collect style cell result[_r_p], nformat(%5.3f)
collect style cell result[_r_ci], sformat("%s")
collect style cell result[_r_ci], cidelimiter(,)
collect style cell result, halign(center)
}
collect layout (coleq#colname) (result[_r_b _r_ci _r_p])


* Run multivariate OLS regression (EQ5D, Pooled data)

quietly{
capture frame change pooledLong // use long frame

eststo clear //clear stored estimates

qui eststo: reg carer_eq5d_100 calc_age_c carer_female carer_employed carer_university 1.rel2ppt zarit_score als_score mq_exist_score csri_equip csri_outpat participant_self_care participant_usual_activ participant_pain participant_anxiety, vce(cluster screening)

qui eststo: reg carer_eq5d_100 calc_age_c carer_female carer_employed carer_university 1.rel2ppt zarit_score  mq_exist_score csri_equip csri_outpat participant_self_care participant_usual_activ participant_pain participant_anxiety, vce(cluster screening)

qui eststo: reg carer_eq5d_100 calc_age_c carer_female carer_employed carer_university 1.rel2ppt zarit_score  csri_equip csri_outpat participant_self_care participant_usual_activ participant_pain participant_anxiety, vce(cluster screening)

qui eststo: reg carer_eq5d_100 calc_age_c carer_female carer_employed carer_university 1.rel2ppt zarit_score als_score csri_equip csri_outpat, vce(cluster screening)

qui eststo: reg carer_eq5d_100 calc_age_c carer_female carer_employed carer_university 1.rel2ppt zarit_score  participant_self_care participant_usual_activ participant_pain participant_anxiety, vce(cluster screening)

}

esttab, label varwidth(32) r2 ar2 p nostar nocon cells(`b(fmt(2)) p(fmt(3))') keep(zarit_score als_score mq_exist_score csri_equip csri_outpat participant_self_care participant_usual_activ participant_pain participant_anxiety) nomtitles

esttab using example.tex, label varwidth(32) r2 ar2 p nostar nocon cells(`b(fmt(2)) p(fmt(3))') keep(zarit_score als_score mq_exist_score csri_equip csri_outpat participant_self_care participant_usual_activ participant_pain participant_anxiety) nomtitles replace






**# Pooled carer scores by patient's functional status

capture frame change catplot // change to long frame
	
rename carer_mobility score1
rename carer_self_care score2
rename carer_usual_activ score3
rename carer_pain score4
rename carer_anxiety score5

keep if !missing(score1-score5)
gen id = _n
reshape long score, i(id) j(domain)
lab define DOMAIN 1 "MO" 2 "SC" 3 "UA" 4 "PD" 5 "AD"
lab values domain DOMAIN

drop id
decode time, gen(timepoint) 
egen category = concat(domain timepoint), punct(" ")

//ssc install catplot
catplot score, l1title("") ///
over(timepoint, gap(20) label(labgap(1) labsize(*0.7)) sort(2)) ///
over(domain, label(labgap(1) labsize(*0.7) angle(90)) ) ///
stack asyvars perc(category) ytitle("") ylabel(, labsize(small)) ///
legend(label(1 "No problems") label(2 "Slight problems") label(3 "Moderate problems") label(4 "Severe problems") label(5 "Extreme problems") cols(5) keygap(0.5) symxsize(2) size(*0.6) pos(1) bmargin(none)) ///
ysize(9) xsize(12) plotregion(margin(1 1 1 1)) graphregion(margin(1 3 0 1)) ///
bar(4, fcolor(brown) lcolor(black) lwidth(0.1)) ///
bar(3, fcolor(brown%60) lcolor(black) lwidth(0.1)) ///
bar(2, fcolor(khaki%50) lcolor(black) lwidth(0.1)) ///
bar(1, fcolor(khaki%20) lcolor(black) lwidth(0.1))

graph export output/figures/eq5d-domains-time.png, width(6000) height(4500) replace


**# Pooled carer scores by patient's functional status
* Summary statistics for carer scores by King's stage (Pooled)
capture frame change pooledLong // change to long frame
tabstat zarit_score carer_eq_vas_score ///
carer_eq5d_score carer_mobility carer_self_care ///
carer_usual_activ carer_pain carer_anxiety if stage!=5, ///
by(stage) stat(mean sd) nototal format(%8.3fc)


* ANOVA statistics for carer scores by King's stage
capture frame change pooledLong // change to long frame
foreach var of varlist zarit_score carer_eq5d_score carer_eq_vas_score carer_mobility carer_self_care carer_usual_activ carer_pain carer_anxiety {
	quietly anova `var' stage
	di "P-value for `var': 0" round(Ftail(e(df_m), e(df_r), e(F)), 0.0001)
}


**# Correlation between functional status and outcomes
// ALSFRS-R maximum score of 48 (best) and a minimum score of 0 (worst)
* Using pooled data
capture frame change pooledLong // change to long frame
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




/// What does the graph below tell?
set scheme stmono2
scatter carer_eq5d_scoreD zarit_scoreD
graph export output/figures/zarit-eq5d-scoreD.png, width(6000) height(4000) replace

