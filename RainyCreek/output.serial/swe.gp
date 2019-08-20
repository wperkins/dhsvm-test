# set term post enh eps color solid "Helvetica" 16

set xdata time
set timefmt "%m/%d/%Y-%H:%M:%S"

set pointsize 1.0
set key title "Rainy Creek"
set key left
# set key width -5

set format x "%d%b\n%Y"
set ylabel "Basin-wide Snow Water Equivalent, m"

plot 'Aggregated.Values' every 8::1 using 1:($9) title "Original" with points ls 2 lc "gray50", \
     '../output.4/Aggregated.Values' every ::1 using 1:($9) title "New" with lines ls 1 lw 1


