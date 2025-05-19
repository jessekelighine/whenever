#!/usr/bin/env bash

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Author: Jesse C. Chen  (jessekelighine.com)                                 #
# Description: `whenever`, run a command whenever a file/dir is changed.      #
# Last Modified: 2024-02-07                                                   #
#                                                                             #
# License: GPL-3                                                              #
# Copyright 2023-2025 Jesse C. Chen                                           #
###############################################################################

set -e

: "${WHENEVER_INTERVAL:=1}"
: "${WHENEVER_COMMAND:=md5sum}"

### Functions #################################################################

message () {
	local examples; examples="$(tput bold)EXAMPLES$(tput sgr0)"
	local description; description="$(tput bold)DESCRIPTION$(tput sgr0)"
	local usage; usage="$(tput bold)USAGE$(tput sgr0)"
	local command; command="$(tput bold)$(basename "$0")$(tput sgr0)"
	cat << EOF
$usage: $command [command] <<< [files|directories]
$description:
	Run [command] whenever [files|directories] are modified. Files/directories
	that are watched for changes are passed to $command via stdin, this usually
	means piping [files|directories] to $command, see $examples. Please do not
	have any special characters in the filenames.
$examples:
	# echo "hmmm" whenever any file in the current directory is modified.
	find . -type f | $command echo "hmmm"

	# Recompile LaTeX whenever the source file or style file is modified.
	echo paper.tex settings.sty | $command pdflatex paper.tex
EOF
}

progress () {
	local yellow; yellow=$(tput bold && tput setaf 214)
	local norm; norm=$(tput sgr0)
	printf "${yellow}== whenever: %d ==================================${norm}\n" "$1"
}

calculate_hash () {
	echo "$1" | xargs -n 1 -J % find % -type f -exec sh -c "$WHENEVER_COMMAND {}" \;
}

### Main ######################################################################

[[ $# -lt 1 ]] && {
	message >&2
	exit 1
}

count=0
watch_files="$(</dev/stdin)"
previous_state="$(calculate_hash "$watch_files")"
while : ; do sleep "$WHENEVER_INTERVAL"
	current_state="$(calculate_hash "$watch_files")"
	[[ "$previous_state" != "$current_state" ]] && {
		"$@"
		progress $((++count))
		previous_state="$(calculate_hash "$watch_files")"
	}
done
