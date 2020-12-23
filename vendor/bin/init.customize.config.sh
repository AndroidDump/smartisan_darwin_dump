#! /vendor/bin/sh

#####################################################################
## START: File                                                     ##
## Function: Set some custiomize config for customer               ##
## DATE: 2019.06.19                                                ##
#####################################################################

#####################################################################
## START: Common function defined                                  ##

set_prop_func()
{
    while read -r line
    do
        #echo $line
        if [ "${line:0:1}" = "#" ] || [ "${line:0:1}" = "" ]
        then
            continue
        fi
        setprop ${line%=*} ${line#*=}
        #echo "setprop ${line%=*} ${line#*=}"
    done < $1
}

## END: Common fuction defined                                     ##
#####################################################################


#####################################################################
## START: Config the ro.housing.color prop                         ##

color_file=/vendor/etc/housing-color.prop
set_color=$(cat /sys/hwinfo/housing_color)

if  [ ! -e $color_file -o -z $set_color ]
then
    setprop ro.housing.color unknown
fi
while read -r line
do
    #echo $line
    #echo $set_color
    if [ $line"xx" = ${set_color:14:${#line}}"xx" ]
    then
        setprop ro.housing.color $line
        #echo "setprop ro.housing.color $line"
        break
    fi
done < $color_file

#set default color unknown
setprop ro.housing.color unknown

## END: Config the ro.housing.color prop                           ##
#####################################################################

#####################################################################
## START: Config the vendor.foc.dw prop                         ##

lcd_magic=$(cat /sys/hwinfo/lcd_magic | sed -r 's/lcd_magic=//g')
setprop vendor.foc.dw $lcd_magic

## END: Config the vendor.foc.dw prop                           ##
#####################################################################

#####################################################################
## START: Config the customize product version                     ##

version_id_file=/sys/hwinfo/version_id

if [ -e "$version_id_file" ]
then
    product_id=$(cat $version_id_file | sed -r 's/.*=(...):.*/\1/')
    product_prop_file="/vendor/etc/smartisan-$product_id.prop"

    if [ -f "$product_prop_file" ]
    then
        set_prop_func $product_prop_file
    else
        echo "Not found $product_prop_file"
    fi
else
    echo "Not found $version_id_file"
fi
## END: Config the customize product version                       ##
#####################################################################

## cat ufs_version to update hwinfo
cat /sys/hwinfo/ufs_version

#####################################################################
## START: Config modem prop                                        ##

modem_prop_file="/vendor/etc/smartisan-modem.prop"

if [ -f "$modem_prop_file" ]
then
    set_prop_func $modem_prop_file
else
    echo "Not found $modem_prop_file"
fi

## END: Config modem prop                                          ##
#####################################################################


#####################################################################
## START: set prop for qchip.serialno                              ##

#ByteDance add qchip id prop
chipidstr="$(grep -o 'qchip_id=[a-zA-Z0-9-]\{8\}' /sys/hwinfo/qchip_id )"
setprop ro.qchip.serialno ${chipidstr:9:8}

## END:                                                            ##
#####################################################################


#####################################################################
## START : setp  prop for dump_happen                              ##
dump_happen_file="/sys/kernel/dload/dump_happen" 

if [ -f "$dump_happen_file" ];then
   dump_happen=$(cat $dump_happen_file)
   setprop ro.vendor.dump_happen $dump_happen
fi
## END:                                                            ##
#####################################################################

#####################################################################
## START: set prop ro.product.model                                ##

flash_light=$(cat /sys/hwinfo/flash_light | grep "flash_light")
echo ${flash_light:12:5}

if [ ${flash_light:12:5}"xx" = "FLL_Axx" ]
then
    setprop ro.product.model DT1902A
    setprop ro.product.vendor.model DT1902A
fi

if [ ${flash_light:12:5}"xx" = "FLLBCxx" ]
then
    setprop ro.product.model DT1901A
    setprop ro.product.vendor.model DT1901A
fi

## END:                                                            ##
#####################################################################

exit 0
## END: file                                                       ##
#####################################################################

