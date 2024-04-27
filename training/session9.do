
////////////////////////////////////////////////////////////////
// SESSION 9: DESCRIPTIVES & GRAPHS II
////////////////////////////////////////////////////////////////

webuse lbw, clear
*** One countinuous variable
//Summarize with detail
summarize bwt
summarize bwt, detail

//Use a histogram with normal density plot
histogram bwt
histogram bwt, fraction
histogram bwt, percent
histogram bwt, frequency
histogram bwt, normal
histogram bwt, percent normal


//Use a Box and Whiskers plots
graph box bwt

//Use cumulative frequency plot
cumul bwt, gen(bwt_cum)
sort bwt_cum  //or sort bwt
line bwt_cum bwt
drop bwt_cum


//estimate means with confidence interval
mean bwt
mean bwt, level(99)
mean bwt, over(smoke)

//estimate medians with confidence intervals
centile bwt
centile bwt, level(99)
bys smoke: centile bwt



*** Two or more countinuous variable
//Correlation
correlate lwt bwt
correlate lwt bwt
correlate lwt bwt, means
bys smoke: correlate lwt bwt


//Use a scatter plot
twoway (scatter bwt lwt)

//Use a fitted line plot
twoway (lfit bwt lwt)

//Use scatter and lfit in one plot
twoway (scatter lwt bwt) (lfit lwt bwt)



*** One continuous and one categorical variable
//Use a scatter plot
twoway (scatter bwt race)

//Use a Box and Whiskers plots
graph box bwt, over (smoke)


*** t-test
ttest bwt, by(smoke)
ttest bwt, by(smoke) level(99)


/*
The mean birthweight among smokers is xxxx (95% CI... among nonsmokers is (95% CI....Children of Nonsmokers have xxx higher birthweight.
Our null hypoothesis is that there is no difference in ..... Our two sided ttest gives us a test statistic of 2.64 corresponding to a p-value of 0.0089.
The probability of having a difference in bwt of at least 282, if the null hypothesis were to be true is 0.0089 or 9 in 1000. We are 95% confidence that, on average, children of nonsmokers weight 71g to 494g higher than children of nonsmokers.. Next step in the interpretation is whether the difference ic clinically relevant.

