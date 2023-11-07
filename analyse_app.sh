#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Error: Expected exactly 1 argument"
    echo "\t $1: path to the APK file to analyze"
    exit -1

fi

cp $1 tmp/apks/

file_name=$(basename $1)
echo "Application base name: " $file_name
package=$(./scripts/get_package.sh $file_name)

#shopt -s expand_aliases
#alias adb='emulator/linux-x86/bin/adb'

echo "Installing application " $file_name
adb install tmp/apks/$file_name 2>&1 | tail -n 1

mkdir -p tmp/info/$file_name
mkdir -p tmp/screen

# Clear log
adb logcat -c

#adb shell monkey -s 42 --throttle 60 -p $package -v 1000 2>&1 > tmp/info/$file_name/monkey_orig
#cat tmp/info/$file_name/monkey_orig | grep -E "\*\*|//" | grep -v "^ " > tmp/info/$file_name/monkey

# Monkey
read -p "Random exploration? [Y]/n? " choice
case "$choice" in
    n|N )
        read -p "Press enter when finished manual exploration ..."
        echo "// Monkey finished" > tmp/info/$file_name/monkey
        ;;
    * )
        adb shell monkey -s 43 --throttle 50 -p $package -v 3000 2>&1 > tmp/info/$file_name/monkey_orig
        cat tmp/info/$file_name/monkey_orig | grep -E "\*\*|//" | grep -v "^ " > tmp/info/$file_name/monkey
        ;;
esac

# Get the package name's PID
pid="$(adb shell ps | grep " $package" | awk '{print $2}')"

# Print package name and PID
echo "packagename: $package"
echo "pid: $pid"

# Fetch log
adb logcat -d -v thread | grep $pid >> templog/$package.txt

java -jar logprocess.jar templog/$package.txt tmp/$package.txt
#adb logcat  -v thread >> /home/ww/桌面/${packagename}_${DATE}.txt

adb shell input keyevent 3 > /dev/null
sleep 2
adb shell pm uninstall $package > /dev/null

echo "finding data race"
mkdir -p tmp/result
java -jar seqCheaker.jar $pid tmp/$package.txt >> tmp/result/$package.txt
#java -jar seqCheaker.jar $pid tmp/$package.txt
