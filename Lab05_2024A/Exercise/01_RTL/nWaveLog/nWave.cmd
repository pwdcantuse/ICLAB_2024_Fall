wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/RAID2/COURSE/iclab/iclab018/Lab05_2024A/Exercise/01_RTL/TMIP.fsdb}
wvResizeWindow -win $_nWave1 1920 23 1920 1009
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_TMIP"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_PATTERN"
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_PATTERN"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_TMIP"
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_TMIP/mem0_addr\[8:0\]} \
{/TESTBED/u_TMIP/mem1_addr\[6:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 )} 
wvSetPosition -win $_nWave1 {("G1" 2)}
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_PATTERN"
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_TMIP/mem0_addr\[8:0\]} \
{/TESTBED/u_TMIP/mem1_addr\[6:0\]} \
{/TESTBED/u_PATTERN/clk} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_TMIP/mem0_addr\[8:0\]} \
{/TESTBED/u_TMIP/mem1_addr\[6:0\]} \
{/TESTBED/u_PATTERN/clk} \
{/TESTBED/u_PATTERN/rst_n} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_TMIP/mem0_addr\[8:0\]} \
{/TESTBED/u_TMIP/mem1_addr\[6:0\]} \
{/TESTBED/u_PATTERN/clk} \
{/TESTBED/u_PATTERN/rst_n} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvGetSignalClose -win $_nWave1
wvZoom -win $_nWave1 0.000000 14944689.298448
wvZoom -win $_nWave1 0.000000 293880.529871
wvSetCursor -win $_nWave1 20056.623785
wvSetCursor -win $_nWave1 15127.453533
wvSetCursor -win $_nWave1 15127.453533
wvSetCursor -win $_nWave1 6628.884132
wvSetCursor -win $_nWave1 4589.227476
wvSetCursor -win $_nWave1 6288.941356
wvSetCursor -win $_nWave1 4079.313312
wvSetCursor -win $_nWave1 5269.113028
wvSearchNext -win $_nWave1
wvSearchPrev -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSearchNext -win $_nWave1
