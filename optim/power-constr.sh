#!/bin/bash

echo -n '"MinPower": ['
seq 2400 | awk 'NR == 1 {mult=1} NR % '$1' == 1 {printf "%.10g, ", 100*900*mult*0.95} NR % 12 == 1 {mult *= 1.01}' | sed 's/, *$//'
echo '],'
echo -n '"MaxPower": ['
seq 2400 | awk 'NR == 1 {mult=1} NR % '$1' == 1 {printf "%.10g, ", 100*900*mult*1.05} NR % 12 == 1 {mult *= 1.01}' | sed 's/, *$//'
echo '],'
