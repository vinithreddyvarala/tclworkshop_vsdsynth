# tclworkshop_vsdsynth
# TCL WORKSHOP
__*Author: Varala Vinith Reddy*__

## INTRODUCTION

In the VLSI industry, TCL (Tool Command Language) is widely used for scripting and automation in electronic design automation (EDA) tasks. It is used for tasks such as automating design setup, simulation, synthesis, timing analysis, and verification. TCL is also used to define design constraints, integrate different EDA tools, write testbenches, perform chip testing, and customize and extend tool functionality. Overall, TCL plays a critical role in streamlining the design flow and improving productivity in the VLSI industry.

## DAY1

Written shell script that expects csv file as the input and passes it to the tcl box to do the further action.
+ When the user does not provide a csv file. The following message is displayed and the program is terminated.
  
![no csv file](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/2825f0da-6aaf-41ca-a3e1-efea73afab74)


+ When the user provides an invalid csv file. The following message is displayed and the program is terminated.
  
![wrong csv](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/42870b70-e2ed-478c-8277-9969380871e1)


+ When the user asks for help. The following data is displayed.

![help](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/78439e0f-7c88-4837-98bd-ac7de11b0dcd)


## DAY2

+ Auto Created the variable names and assigned the respective paths and files to the variables using matrix and arrays from the csv file.

  ![auto creating variable ](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/cfa43087-1d1a-445a-aeca-b92fee24a9bb)


+ Checked the existence of the files and paths provided in the csv file.
  
![validity of the files and folders](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/d0784ad8-8277-4654-b3e5-a269e59bc49e)

+ For creating the SDC format file, extracted the number of rows, columns, clock constraint start position, input constraints start position and output constraints start position from the Constraint file.
  
![finding rows and columns and start positions ](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/da173c8b-6d10-47e1-88f2-763673bf7822)


## DAY3

Clock constraints, input and output constraints from the Constraint file converted to the SDC file format for further processing

#### CLOCK CONSTRAINTS

+ Extracted the column numbers of frequency, duty cycle, early rise & fall delay, late rise & fall delay, early rise & fall slew and late rise & fall slew of the clock for adding clock latency and clock slew constraints into the SDC format file.

  

