#!/bin/bash
# Download large files from gdrive.

if [ $# != 2 ]; then
	echo "Usage: $0 <file id in gdrive link> <file name to output>"
	exit 1
fi

FILE_ID=$1
FILE_NAME=$2
TEMP_FILE=$(mktemp)

# delete tmpfiles automatically
# https://tex2e.github.io/blog/shell/tmpfile-best-practice
function rm_tmpfile {
  [[ -f "$tmpfile" ]] && rm -f "$tmpfile"
}
trap rm_tmpfile EXIT
trap 'trap - EXIT; rm_tmpfile; exit -1' INT PIPE TERM

# save cookie and set to the param
# https://qiita.com/namakemono/items/c963e75e0af3f7eed732
curl -sc ${TEMP_FILE} "https://drive.google.com/uc?export=download&id=${FILE_ID}" > /dev/null
CODE="$(awk '/_warning_/ {print $NF}' ${TEMP_FILE})"  
curl -Lb ${TEMP_FILE} "https://drive.google.com/uc?export=download&confirm=${CODE}&id=${FILE_ID}" -o ${FILE_NAME}
