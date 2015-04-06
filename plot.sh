#!/bin/bash

gnuplot -p -e "plot '$1' using 1:2 with linespoints"
