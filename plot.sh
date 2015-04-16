#!/bin/bash

fname=tmpplot.dat
./query.sh $@ > $fname
gnuplot -p -e "plot '$fname' using 1:2 with linespoints title '$1: $2 $3 $4"
