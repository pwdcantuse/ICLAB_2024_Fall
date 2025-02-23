 
****************************************
Report : resources
Design : SSC
Version: T-2022.03
Date   : Wed Sep 18 17:44:59 2024
****************************************


Resource Report for this hierarchy in file ../01_RTL/SSC.v
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| DP_OP_631J1_122_8317            |            |                            |
|                | DP_OP_631J1_122_8317 |      |                            |
| DP_OP_632J1_123_6177            |            |                            |
|                | DP_OP_632J1_123_6177 |      |                            |
=============================================================================

Datapath Report for DP_OP_631J1_122_8317
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_631J1_122_8317 | add_123 (SSC.v:123) add_122 (SSC.v:122)             |
|                      | add_125 (SSC.v:125) add_121 (SSC.v:121)             |
|                      | add_120 (SSC.v:120) add_124 (SSC.v:124)             |
|                      | add_126 (SSC.v:126) add_115 (SSC.v:115)             |
|                      | add_114 (SSC.v:114) add_117 (SSC.v:117)             |
|                      | add_113 (SSC.v:113) add_112 (SSC.v:112)             |
|                      | add_116 (SSC.v:116) add_118 (SSC.v:118)             |
|                      | add_287 (SSC.v:287)                                 |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 4     |                                          |
| I2    | PI   | Unsigned | 4     |                                          |
| I3    | PI   | Unsigned | 4     |                                          |
| I4    | PI   | Unsigned | 4     |                                          |
| I5    | PI   | Unsigned | 4     |                                          |
| I6    | PI   | Unsigned | 4     |                                          |
| I7    | PI   | Unsigned | 4     |                                          |
| I8    | PI   | Unsigned | 4     |                                          |
| I9    | PI   | Unsigned | 4     |                                          |
| I10   | PI   | Unsigned | 4     |                                          |
| I11   | PI   | Unsigned | 4     |                                          |
| I12   | PI   | Unsigned | 4     |                                          |
| I13   | PI   | Unsigned | 4     |                                          |
| I14   | PI   | Unsigned | 4     |                                          |
| I15   | PI   | Unsigned | 4     |                                          |
| I16   | PI   | Unsigned | 4     |                                          |
| O1    | PO   | Unsigned | 8     | I1 + I2 + I3 + I4 + I5 + I6 + I7 + I8 + I9 + I10 + I11 + I12 + I13 + I14 + I15 + I16 ( SSC.v:112 SSC.v:113 SSC.v:114 SSC.v:115 SSC.v:116 SSC.v:117 SSC.v:118 SSC.v:120 SSC.v:121 SSC.v:122 SSC.v:123 SSC.v:124 SSC.v:125 SSC.v:126 SSC.v:287 ) |
==============================================================================

