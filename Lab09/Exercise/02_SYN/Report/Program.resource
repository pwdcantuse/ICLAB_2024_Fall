 
****************************************
Report : resources
Design : Program
Version: T-2022.03
Date   : Sat Nov 23 19:52:13 2024
****************************************


Resource Report for this hierarchy in file ../01_RTL/Program.sv
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| gte_x_9        | DW_cmp         | width=12   | gte_231_S2 (Program.sv:231) |
| gte_x_10       | DW_cmp         | width=12   | gte_232_S2 (Program.sv:232) |
| gte_x_11       | DW_cmp         | width=12   | gte_233_S2 (Program.sv:233) |
| gte_x_12       | DW_cmp         | width=12   | gte_234_S2 (Program.sv:234) |
| div_25         | DW_div_uns     | a_width=14 | div_342 (Program.sv:342)   |
|                |                | b_width=2  |                            |
| gte_x_27       | DW_cmp         | width=12   | gte_366 (Program.sv:366)   |
| gte_x_43       | DW_cmp         | width=12   | mm0/gte_422_S2 (Program.sv:422) |
| gte_x_47       | DW_cmp         | width=12   | mm3/gte_422_S2 (Program.sv:422) |
| gte_x_51       | DW_cmp         | width=12   | mm2/gte_422_S2 (Program.sv:422) |
| gte_x_57       | DW_cmp         | width=12   | mm1/gte_422_S2 (Program.sv:422) |
| gt_x_64        | DW_cmp         | width=4    | gt_142 (Program.sv:142)    |
|                |                |            | gt_361 (Program.sv:361)    |
| eq_x_65        | DW_cmp         | width=4    | eq_142_3 (Program.sv:142)  |
|                |                |            | eq_361 (Program.sv:361)    |
| gte_x_66       | DW_cmp         | width=5    | gte_142 (Program.sv:142)   |
|                |                |            | gte_361 (Program.sv:361)   |
| DP_OP_158J1_122_899             |            |                            |
|                | DP_OP_158J1_122_899 |       |                            |
| DP_OP_167_140_5830              |            |                            |
|                | DP_OP_167_140_5830 |        |                            |
| DP_OP_47J1_132_4523             |            |                            |
|                | DP_OP_47J1_132_4523 |       |                            |
| DP_OP_44J1_129_2482             |            |                            |
|                | DP_OP_44J1_129_2482 |       |                            |
| DP_OP_41J1_126_441              |            |                            |
|                | DP_OP_41J1_126_441 |        |                            |
| DP_OP_38J1_123_8367             |            |                            |
|                | DP_OP_38J1_123_8367 |       |                            |
=============================================================================

Datapath Report for DP_OP_158J1_122_899
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_158J1_122_899  | add_319 (Program.sv:319) add_319_2 (Program.sv:319) |
|                      | add_319_3 (Program.sv:319)                          |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 1     |                                          |
| I2    | PI   | Unsigned | 1     |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| I4    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 4     | I1 + I2 + I3 + I4 (Program.sv:319)       |
==============================================================================

Datapath Report for DP_OP_167_140_5830
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_167_140_5830   | add_310 (Program.sv:310) add_310_2 (Program.sv:310) |
|                      | add_310_3 (Program.sv:310) add_322 (Program.sv:322) |
|                      | add_322_2 (Program.sv:322) C2239 (Program.sv:308)   |
|                      | add_325 (Program.sv:325) add_325_2 (Program.sv:325) |
|                      | sub_313 (Program.sv:313)                            |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 12    |                                          |
| I2    | PI   | Unsigned | 12    |                                          |
| I3    | PI   | Unsigned | 12    |                                          |
| I4    | PI   | Unsigned | 1     |                                          |
| I5    | PI   | Unsigned | 1     |                                          |
| I6    | PI   | Unsigned | 1     |                                          |
| I7    | PI   | Unsigned | 10    |                                          |
| I8    | PI   | Unsigned | 10    |                                          |
| I9    | PI   | Unsigned | 12    |                                          |
| I10   | PI   | Unsigned | 1     |                                          |
| T152  | IFO  | Unsigned | 11    | I7 + I8 (Program.sv:325)                 |
| T164  | IFO  | Signed   | 14    | { I4, I5, I6 } ? O1 : I1 : T152 (Program.sv:308) |
| O1    | PO   | Unsigned | 14    | I1 + I2 + I3 ( Program.sv:310 Program.sv:322 ) |
| O2    | PO   | Signed   | 14    | addsub(I9,T164,I10) ( Program.sv:310 Program.sv:313 Program.sv:325 ) |
==============================================================================

