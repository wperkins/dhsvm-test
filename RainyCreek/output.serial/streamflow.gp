# set term post enh eps color solid "Helvetica" 16

set xdata time
set timefmt "%m.%d.%Y-%H:%M:%S"

set pointsize 1.0
set key title "Rainy Creek"
set key left
# set key width -5 

set format x "%d%b\n%Y"
set ylabel "Discharge, m^{3}/s"

plot 'Streamflow.Only' every ::1 using 1:($2/3/3600) title "Original" with points ls 2 lc "gray50", \
     '../output/Streamflow.Only' every ::1 using 1:($2/3/3600) title "New" with lines ls 1 lw 1


