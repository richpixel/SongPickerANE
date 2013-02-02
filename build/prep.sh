#!/bin/bash

cp ../SongPickerLib/bin/SongPicker.swc .
unzip -o SongPicker.swc
cp library.swf ios
cp library.swf android
rm library.swf