Datapath Report for DP_OP_47J1_132_4523
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_47J1_132_4523  | add_266 (Program.sv:266) sub_268 (Program.sv:268)   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 13    |                                          |
| I2    | PI   | Signed   | 13    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Signed   | 13    | addsub(I1,I2,I3) ( Program.sv:266 Program.sv:268 ) |
==============================================================================

Datapath Report for DP_OP_44J1_129_2482
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_44J1_129_2482  | add_260 (Program.sv:260) sub_262 (Program.sv:262)   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 13    |                                          |
| I2    | PI   | Signed   | 13    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Signed   | 13    | addsub(I1,I2,I3) ( Program.sv:260 Program.sv:262 ) |
==============================================================================

Datapath Report for DP_OP_41J1_126_441
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_41J1_126_441   | add_254 (Program.sv:254) sub_256 (Program.sv:256)   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 13    |                                          |
| I2    | PI   | Signed   | 13    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Signed   | 13    | addsub(I1,I2,I3) ( Program.sv:254 Program.sv:256 ) |
==============================================================================

Datapath Report for DP_OP_38J1_123_8367
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_38J1_123_8367  | add_248 (Program.sv:248) sub_250 (Program.sv:250)   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 13    |                                          |
| I2    | PI   | Signed   | 13    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Signed   | 13    | addsub(I1,I2,I3) ( Program.sv:248 Program.sv:250 ) |
==============================================================================


Resource Report for Ungrouped Hierarchy div_25
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| gte_x_9            | DW_cmp           | apparch (area)     |                |
| gte_x_10           | DW_cmp           | apparch (area)     |                |
| gte_x_11           | DW_cmp           | apparch (area)     |                |
| gte_x_12           | DW_cmp           | apparch (area)     |                |
| div_25             | DW_div_uns       | cla2               |                |
| gte_x_27           | DW_cmp           | apparch (area)     |                |
| gte_x_43           | DW_cmp           | apparch (area)     |                |
| gte_x_47           | DW_cmp           | apparch (area)     |                |
| gte_x_51           | DW_cmp           | apparch (area)     |                |
| gte_x_57           | DW_cmp           | apparch (area)     |                |
| gt_x_64            | DW_cmp           | apparch (area)     |                |
| eq_x_65            | DW_cmp           | apparch (area)     |                |
| gte_x_66           | DW_cmp           | apparch (area)     |                |
| DP_OP_158J1_122_899                   |                    |                |
|                    | DP_OP_158J1_122_899 | str (area)      |                |
| DP_OP_167_140_5830 | DP_OP_167_140_5830 | str (area,speed) |                |
| DP_OP_47J1_132_4523                   |                    |                |
|                    | DP_OP_47J1_132_4523 | str (area)      |                |
| DP_OP_44J1_129_2482                   |                    |                |
|                    | DP_OP_44J1_129_2482 | str (area,speed)                 |
| DP_OP_41J1_126_441 | DP_OP_41J1_126_441 | str (area)       |                |
| DP_OP_38J1_123_8367                   |                    |                |
|                    | DP_OP_38J1_123_8367 | str (area,speed)                 |
===============================================================================

1
