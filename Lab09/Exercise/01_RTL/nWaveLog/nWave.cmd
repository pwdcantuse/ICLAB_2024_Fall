wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/RAID2/COURSE/iclab/iclab018/Lab09/Exercise/01_RTL/Program.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/dram_r"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/test_p"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/inf"
wvSetPosition -win $_nWave1 {("G1" 27)}
wvSetPosition -win $_nWave1 {("G1" 27)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/inf/AR_ADDR\[16:0\]} \
{/TESTBED/inf/AR_READY} \
{/TESTBED/inf/AR_VALID} \
{/TESTBED/inf/AW_ADDR\[16:0\]} \
{/TESTBED/inf/AW_READY} \
{/TESTBED/inf/AW_VALID} \
{/TESTBED/inf/B_READY} \
{/TESTBED/inf/B_RESP\[1:0\]} \
{/TESTBED/inf/B_VALID} \
{/TESTBED/inf/D} \
{/TESTBED/inf/R_DATA\[63:0\]} \
{/TESTBED/inf/R_READY} \
{/TESTBED/inf/R_RESP\[1:0\]} \
{/TESTBED/inf/R_VALID} \
{/TESTBED/inf/W_DATA\[63:0\]} \
{/TESTBED/inf/W_READY} \
{/TESTBED/inf/W_VALID} \
{/TESTBED/inf/complete} \
{/TESTBED/inf/data_no_valid} \
{/TESTBED/inf/date_valid} \
{/TESTBED/inf/formula_valid} \
{/TESTBED/inf/index_valid} \
{/TESTBED/inf/mode_valid} \
{/TESTBED/inf/out_valid} \
{/TESTBED/inf/rst_n} \
{/TESTBED/inf/sel_action_valid} \
{/TESTBED/inf/warn_msg\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 22 23 24 25 26 27 )} 
wvSetPosition -win $_nWave1 {("G1" 27)}
wvSetPosition -win $_nWave1 {("G1" 27)}
wvSetPosition -win $_nWave1 {("G1" 27)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/inf/AR_ADDR\[16:0\]} \
{/TESTBED/inf/AR_READY} \
{/TESTBED/inf/AR_VALID} \
{/TESTBED/inf/AW_ADDR\[16:0\]} \
{/TESTBED/inf/AW_READY} \
{/TESTBED/inf/AW_VALID} \
{/TESTBED/inf/B_READY} \
{/TESTBED/inf/B_RESP\[1:0\]} \
{/TESTBED/inf/B_VALID} \
{/TESTBED/inf/D} \
{/TESTBED/inf/R_DATA\[63:0\]} \
{/TESTBED/inf/R_READY} \
{/TESTBED/inf/R_RESP\[1:0\]} \
{/TESTBED/inf/R_VALID} \
{/TESTBED/inf/W_DATA\[63:0\]} \
{/TESTBED/inf/W_READY} \
{/TESTBED/inf/W_VALID} \
{/TESTBED/inf/complete} \
{/TESTBED/inf/data_no_valid} \
{/TESTBED/inf/date_valid} \
{/TESTBED/inf/formula_valid} \
{/TESTBED/inf/index_valid} \
{/TESTBED/inf/mode_valid} \
{/TESTBED/inf/out_valid} \
{/TESTBED/inf/rst_n} \
{/TESTBED/inf/sel_action_valid} \
{/TESTBED/inf/warn_msg\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 22 23 24 25 26 27 )} 
wvSetPosition -win $_nWave1 {("G1" 27)}
wvGetSignalClose -win $_nWave1
wvZoomAll -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 10 )} 
wvZoom -win $_nWave1 20202445.455643 22398363.439952
wvZoom -win $_nWave1 21197698.567418 21320945.623870
wvZoomAll -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 27 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/inf"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/inf/DRAM"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/test_p"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/inf/Program_inf"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/test_p"
wvGetSignalSetScope -win $_nWave1 "/_\$novas_unit__1"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/test_p"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/inf/Program_inf"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/dut_p"
wvSetPosition -win $_nWave1 {("G1" 28)}
wvSetPosition -win $_nWave1 {("G1" 28)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/inf/AR_ADDR\[16:0\]} \
{/TESTBED/inf/AR_READY} \
{/TESTBED/inf/AR_VALID} \
{/TESTBED/inf/AW_ADDR\[16:0\]} \
{/TESTBED/inf/AW_READY} \
{/TESTBED/inf/AW_VALID} \
{/TESTBED/inf/B_READY} \
{/TESTBED/inf/B_RESP\[1:0\]} \
{/TESTBED/inf/B_VALID} \
{/TESTBED/inf/D} \
{/TESTBED/inf/R_DATA\[63:0\]} \
{/TESTBED/inf/R_READY} \
{/TESTBED/inf/R_RESP\[1:0\]} \
{/TESTBED/inf/R_VALID} \
{/TESTBED/inf/W_DATA\[63:0\]} \
{/TESTBED/inf/W_READY} \
{/TESTBED/inf/W_VALID} \
{/TESTBED/inf/complete} \
{/TESTBED/inf/data_no_valid} \
{/TESTBED/inf/date_valid} \
{/TESTBED/inf/formula_valid} \
{/TESTBED/inf/index_valid} \
{/TESTBED/inf/mode_valid} \
{/TESTBED/inf/out_valid} \
{/TESTBED/inf/rst_n} \
{/TESTBED/inf/sel_action_valid} \
{/TESTBED/inf/warn_msg\[1:0\]} \
{/TESTBED/dut_p/act_ff\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 28 )} 
wvSetPosition -win $_nWave1 {("G1" 28)}
wvSetPosition -win $_nWave1 {("G1" 28)}
wvSetPosition -win $_nWave1 {("G1" 28)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/inf/AR_ADDR\[16:0\]} \
{/TESTBED/inf/AR_READY} \
{/TESTBED/inf/AR_VALID} \
{/TESTBED/inf/AW_ADDR\[16:0\]} \
{/TESTBED/inf/AW_READY} \
{/TESTBED/inf/AW_VALID} \
{/TESTBED/inf/B_READY} \
{/TESTBED/inf/B_RESP\[1:0\]} \
{/TESTBED/inf/B_VALID} \
{/TESTBED/inf/D} \
{/TESTBED/inf/R_DATA\[63:0\]} \
{/TESTBED/inf/R_READY} \
{/TESTBED/inf/R_RESP\[1:0\]} \
{/TESTBED/inf/R_VALID} \
{/TESTBED/inf/W_DATA\[63:0\]} \
{/TESTBED/inf/W_READY} \
{/TESTBED/inf/W_VALID} \
{/TESTBED/inf/complete} \
{/TESTBED/inf/data_no_valid} \
{/TESTBED/inf/date_valid} \
{/TESTBED/inf/formula_valid} \
{/TESTBED/inf/index_valid} \
{/TESTBED/inf/mode_valid} \
{/TESTBED/inf/out_valid} \
{/TESTBED/inf/rst_n} \
{/TESTBED/inf/sel_action_valid} \
{/TESTBED/inf/warn_msg\[1:0\]} \
{/TESTBED/dut_p/act_ff\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 28 )} 
wvSetPosition -win $_nWave1 {("G1" 28)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 70659760.917320
wvZoom -win $_nWave1 67683072.094146 70610962.739891
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvExit
