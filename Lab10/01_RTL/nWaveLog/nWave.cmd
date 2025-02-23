wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 {/RAID2/COURSE/iclab/iclab018/Lab10/01_RTL/Program.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/\$unit_0x0359e3aa"
wvGetSignalSetScope -win $_nWave1 "/usertype"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/test_p"
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/test_p/data_dir_in} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/test_p/data_dir_in} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSetPosition -win $_nWave1 {("G1" 1)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvExpandBus -win $_nWave1 {("G1" 1)}
wvZoomAll -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/\$unit_0x0359e3aa"
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/test_p"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/check_inst"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/test_p"
wvSetPosition -win $_nWave1 {("G1" 8)}
wvSetPosition -win $_nWave1 {("G1" 8)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/test_p/data_dir_in} \
{/TESTBED/test_p/data_dir_in.Index_A\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_B\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_C\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_D\[11:0\]} \
{/TESTBED/test_p/data_dir_in.M\[3:0\]} \
{/TESTBED/test_p/data_dir_in.D\[4:0\]} \
{/TESTBED/test_p/i_pat\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSetPosition -win $_nWave1 {("G1" 8)}
wvSetPosition -win $_nWave1 {("G1" 8)}
wvSetPosition -win $_nWave1 {("G1" 8)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/test_p/data_dir_in} \
{/TESTBED/test_p/data_dir_in.Index_A\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_B\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_C\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_D\[11:0\]} \
{/TESTBED/test_p/data_dir_in.M\[3:0\]} \
{/TESTBED/test_p/data_dir_in.D\[4:0\]} \
{/TESTBED/test_p/i_pat\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSetPosition -win $_nWave1 {("G1" 8)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 908882994.723404
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSetRadix -win $_nWave1 -format UDec
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetCursor -win $_nWave1 870723785.021277
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/\$unit_0x0359e3aa"
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/test_p"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/test_p"
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/test_p/data_dir_in} \
{/TESTBED/test_p/data_dir_in.Index_A\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_B\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_C\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_D\[11:0\]} \
{/TESTBED/test_p/data_dir_in.M\[3:0\]} \
{/TESTBED/test_p/data_dir_in.D\[4:0\]} \
{/TESTBED/test_p/i_pat\[31:0\]} \
{/TESTBED/test_p/action_in\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/test_p/data_dir_in} \
{/TESTBED/test_p/data_dir_in.Index_A\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_B\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_C\[11:0\]} \
{/TESTBED/test_p/data_dir_in.Index_D\[11:0\]} \
{/TESTBED/test_p/data_dir_in.M\[3:0\]} \
{/TESTBED/test_p/data_dir_in.D\[4:0\]} \
{/TESTBED/test_p/i_pat\[31:0\]} \
{/TESTBED/test_p/action_in\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSetPosition -win $_nWave1 {("G1" 9)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 938369656.765957
wvZoom -win $_nWave1 817821244.297872 833431830.085106
wvResizeWindow -win $_nWave1 1920 23 1920 1057
wvResizeWindow -win $_nWave1 1920 23 1920 1009
wvExit
