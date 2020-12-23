#! /system/bin/sh

BIN=/system/bin/inotifywait
PARMS="-rm -e moved_to -e moved_from -e delete -e create"
DIRS="/sdcard/DCIM /sdcard/Pictures"
BASEPATH=/sdcard/smartisan/.log
LOGPATH=$BASEPATH/gallery
LOGFILE=$LOGPATH/inotifylog
LOGFILE_OLD=$LOGPATH/inotifylog.old
LOGFILE_SIZE=10485760
BASEBIN=/system/bin

#wait for a while
sleep 60

#check base path
if [ ! -d "$BASEPATH" ]; then
	echo $BASEPATH is not exist
	exit 2;
fi

#check log path dir
if [ ! -d "$LOGPATH" ]; then
	$BASEBIN/mkdir -p $LOGPATH
fi

#check current log file size
if [ -f "$LOGFILE" ]; then
	filesize=`$BASEBIN/stat -c "%s" $LOGFILE`
	#echo filesize=$filesize
	if [ $((filesize)) -gt $LOGFILE_SIZE ];then
		$BASEBIN/mv $LOGFILE $LOGFILE_OLD
	fi
fi

#start inotify wait
$BIN $PARMS --timefmt '%Y%m%d_%H:%M:%S' --format '%T %e %w%f' $DIRS -o $LOGFILE
