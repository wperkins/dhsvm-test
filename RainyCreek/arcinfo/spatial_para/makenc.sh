#!/bin/sh
# -------------------------------------------------------------
# file: makenc.sh
#
# This script requires GDAL and NetCDF Operators to be available (and
# on PATH)
# -------------------------------------------------------------
# -------------------------------------------------------------
# Created September  4, 2019 by William A. Perkins
# Last Change: 2019-09-05 11:01:29 d3g096
# -------------------------------------------------------------



set -xue

# gdal_translate is part of GDAL

gdal_translate="/Library/Frameworks/GDAL.framework/Programs/gdal_translate"
gdal_translate="gdal_translate"

header="../rainy30/rainyhdr.txt"
ncols=`awk '/ncols/ { print $NF; }' "$header" `
nrows=`awk '/nrows/ { print $NF; }' "$header" `

maptype() {
    ityp="$1"
    
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
    echo $gtyp
    return 0
}

doit() {
    base="$1"
    var="$2"
    ityp="$3"

    gtyp=`maptype "$ityp"`

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

domulti() {
    out="$1"; shift
    var="$1"; shift
    ityp="$1"; shift

    first=1
    for i in $*; do
        cp $i mtmp.asc
        doit mtmp "$var" "$ityp"
        if [ "$first" -gt 0 ]; then
            cp mtmp.nc "$out"
        else
            ncrcat -O mtmp.nc "$out" junk.nc
            mv -f junk.nc "$out"
        fi
        first="0"
    done
    rm -f mtmp.asc mtmp.nc
}

dolayered() {
    out="$1"; shift
    lvar="$1"; shift
    ityp="$1"; shift

    lyr=0
    while [ $# -gt 0 ]; do
        cp "$1" mtmp.asc
        v="${lyr}.${lvar}"
        doit mtmp "$v" "$ityp"
        if [ "$lyr" -eq 0 ]; then
            cp mtmp.nc "$out"
        else
            ncks -h -A -C -v "$v" mtmp.nc "$out"
        fi
        lyr=`expr "$lyr" + 1 `
        shift
    done
    # rm -f mtmp.asc mtmp.nc
}

doit veg_type_fc "Veg.Fract" f
domulti veg_type_lai.nc "Veg.LAI" f \
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
doit soil_type_kslat "Soil.KsLat" f
dolayered soil_type_poro.nc "Soil.Porosity" f \
    soil_type_poro01.asc \
    soil_type_poro02.asc \
    soil_type_poro03.asc
