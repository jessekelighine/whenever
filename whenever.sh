#!/usr/bin/env bash

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Author: Jesse C. Chen  (jessekelighine@gmail.com)                           #
# Description: `whenever`, run a command whenever a file/dir is changed.      #
# Last Modified: 2023-09-29                                                   #
#                                                                             #
# License: GPL-3                                                              #
# Copyright 2023 Jesse C. Chen                                                #
###############################################################################

: ${WHENEVER_INTERVAL:=1}
: ${WHENEVER_COMMAND:=md5sum}

message () {
	local green; green=$(tput bold && tput setaf 10)
	local blue;  blue=$(tput bold && tput setaf 12)
	local norm;  norm=$(tput sgr0)
	cat << EOF
${green}usage:${norm} ${blue}$(basename $0)${norm} [file|dir] [command]
${green}description:${norm} run [command] whenever [file|dir] is modified.
EOF
}

progress () {
	local yellow; yellow=$(tput bold && tput setaf 214)
	local norm;   norm=$(tput sgr0)
	printf "${yellow}========= whenever: %d =========${norm}\n" $1
}

[[ $# -lt 2 ]] && {
	message >&2
	exit 1
}

count=0
value_prev=$( find "$1" -type f -exec $WHENEVER_COMMAND {} \; )
while : ; do sleep $WHENEVER_INTERVAL
	value_curr=$( find "$1" -type f -exec $WHENEVER_COMMAND {} \; )
	[[ "$value_curr" != "$value_prev" ]] && {
		${@:2}
		progress $((++count))
		value_prev=$( find "$1" -type f -exec $WHENEVER_COMMAND {} \; )
	}
done
