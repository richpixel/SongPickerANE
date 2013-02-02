#!/bin/bash

cp ../SongPickerDefault/bin/SongPickerDefault.swc default
unzip -o default/SongPickerDefault.swc
mv library.swf default
rm default/SongPickerDefault.swc
