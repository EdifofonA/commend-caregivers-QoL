////////////////////////////////////////////////////////////////
// SESSION 10: INTRODUCTION TO REGRESSION
////////////////////////////////////////////////////////////////

webuse lbw, clear

***Linear Regression command
regress bwt lwt
regress bwt lwt, level(99)

*convert from pounds to kg
replace lwt = lwt*0.453592

*Estimating outcome from model
regress bwt lwt, noheader

*for a 60kg woman
lincom _cons + lwt*60
regress bwt lwt, noheader
di 9.76647 + 1.96*3.777061
regress bwt lwt, noheader level(99)
di 9.76647 - 2.576*3.777061

//i. prefix means treat the variable as a categorical variable


***Logistic Regression command
*convert from pounds to kg
use lbw, clear
logit low lwt, noheader

logit low lwt
logistic low smoke

logit low smoke
lincom _cons + 1.smoke, or

logit low smoke, or
lincom _cons + 1.smoke

logistic low smoke
lincom _cons + 1.smoke

logit, level(99)

logistic low i.race
lincom _cons + 1.race
lincom _cons + 2.race

