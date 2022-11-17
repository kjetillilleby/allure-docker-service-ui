#!/bin/sh

set -e 

if [ -z $URL_PREFIX ]; then
    export URL_PREFIX='/'
fi

cp -r /app/ui/** /usr/share/nginx/html
envsubst < /app/ui/prod-config.js > /usr/share/nginx/html/env-config.js
envsubst < /app/ui/index.html > /usr/share/nginx/html/index.html
