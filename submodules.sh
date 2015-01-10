#!/bin/bash
find . -mindepth 2 -and -name '.git' | sort | (
while read line; do
	DIR=$(echo "$line" | sed -e 's/^\.\/\(.*\)\/\.git$/\1/g')
	echo "[submodule \"$DIR\"]"
	printf "\tpath = $DIR\n"
	URL=$(cat "$line/config" | grep "url =")
	echo "$URL"
done)
