proc my_read_sdc {arg} {

set sdc_dirname [file dirname $arg ]
set sdc_filename [lindex [split [file tail $arg] .] 0]
#puts " sdc_dirname: $sdc_dirname, sdc_filename:  $sdc_filename "
set tmpfile [open /tmp/1 w]
set f [open $arg r]
puts -nonewline $tmpfile "[string map { "\[" "" "\]" " "} [read  $f]]"
close $tmpfile
close $f

set tmpfile [open /tmp/1 r]
set timingfile [open /tmp/3 w]
set lines [split [read $tmpfile] "\n"]
set create_clock_line [lsearch -all -inline  $lines " create_clock*"]
#puts "cr: $create_clock_line"
foreach elem $create_clock_line {
	set clock_port [lindex $elem [expr [lsearch $elem "get_ports"]+1]]
	set clock_period [lindex $elem [expr [lsearch $elem "-period"]+1]]
	set clock_duty_cycle [expr 100- [expr [lindex [ lindex $elem  [expr [lsearch $elem "-waveform"]+1]] 1] *100/$clock_period]]
        #puts "\nclock $clock_port $clock_period $clock_duty_cycle"
	puts -nonewline $timingfile "\nclock $clock_port $clock_period $clock_duty_cycle"

}
close $tmpfile

set tmpfile2 [open /tmp/2 w]
set set_clock_latency [lsearch -all -inline $lines " set_clock_latency*"]
#puts $set_clock_latency
set new_port_name ""
foreach elem $set_clock_latency {
	
	set port_name [lindex $elem [expr [lsearch $elem "get_clocks"]+1]]
	#puts $port_name
	if {![string match $new_port_name $port_name]} {
		set new_port_name $port_name
		set ports [lsearch -all -inline $set_clock_latency  "*$port_name "]
	        #puts "ports:$ports"
		set delay_values ""
		foreach item $ports {
		
			lappend  delay_values [lindex $item [expr [lsearch $item "get_clocks"]-1]]
			#puts "delay_values : $delay_values"

	}
		#puts "\nat $port_name $delay_values"
		puts -nonewline $tmpfile2 "\nat $port_name $delay_values"

}

}

close $tmpfile2

set tmpfile2 [open /tmp/2 r]
puts -nonewline $timingfile "[read $tmpfile2]"
close $tmpfile2





#........................................................................#

set tmpfile2 [open /tmp/2 w]
set clock_trans [lsearch -all -inline $lines " set_clock_transition*"]
#puts "clk_trans $clock_trans"

set new_port_name ""
foreach elem $clock_trans {

        set port_name [lindex $elem [expr [lsearch $elem "get_clocks"]+1]]
        #puts $port_name
        if {![string match $new_port_name $port_name]} {
                set new_port_name $port_name
                set ports [lsearch -all -inline $clock_trans  "*$port_name "]
        #puts "ports:$ports"
                set delay_values ""
                foreach item $ports {

                        lappend  delay_values [lindex $item [expr [lsearch $item "get_clocks"]-1]]
                       # puts "delay_values : $delay_values"

        }
                #puts "\nslew $port_name $delay_values"
                puts -nonewline $tmpfile2 "\nslew $port_name $delay_values"

}

}

close $tmpfile2

set tmpfile2 [open /tmp/2 r]
puts -nonewline $timingfile "[read $tmpfile2]"
close $tmpfile2



#........................................................................#

set tmpfile2 [open /tmp/2 w]
set set_input_delay [lsearch -all -inline $lines " set_input_delay*"]
#puts "set_input_delay $set_input_delay"

set new_port_name ""
foreach elem $set_input_delay {

        set port_name [lindex $elem [expr [lsearch $elem "get_ports"]+1]]
        #puts $port_name
        if {![string match $new_port_name $port_name]} {
                set new_port_name $port_name
                set ports [lsearch -all -inline $set_input_delay  "*$port_name* "]
       	        #puts "ports:$ports"
                set delay_values ""
                foreach item $ports {

                        lappend  delay_values [lindex $item [expr [lsearch $item "get_ports"]-1]]
                       # puts "delay_values : $delay_values"

        }
                #puts "\nat $port_name $delay_values"
                puts -nonewline $tmpfile2 "\nat $port_name $delay_values"

}

}

close $tmpfile2

set tmpfile2 [open /tmp/2 r]
puts -nonewline $timingfile "[read $tmpfile2]"
close $tmpfile2



#........................................................................#

set tmpfile2 [open /tmp/2 w]
set set_input_transition [lsearch -all -inline $lines " set_input_transition*"]
#puts "set_input_transition $set_input_transition"

set new_port_name ""
foreach elem $set_input_transition {

        set port_name [lindex $elem [expr [lsearch $elem "get_ports"]+1]]
        #puts $port_name
        if {![string match $new_port_name $port_name]} {
                set new_port_name $port_name
                set ports [lsearch -all -inline $set_input_transition "*$port_name* "]
                 #puts "ports:$ports"
                set delay_values ""
                foreach item $ports {

                        lappend  delay_values [lindex $item [expr [lsearch $item "get_ports"]-1]]
                       # puts "delay_values : $delay_values"

        }
                #puts "\nslew $port_name $delay_values"
                puts -nonewline $tmpfile2 "\nslew $port_name $delay_values"

}

}

close $tmpfile2

set tmpfile2 [open /tmp/2 r]
puts -nonewline $timingfile "[read $tmpfile2]"
close $tmpfile2




#.............TO BE MODIFIED...........................................................#


set tmpfile2 [open /tmp/2 w]
set set_output_delay [lsearch -all -inline $lines " set_output_delay*"]
#puts "set_output_delay $set_output_delay"

set new_port_name ""
foreach elem $set_output_delay {

        set port_name [lindex $elem [expr [lsearch $elem "get_ports"]+1]]
        #puts $port_name
        if {![string match $new_port_name $port_name]} {
                set new_port_name $port_name
                set ports [lsearch -all -inline $set_output_delay  "*$port_name* "]
                 #puts "ports:$ports"
                set delay_values ""
                foreach item $ports {

                        lappend  delay_values [lindex $item [expr [lsearch $item "get_ports"]-1]]
                       # puts "delay_values : $delay_values"

        }
                #puts "\nrat $port_name $delay_values"
                puts -nonewline $tmpfile2 "\nrat $port_name $delay_values"

}

}

close $tmpfile2



set tmpfile2 [open /tmp/2 r]
puts -nonewline $timingfile "[read $tmpfile2]"
close $tmpfile2

#............................................................#

set tmpfile2 [open /tmp/2 w]
set set_load [lsearch -all -inline $lines " set_load*"]
#puts "set_load $set_load"

set new_port_name ""
foreach elem $set_load {

        set port_name [lindex $elem [expr [lsearch $elem "get_ports"]+1]]
        #puts $port_name
	set delay_values [lindex $item [expr [lsearch $item "get_ports"]-1]]

        # puts "delay_values : $delay_values"

         #puts "\nload $port_name $delay_values"
         puts -nonewline $tmpfile2 "\nload $port_name $delay_values"

}


close $tmpfile2

set tmpfile2 [open /tmp/2 r]
puts -nonewline $timingfile "[read $tmpfile2]"
close $tmpfile2
close $timingfile

#.............................................................................................#


set timingfile [open /tmp/3 r]
set final_timing_file [open $sdc_dirname/$sdc_filename.timing w]

while {[gets $timingfile line]!= -1} {

	if {[regexp -all -- {\*} $line]} {

		set bus_port [lindex [lindex [split $line "*"] 0] 1]
		
		set final_synth [open $sdc_dirname/$sdc_filename.final.synth.v r]

		while {[gets $final_synth newline]!= -1} {
			
			if {[regexp -all -- $bus_port $newline] && [regexp -all -- {input} $newline] && ![string match "" $line]} {
				puts -nonewline $final_timing_file "\n[lindex [lindex [split $line "*"] 0] 0] [lindex [lindex [split $newline ";"] 0] 1] [lindex [split $line "*"] 1]"

			} elseif {[regexp -all -- $bus_port $newline] && [regexp -all -- {output} $newline]  && ![string match "" $line]} {
                                puts -nonewline $final_timing_file "\n[lindex [lindex [split $line "*"] 0] 0] [lindex [lindex [split $newline ";"] 0] 1] [lindex [split $line "*"] 1]"





			}
		}

		


	}  else {
		puts -nonewline $final_timing_file "\n$line"
		
	}







}


close $final_synth
close $timingfile
close $final_timing_file



puts "set_timing_fpath $sdc_dirname/$sdc_filename.timing"

}
my_read_sdc /home/vsduser/vvr/vsdsynth/outdir_openMSP430/openMSP430.sdc
