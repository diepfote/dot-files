set command '(for file in (ls ~/Documents/passwds/); basename "$file"; end)'

complete -c pass_find -a $command
complete -c view_pass_file -a $command
complete -c view_pass_files -a $command
complete -c rm_pass_files -a $command
complete -c mv_pass_file -a $command

