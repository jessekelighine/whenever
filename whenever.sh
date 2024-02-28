#!/usr/bin/env bash

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Author: Jesse C. Chen  (jessekelighine.com)                                 #
# Description: `whenever`, run a command whenever a file/dir is changed.      #
# Last Modified: 2024-02-07                                                   #
#                                                                             #
# License: GPL-3                                                              #
# Copyright 2023-2024 Jesse C. Chen                                           #
###############################################################################

: ${WHENEVER_INTERVAL:=1}
: ${WHENEVER_COMMAND:=md5sum}

### Functions #################################################################

message () {
	local green; green=$(tput bold && tput setaf 10)
	local blue; blue=$(tput bold && tput setaf 12)
	local norm; norm=$(tput sgr0)
	local usage; usage="${green}usage${norm}"
	local command; command="${blue}$(basename $0)${norm}"
	local description; description="${green}description${norm}"
	cat << EOF
${usage}: ${command} [file|dir] [command]
${description}: run [command] whenever [file|dir] is modified.
EOF
}

progress () {
	local yellow; yellow=$(tput bold && tput setaf 214)
	local norm; norm=$(tput sgr0)
	printf "${yellow}== whenever: %d ==================================${norm}\n" $1
}

calc_value () {
	echo "$(find "$1" -type f -exec $WHENEVER_COMMAND {} \;)"
}

### Main ######################################################################

[[ $# -lt 2 ]] && {
	message >&2
	exit 1
}

count=0
previous_state="$(calc_value "$1")"
while : ; do sleep $WHENEVER_INTERVAL
	current_state="$(calc_value "$1")"
	[[ "$previous_state" != "$current_state" ]] && {
		${@:2}
		progress $((++count))
		previous_state="$(calc_value "$1")"
	}
done
