#!/bin/bash

set -e
HELPISSET=0
VERSIONISSET=0
PROGRAM_VERSION="0.2"

_usage() {
	printf "Use wofi to get password quickly.\n"
	printf "Usage: passmenu.sh [options]\n"
	printf "	-c <command>, --copy=<command>        Use specified command to copy your select to clipboard.\n"
	printf "	-h, --help, --usage                   Show this help message and exit.\n"
	printf "	-m <menu>, --menu=<command>           Use specified command to create the pass menu.\n"
	printf "	-o, --otp                             Consider selected password as a otp url.\n"
	printf "	-t <command>, --type=<command>        Use specified command to type your select.\n"
	printf "	-V, --version                         Show version infomation and exit.\n"
	exit
}

_version() {
	printf "passmenu.sh ${PROGRAM_VERSION}\n"
	exit
}

args="$(getopt --options c:hm:ot:V --longoptions copy:,help,menu:,otp,type:,usage,version -n 'passmenu.sh' -- "$@")"
eval set -- "${args}"
while true; do
	case "${1}" in
		-c|--copy) COPY_COMMAND="${2}"; shift 2 ;;
		-h|--help|--usage) HELPISSET=1; shift ;;
		-m|--menu) MENU_COMMAND="${2}"; shift 2 ;;
		-o|--otp) OTP="otp"; shift ;;
		-t|--type) TYPE_COMMAND="${2}"; shift 2 ;;
		-v|--version) VERSIONISSET=1; shift ;;
		--) shift; break ;;
		*) 
			printf "Error when parsing the arguments.Exiting.\n"
			exit
			;;
	esac
done

if ! command -v ${MENU_COMMAND%% *}; then
	printf "The command used for creating menu is unavailable.Exiting.\n"
	exit
fi

if [ "${HELPISSET}" -eq 1 ]; then
	_usage
fi

if [ "${VERSIONISSET}" -eq 1 ]; then
	_version
fi

cd ${PASSWORD_STORE_DIR:-${HOME}/.password-store/}
SELECT="$(find . -name "*.gpg"|cut -d'/' -f2-| ${MENU_COMMAND})"
if [ -n "${SELECT}" ]; then
	if command -v "${COPY_COMMAND%% *}"; then
		pass ${OTP} show ${SELECT%.*}| tr -d '\n'| ${COPY_COMMAND}
	else
		printf "Command for copying is not available.\n"
	fi
	if command -v "${TYPE_COMMAND%% *}"; then
		pass ${OTP} show ${SELECT%.*}| tr -d '\n'| ${TYPE_COMMAND}
	else
		printf "Command for typing is not available.\n"
	fi
else
	printf "The action has been canceled.Exiting.\n"
	exit
fi
