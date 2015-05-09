#!/bin/bash

echo "<prototypes>"
tail -n+2 $1 | awk '$2 > 0 {print "<val>slow_reactor</val>"} $3 > 0 {print "<val>fast_reactor</val>"}'
echo "</prototypes>"

echo "<n_build>"
tail -n+2 $1 | awk '$2 > 0 {printf "<val>%s</val>\n",$2} $3 > 0 {printf "<val>%s</val>\n",$3}'
echo "</n_build>"

echo "<build_times>"
tail -n+2 $1 | awk '$2 > 0 {printf "<val>%d</val>\n",($1-2015)*12+1} $3 > 0 {printf "<val>%d</val>\n",($1-2015)*12+1}'
echo "</build_times>"
