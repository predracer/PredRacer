#!/bin/bash

echo "Restarting ADB server"
linux-x86/bin/adb kill-server
linux-x86/bin/adb start-server

USE_KVM=true

if [ $USE_KVM == true ]; then
	echo "Starting emulator with KVM enabled"
else
	echo "Starting emulator with KVM disabled. Note that as a result emulator will likely be very slow."
fi	

has_kvm=`egrep '^flags.*(vmx|svm)' /proc/cpuinfo | wc -l`
if [ $has_kvm == "0" ]; then
	echo "The system seems to not support KVM. You may be running in a Virtual Machine. Note that as a result emulator will likely be very slow. For more information consult http://www.linux-kvm.org/page/FAQ"
	USE_KVM=false
fi

#prepare SD card
rm generic_x86/sdcard.img 2> /dev/null
linux-x86/bin/mksdcard 512M generic_x86/sdcard.img

#tell emulator where to find seqCheak AVD
mkdir -p .android/avd
export ANDROID_SDK_HOME=`pwd`
echo $ANDROID_SDK_HOME

#for emulator to find openGL libaries
export LD_LIBRARY_PATH=`pwd`"/linux-x86/lib:$LD_LIBRARY_PATH"

echo "avd.ini.encoding=UTF-8" > .android/avd/seqCheak.ini
echo "path="`pwd`"/.android/avd/seqCheak.avd" >> .android/avd/seqCheak.ini
echo "path.rel=avd/seqCheak.avd" >> .android/avd/seqCheak.ini
echo "target=android-19" >> .android/avd/seqCheak.ini

cp .android/avd/seqCheak.avd/config_base.ini .android/avd/seqCheak.avd/config.ini
echo "image.sysdir.1="`pwd`"/generic_x86/" >> .android/avd/seqCheak.avd/config.ini

#-wipe-data
if [ $USE_KVM == true ]; then
	linux-x86/bin/emulator  -avd seqCheak -skin WVGA854 -skindir skins -sdcard generic_x86/sdcard.img -kernel qemu-kernel/x86/kernel-qemu -qemu -m 1024 -enable-kvm &
else
	linux-x86/bin/emulator  -avd seqCheak -skin HVGA -skindir skins -sdcard generic_x86/sdcard.img -kernel qemu-kernel/x86/kernel-qemu &
fi

sleep 2
echo -n "Waiting for emulator to boot "
#wait for device to boot
out=`linux-x86/bin/adb shell setprop sys.boot_completed 0 2> /dev/null`
out=`linux-x86/bin/adb shell getprop sys.boot_completed 2> /dev/null`
while [[ ! $out =~ .*1.* ]]
do
	sleep 1	
	echo -n "."
	out=`linux-x86/bin/adb shell getprop sys.boot_completed 2> /dev/null`
done

echo ""
echo "Initializing SD card from " `pwd`"/sdcard"
#populate sdcard with test files
for dir in `find sdcard -type d | sed 's/^sdcard//'`
do	
    linux-x86/bin/adb shell mkdir "storage/sdcard/Download"$dir > /dev/null 2>&1
done

linux-x86/bin/adb push sdcard storage/sdcard/Download/ > /dev/null 2>&1

echo "Emulator started succesfully"

