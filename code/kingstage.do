quietly{
// Using ALSFRS-R to assign King's stage as this is what Paul's model used  
// Also used Al Chalabi presentation on ENCALS training saved as Kings-Clinical-Staging-Presentation_PT.pdf
// Al Chalabi used Stages 4a and 4b and I have used 4a and 4b as Stage 4
// Algorithm main reference Reference Balendra 2014 
//  The algorithm used to calculate clinical stage from ALSFRS-R was as follows:
// 1. If a patient dropped any points on any of the three ALSFRS-R questions regarding speech (question 1), salivation (question 2) or swallowing
// (question 3), then the bulbar region was considered involved.
// 2. If a patient dropped any points on either of the two ALSFRS-R questions regarding hand function,
// which are handwriting (question 4) and ability to cut food and handle utensils (question 5A), then the upper limb region was considered
// involved.
// 3. If a patient dropped any points on the ALSFRS-R question regarding ability to walk (question 8), then the lower limb region was
// considered involved.
// 4. Question 5B on the ALSFRS-R is used to assess ability to manipulate fastenings if a patient has
// a gastrostomy. Therefore, if this question had been answered, rather than question 5A, which is only answered by patients without a gastrostomy,
// then Stage 4A had been reached.
// 5. Question 10 of the ALSFRS-R relates to dyspnoea and scoring 0 on this question indicates
// that a patient has signifi cant difficulty with dyspnoea and is considering using mechanical respiratory support. Question 12 of the ALSFRS-
// R relates to the use of Bi-level Positive Airway Pressure (BiPAP) ventilation and dropping any points on this question indicates that BiPAP is being used. 
// Therefore, if a patient scored 0 points on question 10 or less than 4 points on question 12 this indicated that Stage 4B had been reached.

** Baseline 
** At baseline there are 2 people who do not drop any point and they have not been assigned any stage.
gen stage0 = . 
lab var stage "King's Stage at baseline"

gen bulbar0 = 0 
lab var bulbar0 "Bulbar region involved"
replace bulbar0 = 1 if alsfrs_1_speech0 <4 | alsfrs_2_saliva0 <4 | alsfrs_3_swallow0 <4

gen upperlimb0 = 0
lab var upperlimb0 "Upper limbs involved"
replace upperlimb0 = 1 if alsfrs_4_handwriting0 < 4 | alsfrs_5a_food0 < 4

gen lowerlimb0 = 0
lab var lowerlimb0 "Lower limbs involved"
replace lowerlimb0 = 1 if alsfrs_8_walk0 < 4 

*** Sum across bulbar, upperlimb and lower limb and call this variable region 
egen region0 = rowtotal(bulbar0 upperlimb0 lowerlimb0)
lab var region0 "Count of regions affected to determine stages 1 to 3"
replace stage0 = 1 if region0 ==1 
replace stage0 = 2 if region0 ==2 
replace stage0 = 3 if region0 ==3 
 
*** These have to be coded after Stages 1-3 because they "trump" the previous stages 

replace stage0 = 4 if alsfrs_10_breath0 == 0 
replace stage0 = 4 if alsfrs_12_bipap0 <4  
** Any score, that is if this question has been answered
replace stage0 = 4 if alsfrs_5b_peg0 !=.

** Everyone completed baseline measures so no need to account for death 

** 6 months 

gen stage1 = . 
lab var stage1 "King's Stage at 6 months"

gen bulbar1 = 0 
lab var bulbar1 "Bulbar region involved"
replace bulbar1 = 1 if alsfrs_1_speech1 <4 | alsfrs_2_saliva1 <4 | alsfrs_3_swallow1 <4

gen upperlimb1 = 0
lab var upperlimb1 "Upper limbs involved"
replace upperlimb1 = 1 if alsfrs_4_handwriting1 < 4 | alsfrs_5a_food1 < 4

gen lowerlimb1 = 0
lab var lowerlimb1 "Lower limbs involved"
replace lowerlimb1 = 1 if alsfrs_8_walk1 < 4 

*** Sum across bulbar, upperlimb and lower limb and call this variable region 
egen region1 = rowtotal(bulbar1 upperlimb1 lowerlimb1)
lab var region1 "Count of regions affected to determine stages 1 to 3"
replace stage1 = 1 if region1 ==1 
replace stage1 = 2 if region1 ==2 
replace stage1 = 3 if region1 ==3 
 
*** These have to be coded after Stages 1-3 because they "trump" the previous stages 

replace stage1 = 4 if alsfrs_10_breath1 == 0 
replace stage1 = 4 if alsfrs_12_bipap1 <4  
** Any score, that is if this question has been answered
replace stage1 = 4 if alsfrs_5b_peg1 !=.

** need to account for those who died between baseline and 6 months  
replace stage1 = 5 if discon_stage == 2 & discon_rsn == 2 & comp_date1 == .


*** 9 months 

gen stage2 = . 
lab var stage2 "King's Stage at 9 months"

gen bulbar2 = 0 
lab var bulbar2 "Bulbar region involved"
replace bulbar2 = 1 if alsfrs_1_speech2 <4 | alsfrs_2_saliva2 <4 | alsfrs_3_swallow2 <4

gen upperlimb2 = 0
lab var upperlimb2 "Upper limbs involved"
replace upperlimb2 = 1 if alsfrs_4_handwriting2 < 4 | alsfrs_5a_food2 < 4

gen lowerlimb2 = 0
lab var lowerlimb2 "Lower limbs involved"
replace lowerlimb2 = 1 if alsfrs_8_walk2 < 4 

*** Sum across bulbar, upperlimb and lower limb and call this variable region 
egen region2 = rowtotal(bulbar2 upperlimb2 lowerlimb2)
lab var region2 "Count of regions affected to determine stages 1 to 3"
replace stage2 = 1 if region2 ==1 
replace stage2 = 2 if region2 ==2 
replace stage2 = 3 if region2 ==3 
 
*** These have to be coded after Stages 1-3 because they "trump" the previous stages 

replace stage2 = 4 if alsfrs_10_breath2 == 0 
replace stage2 = 4 if alsfrs_12_bipap2 <4  
** Any score, that is if this question has been answered
replace stage2 = 4 if alsfrs_5b_peg2 !=.

** Need to account for death 
replace stage2 = 5 if discon_stage == 3 & discon_rsn == 2 & comp_date2 == .

}
