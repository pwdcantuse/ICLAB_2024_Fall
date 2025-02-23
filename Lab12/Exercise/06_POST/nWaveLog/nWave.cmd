wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/RAID2/COURSE/iclab/iclab018/Lab12/Exercise/06_POST/CHIP_POST.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/clk} \
{/TESTBED/fail} \
{/TESTBED/in_valid} \
{/TESTBED/position\[2:0\]} \
{/TESTBED/rst_n} \
{/TESTBED/score\[3:0\]} \
{/TESTBED/score_valid} \
{/TESTBED/tetris\[71:0\]} \
{/TESTBED/tetris_valid} \
{/TESTBED/tetrominoes\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 )} 
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/clk} \
{/TESTBED/fail} \
{/TESTBED/in_valid} \
{/TESTBED/position\[2:0\]} \
{/TESTBED/rst_n} \
{/TESTBED/score\[3:0\]} \
{/TESTBED/score_valid} \
{/TESTBED/tetris\[71:0\]} \
{/TESTBED/tetris_valid} \
{/TESTBED/tetrominoes\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 )} 
wvSetPosition -win $_nWave1 {("G1" 10)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 12315.039012
wvZoomAll -win $_nWave1
wvSetCursor -win $_nWave1 12315.039012
wvResizeWindow -win $_nWave1 450 310 960 332
wvResizeWindow -win $_nWave1 450 310 960 332
wvSetCursor -win $_nWave1 99047.124172
wvExit
