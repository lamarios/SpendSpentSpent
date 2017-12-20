#!/bin/sh

OLD_JAR=$1
NEW_JAR=$2
JAVA_OPTS=$3
OLD_JAR_BACKUP="$OLDJAR.bak"
echo "OLD JAR =: $OLD_JAR , NEW JAR: $NEW_JAR, BACKUP: $OLD_JAR_BACKUP JAVA_OPTS: $JAVA_OPTS"

#Giving some time for app to stop
sleep 5

mv $OLD_JAR $OLD_JAR_BACKUP
mv $NEW_JAR $OLD_JAR

echo "java  $JAVA_OPTS -jar $OLD_JAR"
java  $JAVA_OPTS -jar $OLD_JAR

