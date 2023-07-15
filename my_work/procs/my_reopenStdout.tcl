proc my_reopenStdout {file} {
	close stdout
	open $file w
}


