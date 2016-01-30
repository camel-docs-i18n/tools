#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
