#!/bin/sh
# -------------------------------------------------------------
# file: makebin.sh
# -------------------------------------------------------------
# -------------------------------------------------------------
# Created September  4, 2019 by William A. Perkins
# Last Change: 2019-09-04 08:12:47 d3g096
# -------------------------------------------------------------

set -xue

# The myconvert program is built as part of the DHSVM 
myconvert="/home/d3g096/Projects/DHSVM/src/dhsvm/build/DHSVM/program/myconvert"

header="../rainy30/rainyhdr.txt"
ncols=`awk '/ncols/ { print $NF; }' "$header" `
nrows=`awk '/nrows/ { print $NF; }' "$header" `

doit() {
    base="$1"
    ityp="$2"

    bin="${base}.bin"
    asc="${base}.asc"

    tail -n +7 "$asc" > tmp
    $myconvert a "$ityp" tmp "$bin" $nrows $ncols
    rm -f tmp

    return 0
}

domany() {
    mbase="$1"
    shift
    mityp="$1"
    shift

    cp /dev/null "${mbase}.bin"
    for masc in $*; do
        cp "$masc" mtmp.asc
        doit mtmp "$mityp"
        cat mtmp.bin >> "${mbase}.bin"
        rm -f mtmp.asc mtmp.bin
    done
}

doit veg_type_fc f
domany veg_type_lai f \
    veg_type_lai01.asc \
    veg_type_lai02.asc \
    veg_type_lai03.asc \
    veg_type_lai04.asc \
    veg_type_lai05.asc \
    veg_type_lai06.asc \
    veg_type_lai07.asc \
    veg_type_lai08.asc \
    veg_type_lai09.asc \
    veg_type_lai10.asc \
    veg_type_lai11.asc \
    veg_type_lai12.asc

