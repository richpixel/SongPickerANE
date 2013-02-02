#!/bin/bash

adt -package -target ane SongPicker.ane extension.xml -swc SongPicker.swc -platform default -C default . -platform iPhone-ARM -C ios . -platformoptions platformoptions.xml -platform Android-ARM -C android .
cp SongPicker.ane /Work/Samuel/"BREAZE app"/app-source/lib/ane
