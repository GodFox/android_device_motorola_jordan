#!/bin/bash
DEVICE_OUT=$ANDROID_BUILD_TOP/out/target/product/jordan
MODULES=$DEVICE_OUT/system/lib/modules
RNDBOOT_MODULES=$DEVICE_OUT/system/lib/modules/2ndboot

ko=`find $RNDBOOT_MODULES/ -name "*.ko"`
for i in $ko; do mv $i ${i/%.ko/-2ndboot.ko}; done;\
mv $RNDBOOT_MODULES/* $MODULES/

rm -rf $RNDBOOT_MODULES