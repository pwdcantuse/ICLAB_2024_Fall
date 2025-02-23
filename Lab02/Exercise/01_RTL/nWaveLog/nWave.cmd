wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/RAID2/COURSE/iclab/iclab018/Lab02/Exercise/01_RTL/BB.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalClose -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSetPosition -win $_nWave1 {("G1" 1)}
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetPosition -win $_nWave1 {("G1" 2)}
wvGetSignalClose -win $_nWave1
wvZoomAll -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/inning\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSetPosition -win $_nWave1 {("G1" 5)}
wvGetSignalClose -win $_nWave1
wvResizeWindow -win $_nWave1 8 31 893 202
wvResizeWindow -win $_nWave1 8 31 893 913
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 727505.785289 1151295.563127
wvGetSignalOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSetPosition -win $_nWave1 {("G1" 6)}
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetCursor -win $_nWave1 910994.475331 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 920975.031693 -snap {("G1" 1)}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/half} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/half} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvGetSignalClose -win $_nWave1
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvGetSignalClose -win $_nWave1
wvResizeWindow -win $_nWave1 0 23 1920 1009
wvResizeWindow -win $_nWave1 8 31 893 913
wvResizeWindow -win $_nWave1 0 23 1920 1009
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
{/TESTBED/u_BB/State\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
{/TESTBED/u_BB/State\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvGetSignalClose -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 0)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSelectGroup -win $_nWave1 {G1}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectGroup -win $_nWave1 {G1}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 2)}
wvResizeWindow -win $_nWave1 8 31 893 913
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/State\[2:0\]} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/State\[2:0\]} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvGetSignalClose -win $_nWave1
wvResizeWindow -win $_nWave1 8 31 893 984
wvResizeWindow -win $_nWave1 0 23 1920 1009
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvZoom -win $_nWave1 1889835.370488 2204077.137429
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/State\[2:0\]} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 5 )} 
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/State\[2:0\]} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 5 )} 
wvSetPosition -win $_nWave1 {("G1" 5)}
wvGetSignalClose -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 8)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetCursor -win $_nWave1 2184616.186751 -snap {("G1" 1)}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G1" 11)}
wvSetPosition -win $_nWave1 {("G1" 11)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/State\[2:0\]} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/get_score\[7:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 11 )} 
wvSetPosition -win $_nWave1 {("G1" 11)}
wvSetPosition -win $_nWave1 {("G1" 11)}
wvSetPosition -win $_nWave1 {("G1" 11)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/State\[2:0\]} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/get_score\[7:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 11 )} 
wvSetPosition -win $_nWave1 {("G1" 11)}
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G1" 12)}
wvSetPosition -win $_nWave1 {("G1" 12)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/State\[2:0\]} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/get_score\[7:0\]} \
{/TESTBED/u_BB/base\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 12 )} 
wvSetPosition -win $_nWave1 {("G1" 12)}
wvSetPosition -win $_nWave1 {("G1" 12)}
wvSetPosition -win $_nWave1 {("G1" 12)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/State\[2:0\]} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/get_score\[7:0\]} \
{/TESTBED/u_BB/base\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 12 )} 
wvSetPosition -win $_nWave1 {("G1" 12)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 12 )} 
wvSetRadix -win $_nWave1 -format Bin
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G1" 13)}
wvSetPosition -win $_nWave1 {("G1" 13)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/State\[2:0\]} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/get_score\[7:0\]} \
{/TESTBED/u_BB/base\[2:0\]} \
{/TESTBED/u_BB/current_action\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 13 )} 
wvSetPosition -win $_nWave1 {("G1" 13)}
wvSetPosition -win $_nWave1 {("G1" 13)}
wvSetPosition -win $_nWave1 {("G1" 13)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/State\[2:0\]} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/current_inning\[1:0\]} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/nextState\[2:0\]} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/get_score\[7:0\]} \
{/TESTBED/u_BB/base\[2:0\]} \
{/TESTBED/u_BB/current_action\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 13 )} 
wvSetPosition -win $_nWave1 {("G1" 13)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvExpandBus -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSelectSignal -win $_nWave1 {( "G1" 16 )} 
wvSetPosition -win $_nWave1 {("G1" 16)}
wvExpandBus -win $_nWave1 {("G1" 16)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 17 )} 
wvSelectSignal -win $_nWave1 {( "G1" 16 )} 
wvSetPosition -win $_nWave1 {("G1" 16)}
wvCollapseBus -win $_nWave1 {("G1" 16)}
wvSetPosition -win $_nWave1 {("G1" 16)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvCollapseBus -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvExpandBus -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSelectSignal -win $_nWave1 {( "G1" 11 )} 
wvSelectSignal -win $_nWave1 {( "G1" 12 )} 
wvSelectSignal -win $_nWave1 {( "G1" 16 )} 
wvSetPosition -win $_nWave1 {("G1" 16)}
wvExpandBus -win $_nWave1 {("G1" 16)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSelectSignal -win $_nWave1 {( "G1" 21 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 16 )} 
wvSetPosition -win $_nWave1 {("G1" 16)}
wvCollapseBus -win $_nWave1 {("G1" 16)}
wvSetPosition -win $_nWave1 {("G1" 16)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvCollapseBus -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetCursor -win $_nWave1 37271723.436449 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvUnknownSaveResult -win $_nWave1 -clear
wvGetSignalOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 1)}
wvSetPosition -win $_nWave1 {("G2" 1)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/base\[2:0\]} \
{/TESTBED/u_BB/current_action\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/u_BB/inning\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSetPosition -win $_nWave1 {("G2" 1)}
wvSetPosition -win $_nWave1 {("G2" 1)}
wvSetPosition -win $_nWave1 {("G2" 1)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/base\[2:0\]} \
{/TESTBED/u_BB/current_action\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/u_BB/inning\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSetPosition -win $_nWave1 {("G2" 1)}
wvGetSignalClose -win $_nWave1
wvZoomAll -win $_nWave1
wvZoom -win $_nWave1 3533416.877771 3722496.041799
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/base\[2:0\]} \
{/TESTBED/u_BB/current_action\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/u_BB/inning\[1:0\]} \
{/TESTBED/u_BB/State\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/base\[2:0\]} \
{/TESTBED/u_BB/current_action\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/u_BB/inning\[1:0\]} \
{/TESTBED/u_BB/State\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSetPosition -win $_nWave1 {("G2" 2)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 3603103.147248 -snap {("G2" 2)}
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/u_BB"
wvSetPosition -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G2" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/base\[2:0\]} \
{/TESTBED/u_BB/current_action\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/u_BB/inning\[1:0\]} \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/get_score\[3:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSetPosition -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G2" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/u_BB/in_valid} \
{/TESTBED/u_BB/half} \
{/TESTBED/u_BB/out_valid} \
{/TESTBED/u_BB/three_out} \
{/TESTBED/u_BB/current_half} \
{/TESTBED/u_BB/score_A\[7:0\]} \
{/TESTBED/u_BB/score_B\[7:0\]} \
{/TESTBED/u_BB/base\[2:0\]} \
{/TESTBED/u_BB/current_action\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/u_BB/inning\[1:0\]} \
{/TESTBED/u_BB/State\[1:0\]} \
{/TESTBED/u_BB/get_score\[3:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSetPosition -win $_nWave1 {("G2" 3)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 3494852.631554 -snap {("G2" 3)}
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvExit
