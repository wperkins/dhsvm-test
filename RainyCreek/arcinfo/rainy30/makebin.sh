#!/bin/sh
# -------------------------------------------------------------
# file: makebin.sh
# -------------------------------------------------------------
# -------------------------------------------------------------
# Created July 16, 2019 by William A. Perkins
# Last Change: 2019-07-16 13:01:54 d3g096
# -------------------------------------------------------------

set -xue

# The myconvert program is built as part of the DHSVM 
myconvert="/home/d3g096/Projects/DHSVM/src/dhsvm/build/DHSVM/program/myconvert"

header="rainyhdr.txt"
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

doit rainymask uc
doit rainydem f
doit soildepth f
doit rainysoil uc
doit rc_veg uc
