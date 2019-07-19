set term post enh eps color solid "Helvetica" 16

set xdata time
set timefmt "%m/%d/%Y-%H:%M:%S"

set pointsize .75
set key title "Rainy Creek"
set key left
set key width -5

set format x "%d%b\n%Y"
set ylabel "Basin-wide Snow Water Equivalent, m"

plot 'Aggregated.Values' every 8::1 using 1:($9) title "Serial (master 59e3)" with points ls 7 lc "gray50", \
     '../output.4/Aggregated.Values' every ::1 using 1:($9) title "Parallel (parallel e24b)" with lines ls 1 lw 2 lc "red",


