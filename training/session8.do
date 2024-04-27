////////////////////////////////////////////////////////////////
// SESSION 8: DESCRIPTIVES & GRAPHS
////////////////////////////////////////////////////////////////
webuse lbw, clear

*** One categorical variable
help tabulate oneway

**Tabulate
tab low

*Tabulate two variables separately
tab1 low race

*Tabulate over another variable
bys race: tabulate low

*Tabulate and include missing values
tab low, missing
webuse, lbw

*Tabulate without value labels
tab low, nolabel

**Use a bar graph and report percentages
graph bar, over(low)

**Use a bar graph and report actual numbers
graph bar(count), over(low)

**tabulate and produce a bar chart of the relative frequencies
tab low, plot

**display the table in descending order of frequency
tab race
tab race, sort

**Use a pie chart
graph pie, over(low)

**estimate proportions with confidence intervals
proportion anemia_cat

*** Two categorical variables
help tabulate twoway

*Tabulate
tab low race

**many of the options with one categorical variable still work
tab low race, col
tab low race, row
tab low race, missing
tab low race, nolabel

**display the table in descending order of frequency (Stata)
tab low race, colsort
tab low race, rowsort

**report the cell frequency instead of colum or row frequencies
tab low race, cell

**report the chi square
tabulate low race, chi

**report the Fischer's exact test for small samples
drop in 1/110
drop in 30/79
tabulate low race, exact

**Use a bar graph
webuse lbw, clear
graph bar, over(low) over(race)