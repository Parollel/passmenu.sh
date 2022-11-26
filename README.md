# passmenu.sh

A simple script for pass typing or copying.
The script is used to create a list of pass entries for dmenu-compatible launcher,user can select a pass entry to copy or type.  
It is recommended to use the script with wofi(or any launcher compatible with dmenu), wl-clipboard (or xclip for x11) and wtype (I didn't find an alternative for x11).

Usage: passwofi.sh [options]  
    -c <command>, --copy=<command>        Use specified command to copy your select to clipboard.  
    -h, --help, --usage                   Show this help message and exit.  
    -o, --otp                             Consider selected password as a otp url.  
    -t <command>, --type=<command>        Use specified command to type your select.  
    -V, --version                         Show version infomation and exit.  
