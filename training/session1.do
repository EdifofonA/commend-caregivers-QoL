*************************************************
* SESSION 1: INTRODUCTION
*************************************************


****** STARTING, CLEARING AND EXITING STATA
***Datasets installed with Stata: sysuse
sysuse bplong.dta

***Datasets from Stata website: sysuse
webuse lbw


*You can resize the windows by dragging along their edges


****** FIVE BASIC STATA WINDOWS ******
***1. Command: Where you type your Stata code
*pg up and pg dn to go through command history and tab for autocomplete variable names

***2. History/review: Where your previous commands appear
*Right click to being up more options

***3. Results: Where your results are displayed
*Right click to being up more options

***4. Variables: Here is what you have in memory
*Click variable to select, double click to insert in command window, right click for more options

***5. Properties: of your data and variables
*Properties window displays variable and dataset properties



****** MENUS, DIALOG BOXES AND COMMANDS IN STATA******
***There are two ways to work

*Menus and dialog boxes
//File >>> Example datasets... >>> Example datasets installed with //Stata >>> bplong.dta  use | describe 

*Command window.
sysuse bplong.dta


***Main menu
*File
*Edit
*View
*Data
*Graphics
*Statistics
*User
*Window
*Help

***Toolbar
*Log
*Viewer
*Graph
*Dofile editor
*Data Editors
*Variables Manager
*Show more
*Break



****** DIRECTORIES IN STATA ******
*Current Working Directory - see bottom left of your screen
*The current working directory is the folder where graphs and datasets will be saved when typing commands
*Use quotation marks if there are spaces in your directory

*View path of working directory: pwd

*Change directory: cd
 								



****** OPENING AND SAVING ******
*Opening: use and use,clear
*adding the option clear will clear the Stata memory


*Saving: save and save,replace
*adding the option replace will delete any file with similar name in current directory

****** REMOVING ITEMS FROM STATA MEMORY AND DISK ******
*Clear programs, results, commands, dialog boxes, graphs: discard or clear


*Clear results window: 
cls

*clear data and labels
clear

**Colours of the do file
Green - a code that has been commented (will not run)
Blue - a Stata commanmd
Black - a variable or other kinds of text
Red - everything in quotes (e.g. variable labels, directories etc)

**Colours of the data editor
Black - continuous variables
Blue - Factor variables (categorical)
Red - String variables (text)



