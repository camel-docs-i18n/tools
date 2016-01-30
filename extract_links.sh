#!/bin/bash

if [ $# -ne 1 ]; then
    exit 1
fi
if [ ! -f "$1" ]; then
    exit 1
fi

# Extract only relative URLs (except ..)
grep -Eo 'href="[^#?].+?"' "$1" | sed -E 's/href=" *(.+) *"/\1/g' | grep -Ev "^https?:" | grep -E "\.html$" | grep -v "^//" | grep -v "^\.\." | sort -u
