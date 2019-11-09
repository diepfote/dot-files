set command "find ~/.config/systemd/user -maxdepth 1 -type f | sed 's#.*/##g'; find /usr/lib/systemd/user/ -maxdepth 1 -type f | sed 's#.*/##g'"

complete -c "systemctl --user" -a $command

