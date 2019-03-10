#!/usr/bin/env bash
if [ -z ${SALT+x} ]; then
    echo "Missing SALT environment variable"
else
    java -Xmx256M -Dsalt=$SALT -Dhttp.port=9001 -Ddb.url=/config/SSS -jar /app/SpendSpentSpent.jar
fi