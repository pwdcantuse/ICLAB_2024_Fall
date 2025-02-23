wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/RAID2/COURSE/iclab/iclab018/Lab08/EXERCISE_wocg/01_RTL/SA.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/MA_19"
wvGetSignalSetScope -win $_nWave1 "/MA_41"
wvGetSignalSetScope -win $_nWave1 "/MA_19"
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/MA_19"
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/I_PATTERN"
wvGetSignalSetScope -win $_nWave1 "/MA_41"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/I_PATTERN"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/I_SA"
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/I_SA/MA_result\[0:6\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvExpandBus -win $_nWave1 {("G1" 1)}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSetPosition -win $_nWave1 {("G1" 1)}
wvCollapseBus -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvExpandBus -win $_nWave1 {("G1" 1)}
wvZoomAll -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetPosition -win $_nWave1 {("G1" 15)}
wvSetPosition -win $_nWave1 {("G1" 15)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/I_SA/MA_result\[0:6\]} \
{/TESTBED/I_SA/MA_result\[0\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[1\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[2\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[3\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[4\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[5\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[6\]\[40:0\]} \
{/TESTBED/I_SA/temp_19_0\[0:7\]} \
{/TESTBED/I_SA/temp_19_1\[0:7\]} \
{/TESTBED/I_SA/temp_19_2\[0:7\]} \
{/TESTBED/I_SA/temp_19_3\[0:7\]} \
{/TESTBED/I_SA/temp_19_4\[0:7\]} \
{/TESTBED/I_SA/temp_19_5\[0:7\]} \
{/TESTBED/I_SA/temp_19_6\[0:7\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 15 )} 
wvSetPosition -win $_nWave1 {("G1" 15)}
wvSetPosition -win $_nWave1 {("G1" 17)}
wvSetPosition -win $_nWave1 {("G1" 17)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/I_SA/MA_result\[0:6\]} \
{/TESTBED/I_SA/MA_result\[0\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[1\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[2\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[3\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[4\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[5\]\[40:0\]} \
{/TESTBED/I_SA/MA_result\[6\]\[40:0\]} \
{/TESTBED/I_SA/temp_19_0\[0:7\]} \
{/TESTBED/I_SA/temp_19_1\[0:7\]} \
{/TESTBED/I_SA/temp_19_2\[0:7\]} \
{/TESTBED/I_SA/temp_19_3\[0:7\]} \
{/TESTBED/I_SA/temp_19_4\[0:7\]} \
{/TESTBED/I_SA/temp_19_5\[0:7\]} \
{/TESTBED/I_SA/temp_19_6\[0:7\]} \
{/TESTBED/I_SA/MA3_in_a\[0:7\]} \
{/TESTBED/I_SA/MA3_in_b\[0:7\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 16 17 )} 
wvSetPosition -win $_nWave1 {("G1" 17)}
wvGetSignalClose -win $_nWave1
wvResizeWindow -win $_nWave1 2599 309 893 202
wvResizeWindow -win $_nWave1 1920 23 1920 1009
wvSelectSignal -win $_nWave1 {( "G1" 16 )} 
wvSetPosition -win $_nWave1 {("G1" 16)}
wvExpandBus -win $_nWave1 {("G1" 16)}
wvSetPosition -win $_nWave1 {("G1" 25)}
wvSelectSignal -win $_nWave1 {( "G1" 25 )} 
wvExpandBus -win $_nWave1 {("G1" 25)}
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSetPosition -win $_nWave1 {("G1" 9)}
wvExpandBus -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 41)}
wvSelectSignal -win $_nWave1 {( "G1" 19 )} 
wvSetPosition -win $_nWave1 {("G1" 19)}
wvExpandBus -win $_nWave1 {("G1" 19)}
wvSetPosition -win $_nWave1 {("G1" 49)}
wvSelectSignal -win $_nWave1 {( "G1" 19 )} 
wvSetPosition -win $_nWave1 {("G1" 19)}
wvCollapseBus -win $_nWave1 {("G1" 19)}
wvSetPosition -win $_nWave1 {("G1" 19)}
wvSetPosition -win $_nWave1 {("G1" 41)}
wvSelectSignal -win $_nWave1 {( "G1" 19 )} 
wvSetPosition -win $_nWave1 {("G1" 19)}
wvExpandBus -win $_nWave1 {("G1" 19)}
wvSetPosition -win $_nWave1 {("G1" 49)}
wvExit
