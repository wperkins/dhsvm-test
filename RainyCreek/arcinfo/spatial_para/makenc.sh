#!/bin/sh
# -------------------------------------------------------------
# file: makenc.sh
#
# This script requires GDAL and NetCDF Operators to be available (and
# on PATH)
# -------------------------------------------------------------
# -------------------------------------------------------------
# Created September  4, 2019 by William A. Perkins
# Last Change: 2019-09-04 09:17:03 d3g096
# -------------------------------------------------------------



set -xue

# gdal_translate is part of GDAL

gdal_translate="/Library/Frameworks/GDAL.framework/Programs/gdal_translate"
gdal_translate="gdal_translate"

header="../rainy30/rainyhdr.txt"
ncols=`awk '/ncols/ { print $NF; }' "$header" `
nrows=`awk '/nrows/ { print $NF; }' "$header" `

doit() {
    base="$1"
    var="$2"
    ityp="$3"

    case $ityp in
        f)
            gtyp="Float32"
            ;;
        uc) 
            gtyp="Byte"
            ;;
        i)
            gtyp="Int32"
            ;;
        *)
            return 1
    esac

    asc="${base}.asc"
    nc="${base}.nc"

    "$gdal_translate" -a_srs EPSG:26911 -of netCDF \
                    -co FORMAT=NC4 -co WRITE_BOTTOMUP=NO \
                    -ot "$gtyp"  "$asc" tmp1.nc
    ncecat -O -u time tmp1.nc tmp2.nc
    ncrename -h -O -v "Band1","$var" tmp2.nc tmp1.nc
    mv tmp1.nc "$nc"
    rm -f tmp tmp1.nc tmp2.nc

    return 0
}

doit veg_type_fc "Veg.Fract" f