Datapath Report for DP_OP_632J1_123_6177
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_632J1_123_6177 | m1/mult_840 (SSC.v:840) gte_346 (SSC.v:346)         |
|                      | gte_479 (SSC.v:479) gte_508 (SSC.v:508)             |
|                      | gte_435 (SSC.v:435) gte_464 (SSC.v:464)             |
|                      | m2/mult_840 (SSC.v:840) gte_390 (SSC.v:390)         |
|                      | gte_493 (SSC.v:493) gte_449 (SSC.v:449)             |
|                      | gte_390_2 (SSC.v:390) gte_493_2 (SSC.v:493)         |
|                      | gte_347 (SSC.v:347) gte_376 (SSC.v:376)             |
|                      | gte_480 (SSC.v:480) m3/mult_840 (SSC.v:840)         |
|                      | gte_346_2 (SSC.v:346) gte_479_2 (SSC.v:479)         |
|                      | gte_391 (SSC.v:391) gte_420 (SSC.v:420)             |
|                      | gte_494 (SSC.v:494) gte_434 (SSC.v:434)             |
|                      | gte_405 (SSC.v:405) gte_434_2 (SSC.v:434)           |
|                      | gte_361 (SSC.v:361) gte_434_3 (SSC.v:434)           |
|                      | gte_361_2 (SSC.v:361) gte_348 (SSC.v:348)           |
|                      | gte_405_2 (SSC.v:405) gte_392 (SSC.v:392)           |
|                      | m4/mult_840 (SSC.v:840) gte_346_3 (SSC.v:346)       |
|                      | gte_391_2 (SSC.v:391) gte_406 (SSC.v:406)           |
|                      | gte_435_2 (SSC.v:435) gte_450 (SSC.v:450)           |
|                      | gte_390_3 (SSC.v:390) gte_347_2 (SSC.v:347)         |
|                      | gte_362 (SSC.v:362) gte_449_2 (SSC.v:449)           |
|                      | gte_436 (SSC.v:436) C2253 (SSC.v:435)               |
|                      | C2246 (SSC.v:391) C2239 (SSC.v:347)                 |
|                      | C2258 (SSC.v:346) C2297 (SSC.v:748)                 |
|                      | C2282 (SSC.v:616) C2275 (SSC.v:572)                 |
|                      | C2268 (SSC.v:528) C2287 (SSC.v:527)                 |
|                      | m5/mult_840 (SSC.v:840) gte_527 (SSC.v:527)         |
|                      | gte_660 (SSC.v:660) gte_689 (SSC.v:689)             |
|                      | gte_616 (SSC.v:616) gte_645 (SSC.v:645)             |
|                      | m6/mult_840 (SSC.v:840) gte_571 (SSC.v:571)         |
|                      | gte_674 (SSC.v:674) gte_630 (SSC.v:630)             |
|                      | gte_571_2 (SSC.v:571) gte_674_2 (SSC.v:674)         |
|                      | gte_528 (SSC.v:528) gte_557 (SSC.v:557)             |
|                      | gte_661 (SSC.v:661) m7/mult_840 (SSC.v:840)         |
|                      | gte_527_2 (SSC.v:527) gte_660_2 (SSC.v:660)         |
|                      | gte_572 (SSC.v:572) gte_601 (SSC.v:601)             |
|                      | gte_675 (SSC.v:675) gte_615 (SSC.v:615)             |
|                      | gte_586 (SSC.v:586) gte_615_2 (SSC.v:615)           |
|                      | gte_542 (SSC.v:542) gte_615_3 (SSC.v:615)           |
|                      | gte_542_2 (SSC.v:542) gte_529 (SSC.v:529)           |
|                      | gte_586_2 (SSC.v:586) gte_573 (SSC.v:573)           |
|                      | m8/mult_840 (SSC.v:840) gte_527_3 (SSC.v:527)       |
|                      | gte_572_2 (SSC.v:572) gte_587 (SSC.v:587)           |
|                      | gte_616_2 (SSC.v:616) gte_631 (SSC.v:631)           |
|                      | gte_571_3 (SSC.v:571) gte_528_2 (SSC.v:528)         |
|                      | gte_543 (SSC.v:543) gte_630_2 (SSC.v:630)           |
|                      | gte_617 (SSC.v:617) C2288 (SSC.v:527)               |
|                      | C2291 (SSC.v:724) C2259 (SSC.v:346)                 |
|                      | C2292 (SSC.v:724) C2303 (SSC.v:772)                 |
|                      | C2298 (SSC.v:748) C2304 (SSC.v:772)                 |
|                      | sub_291 (SSC.v:291) sub_290 (SSC.v:290)             |
|                      | sub_292 (SSC.v:292) C2308 (SSC.v:788)               |
|                      | C2302 (SSC.v:764) C2296 (SSC.v:740)                 |
|                      | C2257 (SSC.v:494) C2255 (SSC.v:480)                 |
|                      | C2250 (SSC.v:450) C2248 (SSC.v:436)                 |
|                      | C2252 (SSC.v:435) C2243 (SSC.v:406)                 |
|                      | C2241 (SSC.v:392) C2245 (SSC.v:391)                 |
|                      | C2236 (SSC.v:362) C2234 (SSC.v:348)                 |
|                      | C2238 (SSC.v:347) C2261 (SSC.v:346)                 |
|                      | C2295 (SSC.v:740) C2286 (SSC.v:675)                 |
|                      | C2284 (SSC.v:661) C2279 (SSC.v:631)                 |
|                      | C2277 (SSC.v:617) C2281 (SSC.v:616)                 |
|                      | C2272 (SSC.v:587) C2270 (SSC.v:573)                 |
|                      | C2274 (SSC.v:572) C2265 (SSC.v:543)                 |
|                      | C2263 (SSC.v:529) C2267 (SSC.v:528)                 |
|                      | C2290 (SSC.v:527) comp_3/gt_823 (SSC.v:823)         |
|                      | C2299 (SSC.v:756) C2294 (SSC.v:732)                 |
|                      | C2256 (SSC.v:494) C2254 (SSC.v:480)                 |
|                      | C2249 (SSC.v:450) C2247 (SSC.v:436)                 |
|                      | C2251 (SSC.v:435) C2242 (SSC.v:406)                 |
|                      | C2240 (SSC.v:392) C2244 (SSC.v:391)                 |
|                      | C2235 (SSC.v:362) C2233 (SSC.v:348)                 |
|                      | C2237 (SSC.v:347) C2260 (SSC.v:346)                 |
|                      | C2293 (SSC.v:732) C2285 (SSC.v:675)                 |
|                      | C2283 (SSC.v:661) C2278 (SSC.v:631)                 |
|                      | C2276 (SSC.v:617) C2280 (SSC.v:616)                 |
|                      | C2271 (SSC.v:587) C2269 (SSC.v:573)                 |
|                      | C2273 (SSC.v:572) C2264 (SSC.v:543)                 |
|                      | C2262 (SSC.v:529) C2266 (SSC.v:528)                 |
|                      | C2289 (SSC.v:527) comp_2/gt_823 (SSC.v:823)         |
|                      | sub_297 (SSC.v:297) sub_296 (SSC.v:296)             |
|                      | sub_295 (SSC.v:295) sub_294 (SSC.v:294)             |
|                      | sub_293 (SSC.v:293) C2310 (SSC.v:796)               |
|                      | C2306 (SSC.v:780) C2300 (SSC.v:756)                 |
|                      | C2305 (SSC.v:780) C2301 (SSC.v:764)                 |
|                      | comp_8/gt_823 (SSC.v:823) C2309 (SSC.v:796)         |
|                      | C2307 (SSC.v:788) comp_10/gt_823 (SSC.v:823)        |
|                      | comp_5/gt_823 (SSC.v:823) comp_6/gt_823 (SSC.v:823) |
|                      | comp_9/gt_823 (SSC.v:823) comp_7/gt_823 (SSC.v:823) |
|                      | comp_1/gt_823 (SSC.v:823) comp_4/gt_823 (SSC.v:823) |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 4     |                                          |
| I2    | PI   | Unsigned | 4     |                                          |
| I3    | PI   | Unsigned | 4     |                                          |
| I4    | PI   | Unsigned | 4     |                                          |
| I5    | PI   | Unsigned | 4     |                                          |
| I6    | PI   | Unsigned | 4     |                                          |
| I7    | PI   | Unsigned | 4     |                                          |
| I8    | PI   | Unsigned | 4     |                                          |
| I9    | PI   | Unsigned | 1     |                                          |
| I10   | PI   | Unsigned | 1     |                                          |
| I11   | PI   | Unsigned | 1     |                                          |
| I12   | PI   | Unsigned | 1     |                                          |
| I13   | PI   | Unsigned | 1     |                                          |
| I14   | PI   | Unsigned | 1     |                                          |
| I15   | PI   | Unsigned | 1     |                                          |
| I16   | PI   | Unsigned | 1     |                                          |
| I17   | PI   | Unsigned | 1     |                                          |
| I18   | PI   | Unsigned | 1     |                                          |
| I19   | PI   | Unsigned | 4     |                                          |
| I20   | PI   | Unsigned | 4     |                                          |
| I21   | PI   | Unsigned | 4     |                                          |
| I22   | PI   | Unsigned | 4     |                                          |
| I23   | PI   | Unsigned | 4     |                                          |
| I24   | PI   | Unsigned | 4     |                                          |
| I25   | PI   | Unsigned | 4     |                                          |
| I26   | PI   | Unsigned | 4     |                                          |
| I27   | PI   | Unsigned | 1     |                                          |
| I28   | PI   | Unsigned | 1     |                                          |
| I29   | PI   | Unsigned | 1     |                                          |
| I30   | PI   | Unsigned | 1     |                                          |
| I31   | PI   | Unsigned | 1     |                                          |
| I32   | PI   | Unsigned | 1     |                                          |
| I33   | PI   | Unsigned | 1     |                                          |
| I34   | PI   | Unsigned | 1     |                                          |
| I35   | PI   | Unsigned | 1     |                                          |
| I36   | PI   | Unsigned | 1     |                                          |
| I37   | PI   | Unsigned | 1     |                                          |
| I38   | PI   | Unsigned | 1     |                                          |
| I39   | PI   | Unsigned | 9     |                                          |
| I40   | PI   | Unsigned | 1     |                                          |
| I41   | PI   | Unsigned | 1     |                                          |
| I42   | PI   | Unsigned | 1     |                                          |
| I43   | PI   | Unsigned | 1     |                                          |
| I44   | PI   | Unsigned | 1     |                                          |
| I45   | PI   | Unsigned | 1     |                                          |
| I46   | PI   | Unsigned | 1     |                                          |
| I47   | PI   | Unsigned | 1     |                                          |
| I48   | PI   | Unsigned | 1     |                                          |
| I49   | PI   | Unsigned | 1     |                                          |
| I50   | PI   | Unsigned | 1     |                                          |
| I51   | PI   | Unsigned | 1     |                                          |
| I52   | PI   | Unsigned | 1     |                                          |
| I53   | PI   | Unsigned | 1     |                                          |
| I54   | PI   | Unsigned | 1     |                                          |
| I55   | PI   | Unsigned | 1     |                                          |
| I56   | PI   | Unsigned | 1     |                                          |
| I57   | PI   | Unsigned | 1     |                                          |
| I58   | PI   | Unsigned | 1     |                                          |
| I59   | PI   | Unsigned | 1     |                                          |
| I60   | PI   | Unsigned | 1     |                                          |
| I61   | PI   | Unsigned | 1     |                                          |
| I62   | PI   | Unsigned | 1     |                                          |
| I63   | PI   | Unsigned | 1     |                                          |
| I64   | PI   | Unsigned | 1     |                                          |
| I65   | PI   | Unsigned | 1     |                                          |
| I66   | PI   | Unsigned | 1     |                                          |
| I67   | PI   | Unsigned | 1     |                                          |
| I68   | PI   | Unsigned | 1     |                                          |
| I69   | PI   | Unsigned | 1     |                                          |
| T211  | IFO  | Unsigned | 8     | I1 * I2 (SSC.v:840)                      |
| T235  | IFO  | Unsigned | 8     | I3 * I4 (SSC.v:840)                      |
| T232  | IFO  | Unsigned | 8     | I5 * I6 (SSC.v:840)                      |
| T229  | IFO  | Unsigned | 8     | I7 * I8 (SSC.v:840)                      |
| T226  | IFO  | Unsigned | 8     | I19 * I20 (SSC.v:840)                    |
| T223  | IFO  | Unsigned | 8     | I21 * I22 (SSC.v:840)                    |
| T220  | IFO  | Unsigned | 8     | I23 * I24 (SSC.v:840)                    |
| T217  | IFO  | Unsigned | 8     | I25 * I26 (SSC.v:840)                    |
| T498  | IFO  | Unsigned | 8     | { I46, I47, I48, I49 } ? T211 : T232 : T235 : T229 ( SSC.v:346 SSC.v:347 SSC.v:348 SSC.v:362 SSC.v:391 SSC.v:392 SSC.v:406 SSC.v:435 SSC.v:436 SSC.v:450 SSC.v:480 SSC.v:494 ) |
| T608  | IFO  | Unsigned | 8     | { I50, I51, I52, I53 } ? T226 : T220 : T223 : T217 ( SSC.v:527 SSC.v:528 SSC.v:529 SSC.v:543 SSC.v:572 SSC.v:573 SSC.v:587 SSC.v:616 SSC.v:617 SSC.v:631 SSC.v:661 SSC.v:675 ) |
| T454  | IFO  | Unsigned | 8     | { I58, I59, I60, I61 } ? T232 : T211 : T235 : T229 ( SSC.v:346 SSC.v:347 SSC.v:348 SSC.v:362 SSC.v:391 SSC.v:392 SSC.v:406 SSC.v:435 SSC.v:436 SSC.v:450 SSC.v:480 SSC.v:494 ) |
| T564  | IFO  | Unsigned | 8     | { I62, I63, I64, I65 } ? T220 : T226 : T223 : T217 ( SSC.v:527 SSC.v:528 SSC.v:529 SSC.v:543 SSC.v:572 SSC.v:573 SSC.v:587 SSC.v:616 SSC.v:617 SSC.v:631 SSC.v:661 SSC.v:675 ) |
| T413  | IFO  | Unsigned | 8     | { I33, I34, I35, I36 } ? T211 : T235 : T232 : T229 (SSC.v:346) |
| T523  | IFO  | Unsigned | 8     | { I27, I28, I29, I30 } ? T226 : T223 : T220 : T217 (SSC.v:527) |
| T190  | IFO  | Unsigned | 8     | { I31, I32 } ? T413 : T523 (SSC.v:724)   |
| T408  | IFO  | Unsigned | 8     | { I9, I10, I11, I12 } ? T211 : T235 : T229 : T232 ( SSC.v:346 SSC.v:347 SSC.v:391 SSC.v:435 ) |
| T518  | IFO  | Unsigned | 8     | { I15, I16, I17, I18 } ? T226 : T223 : T217 : T220 ( SSC.v:527 SSC.v:528 SSC.v:572 SSC.v:616 ) |
| T197  | IFO  | Unsigned | 8     | { I13, I14 } ? T408 : T518 (SSC.v:748)   |
| T191  | IFO  | Unsigned | 8     | { I31, I32 } ? T523 : T413 (SSC.v:724)   |
| T203  | IFO  | Unsigned | 8     | { I37, I38 } ? T197 : T191 (SSC.v:772)   |
| T195  | IFO  | Unsigned | 8     | { I44, I45 } ? T498 : T608 (SSC.v:740)   |
| T196  | IFO  | Unsigned | 8     | { I13, I14 } ? T518 : T408 (SSC.v:748)   |
| T201  | IFO  | Unsigned | 8     | { I42, I43 } ? T195 : T196 (SSC.v:764)   |
| T202  | IFO  | Unsigned | 8     | { I37, I38 } ? T191 : T197 (SSC.v:772)   |
| T207  | IFO  | Unsigned | 8     | { I40, I41 } ? T201 : T202 (SSC.v:788)   |
| T193  | IFO  | Unsigned | 8     | { I56, I57 } ? T454 : T564 (SSC.v:732)   |
| T194  | IFO  | Unsigned | 8     | { I44, I45 } ? T608 : T498 (SSC.v:740)   |
| T199  | IFO  | Unsigned | 8     | { I54, I55 } ? T193 : T194 (SSC.v:756)   |
| T200  | IFO  | Unsigned | 8     | { I42, I43 } ? T196 : T195 (SSC.v:764)   |
| T205  | IFO  | Unsigned | 8     | { I68, I69 } ? T199 : T200 (SSC.v:780)   |
| T206  | IFO  | Unsigned | 8     | { I40, I41 } ? T202 : T201 (SSC.v:788)   |
| T209  | IFO  | Unsigned | 8     | { I66, I67 } ? T205 : T206 (SSC.v:796)   |
| T208  | IFO  | Unsigned | 8     | { I66, I67 } ? T206 : T205 (SSC.v:796)   |
| T204  | IFO  | Unsigned | 8     | { I68, I69 } ? T200 : T199 (SSC.v:780)   |
| T198  | IFO  | Unsigned | 8     | { I54, I55 } ? T194 : T193 (SSC.v:756)   |
| T192  | IFO  | Unsigned | 8     | { I56, I57 } ? T564 : T454 (SSC.v:732)   |
| O1    | PO   | Unsigned | 1     | T211 >= T235 ( SSC.v:346 SSC.v:435 SSC.v:464 SSC.v:479 SSC.v:508 ) |
| O2    | PO   | Unsigned | 1     | T235 >= T211 ( SSC.v:390 SSC.v:449 SSC.v:493 ) |
| O3    | PO   | Unsigned | 1     | T235 >= T232 ( SSC.v:347 SSC.v:376 SSC.v:390 SSC.v:480 SSC.v:493 ) |
| O4    | PO   | Unsigned | 1     | T211 >= T232 ( SSC.v:346 SSC.v:391 SSC.v:420 SSC.v:479 SSC.v:494 ) |
| O5    | PO   | Unsigned | 1     | T232 >= T211 ( SSC.v:405 SSC.v:434 )     |
| O6    | PO   | Unsigned | 1     | T232 >= T235 ( SSC.v:361 SSC.v:434 )     |
| O7    | PO   | Unsigned | 1     | T232 >= T229 ( SSC.v:348 SSC.v:361 SSC.v:392 SSC.v:405 SSC.v:434 ) |
| O8    | PO   | Unsigned | 1     | T211 >= T229 ( SSC.v:346 SSC.v:391 SSC.v:406 SSC.v:435 SSC.v:450 ) |
| O9    | PO   | Unsigned | 1     | T235 >= T229 ( SSC.v:347 SSC.v:362 SSC.v:390 SSC.v:436 SSC.v:449 ) |
| O10   | PO   | Unsigned | 1     | T226 >= T223 ( SSC.v:527 SSC.v:616 SSC.v:645 SSC.v:660 SSC.v:689 ) |
| O11   | PO   | Unsigned | 1     | T223 >= T226 ( SSC.v:571 SSC.v:630 SSC.v:674 ) |
| O12   | PO   | Unsigned | 1     | T223 >= T220 ( SSC.v:528 SSC.v:557 SSC.v:571 SSC.v:661 SSC.v:674 ) |
| O13   | PO   | Unsigned | 1     | T226 >= T220 ( SSC.v:527 SSC.v:572 SSC.v:601 SSC.v:660 SSC.v:675 ) |
| O14   | PO   | Unsigned | 1     | T220 >= T226 ( SSC.v:586 SSC.v:615 )     |
| O15   | PO   | Unsigned | 1     | T220 >= T223 ( SSC.v:542 SSC.v:615 )     |
| O16   | PO   | Unsigned | 1     | T220 >= T217 ( SSC.v:529 SSC.v:542 SSC.v:573 SSC.v:586 SSC.v:615 ) |
| O17   | PO   | Unsigned | 1     | T226 >= T217 ( SSC.v:527 SSC.v:572 SSC.v:587 SSC.v:616 SSC.v:631 ) |
| O18   | PO   | Unsigned | 1     | T223 >= T217 ( SSC.v:528 SSC.v:543 SSC.v:571 SSC.v:617 SSC.v:630 ) |
| O19   | PO   | Signed   | 10    | O20 - T203 (SSC.v:291)                   |
| O20   | PO   | Signed   | 10    | I39 - T190 (SSC.v:290)                   |
| O21   | PO   | Signed   | 10    | O19 - T207 (SSC.v:292)                   |
| O22   | PO   | Unsigned | 1     | T498 > T608 (SSC.v:823)                  |
| O23   | PO   | Unsigned | 1     | T454 > T564 (SSC.v:823)                  |
| O24   | PO   | Signed   | 10    | O25 - T192 (SSC.v:297)                   |
| O25   | PO   | Signed   | 10    | O26 - T198 (SSC.v:296)                   |
| O26   | PO   | Signed   | 10    | O27 - T204 (SSC.v:295)                   |
| O27   | PO   | Signed   | 10    | O28 - T208 (SSC.v:294)                   |
| O28   | PO   | Signed   | 10    | O21 - T209 (SSC.v:293)                   |
| O29   | PO   | Unsigned | 1     | T199 > T200 (SSC.v:823)                  |
| O30   | PO   | Unsigned | 1     | T205 > T206 (SSC.v:823)                  |
| O31   | PO   | Unsigned | 1     | T193 > T194 (SSC.v:823)                  |
| O32   | PO   | Unsigned | 1     | T195 > T196 (SSC.v:823)                  |
| O33   | PO   | Unsigned | 1     | T201 > T202 (SSC.v:823)                  |
| O34   | PO   | Unsigned | 1     | T197 > T191 (SSC.v:823)                  |
| O35   | PO   | Unsigned | 1     | T413 > T523 (SSC.v:823)                  |
| O36   | PO   | Unsigned | 1     | T408 > T518 (SSC.v:823)                  |
==============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| DP_OP_631J1_122_8317                  |                    |                |
|                    | DP_OP_631J1_122_8317 | str (area)     |                |
| DP_OP_632J1_123_6177                  |                    |                |
|                    | DP_OP_632J1_123_6177 | str (area)     |                |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: and     |                |
===============================================================================

1
