# passmenu.sh

A simple script for pass typing or copying.  
The script is used to create a list of pass entries for dmenu-compatible launcher,user can select a pass entry to copy or type.  
It is recommended to use the script with wofi(or any launcher compatible with dmenu), wl-clipboard (or xclip for x11) and wtyep (or xte for x11).  
If selected file has the suffix '.otp.gpg', it will be considered as an otp url.  

```
Usage: passmenu.sh [options]
	-h, --help, --usage                   Show this help message and exit.
	-m <menu>, --menu=<command>           Use specified command to create the pass menu.
	-t <command>, --type=<command>        Use specified command to type your select.
	-V, --version                         Show version infomation and exit.
```
