#!/bin/sh

set -ue

# -------------------------------------------------------------
# initialize variables
# -------------------------------------------------------------

# Point this at the local numdiff
numdiff=numdiff

# Directory with expected output files
gooddir="../output.serial"
gooddir="../output.4"

# Relative numeric error to except (this is really low)
relerr="1.0E-04"

# Output files to check
files=" \
    Aggregated.Values \
    ATP.Only \
    Inflow.Only \
    Mass.Balance \
    Mass.Final.Balance \
    Melt.Only \
    NLW.Only \
    NSW.Only \
    Outflow.Only \
    Stream.Flow \
    Streamflow.Only \
    VP.Only \
    WND.Only \
"

# -------------------------------------------------------------
# main program
# -------------------------------------------------------------


for i in $files; do
    if [ -f "$i" ]; then
        echo $i
        numdiff -r "$relerr" $i "${gooddir}/$i" || true
    else
        echo "$i not found"
    fi
done
