debImport "-sv" "-f" "filelist.f" "+define+RTL" "+v2k" -autoalias
debLoadSimResult /RAID2/COURSE/iclab/iclab018/Lab02/Exercise/01_RTL/BB.fsdb
wvCreateWindow
schCreateWindow -delim "." -win $_nSchema1 -scope "TESTBED"
schSelect -win $_nSchema3 -inst "u_BB"
schPushViewIn -win $_nSchema3
verdiDockWidgetMaximize -dock windowDock_nSchema_3
schSelect -win $_nSchema3 -inst "BB\(@1\):FSM0:65:354:FSM"
schPushViewIn -win $_nSchema3
fsmSetCurrentWindow -win $_nState4
fsmResizeWindow 0 27 1920 879 -win $_nState4
fsmResizeWindow 0 27 1920 879 -win $_nState4
fsmResizeWindow 0 27 1920 879 -win $_nState4
verdiDockWidgetSetCurTab -dock windowDock_nState_4
fsmResizeWindow 0 27 1920 879 -win $_nState4
fsmResizeWindow 0 27 1920 879 -win $_nState4
verdiDockWidgetSetCurTab -dock windowDock_nSchema_3
schDeselectAll -win $_nSchema3
schSelect -win $_nSchema3 -inst "BB\(@1\):Always11:260:310:Combo"
schPushViewIn -win $_nSchema3
srcSetScope -win $_nTrace1 "TESTBED.u_BB" -delim "."
srcSelect -win $_nTrace1 -range {260 310 1 2 1 1}
verdiDockWidgetSetCurTab -dock windowDock_nSchema_3
schSelect -win $_nSchema3 -inst "BB\(@1\):Always15:356:361:Combo"
schPushViewIn -win $_nSchema3
srcSelect -win $_nTrace1 -range {356 361 1 2 1 1}
verdiDockWidgetSetCurTab -dock windowDock_nSchema_3
schSelect -win $_nSchema3 -inst "BB\(@1\):Always8:203:220:Combo"
schPushViewIn -win $_nSchema3
srcSelect -win $_nTrace1 -range {203 220 1 2 1 1}
verdiDockWidgetSetCurTab -dock windowDock_nSchema_3
schPushViewIn -win $_nSchema3
srcSelect -win $_nTrace1 -range {203 220 1 2 1 1}
verdiDockWidgetSetCurTab -dock windowDock_nSchema_3
tfgGenerate -incr -ref "TESTBED.u_BB.out_num\[1:0\]#0#T" -startWithStmt -schFG -traceFlattenMDA 0 -clockSkew 0 -loopUnroll 0 -bboxEmptyModule 0 -bboxIgnoreProtected 0 -cellModel 0 -confined_flattern 32768
tfgFolderClick  -funcblk -win $_tFlowView5 "TESTBED.u_BB.out_num\[1:0\]#0#T"
tfgFit -win $_tFlowView5
tfgFit -win $_tFlowView5
tfgCloseViewer -win $_tFlowView5
verdiDockWidgetSetCurTab -dock windowDock_nState_4
verdiDockWidgetSetCurTab -dock windowDock_nSchema_3
schDeselectAll -win $_nSchema3
schSelect -win $_nSchema3 -inst "BB\(@1\):Always4:107:110:Reg"
schPushViewIn -win $_nSchema3
srcSelect -win $_nTrace1 -range {107 110 1 2 1 1}
verdiDockWidgetSetCurTab -dock windowDock_nSchema_3
schDeselectAll -win $_nSchema3
schFit -win $_nSchema3
schFit -win $_nSchema3
schFit -win $_nSchema3
schSelect -win $_nSchema3 -instpin "BB\(@1\):Always11:260:310:Combo" \
          "CH_base\[2:0\]"
schSelect -win $_nSchema3 -signal "clk" "base\[2\]" "base\[1\]" "base\[0\]" \
          "out_num\[1\]" "in_valid" "three_out" "current_half" "out_valid" \
          "rst_n" "half" "next_out_num\[1:0\]" "score_B\[7:0\]" \
          "score_A\[7:0\]" "nextState\[1:0\]" "current_action\[2:0\]" \
          "next_base\[2:0\]" "base\[2:0\]" "base\[2:1\]" "get_score\[7:0\]" \
          "out_num\[1:0\]" "State\[1:0\]" "current_inning\[1:0\]" "a\[2:0\]" \
          -inst "BB\(@1\):FSM0:65:354:FSM" "BB\(@1\):Always11:260:310:Combo"
schDeselectAll -win $_nSchema3
schZoomIn -win $_nSchema3
schZoomIn -win $_nSchema3
schZoomIn -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoom {14373} {25634} {14548} {29163} -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schSetOptions -win $_nSchema3 -pan on
schSelect -win $_nSchema3 -inst "BB\(@1\):Always11:260:310:Combo"
schSelect -win $_nSchema3 -inst "BB\(@1\):Always11:260:310:Combo"
schPushViewIn -win $_nSchema3
srcSelect -win $_nTrace1 -range {260 310 1 2 1 1}
verdiDockWidgetSetCurTab -dock widgetDock_<Message>
verdiDockWidgetSetCurTab -dock windowDock_nSchema_3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schSelect -win $_nSchema3 -inst "BB\(@1\):Always7:142:199:Combo"
schPushViewIn -win $_nSchema3
srcSelect -win $_nTrace1 -range {142 199 1 2 1 1}
verdiDockWidgetSetCurTab -dock windowDock_nSchema_3
verdiDockWidgetSetCurTab -dock windowDock_nState_4
verdiDockWidgetSetCurTab -dock widgetDock_<Message>
nsMsgSwitchTab -tab cmpl
debReload
nsMsgSwitchTab -tab cmpl
nsMsgSwitchTab -tab trace
nsMsgSwitchTab -tab search
nsMsgSwitchTab -tab intercon
verdiDockWidgetSetCurTab -dock windowDock_nState_4
fsmResizeWindow 0 27 1920 877 -win $_nState4
verdiDockWidgetSetCurTab -dock windowDock_nSchema_3
verdiDockWidgetSetCurTab -dock widgetDock_MTB_SOURCE_TAB_1
verdiDockWidgetSetCurTab -dock windowDock_nSchema_3
schSelect -win $_nSchema3 -inst "BB\(@1\):Always11:260:310:Combo"
schSelect -win $_nSchema3 -inst "BB\(@1\):Always9:223:243:Combo"
schProperties -win $_nSchema3
schProperties -win $_nSchema3 -Basic on -Library on
schSelect -win $_nSchema3 -inst "BB\(@1\):FSM0:65:354:FSM"
schPushViewIn -win $_nSchema3
fsmSelect -add -transition "T3" -win $_nState4
fsmSelect -transition "T2" -win $_nState4
debReload
debReload
fsmCloseWindow -win $_nState4
debExit
