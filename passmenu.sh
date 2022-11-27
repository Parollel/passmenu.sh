#!/bin/bash

set -e
HELPISSET=0
VERSIONISSET=0
PROGRAM_VERSION="0.3"

_usage() {
	printf "Use dmenu-compatible menu application to get password quickly,\nwith copying disabled and support for automatically typing otp.\n"
	printf "Usage: passmenu.sh [options]\n"
	printf "	-h, --help, --usage                   Show this help message and exit.\n"
	printf "	-m <menu>, --menu=<command>           Use specified command to create the pass menu.\n"
	printf "	-t <command>, --type=<command>        Use specified command to type your select.\n"
	printf "	-V, --version                         Show version infomation and exit.\n"
	exit
}

_version() {
	printf "passmenu.sh ${PROGRAM_VERSION}\n"
	exit
}

args="$(getopt --options hm:t:V --longoptions help,menu:,type:,usage,version -n 'passmenu.sh' -- "$@")"
eval set -- "${args}"
while true; do
	case "${1}" in
		-h|--help|--usage) HELPISSET=1; shift ;;
		-m|--menu) MENU_COMMAND="${2}"; shift 2 ;;
		-t|--type) TYPE_COMMAND="${2}"; shift 2 ;;
		-V|--version) VERSIONISSET=1; shift ;;
		--) shift; break ;;
		*) 
			printf "Error when parsing the arguments.Exiting.\n"
			exit
			;;
	esac
done

if ! command -v "${MENU_COMMAND%% *}"; then
	printf "The command used for creating menu is unavailable.Exiting.\n"
	exit
fi
if ! command -v "${TYPE_COMMAND%% *}"; then
	printf "The command used for typing is unavailable.Exiting.\n"
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
case ${SELECT} in
	*.otp.gpg)
		if command -v "${TYPE_COMMAND%% *}"; then
			pass otp show "${SELECT%.*}"| tr -d '\n'| ${TYPE_COMMAND}
		fi
		;;
	*.gpg)
		if command -v "${TYPE_COMMAND%% *}"; then
			pass show "${SELECT%.*}"| tr -d '\n'| ${TYPE_COMMAND}
		fi
		;;
	*)
		printf "Selected file does not have a gpg suffix.Exiting.\n"
		exit
		;;
esac
