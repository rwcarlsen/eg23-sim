#!/bin/bash

echo "<prototypes>"
tail -n+2 $1 | awk '$2 > 0 {print "    <val>slow_reactor</val>"}'
echo "</prototypes>"

echo "<n_build>"
tail -n+2 $1 | awk '$2 > 0 {printf "    <val>%d</val>\n",$2}'
echo "</n_build>"

# build initial reactors on time step 1
echo "<build_times>"
tail -n+2 $1 | awk '$2 > 0 {printf "    <val>%d</val>\n",1}'
echo "</build_times>"

echo "<lifetimes>"
tail -n+2 $1 | awk '$2 > 0 {printf "    <val>%d</val>\n",($1-2015)*12}'
echo "</lifetimes>"
