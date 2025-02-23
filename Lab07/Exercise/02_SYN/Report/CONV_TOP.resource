 
****************************************
Report : resources
Design : CONV_TOP
Version: T-2022.03
Date   : Mon Nov  4 01:53:18 2024
****************************************


Resource Report for this hierarchy in file ../01_RTL/DESIGN_module.v
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_54       | DW01_inc       | width=3    | u_Conv/add_383_S2 (DESIGN_module.v:383) |
| add_x_67       | DW01_inc       | width=2    | u_FIFO_syn/add_89 (FIFO_syn.v:89) |
| eq_x_69        | DW_cmp         | width=6    | u_FIFO_syn/eq_98 (FIFO_syn.v:98) |
| add_x_70       | DW01_inc       | width=7    | u_FIFO_syn/add_114 (FIFO_syn.v:114) |
| add_x_71       | DW01_inc       | width=2    | u_FIFO_syn/add_132 (FIFO_syn.v:132) |
| add_x_73       | DW01_inc       | width=7    | u_FIFO_syn/add_159 (FIFO_syn.v:159) |
| add_x_9        | DW01_inc       | width=8    | u_input_output/add_196_S2 (DESIGN_module.v:196) |
             |            | u_input_output/add_200_S2 (DESIGN_module.v:200) |
             |            | u_input_output/add_205_S2 (DESIGN_module.v:205) |
             |            | u_input_output/add_216 (DESIGN_module.v:216) |
| add_x_61       | DW01_inc       | width=5    | u_Conv/add_411_S2 (DESIGN_module.v:411) |
    |                |            | u_Conv/add_416_S2 (DESIGN_module.v:416) |
    |                |            | u_Conv/add_424_S2 (DESIGN_module.v:424) |
| DP_OP_323J1_122_5388            |            |                            |
|                | DP_OP_323J1_122_5388 |      |                            |
| DP_OP_324J1_123_5861            |            |                            |
|                | DP_OP_324J1_123_5861 |      |                            |
=============================================================================

Datapath Report for DP_OP_323J1_122_5388
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_323J1_122_5388 | u_Conv/mult_619 (DESIGN_module.v:619)               |
|                      | u_Conv/add_619 (DESIGN_module.v:619)                |
|                      | u_Conv/add_619_2 (DESIGN_module.v:619)              |
|                      | u_Conv/add_619_3 (DESIGN_module.v:619)              |
|                      | u_Conv/mult_619_2 (DESIGN_module.v:619)             |
|                      | u_Conv/mult_619_3 (DESIGN_module.v:619)             |
|                      | u_Conv/mult_619_4 (DESIGN_module.v:619)             |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 3     |                                          |
| I2    | PI   | Unsigned | 3     |                                          |
| I3    | PI   | Unsigned | 3     |                                          |
| I4    | PI   | Unsigned | 3     |                                          |
| I5    | PI   | Unsigned | 3     |                                          |
| I6    | PI   | Unsigned | 3     |                                          |
| I7    | PI   | Unsigned | 3     |                                          |
| I8    | PI   | Unsigned | 3     |                                          |
| T70   | IFO  | Unsigned | 6     | I1 * I2 (DESIGN_module.v:619)            |
| T71   | IFO  | Unsigned | 6     | I3 * I4 (DESIGN_module.v:619)            |
| T73   | IFO  | Unsigned | 6     | I5 * I6 (DESIGN_module.v:619)            |
| T75   | IFO  | Unsigned | 6     | I7 * I8 (DESIGN_module.v:619)            |
| O1    | PO   | Unsigned | 8     | T70 + T71 + T73 + T75 (DESIGN_module.v:619) |
==============================================================================

Datapath Report for DP_OP_324J1_123_5861
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_324J1_123_5861 | u_FIFO_syn/sub_136 (FIFO_syn.v:136)                 |
|                      | u_FIFO_syn/eq_143 (FIFO_syn.v:143)                  |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 6     |                                          |
| I2    | PI   | Unsigned | 6     |                                          |
| T84   | IFO  | Signed   | 6     | I1 - $unsigned(1'b1) (FIFO_syn.v:136)    |
| O1    | PO   | Unsigned | 1     | I2 == $unsigned(T84) (FIFO_syn.v:143)    |
==============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_x_54           | DW01_inc         | apparch (area)     |                |
| add_x_67           | DW01_inc         | apparch (area)     |                |
| eq_x_69            | DW_cmp           | apparch (area)     |                |
| add_x_70           | DW01_inc         | apparch (area)     |                |
| add_x_71           | DW01_inc         | apparch (area)     |                |
| add_x_73           | DW01_inc         | apparch (area)     |                |
| add_x_9            | DW01_inc         | apparch (area)     |                |
| add_x_61           | DW01_inc         | apparch (area)     |                |
| DP_OP_323J1_122_5388                  |                    |                |
|                    | DP_OP_323J1_122_5388 | str (area)     |                |
|                    |                  | mult_arch: and     |                |
| DP_OP_324J1_123_5861                  |                    |                |
|                    | DP_OP_324J1_123_5861 | str (area)     |                |
===============================================================================

1
