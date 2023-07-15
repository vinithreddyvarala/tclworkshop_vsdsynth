#.......................................................................#
#.......Script for creating variables...............................#
#..................................................................#

set pre_layout_timing 1

set filename [lindex $argv 0]
puts "filename $filename"
package require csv
package require struct::matrix
struct::matrix m
set f [open $filename]
csv::read2matrix $f m , auto
close $f
m link my_arr
set no_of_rows [m rows]
puts "no_of_rows: $no_of_rows"
for {set i 0} {$i< $no_of_rows} {incr i} {
	puts "Info: Assigning $my_arr(1,$i) to $my_arr(0,$i) "
       
	if {[string match "./*" $my_arr(1,$i)]} {
		set [string map {" " ""} $my_arr(0,$i)]  [file normalize $my_arr(1,$i)]   
        } else {
       	        set [string map {" " ""} $my_arr(0,$i)]  $my_arr(1,$i)  

        }
        
}

puts "DesignName $DesignName"
puts "OutputDirectory $OutputDirectory"
puts "NetlistDirectory $NetlistDirectory"
puts "EarlyLibraryPath $EarlyLibraryPath"
puts "LateLibraryPath $LateLibraryPath"
puts "ConstraintsFile $ConstraintsFile"


#......................................................................#
#......Script for checking existence of the files mentioned in csv.....#
#.....................................................................#


if {[file isdirectory $OutputDirectory]}  {
	puts "Info: output directory i.e. $OutputDirectory exists"
} else {
	puts "Info:output directory i.e. $OutputDirectory doesnot exist. Creating $OutputDirectory"
	file mkdir $OutputDirectory
}

if {[file isdirectory $NetlistDirectory]} {
	puts "Info: netlist directory i.e. $NetlistDirectory exists"
} else {
	puts "Error: netlist directory i.e. $NetlistDirectory doesnot exists"
	exit
}

if {[file exists $EarlyLibraryPath]} {
	puts "Info: Early cell lib i.e. $EarlyLibraryPath exists"
} else {
	puts "Error: Early cell lib i.e. $EarlyLibraryPath doesnot exists"
	exit
}

if {[file exists $LateLibraryPath]} {
	puts "Info: Late cell lib i.e. $LateLibraryPath exists"
} else {
        puts "Error: Late cell lib i.e. $LateLibraryPath doesnot exists"
        exit
}
if {[file exists $ConstraintsFile]} {
	puts "Info: Constraint file i.e. $ConstraintsFile exists"
} else {
	puts "Error: Constraint file i.e. $ConstraintsFile doesnot exists"
	exit
}

#.....................................................................#
#.........Creating SDC format using constraint file...................#
#....................................................................#
puts "Creating SDC format file using Constraint file"

struct::matrix constraints
set chan [open $ConstraintsFile]
csv::read2matrix $chan constraints , auto

close $chan

set no_rows [constraints rows]
puts "no_rows = $no_rows"
set no_columns [constraints columns]
puts "no_columns = $no_columns"
set clock_start_row [lindex [lindex [constraints search all CLOCKS] 0] 1]
puts "clock_start_row = $clock_start_row"
set clock_start_column [lindex [lindex [constraints search all CLOCKS] 0] 0]
puts "clock_start_column = $clock_start_column"
set input_start_row [lindex [lindex [constraints search all INPUTS] 0] 1]
puts "input_start_row = $input_start_row"
set output_start_row [lindex [lindex [constraints search all OUTPUTS] 0] 1]
puts "output_start_row = $output_start_row"

#.....................................................................#
#.......................Creating clock constraints.....................#
#.....................................................................#

puts "Working on Clock constraints and dumping into SDC" 

