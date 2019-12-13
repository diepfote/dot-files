set command "(dict --help | tail -n +8 | tr -s ' ' | cut -d ' ' -f2)"
#set description "dict --help | tail -n +8 | tr -s ' ' | sed -r 's#[a-zA-Z-]+ [A-Za-z<>-]+ ##' | sed -r 's#<.*>##' | sed 's#^ ##'"

complete -c dict -a $command

