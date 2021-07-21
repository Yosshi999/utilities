#!/bin/bash
# Unzip with progress bar.
# You need pv (apt install pv)

if [ $# != 2 ]; then
	echo "Usage: $0 <file to unzip> <output path>"
	exit 1
fi

type pv 1>/dev/null 2>/dev/null || {
	echo "You need pv (apt install pv)"
	exit 1
}

n_files=$(unzip -Z1 $1 | grep -v '/$' | wc -l)
unzip -o $1 -d $2 2>/dev/null | pv -l -s ${n_files} > /dev/null