set clock_frequency_column_start  [lindex [lindex  [constraints search rect $clock_start_column $clock_start_row [expr $no_columns-1]  $clock_start_row  frequency ] 0] 0]
puts "clock_frequency_column_start = $clock_frequency_column_start"
set clock_duty_cycle_column_start  [lindex [lindex  [constraints search rect $clock_start_column $clock_start_row [expr $no_columns-1]  $clock_start_row  duty_cycle ] 0] 0]
puts "clock_duty_cycle_column_start = $clock_duty_cycle_column_start"
set clock_early_rise_delay_column_start  [lindex [lindex  [constraints search rect $clock_start_column $clock_start_row [expr $no_columns-1]  $clock_start_row  early_rise_delay ] 0] 0]
puts "clock_early_rise_delay_column_start = $clock_early_rise_delay_column_start"
set clock_early_fall_delay_column_start  [lindex [lindex  [constraints search rect $clock_start_column $clock_start_row [expr $no_columns-1]  $clock_start_row  early_fall_delay ] 0] 0]
puts "clock_early_fall_delay_column_start = $clock_early_fall_delay_column_start"
set clock_late_rise_delay_column_start    [lindex  [lindex  [constraints search rect $clock_start_column $clock_start_row  [expr $no_columns-1] $clock_start_row late_rise_delay ] 0] 0]
puts "clock_late_rise_delay_column_start = $clock_late_rise_delay_column_start"
set clock_late_fall_delay_column_start    [lindex  [lindex  [constraints search rect $clock_start_column $clock_start_row  [expr $no_columns-1] $clock_start_row late_fall_delay ] 0] 0]
puts "clock_late_fall_delay_column_start = $clock_late_fall_delay_column_start"
set clock_early_rise_slew_column_start  [lindex [lindex  [constraints search rect $clock_start_column $clock_start_row [expr $no_columns-1]  $clock_start_row  early_rise_slew ] 0] 0]
puts "clock_early_rise_slew_column_start = $clock_early_rise_slew_column_start"
set clock_early_fall_slew_column_start  [lindex [lindex  [constraints search rect $clock_start_column $clock_start_row [expr $no_columns-1]  $clock_start_row  early_fall_slew ] 0] 0]
puts "clock_early_fall_slew_column_start = $clock_early_fall_slew_column_start"
set clock_late_rise_slew_column_start    [lindex  [lindex  [constraints search rect $clock_start_column $clock_start_row  [expr $no_columns-1] $clock_start_row late_rise_slew ] 0] 0]
puts "clock_late_rise_slew_column_start = $clock_late_rise_slew_column_start"
set clock_late_fall_slew_column_start [lindex [lindex [constraints search rect $clock_start_column $clock_start_row [expr $no_columns-1] $clock_start_row late_fall_slew] 0] 0]
puts "clock_late_fall_slew_column_start = $clock_late_fall_slew_column_start"

set sdcfile [open outdir_openMSP430/openMSP430.sdc "w"]
for {set i [expr $clock_start_row + 1]} {$i < [expr $input_start_row - 1]} {incr i} {
	puts -nonewline  $sdcfile "\n create_clock -name [constraints get cell $clock_start_column $i] -period [constraints get cell $clock_frequency_column_start $i] -waveform {0 [expr [constraints get cell $clock_frequency_column_start $i]* [constraints get cell $clock_duty_cycle_column_start $i]/100 ]} \[get_ports [constraints get cell $clock_start_column $i]\]  "
        puts -nonewline $sdcfile "\n set_clock_transition -rise -min [constraints get cell $clock_early_rise_slew_column_start $i] \[get_clocks [constraints get cell $clock_start_column $i]\]"
	puts -nonewline $sdcfile "\n set_clock_transition -fall -min [constraints get cell $clock_early_fall_slew_column_start $i] \[get_clocks [constraints get cell $clock_start_column $i]\]"
        puts -nonewline $sdcfile "\n set_clock_transition -rise -max [constraints get cell $clock_late_rise_slew_column_start $i] \[get_clocks [constraints get cell $clock_start_column $i]\]"
        puts -nonewline $sdcfile "\n set_clock_transition -fall -max [constraints get cell $clock_late_fall_slew_column_start $i] \[get_clocks [constraints get cell $clock_start_column $i]\]"
	puts -nonewline $sdcfile "\n set_clock_latency -source -early -rise [constraints get cell $clock_early_rise_delay_column_start $i] \[get_clocks [constraints get cell $clock_start_column $i]\]"       
	puts -nonewline $sdcfile "\n set_clock_latency -source -early -fall [constraints get cell $clock_early_fall_delay_column_start $i] \[get_clocks [constraints get cell $clock_start_column $i]\]"
        puts -nonewline $sdcfile "\n set_clock_latency -source -late -rise [constraints get cell $clock_late_rise_delay_column_start $i] \[get_clocks [constraints get cell $clock_start_column $i]\]"
	puts -nonewline $sdcfile "\n set_clock_latency -source -late -fall [constraints get cell $clock_late_fall_delay_column_start $i] \[get_clocks [constraints get cell $clock_start_column $i]\]"
}

