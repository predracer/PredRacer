#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Error: Expected exactly 1 argument specifying location of the apk file to analyse"
	exit -1
fi

if [ ! -d /tmp ]; then
	mkdir /tmp
fi	

out=`./apktool/apktool d -s -f -o tmp/$1 tmp/apks/$1 2>&1`

if [ ! -f tmp/$1/AndroidManifest.xml ]; then
	echo "Error: Unable to extract AndroidManifest.xml from $1"
	echo $out
	exit -1
fi

grep "package" tmp/$1/AndroidManifest.xml | tr ' ' '\n' | grep "package" | head -n 1 | cut -d '"' -f 2

rm -r tmp/$1
