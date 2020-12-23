#! /vendor/bin/sh

#####################################################################
## START: File                                                     ##
## Function: Set some custiomize unit test customer                ##
## DATE: 2019.09.22                                                ##
#####################################################################

#####################################################################
## START: Random to reboot the devices                             ##

function rand(){
    i=1
    min=$1
    max=$(($2-$min+1))
    num=$(($RANDOM+1000000000))
    #echo $num
    time=$(($num%$max+$min))
    while [ $i -le $time ]
    do
        i=$(($i+1))
        sleep 1
    done
    echo ${time}
}

rand 15 105
/system/bin/reboot

## END:                                                            ##
#####################################################################

exit 0
## END: file                                                       ##
#####################################################################

