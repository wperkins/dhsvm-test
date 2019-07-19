set term post enh eps color solid "Helvetica" 16

set xdata time
set timefmt "%m.%d.%Y-%H:%M:%S"

set pointsize 0.75
set key title "Rainy Creek"
set key left
set key width -5 

set format x "%d%b\n%Y"
set ylabel "Discharge, m^{3}/s"

plot 'Streamflow.Only' every ::1 using 1:($2/3/3600) title "Serial (master 59e3230)" with points ls 7 lc "gray50", \
     '../output.4/Streamflow.Only' every ::1 using 1:($2/3/3600) title "Parallel (parallel e24b11c)" with lines ls 1 lc "red" lw 2


