proc my_read_lib {args} {
array set option {-late <late_lib_path> -early <early_lib_path> -help ""}

while {[llength $args] } {

	switch -glob [lindex $args 0] {

	-late {
		set args [lassign $args - option(-late)]
		puts "set_late_celllib_fpath $option(-late)"
	}
	
	-early {
		set args [lassign $args - option(-early)]
		puts "set_early_celllib_fpath $option(-early)"
	}

	-help {
		set args [lassign $args - option(-help)]
		puts "Usage :my_read_lib -late  <late_lib_path> or -early  <early_lib_path>"

	}

}








}

}
my_read_lib -late osu018_stdcells.lib
