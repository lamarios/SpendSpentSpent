#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

FULLDIR=$DIR"/target/universal/stage"

PID=$FULLDIR"/RUNNING_PID"

LOG=$FULLDIR"/logs"

APPNAME="spendspentspent"

cd "$DIR"

chmod +x activator

function stop {
    if [ -e $PID ]
    then
        echo "Stopping ExpTracker"
        kill -9 $(cat $FULLDIR/RUNNING_PID)

        rm $FULLDIR/RUNNING_PID
    else
        echo "ExpTracker not running or PID file has already been deleted"
    fi

}

function start {
    if [ -e $PID ]
    then
        echo "ExpTracker is already running. If it is not, delete the file $PID"
    else
    	if [ ! -e $DIR/conf/launch.conf ]
    	then
    		createlaunchconf
    	fi
    	
    	if [ ! -e $DIR/conf/user.conf ]
    	then
    		createdbconf
    	fi
    	
    	migrate239to240
    	
    	source $DIR/conf/launch.conf
    	
        echo "Compiling ExpTracker...."

        $DIR/activator clean stage

        chmod +x $FULLDIR/bin/$APPNAME

        echo "Starting ExpTracker in the background"
        echo "Port: $PORT"
        $FULLDIR/bin/$APPNAME -Dhttp.port=$PORT -Dplay.evolutions.db.default.autoApply=true  -DapplyDownEvolutions.default=true -J-Xms$XMS -J-Xmx$XMX
       
    fi
}

function restart {
    stop
    start
}

function randomString32 {

	index=0

	str=""

	for i in {a..z}; do arr[index]=$i; index=`expr ${index} + 1`; done

	for i in {A..Z}; do arr[index]=$i; index=`expr ${index} + 1`; done

	for i in {0..9}; do arr[index]=$i; index=`expr ${index} + 1`; done

	for i in {1..64}; do str="$str${arr[$RANDOM%$index]}"; done

	APP_SECRET=$str

}

function migrate239to240 {
	CONF_FILE=$DIR/conf/user.conf
	TMP_FILE=$DIR/conf/user.conf.tmp
	echo "Migrating config from Play 2.3.9 to play 2.4.0"
	if [ -e $CONF_FILE ]
    then
    	sed 's/application\.secret/play\.crypto\.secret/g' $CONF_FILE > $TMP_FILE
    	rm $CONF_FILE
    	mv $TMP_FILE $CONF_FILE
    fi
}

function createdbconf {
	CONF_FILE=$DIR/conf/user.conf
	
	echo "Setting up the database"
	
	read -p "Database folder (full path), missing folders will be created[$DIR]\n" DB
	

	if [ "$DB" == "" ]
	then
    	DB="$DIR"
	fi
	
	if [[ "$DB" != */ ]]
	then
    	DB="$DB/"
	fi

	mkdir -p $DB

	DB+="SSS"

	randomString32

	touch  $CONF_FILE
	echo "play.crypto.secret=\"$APP_SECRET\"" >> $CONF_FILE
	echo "db.default.driver=org.h2.Driver" >> $CONF_FILE
	echo "db.default.url=\"jdbc:h2:$DB;MODE=MYSQL\"" >> $CONF_FILE

	
	echo "Config written to $CONF_FILE"
}


function createlaunchconf {

	echo "First time launching ExpTracker, let's set up few things first"
	
	read -p "Enter port to run ExpTracker [9000]:" PORT
	if [ "$PORT" = "" ]
	then
    	PORT=9000
	fi
	
	
	read -p "Minimum RAM used by the JVM Xms ExpTracker [64M]:" XMS
	if [ "$XMS" = "" ]
	then
    	XMS="64M"
	fi
	
	read -p "Maximum RAM used by the JVM Xmx ExpTracker [128M]:" XMX
	if [ "$XMX" = "" ]
	then
    	XMX="128M"
	fi
	
	touch  $DIR/conf/launch.conf
	echo "PORT=$PORT" >>  $DIR/conf/launch.conf
	echo "XMS=$XMS" >>  $DIR/conf/launch.conf
	echo "XMX=$XMX" >>  $DIR/conf/launch.conf

	
	echo "Config written in $DIR/conf/launch.conf, you can change the values anytime. Requires ExpTracker restart."
	
}


if [ $# -eq 0 ]
then
    echo "Argument needed start|restart|stop|update"
elif [ $1 == "start" ]
then
    start
elif [ $1 == "restart" ]
then
    restart
elif [ $1 == "stop" ]
then
    stop
elif [ $1 == "update" ]
then
    git pull
    restart
else
    echo "Argument needed start|restart|stop|update"
fi