puts "Dumping clock constraints into SDC file completed"


#...........................................................................#
#.............Adding input constraints into SDC.............................#
#..........................................................................#

set input_early_rise_delay [lindex [lindex [constraints search rect 0 $input_start_row [expr $no_columns -1 ] $input_start_row early_rise_delay] 0] 0]
set input_early_fall_delay [lindex [lindex [constraints search rect 0 $input_start_row [expr $no_columns -1 ] $input_start_row early_fall_delay] 0] 0]
set input_late_rise_delay [lindex [lindex [constraints search rect 0 $input_start_row [expr $no_columns -1 ] $input_start_row late_rise_delay] 0] 0]
set input_late_fall_delay [lindex [lindex [constraints search rect 0 $input_start_row [expr $no_columns -1 ] $input_start_row late_fall_delay] 0] 0]
set input_early_rise_slew [lindex [lindex [constraints search rect 0 $input_start_row [expr $no_columns -1 ] $input_start_row early_rise_slew] 0] 0]
set input_early_fall_slew [lindex [lindex [constraints search rect 0 $input_start_row [expr $no_columns -1 ] $input_start_row early_fall_slew] 0] 0]
set input_late_rise_slew [lindex [lindex [constraints search rect 0 $input_start_row [expr $no_columns -1 ] $input_start_row late_rise_slew] 0] 0]
set input_late_fall_slew [lindex [lindex [constraints search rect 0 $input_start_row [expr $no_columns -1 ] $input_start_row late_fall_slew] 0] 0]
set input_clocks [lindex [lindex [constraints search rect 0 $input_start_row [expr $no_columns -1 ] $input_start_row clocks] 0] 0]

#puts "inputss.....$input_early_rise_delay $input_early_fall_delay $input_late_rise_delay $input_late_fall_delay $input_early_rise_slew $input_early_fall_slew $input_late_rise_slew $input_late_fall_slew"

#....figuring out one bit and multibit signals from the netlist..................#


