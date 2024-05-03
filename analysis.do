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

* Carer EQ-VAS by stage
quietly{
graph bar carer_eq_vas_score0 if stage0 !=5, over(stage0) name(A2, replace) ytitle(EQ-VAS score) nodraw ylabel(0(20)100)
graph bar carer_eq_vas_score1 if stage1 !=5, over(stage1) name(B2, replace) ytitle(EQ-VAS score) nodraw ylabel(0(20)100)
graph bar carer_eq_vas_score2 if stage2 !=5, over(stage2) name(C2, replace) ytitle(EQ-VAS score) nodraw ylabel(0(20)100)
// nodraw prevents the graph from popping up
}
//graph combine A2 B2 C2, ycommon xsize(4) ysize(1.5) rows(1) imargin(2 2 0 0) name(eqvasKings, replace)

* Carer EQ-5D by stage
quietly{
graph bar carer_eq5d_score0 if stage0 !=5, over(stage0) name(A1, replace) ytitle(EQ-5D score) nodraw ylabel(0(0.2)1)
graph bar carer_eq5d_score1 if stage1 !=5, over(stage1) name(B1, replace) ytitle(EQ-5D score) nodraw ylabel(0(0.2)1)
graph bar carer_eq5d_score2 if stage2 !=5, over(stage2) name(C1, replace) ytitle(EQ-5D score) nodraw ylabel(0(0.2)1)
// nodraw prevents the graph from popping up
}
//graph combine A1 B1 C1, ycommon xsize(4) ysize(1.5) rows(1) imargin(2 2 0 0) name(eq5dKings, replace)

* Carer ZBI by stage
quietly{
graph bar zarit_score0 if stage0 !=5, over(stage0) name(A3, replace) ytitle(ZBI score) b1title("Stage at baseline") nodraw ylabel(0(5)25)
graph bar zarit_score0 if stage1 !=5, over(stage1) name(B3, replace) ytitle(ZBI score) b1title("Stage at 6 months") nodraw ylabel(0(5)25)
graph bar zarit_score0 if stage2 !=5, over(stage2) name(C3, replace) ytitle(ZBI score) b1title("Stage at 9 months") nodraw ylabel(0(5)25)
// nodraw prevents the graph from popping up
}
//graph combine A3 B3 C3, ycommon xsize(4) ysize(1.5) rows(1) imargin(2 2 0 0) name(zbiKings, replace) 

graph combine A1 B1 C1 A2 B2 C2 A3 B3 C3, rows(3) xsize(8) ysize(6) iscale(0.6) imargin(0 3 1 1)
graph export output/outcomeKings.png, width(8000) height(6000) replace

//graph combine eqvasKings eq5dKings zbiKings, rows(3) xsize(7) ysize(6) iscale(0.75) imargin(0 0 1 1)
