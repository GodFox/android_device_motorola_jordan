#!/sbin/busybox ash

######## BootMenu Script
######## Execute Post BootMenu

source /system/bootmenu/script/_config.sh

export PATH=/system/xbin:/system/bin:/sbin

######## Main Script

# there is a problem, this script is executed if we 
# exit from recovery... (init.rc re-start)

echo 0 > /sys/class/leds/blue/brightness

## Run Init Script

######## Don't Delete.... ########################
mount -o remount,rw rootfs /
mount -o remount,rw $PART_SYSTEM /system
##################################################

# fast button warning (to check when script is really used)
if [ -L /sbin/adbd.root ]; then
    echo 1 > /sys/class/leds/button-backlight/brightness
    usleep 150000
    echo 0 > /sys/class/leds/button-backlight/brightness
    usleep 50000
    echo 1 > /sys/class/leds/button-backlight/brightness
    usleep 150000
    echo 0 > /sys/class/leds/button-backlight/brightness
    exit 1
fi

chmod 777 /dev/graphics
chmod 666 /dev/graphics/fb0
chmod 666 /dev/video*

if [ -d /system/bootmenu/init.d ]; then
    chmod 755 /system/bootmenu/init.d/*
    run-parts /system/bootmenu/init.d
fi

# not made automatically in ics ? to check in vendor/cm
chmod 755 /system/etc/init.d/*
run-parts /system/etc/init.d

# Camera flash
busybox chmod a+rw /sys/class/leds/spotlight/*
busybox chmod a+rw /sys/class/leds/torch-flash/*
busybox chown -R camera:system /sys/class/leds/torch-flash /sys/class/leds/spotlight


######## Don't Delete.... ########################
mount -o remount,ro rootfs /
mount -o remount,ro $PART_SYSTEM /system
##################################################

#/system/bootmenu/script/media_fixup.sh &

exit 0
