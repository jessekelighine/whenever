#!/usr/bin/env bash

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Author: Jesse C. Chen  (jessekelighine.com)                                 #
# Description: Run a command WHENEVER some files/dirs are changed.            #
# Last Modified: 2025-09-13                                                   #
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
	local environment; environment="$(tput bold)ENVIRONMENT$(tput sgr0)"
	local whenever; whenever="$(tput bold)$(basename "$0")$(tput sgr0)"
	cat << EOF
$usage: $whenever [command] <<< [files|directories]
$description:
    Run [command] whenever [files|directories] are modified. Files/directories
    that are watched for changes are passed to $whenever via stdin, this
    usually means piping [files|directories] to $whenever, see $examples.
    Please do not have any special characters in the file paths, $whenever
    does not handle them well.
$examples:
    # echo "hmmm" whenever any file in the current directory is modified.
    find . -type f | $whenever echo "hmmm"

    # Convert markdown to html whenever the file itself, the style sheet,
    # or any thing in the src directory is modified.
    echo index.md style.css src/ | $whenever pandoc index.md --output index.html
$environment:
    WHENEVER_INTERVAL    The interval in seconds to check for changes. Default
                         is 1 second, it is currently set to $WHENEVER_INTERVAL second(s).

    WHENEVER_COMMAND     The command used to check whether files are modified.
                         Default is \`md5sum\`, it is currently set to \`$WHENEVER_COMMAND\`.
EOF
}

progress () {
	local yellow; yellow=$(tput bold && tput setaf 214)
	local norm; norm=$(tput sgr0)
	printf "${yellow}== whenever: %d ==================================${norm}\n" "$1"
}

calculate_hash () {
	echo "$1" | xargs -n 1 -J % find % -type f -exec $WHENEVER_COMMAND {} \;
}

### Main ######################################################################

[[ $# -lt 1 ]] && {
	message >&2
	exit 1
}

watch_files="$(</dev/stdin)"
count=0
previous_state="$(calculate_hash "$watch_files")"
while : ; do sleep "$WHENEVER_INTERVAL"
	current_state="$(calculate_hash "$watch_files")"
	[[ "$previous_state" != "$current_state" ]] && {
		"$@"
		progress $((++count))
		previous_state="$(calculate_hash "$watch_files")"
	}
done
