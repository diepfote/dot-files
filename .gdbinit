set history save on


# gef - gdb enhanced features
# AUR pkg "gef-git"
#
define gef
source /usr/share/gef/gef.py
end
document gef
Initializes GEF (GDB Enhanced Features)
end

## pwndbg
#define init-pwndbg
#source /usr/share/pwndbg/gdbinit.py
#end
#document init-pwndbg
#Initializes PwnDBG
#end

# peda
# Python Exploit Development Assistance for GDB
#
define peda
source /usr/share/peda/peda.py
end
document peda
Initializes the PEDA (Python Exploit Development Assistant for GDB) framework
end


#set disassembly-flavor att
set disassembly-flavor intel

