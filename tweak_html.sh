#!/bin/bash

shopt -s expand_aliases

if sed --version 2>/dev/null | grep -q GNU; then
    alias sedi='sed -i '
else
    alias sedi='sed -i "" '
fi

if [ $# -ne 1 ]; then
    exit 1
fi
if [ ! -f "$1" ]; then
    exit 1
fi

# Comment out site scripts
TAG='<script src="//camel.apache.org/styles/prototype.js" type="text/javascript"></script>'
sedi -e "s@^ *$TAG@<!-- $TAG@" "$1"
TAG='<script src="//camel.apache.org/styles/site.js" type="text/javascript"></script>'
sedi -e "s@$TAG\$@$TAG -->@g" "$1"

# Load images from the original site
KEYWORD='banner.data/'
sedi -e "s@($KEYWORD@(//camel.apache.org/$KEYWORD@g" "$1"
KEYWORD='index.userimage/'
sedi -e "s@\"$KEYWORD@\"//camel.apache.org/$KEYWORD@g" "$1"

# Embed scripts for Transifex Live
TXL_SCRIPT='<script type="text/javascript">window.liveSettings={api_key:"9bc4339107134d7498f2c68a7d3db5ee"};</script><script type="text/javascript" src="//cdn.transifex.com/live.js"></script>'
if ! grep -q 'cdn.transifex.com/live.js' "$1"; then
    sedi -e "s@</head>@$TXL_SCRIPT</head>@g" "$1"
fi

# Replace Google Analytics account
GA_ACCOUNT=''
sedi -e "s/'_setAccount', '.*'/'_setAccount', '$GA_ACCOUNT'/g" "$1"
