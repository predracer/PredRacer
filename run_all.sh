#!/bin/bash

cd emulator
./start_emulator.sh
cd ..

APKS=$(find bench -name "*.apk" -not -type d)
for APK in $APKS; do
	./analyse_app.sh $APK
done


