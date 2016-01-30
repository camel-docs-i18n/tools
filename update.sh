#!/bin/bash

USER_AGENT="curl (crawler for camel-docs-i18n.github.io)"
URL_BASE="http://camel.apache.org/"
DATA_DIR="data/"
PATH_LIST_FILE="path_list.txt"
INTERVAL=2

if [ ! -f $PATH_LIST_FILE ]; then
    echo 'index.html' > $PATH_LIST_FILE
fi

while read -r URL_PATH
do
    echo "$URL_PATH"
    curl -s -A "$USER_AGENT" --create-dirs -o "${DATA_DIR}${URL_PATH}" "${URL_BASE}${URL_PATH}"
    ./tweak_html.sh "${DATA_DIR}${URL_PATH}"
    sleep $INTERVAL
done < $PATH_LIST_FILE

find . -name "*.html" -exec ./extract_links.sh  {} \; >> "$PATH_LIST_FILE"
sort "$PATH_LIST_FILE" -uo "$PATH_LIST_FILE"
