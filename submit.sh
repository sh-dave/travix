#!/bin/sh

haxe build.hxml
zip -r temp.zip src haxelib.json run.n README.md LICENSE
haxelib submit temp.zip
rm temp.zip
rm run.n