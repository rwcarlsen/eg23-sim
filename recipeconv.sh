#!/bin/bash

name=$1
file=$2
echo '<recipe>'
echo "    <name>$name</name>"
echo "    <basis>mass</basis>"
awk '$2 > 0 {printf "    <nuclide> <id>%s</id> <comp>%f</comp> </nuclide>\n",$1,$2}' $file
echo '</recipe>'
