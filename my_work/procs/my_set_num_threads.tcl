proc set_multi_cpu_usage {args} {

	array set options {-localcpu <no_of_threads> -help ""}
	foreach {switch value} [array get options] {
		puts "Option switch is $switch and value is $value "

	}
	puts "length is [llength $args]"

	while {[llength $args]} {
		switch -glob [lindex $args 0]  {
			
			-localcpu {
				puts "old args is $args "
				set args [lassign $args - options(-localcpu)]
				puts "new args is $args "
				set set_num_threads $options(-localcpu)
				puts "set_num_threads $set_num_threads"
			}

			-help {

				puts " old args is $args"
				set args [lassign $args - options(-help)]
				puts " new args is $args"
				puts " Usage : set_multi_cpu_usage -localcpu <no_of_threads> "
			}



		}
		puts "length is [llength $args]"


	}



}
set_multi_cpu_usage -localcpu 4 -help
