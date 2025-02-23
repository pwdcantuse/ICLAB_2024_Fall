/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NYCU Institute of Electronic
2023 Autumn IC Design Laboratory 
Lab10: SystemVerilog Coverage & Assertion
File Name   : CHECKER.sv
Module Name : CHECKER
Release version : v1.0 (Release Date: Nov-2023)
Author : Jui-Huang Tsai (erictsai.10@nycu.edu.tw)
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

`include "Usertype.sv"
module Checker(input clk, INF.CHECKER inf);
import usertype::*;

// integer fp_w;

// initial begin
// fp_w = $fopen("out_valid.txt", "w");
// end

/**
 * This section contains the definition of the class and the instantiation of the object.
 *  * 
 * The always_ff blocks update the object based on the values of valid signals.
 * When valid signal is true, the corresponding property is updated with the value of inf.D
 */
 
//---------------------------------------------------------------------
//   MESSAGE
//---------------------------------------------------------------------
logic [23*8:1] MESSAGE1 = "Assertion 1 is violated";
logic [23*8:1] MESSAGE2 = "Assertion 2 is violated";
logic [23*8:1] MESSAGE3 = "Assertion 3 is violated";
logic [23*8:1] MESSAGE4 = "Assertion 4 is violated";
logic [23*8:1] MESSAGE5 = "Assertion 5 is violated";
logic [23*8:1] MESSAGE6 = "Assertion 6 is violated";
logic [23*8:1] MESSAGE7 = "Assertion 7 is violated";
logic [23*8:1] MESSAGE8 = "Assertion 8 is violated";
logic [23*8:1] MESSAGE9 = "Assertion 9 is violated";
logic [24*8:1] MESSAGE10 = "Assertion 10 is violated";


//---------------------------------------------------------------------
//   COVERAGE PART
//---------------------------------------------------------------------
class Formula_and_mode;
    Formula_Type f_type;
    Mode f_mode;
endclass

Formula_and_mode fm_info = new();
Action act_ff;
always_ff @(posedge clk) if(inf.formula_valid) fm_info.f_type = inf.D.d_formula[0];
always_comb  if(inf.mode_valid) fm_info.f_mode = inf.D.d_mode[0];
always_ff @(posedge clk) if(inf.sel_action_valid) act_ff = inf.D.d_act[0];

covergroup Spec1 @(posedge clk iff(inf.formula_valid));
    option.per_instance = 1;
    option.at_least     = 150;
    coverpoint fm_info.f_type{
        bins type_bin [] = {[Formula_A:Formula_H]};
    }
endgroup

covergroup Spec2 @(posedge clk iff(inf.mode_valid));
    option.per_instance = 1;
    option.at_least     = 150;
    coverpoint fm_info.f_mode{
        bins mode_bin [] = {[Insensitive:Sensitive]};
    }
endgroup

covergroup Spec3 @(posedge clk iff(inf.mode_valid));
    option.per_instance = 1;
    option.at_least     = 150;
    coverpoint fm_info.f_type;
    coverpoint fm_info.f_mode;
	cross fm_info.f_type, fm_info.f_mode;
endgroup

covergroup Spec4 @(negedge clk iff(inf.out_valid));
    option.per_instance = 1;
    option.at_least     = 50;
    coverpoint inf.warn_msg{
        bins warn_msg_bin [] = {[No_Warn:Data_Warn]};
    }
endgroup

covergroup Spec5 @(posedge clk iff(inf.sel_action_valid));
    option.per_instance = 1;
    option.at_least     = 300;
    coverpoint inf.D.d_act[0]{
        bins action_bin [] = ([Index_Check:Check_Valid_Date]=>[Index_Check:Check_Valid_Date]);
    }
endgroup

covergroup Spec6 @(posedge clk iff(act_ff==Update && inf.index_valid));
    option.per_instance = 1;
    option.at_least     = 1;
    coverpoint inf.D.d_index[0]{
        option.auto_bin_max = 32;
    }
endgroup

Spec1 spec1 = new();
Spec2 spec2 = new();
Spec3 spec3 = new();
Spec4 spec4 = new();
Spec5 spec5 = new();
Spec6 spec6 = new();

//---------------------------------------------------------------------
//   ASSERTION
//---------------------------------------------------------------------

property reset_task;
    @(posedge inf.rst_n) inf.rst_n === 0 |-> (
            inf.out_valid === 1'b0 &&
            inf.warn_msg === No_Warn &&
            inf.complete === 1'b0 &&
            inf.AR_VALID === 1'b0 &&
            inf.AR_ADDR === 17'd0 &&
            inf.R_READY === 1'b0 &&
            inf.AW_VALID === 1'b0 &&
            inf.AW_ADDR === 17'd0 &&
            inf.W_VALID === 1'b0 &&
            inf.W_DATA === 64'd0 &&
            inf.B_READY === 1'b0
        );
endproperty

assertion1: assert property (reset_task) else $fatal(0, "%0s", MESSAGE1);

Action action_type;
logic [2:0] count_index_valid;

always_ff@(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) count_index_valid <= 0;
    else if(inf.out_valid) count_index_valid <= 0;
    else if(inf.index_valid) count_index_valid <= count_index_valid +1 ;
end

always_ff @(posedge clk) action_type <= (inf.sel_action_valid)? inf.D.d_act[0]: action_type;
property wait_Index_Check;
     @(posedge clk) 
        (action_type==Index_Check && count_index_valid===4) |-> ##[1:1000] (inf.out_valid===1'b1);
endproperty
property wait_Update;
    @(posedge clk) 
        (action_type==Update && count_index_valid===4) |-> ##[1:1000] (inf.out_valid===1'b1);
endproperty
property wait_Check_Valid_Date;
    @(posedge clk) 
        ((action_type==Check_Valid_Date) && inf.data_no_valid===1'b1) |-> ##[1:1000] (inf.out_valid===1'b1);
endproperty

property wait_output;
    wait_Index_Check and wait_Update and wait_Check_Valid_Date;
endproperty

assertion2: assert property (wait_output) else $fatal(0, "%0s", MESSAGE2);


property complete_no_warn;
     @(negedge clk) 
        inf.complete===1'b1 |-> inf.warn_msg === No_Warn;
endproperty

assertion3: assert property (complete_no_warn) else $fatal(0, "%0s", MESSAGE3);

property invalid_Index_Check;
     @(posedge clk) 
        (inf.sel_action_valid===1'b1 && inf.D.d_act[0] === Index_Check) |-> ##[1:4] inf.formula_valid ##[1:4] inf.mode_valid ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid;
endproperty
property invalid_Update;
    @(posedge clk) 
        (inf.sel_action_valid===1'b1 && inf.D.d_act[0] === Update) |-> ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid;
endproperty
property invalid_Check_Valid_Date;
    @(posedge clk) 
        (inf.sel_action_valid===1'b1 && inf.D.d_act[0] === Check_Valid_Date) |-> ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid;
endproperty

property invalid_delay;
    invalid_Index_Check and invalid_Update and invalid_Check_Valid_Date;
endproperty
assertion4: assert property (invalid_delay) else $fatal(0, "%0s", MESSAGE4);

property in_overlap_1;
    @(posedge clk)
    (inf.sel_action_valid |-> !(inf.formula_valid || inf.mode_valid || inf.date_valid || inf.data_no_valid || inf.index_valid)) ;
endproperty
property in_overlap_2;
    @(posedge clk)
    (inf.formula_valid |-> !(inf.mode_valid || inf.date_valid || inf.data_no_valid || inf.index_valid)) ;
endproperty
property in_overlap_3;
    @(posedge clk)
    (inf.mode_valid |-> !(inf.date_valid || inf.data_no_valid || inf.index_valid)) ;
endproperty
property in_overlap_4;
    @(posedge clk)
    (inf.date_valid |-> !(inf.data_no_valid || inf.index_valid)) ;
endproperty
property in_overlap_5;
    @(posedge clk)
    (!(inf.data_no_valid && inf.index_valid));
endproperty
assertion5: assert property (in_overlap_1 and in_overlap_2 and in_overlap_3 and in_overlap_4 and in_overlap_5) else $fatal(0, "%0s", MESSAGE5);

property out_valid_one_cycle;
    @(posedge clk)
        if(inf.out_valid)  inf.out_valid ##1 !inf.out_valid;
endproperty

assertion6: assert property (out_valid_one_cycle) else $fatal(0, "%0s", MESSAGE6);

property next_in_valid;
    @(posedge clk)
        if(inf.out_valid)  inf.out_valid ##[1:4] inf.sel_action_valid;
endproperty

assertion7: assert property (next_in_valid) else $fatal(0, "%0s", MESSAGE7);

property date;
    @(posedge clk)
    inf.date_valid |-> (
        (inf.D.d_date[0].M == 1&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D <= 31) ||
        (inf.D.d_date[0].M == 2&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D <= 28) ||
        (inf.D.d_date[0].M == 3&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D <= 31) ||
        (inf.D.d_date[0].M == 4&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D <= 30) ||
        (inf.D.d_date[0].M == 5&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D <= 31) ||
        (inf.D.d_date[0].M == 6&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D <= 30) ||
        (inf.D.d_date[0].M == 7&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D <= 31) ||
        (inf.D.d_date[0].M == 8&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D <= 31) ||
        (inf.D.d_date[0].M == 9&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D <= 30) ||
        (inf.D.d_date[0].M == 10&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D<= 31) ||
        (inf.D.d_date[0].M == 11&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D<= 30) ||
        (inf.D.d_date[0].M == 12&&inf.D.d_date[0].D >0&&inf.D.d_date[0].D<= 31)
    );
endproperty
assertion8: assert property (date) else $fatal(0, "%0s", MESSAGE8);


property ar_overlap_1;
    @(posedge clk)
    inf.AR_VALID===1 |->  inf.AW_VALID===0;
endproperty
property ar_overlap_2;
    @(posedge clk)
    inf.AW_VALID===1 |->  inf.AR_VALID===0;
endproperty
assertion9: assert property (ar_overlap_1 and ar_overlap_2) else $fatal(0, "%0s", MESSAGE9);


endmodule