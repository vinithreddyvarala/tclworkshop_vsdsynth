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

![clock constraints](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/1de8f922-460b-4ce8-bf0c-28507a6999d0)


+ Generated SDC format file with clock latency and clock slew constraints.
  
![clock latency and slew constraints in sdc](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/329af6bf-65a5-4e98-a889-5e06fd839a92)


#### INPUT CONSTRAINTS

+ Categorized input ports as bits and buses using NetlistDirectory. Input port is searched in the Verilog files present in NetlistDirectory. Splitted the line with ; delimiter. Multi-space is made into a single space using regular expressions, duplications are removed and added into a temporary file.
  
![differentiating bus and bit](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/bc9127ac-3e44-4647-b0ee-062a01567362)


+ The count variable stores the count of words in the file. If the count value exceeds 2, the input port is a bus else a bit.
  
![bit and bus](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/a336cb25-da9d-4f19-8e4d-f7f5b4e808e2)


+ Added input constraints into the SDC file. The input port which is a bus has * with the port name.

![sdc format for input bit and bus](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/ff7bf46e-0b9c-45a5-89ba-8f463ea7c509)


  #### OUTPUT CONSTRAINTS

+ Categorized output ports as bits and buses using NetlistDirectory. Output port is searched in the Verilog files present in NetlistDirectory. Splitted the line with; delimiter. Multi-space is made into a single space using regular expressions, duplications are removed and added into a temporary file. The count variable stores the count of words in the file. If the count value exceeds 2, the input port is a bus else a bit.

![output constraints bits and bus ](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/ff1bdd0f-bee2-4e36-8be2-6c259efee371)


+ Added output constraints into the SDC file. The output port which is a bus has * with the port name.

![sdc output constraints](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/bdacd335-e9fc-4e44-831e-2944fe29c0f4)


## HIERARCHY CHECK 

+ Created .ys file which checks the hierarchy of the entire design.

![yosys file for hierarchy](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/efc963b8-6f08-4952-84c9-06c9078f36fc)


+ The .ys file is passed to the `YOSYS` tool and generates a log file associated with it. Since all .v files exist in the top module no errors are found.

![hierarchy check pass updated](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/ff21c0e0-7c47-403a-a480-689b0d2c4fe6)


+ Modified one of the .v file names in the top module to check the script's functionality. The following output is displayed i.e. error occurs.

![hierarchy failed check updated](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/8cc307d2-1373-49bf-888e-c411d449d2c3)


+ The log file contains the error as follows

![log file showing errror](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/8c81e9ea-f2f1-496c-b29a-981b1afe90ab)


#### MAIN SYNTHESIS 

+ Created final .ys file for synthesis and passed to the `YOSYS` tool and generated synth.v file.
  
![synth pass](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/ba7e74bc-1797-40e5-ab73-e47ce8aa1672)


+ Modified one of the .v file names in the top module to check the script's functionality. The following output is displayed i.e. error occurs

![synthesis failed](https://github.com/vinithreddyvarala/tclworkshop_vsdsynth/assets/138814647/d6f89417-6708-4a18-8c3c-36cbdbe5fc0f)


+ 


 