for {set i [expr $input_start_row +1 ]} { $i < [expr $output_start_row -1] } {incr i} {
	set netlist [glob dir $NetlistDirectory/*.v]
	set tempfile [open /tmp/1 "w"]
	foreach f $netlist {
		
		set fo [open $f]
		
		while {[gets $fo line] != -1 }  {
			set pattern1 " [constraints get cell $clock_start_column $i];"
			if {[regexp -all $pattern1 $line]} {
				set pattern2 [lindex [split $line ";"] 0 ]
				if { [regexp -all {input}  [lindex [split $pattern2 "\S+"] 0 ]] } {
				        #set s1 [regexp -all -inline {\S+} $pattern2]
					#puts -nonewline  $tempfile "\n $s1   "
					set s1 " [lindex [split $pattern2 "\S+"] 0]  [lindex [split $pattern2 "\S+"] 1]  [lindex [split $pattern2 "\S+"] 2]"
					#puts "s1 content : $s1"
					puts -nonewline $tempfile "\n [regsub -all {\s+} $s1 " "]"
				       	#puts "\n ...... $pattern2 "
					#puts -nonewline $tempfile "\n $pattern2"
					#puts $tempfile "$s1"	
				}
			}
               
		}
		close $fo
	}
	close $tempfile
set tempfile [open /tmp/1 r]
set tempfile2 [open /tmp/2 w]
puts -nonewline $tempfile2 " [join  [lsort -unique [split [read $tempfile] \n]] \n]"

close $tempfile
close $tempfile2

#set tempfile2 [open /tmp/2 r]
#puts " file content [read $tempfile2] "
#close $tempfile2

set tempfile2 [open /tmp/2 r]
set count  [llength [read $tempfile2]]
#puts "count: $count"
if {$count > 2} {
	set inp_port [concat [constraints get cell 0 $i]*]
	puts " inp_port $inp_port is a bus i.e. count : $count"
} else {
	set inp_port [constraints get cell 0 $i]
	puts "inp_port $inp_port is a single bit i.e count: $count"
}
close $tempfile2

	puts -nonewline $sdcfile "\n set_input_delay -clock \[get_clocks [constraints get cell $input_clocks $i]\] -min -rise -source_latency_included [constraints get cell $input_early_rise_delay $i] \[get_ports $inp_port\]    "  

	puts -nonewline $sdcfile "\n set_input_delay -clock \[get_clocks [constraints get cell $input_clocks $i]\] -min -fall -source_latency_included [constraints get cell $input_early_fall_delay $i] \[get_ports $inp_port\]    "

        puts -nonewline $sdcfile "\n set_input_delay -clock \[get_clocks [constraints get cell $input_clocks $i]\] -max -rise -source_latency_included [constraints get cell $input_late_rise_delay $i] \[get_ports $inp_port\]    "

	puts -nonewline $sdcfile "\n set_input_delay -clock \[get_clocks [constraints get cell $input_clocks $i]\] -max -fall -source_latency_included [constraints get cell $input_late_fall_delay $i] \[get_ports $inp_port\]    "
	
        puts -nonewline $sdcfile "\n set_input_transition -clock \[get_clocks [constraints get cell $input_clocks $i]\] -min -rise -source_latency_included [constraints get cell $input_early_rise_slew $i] \[get_ports $inp_port\]    "
    
	puts -nonewline $sdcfile "\n set_input_transition -clock \[get_clocks [constraints get cell $input_clocks $i]\] -min -fall -source_latency_included [constraints get cell $input_early_fall_slew $i] \[get_ports $inp_port\]    "

	puts -nonewline $sdcfile "\n set_input_transition -clock \[get_clocks [constraints get cell $input_clocks $i]\] -max -rise -source_latency_included [constraints get cell $input_late_rise_slew $i] \[get_ports $inp_port\]    "

	puts -nonewline $sdcfile "\n set_input_transition -clock \[get_clocks [constraints get cell $input_clocks $i]\] -max -fall -source_latency_included [constraints get cell $input_late_fall_slew $i] \[get_ports $inp_port\]    "

}
puts "Completed adding  Inputs constraints to SDC file "

#.............................................................................#
#....................Output Constraints.......................................#
#............................................................................#

puts " Working on adding output constraints to SDC file"

set output_early_rise_delay [lindex [lindex [constraints search rect 0 $output_start_row [expr $no_columns -1 ] $output_start_row early_rise_delay] 0] 0]
set output_early_fall_delay [lindex [lindex [constraints search rect 0 $output_start_row [expr $no_columns -1 ] $output_start_row early_fall_delay] 0] 0]
set output_late_rise_delay [lindex [lindex [constraints search rect 0 $output_start_row [expr $no_columns -1 ] $output_start_row late_rise_delay] 0] 0]
set output_late_fall_delay [lindex [lindex [constraints search rect 0 $output_start_row [expr $no_columns -1 ] $output_start_row late_fall_delay] 0] 0]
set output_load [lindex [lindex [constraints search rect 0 $output_start_row [expr $no_columns -1 ] $output_start_row load] 0] 0]
set output_clocks [lindex [lindex [constraints search rect 0 $output_start_row [expr $no_columns -1 ] $output_start_row clocks] 0] 0]

puts " $output_early_rise_delay $output_early_fall_delay $output_late_rise_delay $output_late_fall_delay $output_load $output_clocks"


for {set i [expr $output_start_row +1 ]} { $i < $no_rows} {incr i} {
        set netlist [glob dir $NetlistDirectory/*.v]
        set tempfile [open /tmp/1 "w"]
        foreach f $netlist {

                set fo [open $f]

                while {[gets $fo line] != -1 }  {
                        set pattern1 " [constraints get cell $clock_start_column $i];"
                        if {[regexp -all $pattern1 $line]} {
                                set pattern2 [lindex [split $line ";"] 0 ]
                                if { [regexp -all {output}  [lindex [split $pattern2 "\S+"] 0 ]] } {
                                        #set s1 [regexp -all -inline {\S+} $pattern2]
                                        #puts -nonewline  $tempfile "\n $s1   "
                                        set s1 " [lindex [split $pattern2 "\S+"] 0]  [lindex [split $pattern2 "\S+"] 1]  [lindex [split $pattern2 "\S+"] 2]"
                                        #puts "s1 content : $s1"
                                        puts -nonewline $tempfile "\n [regsub -all {\s+} $s1 " "]"
                                        #puts "\n ...... $pattern2 "
                                        #puts -nonewline $tempfile "\n $pattern2"
                                        #puts $tempfile "$s1"   
                                }
                        }

                }
                close $fo
        }
        close $tempfile
set tempfile [open /tmp/1 r]
set tempfile2 [open /tmp/2 w]
puts -nonewline $tempfile2 " [join  [lsort -unique [split [read $tempfile] \n]] \n]"

close $tempfile
close $tempfile2

#set tempfile2 [open /tmp/2 r]
#puts " file content [read $tempfile2] "
                                                                                                                                   
set tempfile2 [open /tmp/2 r]
set count  [llength [read $tempfile2]]
#puts "count: $count"
if {$count > 2} {
        set out_port [concat [constraints get cell 0 $i]*]
        puts " out_port $out_port is a bus i.e. count : $count"
} else {
        set out_port [constraints get cell 0 $i]
        puts "out_port $out_port is a single bit i.e count: $count"
}
close $tempfile2

        puts -nonewline $sdcfile "\n set_output_delay -clock \[get_clocks [constraints get cell $output_clocks $i]\] -min -rise -source_latency_included [constraints get cell $output_early_rise_delay $i] \[get_ports $out_port\]    "
 
        puts -nonewline $sdcfile "\n set_output_delay -clock \[get_clocks [constraints get cell $output_clocks $i]\] -min -fall -source_latency_included [constraints get cell $output_early_fall_delay $i] \[get_ports $out_port\]    "

        puts -nonewline $sdcfile "\n set_output_delay -clock \[get_clocks [constraints get cell $output_clocks $i]\] -max -rise -source_latency_included [constraints get cell $output_late_rise_delay $i] \[get_ports $out_port\]    "

        puts -nonewline $sdcfile "\n set_output_delay -clock \[get_clocks [constraints get cell $output_clocks $i]\] -max -fall -source_latency_included [constraints get cell $output_late_fall_delay $i] \[get_ports $out_port\]    "


        puts -nonewline $sdcfile "\n set_load [constraints get cell $output_load $i] \[get_ports $out_port\]    "

}

close $sdcfile
puts " Completed adding output constraints to SDC file"

#..........................................................#
#..................Heirarchy check.........................#
#..........................................................#

puts " Doing Heirarchial checks......"
set file_hier [open $OutputDirectory/openMSP430.hier.ys w]
#puts -nonewline $file_hier "\n read_liberty -lib -ignore_miss_dir -setattr [file normalize $LateLibraryPath] "
puts -nonewline $file_hier "\n read_liberty -lib -ignore_miss_dir -setattr blackbox $LateLibraryPath "

set netlist [glob dir $NetlistDirectory/*.v]
foreach f $netlist {
	puts -nonewline $file_hier "\n read_verilog $f"

}
puts -nonewline $file_hier "\n hierarchy -check"
close $file_hier

set error_flag [catch {exec yosys -s $OutputDirectory/openMSP430.hier.ys >& $OutputDirectory/openMSP430.hierarchy_check.log} msg]
puts "error_flag :$error_flag"



if {$error_flag} {
	set file_hier_check [open $OutputDirectory/openMSP430.hierarchy_check.log r]
	#puts $file_hier_check
	#return
	set pattern {referenced in module}
	while {[gets $file_hier_check line] != -1} {
		if {[regexp -all $pattern $line]} {
			puts "The file i.e [lindex $line 2] is not part of hierarchy "
                        puts " Hierarchy check FAILED ...................."
		}


	}
	close $file_hier_check


} else {
       	puts " Hierarchy check PASS......"

}
puts "Info: Please refer the log file generated i.e. $OutputDirectory/openMSP430.hierarchy_check.log"


#.....................................................................#
#..................Synthesis SCRIPT...................................#
#.....................................................................#


set file_synth [open $OutputDirectory/openMSP430.ys w]
puts -nonewline $file_synth "\nread_liberty -lib -ignore_miss_dir -setattr blackbox [file normalize $LateLibraryPath]"
set netlist [glob dir $NetlistDirectory/*.v]

foreach f $netlist {
	puts -nonewline $file_synth "\nread_verilog $f"
	
}

puts -nonewline $file_synth "\nhierarchy -top $DesignName \nsynth -top $DesignName \nsplitnets -ports -format ___ "
puts -nonewline $file_synth "\ndfflibmap -liberty [file normalize $LateLibraryPath]"
puts -nonewline $file_synth "\nopt \nabc -liberty [file normalize $LateLibraryPath] \nflatten \nclean -purge \niopadmap -outpad BUFX2 A:Y -bits \nopt \nclean "
puts -nonewline $file_synth "\nwrite_verilog $OutputDirectory/$DesignName.synth.v"
close $file_synth
if { [catch {exec yosys -s $OutputDirectory/openMSP430.ys >& $OutputDirectory/$DesignName.synth.log}]} {
	puts "Error: Synthesis Failed....."

} else {
	puts "Info :Synthesis successful......"
}
puts "Info: Refer the log file i.e.$OutputDirectory/$DesignName.synth.log"

#.......................................................#
#.........format[2] Synthesis file ........................#
#........................................................#

puts "Info: Updating synthesis file i.e. $OutputDirectory/$DesignName.synth.v into format_2"
set temp1 [open /tmp/1 "w"]
puts $temp1 [exec grep -v -w "*" $OutputDirectory/$DesignName.synth.v]
close $temp1

set f2 [open $OutputDirectory/$DesignName.final.synth.v w]
set temp1 [open /tmp/1 r]
while { [gets $temp1 line] != -1} {
	puts $f2 [string map {"\\" ""} $line]
}
close $temp1
close $f2
puts "Info: Final synthesis file is ready......i.e. $OutputDirectory/$DesignName.final.synth.v "



#............................................#
#...................STA......................#
#............................................#  

source /home/vsduser/vvr/vsdsynth/procs/my_reopenStdout.proc
#set config_file [open $OutputDirectory/$DesignName.my.config w]
my_reopenStdout $OutputDirectory/$DesignName.my.config
source /home/vsduser/vvr/vsdsynth/procs/my_set_num_threads.proc

set_multi_cpu_usage -localcpu 4

source /home/vsduser/vvr/vsdsynth/procs/my_read_lib.proc

my_read_lib -early  osu018_stdcells.lib

my_read_lib -late osu018_stdcells.lib

source /home/vsduser/vvr/vsdsynth/procs/my_read_verilog.proc

my_read_verilog $OutputDirectory/$DesignName.final.synth.v

source /home/vsduser/vvr/vsdsynth/procs/my_read_sdc.proc

my_read_sdc $OutputDirectory/$DesignName.sdc

my_reopenStdout /dev/tty

if {$pre_layout_timing ==1} {

	set spef_file [open $OutputDirectory/$DesignName.spef w]
	puts $spef_file "*SPEF \"IEEE 1481-1998\" "
	puts $spef_file "*DESIGN \"$DesignName\" "
	puts $spef_file "*DATE \"Tue July 11 12:33:00 2023\" "
	puts $spef_file "*VENDOR \"TAU 2015 Contest\" "
	puts $spef_file "*PROGRAM \"Benchmark Parasitic Generator\" "
	puts $spef_file "*VERSION \"0.0\" "
	puts $spef_file "*DESIGN_FLOW \"NETLIST_TYPE_VERILOG\" "
	puts $spef_file "*DIVIDER / "
	puts $spef_file "*DELIMITER : "
	puts $spef_file "*BUS_DELIMITER []"
	puts $spef_file "*T_UNIT 1 PS "
	puts $spef_file "*C_UNIT 1 FF "
	puts $spef_file "*R_UNIT 1 KOHM "
	puts $spef_file "L_UNIT 1UH "



}

close $spef_file
set config_file [open $OutputDirectory/$DesignName.my.config a ]
puts $config_file "set_spef_fpath $OutputDirectory/$DesignName.spef"
puts $config_file "init_timer "
puts $config_file "report_timer "
puts $config_file "report_wns "
puts $config_file "report_worst_paths -numPaths 10000 "
close $config_file

#close $OutputDirectory/$DesignName.my.config
puts " HI..........."

set time_taken_us [time {exec /home/vsduser/OpenTimer-1.0.5/bin/OpenTimer < $OutputDirectory/$DesignName.my.config >& $OutputDirectory/$DesignName.my.results  } ]
puts "Info : time_taken_us $time_taken_us"
set time_taken_sec "[expr [lindex $time_taken_us 0]/100000]sec"
puts "Info : time_taken_sec $time_taken_sec"





#................................................................................#



set results_file [open  $OutputDirectory/openMSP430.my.results r]
set RAT_slack "-"
while {[gets $results_file line]!= -1} {

        if {[regexp {RAT} $line]} {
                set RAT_slack "[expr [lindex $line 3]/1000]ns"
                break
        } else {
                continue
        }
        

}
puts "Info :  RAT_slack  $RAT_slack"
close $results_file

set results_file [open  $OutputDirectory/openMSP430.my.results r]
set count 0
while {[gets $results_file line]!= -1} {

        incr count [regexp  {RAT} $line]
        

}
close $results_file

set RAT_count $count

puts "Info : RAT_count = $RAT_count"

#.............................................................................#

set results_file [open  $OutputDirectory/openMSP430.my.results r]
set setup_slack "-"
while {[gets $results_file line]!= -1} {

        if {[regexp {Setup} $line]} {
                set setup_slack "[expr [lindex $line 3]/1000]ns"
                break
        } else {
                continue
        }
        

}
puts "Info :  Setup_slack $setup_slack"
close $results_file

set results_file [open  $OutputDirectory/openMSP430.my.results r]
set count 0
while {[gets $results_file line]!= -1} {

        incr count [regexp  {Setup} $line]
        

}
close $results_file

set setup_slack_count $count

puts "Info : setup_slack_count = $setup_slack_count"

#...........................................................#


set results_file [open  $OutputDirectory/openMSP430.my.results r]
set hold_slack "-"
while {[gets $results_file line]!= -1} {

        if {[regexp {Hold} $line]} {
                set hold_slack "[expr [lindex $line 3]/1000]ns"
                break
        } else {
                continue
        }
        

}
puts "Info :  Hold_slack  $hold_slack"
close $results_file

set results_file [open  $OutputDirectory/openMSP430.my.results r]
set count 0
while {[gets $results_file line]!= -1} {

        incr count [regexp  {Hold} $line]
        

}
close $results_file

set hold_slack_count $count

puts "Info : hold_slak_count = $hold_slack_count"

#...................................................................#


set results_file [open  $OutputDirectory/openMSP430.my.results r]
set no_of_gates "-"
while {[gets $results_file line]!= -1} {

        if {[regexp {Num of gates} $line]} {
                set no_of_gates "[lindex $line 4]"
                break
        } else {
                continue
        }


}
puts "Info :  No_of_gates  $no_of_gates"
close $results_file

#...........................................................#

set format_str {%15s%15s%15s%15s%15s%15s%15s%15s%15s }
puts "                                                                          *PRELAYOUT TIMING REPORT*                   "


puts [format $format_str "----------------"  "----------"   "---------------"   "---------------"   "------------"   "---------"    "----------"      "--------------------------"   "------------"]
puts [format $format_str "Design Name"       " Runtime  "   " Instance Count "   " WNS setup    "   " FEP setup  "   " WNS hold "   " FEP hold "        "     WNS RAT            "    " FEP RAT   "] 
puts [format $format_str "----------------"  "----------"   "---------------"   "---------------"   "------------"   "---------"    "----------"      "---------------------------"  "------------"]
foreach designname $DesignName runtime $time_taken_sec instancecount $no_of_gates wns_setup $setup_slack fep_setup $setup_slack_count wns_hold $hold_slack fep_hold $hold_slack_count wns_rat $RAT_slack fep_rat $RAT_count {


puts [format $format_str $designname $runtime $instancecount $wns_setup $fep_setup $wns_hold $fep_hold $wns_rat $fep_rat ]

}





