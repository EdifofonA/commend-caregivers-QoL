
lab var zarit_score carer_eq_vas_score carer_eq5d_score carer_mobility carer_self_care carer_usual_activ carer_pain carer_anxiety stage stageBin als_score als_scoreBin zarit_prop mq_psychol_score mq_exist_score mhads_anx_score mhads_anx_scoreBin mhads_dep_score mhads_dep_scoreBin participant_eq_vas_score participant_eq5d_score


/*

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



* Multivariate OLS
quietly{
collect clear
qui collect _r_b _r_ci _r_p, tag(model[`var']): regress zarit_score calc_age_c carer_female carer_university 1.rel2ppt  carer_usual_activ carer_pain carer_anxiety als_score oth_mental_yn mq_psychol_score, vce(cluster screening)
collect style cell, nformat(%5.2f)
collect style cell result[_r_p], nformat(%5.3f)
collect style cell result[_r_ci], sformat("(%s)")
collect style cell result[_r_ci], cidelimiter(,)
collect style cell result, halign(center)
}
collect layout (coleq#colname) (result[_r_b _r_ci _r_p])

