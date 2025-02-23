//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab04 Exercise		: Convolution Neural Network 
//   Author     		: Yu-Chi Lin (a6121461214.st12@nycu.edu.tw)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : CNN.v
//   Module Name : CNN
//   Release version : V1.0 (Release Date: 2024-10)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_add.v"
`include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_mult.v"
`include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_sum3.v"
`include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_div.v"
`include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_exp.v"
`include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_cmp.v"
//synopsys translate_on

module CNN(
    //Input Port
    clk,
    rst_n,
    in_valid,
    Img,
    Kernel_ch1,
    Kernel_ch2,
	Weight,
    Opt,

    //Output Port
    out_valid,
    out
    );
  

//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------

// IEEE floating point parameter
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;

parameter IDLE = 3'd0;
parameter READ = 3'd1;
parameter CAL = 3'd2;
parameter DONE = 3'd3;

input rst_n, clk, in_valid;
input [inst_sig_width+inst_exp_width:0] Img, Kernel_ch1, Kernel_ch2, Weight;
input Opt;

output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;

integer k;

//---------------------------------------------------------------------
//   Reg & Wires
//---------------------------------------------------------------------

reg Opt_in;

reg [31:0] soft_max_out [0:2];
reg [31:0] soft_max_exp_out [0:2];
reg [31:0] soft_max_exp_in [0:2];
reg [31:0] soft_max_div_a [0:2];
reg [31:0] soft_max_div_b;
reg [31:0] soft_max_div_out [0:2];
reg [31:0] soft_sum3_a;
reg [31:0] soft_sum3_b;
reg [31:0] soft_sum3_c;
reg [31:0] soft_sum3_out;
reg [31:0] z_ch1, z_ch2;
reg [31:0] act_ch1 [0:3];
reg [31:0] act_ch2 [0:3];
reg [31:0] act_add_a_ch1 [0:1];
wire [31:0] act_add_b_ch1 [0:1];
reg [31:0] act_add_out_ch1 [0:1];
reg [31:0] act_div_a_ch1;
reg [31:0] act_div_b_ch1;
reg [31:0] act_div_out_ch1;
reg [31:0] act_exp_in_ch1;
reg [31:0] act_exp_out_ch1;
reg [31:0] act_add_a_ch2 [0:1];
wire [31:0] act_add_b_ch2 [0:1];
reg [31:0] act_add_out_ch2 [0:1];
reg [31:0] act_div_a_ch2;
reg [31:0] act_div_b_ch2;
reg [31:0] act_div_out_ch2;
reg [31:0] act_exp_in_ch2;
reg [31:0] act_exp_out_ch2;

reg [2:0] State , next_State;
reg [31:0] ifmap [0:3] ;
reg [31:0] Kernel_ch1_mem [0:11];
reg [31:0] Kernel_ch2_mem [0:11];
reg [31:0] Weight_mem [0:23];
reg [31:0] ofmap_ch1 [0:35];
reg [31:0] ofmap_ch2 [0:35];
reg [31:0] next_ofmap_ch1 [0:35];
reg [31:0] next_ofmap_ch2 [0:35];

reg [2:0] i, j;
reg [1:0] pointer_read, pointer_cal, conv_channel;
reg [6:0] t; 
reg [5:0] addr_ij, addr_i_j1, addr_i1_j,addr_i1_j1;


reg[31:0] mult_a;
reg[31:0] mult_b [0:7];
reg[31:0] mult_out [0:7];
reg[31:0] add_a_ch1 [0:8];
reg[31:0] add_b_ch1 [0:8];
reg[31:0] add_ch1_out [0:8];
reg[31:0] add_a_ch2 [0:8];
reg[31:0] add_b_ch2 [0:8];
reg[31:0] add_ch2_out [0:8];

reg [31:0] max_pool_ch1 [0:3];
reg [31:0] max_pool_ch2 [0:3];
reg [31:0] next_max_pool_ch1 [0:3];
reg [31:0] next_max_pool_ch2 [0:3];
reg [31:0] cmp_a_ch1 [0:3];
reg [31:0] cmp_b_ch1 [0:3];
reg [31:0] cmp_a_ch2 [0:3];
reg [31:0] cmp_b_ch2 [0:3];
reg [31:0] cmp_out_ch1 [0:3];
reg [31:0] cmp_out_ch2 [0:3];
reg [31:0] fc_out [0:2];
reg [31:0] fc_mul_a [0:5];
reg [31:0] fc_mul_b [0:5];
reg [31:0] fc_mul_out [0:5];
reg [31:0] fc_sum_3_a [0:2];
reg [31:0] fc_sum_3_b [0:2];
reg [31:0] fc_sum_3_c [0:2];
reg [31:0] fc_sum_3_out [0:2];
//---------------------------------------------------------------------
// IPs
//---------------------------------------------------------------------


DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M0 (.a(mult_a), .b(mult_b[0]), .rnd(3'b000), .z(mult_out[0])); //a
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M1 (.a(mult_a), .b(mult_b[1]), .rnd(3'b000), .z(mult_out[1])); //b
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M2 (.a(mult_a), .b(mult_b[2]), .rnd(3'b000), .z(mult_out[2])); //c
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M3 (.a(mult_a), .b(mult_b[3]), .rnd(3'b000), .z(mult_out[3])); //d
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M4 (.a(mult_a), .b(mult_b[4]), .rnd(3'b000), .z(mult_out[4])); //a_ch2
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M5 (.a(mult_a), .b(mult_b[5]), .rnd(3'b000), .z(mult_out[5])); //b_ch2
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M6 (.a(mult_a), .b(mult_b[6]), .rnd(3'b000), .z(mult_out[6])); //c_ch2
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M7 (.a(mult_a), .b(mult_b[7]), .rnd(3'b000), .z(mult_out[7])); //d_ch2

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A0 (.a(add_a_ch1[0]), .b(add_b_ch1[0]), .rnd(3'b000), .z(add_ch1_out[0])); //a+b
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A1 (.a(add_a_ch1[1]), .b(add_b_ch1[1]), .rnd(3'b000), .z(add_ch1_out[1])); //c+d
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A2 (.a(add_a_ch1[2]), .b(add_b_ch1[2]), .rnd(3'b000), .z(add_ch1_out[2])); //a+b+c+d


DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A3 (.a(add_a_ch1[3]), .b(add_b_ch1[3]), .rnd(3'b000), .z(add_ch1_out[3])); // a+c  
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A4 (.a(add_a_ch1[4]), .b(add_b_ch1[4]), .rnd(3'b000), .z(add_ch1_out[4])); //  b+d
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A5 (.a(add_a_ch1[5]), .b(add_b_ch1[5]), .rnd(3'b000), .z(add_ch1_out[5])); // add prev
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A6 (.a(add_a_ch1[6]), .b(add_b_ch1[6]), .rnd(3'b000), .z(add_ch1_out[6])); // add prev
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A7 (.a(add_a_ch1[7]), .b(add_b_ch1[7]), .rnd(3'b000), .z(add_ch1_out[7])); // add prev
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A8 (.a(add_a_ch1[8]), .b(add_b_ch1[8]), .rnd(3'b000), .z(add_ch1_out[8])); // add prev

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)  A9 (.a(add_a_ch2[0]), .b(add_b_ch2[0]), .rnd(3'b000), .z(add_ch2_out[0]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A10 (.a(add_a_ch2[1]), .b(add_b_ch2[1]), .rnd(3'b000), .z(add_ch2_out[1]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A11 (.a(add_a_ch2[2]), .b(add_b_ch2[2]), .rnd(3'b000), .z(add_ch2_out[2]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A12 (.a(add_a_ch2[3]), .b(add_b_ch2[3]), .rnd(3'b000), .z(add_ch2_out[3]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A13 (.a(add_a_ch2[4]), .b(add_b_ch2[4]), .rnd(3'b000), .z(add_ch2_out[4]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A14 (.a(add_a_ch2[5]), .b(add_b_ch2[5]), .rnd(3'b000), .z(add_ch2_out[5]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A15 (.a(add_a_ch2[6]), .b(add_b_ch2[6]), .rnd(3'b000), .z(add_ch2_out[6]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A16 (.a(add_a_ch2[7]), .b(add_b_ch2[7]), .rnd(3'b000), .z(add_ch2_out[7]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A17 (.a(add_a_ch2[8]), .b(add_b_ch2[8]), .rnd(3'b000), .z(add_ch2_out[8]));






//---------------------------------------------------------------------
// Design
//---------------------------------------------------------------------
//// input /////
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        Opt_in <= 0;
    end
    else if(t == 0 && in_valid) begin
        Opt_in <= Opt;
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(k = 0; k < 36; k++) begin
            ofmap_ch1[k] <= 32'd0;
            ofmap_ch2[k] <= 32'd0;
        end
    end
    else if(State == CAL) begin
        for(k = 0; k < 36; k++) begin
            ofmap_ch1[k] <= next_ofmap_ch1[k];
            ofmap_ch2[k] <= next_ofmap_ch2[k];
        end
    end
    else if(State == IDLE) begin
        for(k = 0; k < 36; k++) begin
            ofmap_ch1[k] <= 32'd0;
            ofmap_ch2[k] <= 32'd0;
        end
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(k = 0; k < 12; k++) begin
            Kernel_ch1_mem[k] <= 32'd0;
            Kernel_ch2_mem[k] <= 32'd0;
        end
    end
    else if(in_valid && t < 7'd12) begin
        Kernel_ch1_mem[t] <= Kernel_ch1;
        Kernel_ch2_mem[t] <= Kernel_ch2;
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(k = 0; k < 4; k++) begin
            ifmap[k] <= 32'd0;
        end
    end
    else if(in_valid) begin
        ifmap[pointer_read] <= Img;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(k = 0; k < 24; k++) begin
            Weight_mem[k] <= 32'd0;
        end
    end
    else if(in_valid && t < 7'd24) begin
        Weight_mem[t] <= Weight;
    end
end
//// output ////
always@(*) begin
    if(!rst_n) out_valid = 0;
    else if(State == DONE) out_valid = 1;
    else out_valid = 0;
end

always@(*) begin
    if(!rst_n) out = 0;
    else if(State == DONE) begin
        if(t == 82) out = soft_max_out[0];
        else if(t == 83) out = soft_max_out[1];
        else out = soft_max_out[2];
    end
    else out = 0;
end


///////////////////



always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        State <= IDLE;
    end
    else begin
        State <= next_State;
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        t <= 7'd0;
    end
    else if(t == 7'd84) begin
        t <= 7'd0;
    end
    else if(in_valid || State == CAL||State == DONE)begin
        t <= t + 7'd1;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pointer_read <= 2'd0;
    end
    else if(State == DONE) begin
        pointer_read <= 2'd0;
    end
    else if(in_valid) begin
        pointer_read <= pointer_read + 2'd1;
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pointer_cal <= 2'd0;
    end
    else if(State == DONE) begin
        pointer_cal <= 2'd0;
    end
    else if(State == CAL) begin
        pointer_cal <= pointer_cal + 2'd1;
    end
end
always@(*) begin
    case(State)
        IDLE: begin
            if(in_valid) next_State = READ;
            else next_State = State;
        end
        READ: begin
            if(t == 7'd3) next_State = CAL;
            else next_State = State;
        end
        CAL: begin
            if(t == 7'd81) next_State = DONE;
            else next_State = State;
        end
        DONE: begin
            if(t == 7'd84) next_State = IDLE;
            else next_State = State;
        end
        default: begin
            next_State = State;
        end
    endcase
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        i <= 3'd0;
    end
    else if(State == DONE) begin
        i <= 3'd0;
    end
    else if(State == CAL) begin
        if(i == 3'd4 && j == 3'd4) i <= 3'd0;
        else if(j == 3'd4) i <= i+3'd1; 
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        j <= 3'd0;
    end
    else if(State == DONE) begin
        j <= 3'd0;
    end
    else if(State == CAL) begin
        if(j == 3'd4) j <= 3'd0;
        else  j <= j+3'd1; 
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        conv_channel <= 2'd0;
    end
    else if(State == DONE) begin
        conv_channel <= 2'd0;
    end
    else if(t == 7'd28||t == 7'd53) begin
        conv_channel <= conv_channel +2'd1; 
    end
end


/////////////////// conv //////////////////
always@(*) begin
    mult_a = ifmap[pointer_cal];
    if(conv_channel == 2'd0) begin
        mult_b[0] = Kernel_ch1_mem[0];
        mult_b[1] = Kernel_ch1_mem[1]; 
        mult_b[2] = Kernel_ch1_mem[2];
        mult_b[3] = Kernel_ch1_mem[3];
        mult_b[4] = Kernel_ch2_mem[0];
        mult_b[5] = Kernel_ch2_mem[1];
        mult_b[6] = Kernel_ch2_mem[2];
        mult_b[7] = Kernel_ch2_mem[3];
    end
    else if(conv_channel == 2'd1) begin
        mult_b[0] = Kernel_ch1_mem[4];
        mult_b[1] = Kernel_ch1_mem[5]; 
        mult_b[2] = Kernel_ch1_mem[6];
        mult_b[3] = Kernel_ch1_mem[7];
        mult_b[4] = Kernel_ch2_mem[4];
        mult_b[5] = Kernel_ch2_mem[5];
        mult_b[6] = Kernel_ch2_mem[6];
        mult_b[7] = Kernel_ch2_mem[7];
    end
    else begin
        mult_b[0] = Kernel_ch1_mem[8];
        mult_b[1] = Kernel_ch1_mem[9]; 
        mult_b[2] = Kernel_ch1_mem[10];
        mult_b[3] = Kernel_ch1_mem[11];
        mult_b[4] = Kernel_ch2_mem[8];
        mult_b[5] = Kernel_ch2_mem[9];
        mult_b[6] = Kernel_ch2_mem[10];
        mult_b[7] = Kernel_ch2_mem[11];
    end
    add_a_ch1[0] = mult_out[0];
    add_b_ch1[0] = mult_out[1];
    add_a_ch1[2] = add_ch1_out[0];
    add_a_ch1[1] = mult_out[2];
    add_b_ch1[1] = mult_out[3];
    add_b_ch1[2] = add_ch1_out[1];
    add_a_ch1[3] = mult_out[0];
    add_b_ch1[3] = mult_out[2];
    add_a_ch1[4] = mult_out[1];
    add_b_ch1[4] = mult_out[3];
    
    add_a_ch2[0] = mult_out[4];
    add_b_ch2[0] = mult_out[5];
    add_a_ch2[2] = add_ch2_out[0];
    add_a_ch2[1] = mult_out[6];
    add_b_ch2[1] = mult_out[7];
    add_b_ch2[2] = add_ch2_out[1];
    add_a_ch2[3] = mult_out[4];
    add_b_ch2[3] = mult_out[6];
    add_a_ch2[4] = mult_out[5];
    add_b_ch2[4] = mult_out[7];
    if(Opt_in == 0) begin
        add_b_ch1[5] = mult_out[3];
        add_b_ch1[6] = mult_out[2];
        add_b_ch1[7] = mult_out[1];
        add_b_ch1[8] = mult_out[0];
    end
    else begin
        if(i==0) begin
            if(j == 0) begin //a+c a+b
                
                add_b_ch1[5] = add_ch1_out[2];
                add_b_ch1[6] = add_ch1_out[3];
                add_b_ch1[7] = add_ch1_out[0];
                add_b_ch1[8] = mult_out[0];
            end
            else if(j == 4) begin //b+d a+b
                
                add_b_ch1[5] = add_ch1_out[4];
                add_b_ch1[6] = add_ch1_out[2];
                add_b_ch1[7] = mult_out[1];
                add_b_ch1[8] = add_ch1_out[0];
            end
            else begin //b+d a+c
                add_b_ch1[5] = add_ch1_out[4];
                add_b_ch1[6] = add_ch1_out[3];
                add_b_ch1[7] = mult_out[1];
                add_b_ch1[8] = mult_out[0];
            end
        end
        else if(i==4) begin
            if(j == 0) begin //a+c c+d
                add_b_ch1[5] = add_ch1_out[1];
                add_b_ch1[6] = mult_out[2];
                add_b_ch1[7] = add_ch1_out[2];
                add_b_ch1[8] = add_ch1_out[3];
            end
            else if(j == 4) begin //b+d c+d
                add_b_ch1[5] = mult_out[3];
                add_b_ch1[6] = add_ch1_out[1];
                add_b_ch1[7] = add_ch1_out[4];
                add_b_ch1[8] = add_ch1_out[2];
            end
            else begin //b+d a+c
                add_b_ch1[5] = mult_out[3];
                add_b_ch1[6] = mult_out[2];
                add_b_ch1[7] = add_ch1_out[4];
                add_b_ch1[8] = add_ch1_out[3];
            end
        end
        else  begin
            if(j == 0) begin 
                add_b_ch1[5] = add_ch1_out[1];
                add_b_ch1[6] = mult_out[2];
                add_b_ch1[7] = add_ch1_out[0];
                add_b_ch1[8] = mult_out[0];
            end
            else if(j == 4) begin 
                add_b_ch1[5] = mult_out[3];
                add_b_ch1[6] = add_ch1_out[1];
                add_b_ch1[7] = mult_out[1];
                add_b_ch1[8] = add_ch1_out[0];
            end
            else begin 
                add_b_ch1[5] = mult_out[3];
                add_b_ch1[6] = mult_out[2];
                add_b_ch1[7] = mult_out[1];
                add_b_ch1[8] = mult_out[0];
            end
        end
    end

    if(Opt_in == 0) begin
        add_b_ch2[5] = mult_out[7];
        add_b_ch2[6] = mult_out[6];
        add_b_ch2[7] = mult_out[5];
        add_b_ch2[8] = mult_out[4];
    end
    else begin
        if(i==0) begin
            if(j == 0) begin //a+c a+b
                
                add_b_ch2[5] = add_ch2_out[2];
                add_b_ch2[6] = add_ch2_out[3];
                add_b_ch2[7] = add_ch2_out[0];
                add_b_ch2[8] = mult_out[4];
            end
            else if(j == 4) begin //b+d a+b
                
                add_b_ch2[5] = add_ch2_out[4];
                add_b_ch2[6] = add_ch2_out[2];
                add_b_ch2[7] = mult_out[5];
                add_b_ch2[8] = add_ch2_out[0];
            end
            else begin //b+d a+c
                add_b_ch2[5] = add_ch2_out[4];
                add_b_ch2[6] = add_ch2_out[3];
                add_b_ch2[7] = mult_out[5];
                add_b_ch2[8] = mult_out[4];
            end
        end
        else if(i==4) begin
            if(j == 0) begin //a+c c+d
                add_b_ch2[5] = add_ch2_out[1];
                add_b_ch2[6] = mult_out[6];
                add_b_ch2[7] = add_ch2_out[2];
                add_b_ch2[8] = add_ch2_out[3];
            end
            else if(j == 4) begin //b+d c+d
                add_b_ch2[5] = mult_out[7];
                add_b_ch2[6] = add_ch2_out[1];
                add_b_ch2[7] = add_ch2_out[4];
                add_b_ch2[8] = add_ch2_out[2];
            end
            else begin //b+d a+c
                add_b_ch2[5] = mult_out[7];
                add_b_ch2[6] = mult_out[6];
                add_b_ch2[7] = add_ch2_out[4];
                add_b_ch2[8] = add_ch2_out[3];
            end
        end
        else  begin
            if(j == 0) begin 
                add_b_ch2[5] = add_ch2_out[1];
                add_b_ch2[6] = mult_out[6];
                add_b_ch2[7] = add_ch2_out[0];
                add_b_ch2[8] = mult_out[4];
            end
            else if(j == 4) begin 
                add_b_ch2[5] = mult_out[7];
                add_b_ch2[6] = add_ch2_out[1];
                add_b_ch2[7] = mult_out[5];
                add_b_ch2[8] = add_ch2_out[0];
            end
            else begin 
                add_b_ch2[5] = mult_out[7];
                add_b_ch2[6] = mult_out[6];
                add_b_ch2[7] = mult_out[5];
                add_b_ch2[8] = mult_out[4];
            end
        end
    end
    case(t)
         4, 29, 54: begin
            add_a_ch1[5] = ofmap_ch1[0];
            add_a_ch1[6] = ofmap_ch1[1];
            add_a_ch1[7] = ofmap_ch1[6];
            add_a_ch1[8] = ofmap_ch1[7];
            add_a_ch2[5] = ofmap_ch2[0];
            add_a_ch2[6] = ofmap_ch2[1];
            add_a_ch2[7] = ofmap_ch2[6];
            add_a_ch2[8] = ofmap_ch2[7];
        end
         5, 30, 55: begin
            add_a_ch1[5] = ofmap_ch1[1];
            add_a_ch1[6] = ofmap_ch1[2];
            add_a_ch1[7] = ofmap_ch1[7];
            add_a_ch1[8] = ofmap_ch1[8];
            add_a_ch2[5] = ofmap_ch2[1];
            add_a_ch2[6] = ofmap_ch2[2];
            add_a_ch2[7] = ofmap_ch2[7];
            add_a_ch2[8] = ofmap_ch2[8];
        end
         6, 31, 56: begin
            add_a_ch1[5] = ofmap_ch1[2];
            add_a_ch1[6] = ofmap_ch1[3];
            add_a_ch1[7] = ofmap_ch1[8];
            add_a_ch1[8] = ofmap_ch1[9];
            add_a_ch2[5] = ofmap_ch2[2];
            add_a_ch2[6] = ofmap_ch2[3];
            add_a_ch2[7] = ofmap_ch2[8];
            add_a_ch2[8] = ofmap_ch2[9];
        end
         7, 32, 57: begin
            add_a_ch1[5] = ofmap_ch1[3];
            add_a_ch1[6] = ofmap_ch1[4];
            add_a_ch1[7] = ofmap_ch1[9];
            add_a_ch1[8] = ofmap_ch1[10];
            add_a_ch2[5] = ofmap_ch2[3];
            add_a_ch2[6] = ofmap_ch2[4];
            add_a_ch2[7] = ofmap_ch2[9];
            add_a_ch2[8] = ofmap_ch2[10];
        end
         8, 33, 58: begin
            add_a_ch1[5] = ofmap_ch1[4];
            add_a_ch1[6] = ofmap_ch1[5];
            add_a_ch1[7] = ofmap_ch1[10];
            add_a_ch1[8] = ofmap_ch1[11];
            add_a_ch2[5] = ofmap_ch2[4];
            add_a_ch2[6] = ofmap_ch2[5];
            add_a_ch2[7] = ofmap_ch2[10];
            add_a_ch2[8] = ofmap_ch2[11];
        end
         9, 34, 59: begin
            add_a_ch1[5] = ofmap_ch1[6];
            add_a_ch1[6] = ofmap_ch1[7];
            add_a_ch1[7] = ofmap_ch1[12];
            add_a_ch1[8] = ofmap_ch1[13];
            add_a_ch2[5] = ofmap_ch2[6];
            add_a_ch2[6] = ofmap_ch2[7];
            add_a_ch2[7] = ofmap_ch2[12];
            add_a_ch2[8] = ofmap_ch2[13];
        end
        10, 35, 60: begin
            add_a_ch1[5] = ofmap_ch1[7];
            add_a_ch1[6] = ofmap_ch1[8];
            add_a_ch1[7] = ofmap_ch1[13];
            add_a_ch1[8] = ofmap_ch1[14];
            add_a_ch2[5] = ofmap_ch2[7];
            add_a_ch2[6] = ofmap_ch2[8];
            add_a_ch2[7] = ofmap_ch2[13];
            add_a_ch2[8] = ofmap_ch2[14];
        end
        11, 36, 61: begin
            add_a_ch1[5] = ofmap_ch1[8];
            add_a_ch1[6] = ofmap_ch1[9];
            add_a_ch1[7] = ofmap_ch1[14];
            add_a_ch1[8] = ofmap_ch1[15];
            add_a_ch2[5] = ofmap_ch2[8];
            add_a_ch2[6] = ofmap_ch2[9];
            add_a_ch2[7] = ofmap_ch2[14];
            add_a_ch2[8] = ofmap_ch2[15];
        end
        12, 37, 62: begin
            add_a_ch1[5] = ofmap_ch1[9];
            add_a_ch1[6] = ofmap_ch1[10];
            add_a_ch1[7] = ofmap_ch1[15];
            add_a_ch1[8] = ofmap_ch1[16];
            add_a_ch2[5] = ofmap_ch2[9];
            add_a_ch2[6] = ofmap_ch2[10];
            add_a_ch2[7] = ofmap_ch2[15];
            add_a_ch2[8] = ofmap_ch2[16];
        end
        13, 38, 63: begin
            add_a_ch1[5] = ofmap_ch1[10];
            add_a_ch1[6] = ofmap_ch1[11];
            add_a_ch1[7] = ofmap_ch1[16];
            add_a_ch1[8] = ofmap_ch1[17];
            add_a_ch2[5] = ofmap_ch2[10];
            add_a_ch2[6] = ofmap_ch2[11];
            add_a_ch2[7] = ofmap_ch2[16];
            add_a_ch2[8] = ofmap_ch2[17];
        end
        14, 39, 64: begin
            add_a_ch1[5] = ofmap_ch1[12];
            add_a_ch1[6] = ofmap_ch1[13];
            add_a_ch1[7] = ofmap_ch1[18];
            add_a_ch1[8] = ofmap_ch1[19];
            add_a_ch2[5] = ofmap_ch2[12];
            add_a_ch2[6] = ofmap_ch2[13];
            add_a_ch2[7] = ofmap_ch2[18];
            add_a_ch2[8] = ofmap_ch2[19];
        end
        15, 40, 65: begin
            add_a_ch1[5] = ofmap_ch1[13];
            add_a_ch1[6] = ofmap_ch1[14];
            add_a_ch1[7] = ofmap_ch1[19];
            add_a_ch1[8] = ofmap_ch1[20];
            add_a_ch2[5] = ofmap_ch2[13];
            add_a_ch2[6] = ofmap_ch2[14];
            add_a_ch2[7] = ofmap_ch2[19];
            add_a_ch2[8] = ofmap_ch2[20];
        end
        16, 41, 66: begin
            add_a_ch1[5] = ofmap_ch1[14];
            add_a_ch1[6] = ofmap_ch1[15];
            add_a_ch1[7] = ofmap_ch1[20];
            add_a_ch1[8] = ofmap_ch1[21];
            add_a_ch2[5] = ofmap_ch2[14];
            add_a_ch2[6] = ofmap_ch2[15];
            add_a_ch2[7] = ofmap_ch2[20];
            add_a_ch2[8] = ofmap_ch2[21];
        end
        17, 42, 67: begin
            add_a_ch1[5] = ofmap_ch1[15];
            add_a_ch1[6] = ofmap_ch1[16];
            add_a_ch1[7] = ofmap_ch1[21];
            add_a_ch1[8] = ofmap_ch1[22];
            add_a_ch2[5] = ofmap_ch2[15];
            add_a_ch2[6] = ofmap_ch2[16];
            add_a_ch2[7] = ofmap_ch2[21];
            add_a_ch2[8] = ofmap_ch2[22];
        end
        18, 43, 68: begin
            add_a_ch1[5] = ofmap_ch1[16];
            add_a_ch1[6] = ofmap_ch1[17];
            add_a_ch1[7] = ofmap_ch1[22];
            add_a_ch1[8] = ofmap_ch1[23];
            add_a_ch2[5] = ofmap_ch2[16];
            add_a_ch2[6] = ofmap_ch2[17];
            add_a_ch2[7] = ofmap_ch2[22];
            add_a_ch2[8] = ofmap_ch2[23];
        end
        19, 44, 69: begin
            add_a_ch1[5] = ofmap_ch1[18];
            add_a_ch1[6] = ofmap_ch1[19];
            add_a_ch1[7] = ofmap_ch1[24];
            add_a_ch1[8] = ofmap_ch1[25];
            add_a_ch2[5] = ofmap_ch2[18];
            add_a_ch2[6] = ofmap_ch2[19];
            add_a_ch2[7] = ofmap_ch2[24];
            add_a_ch2[8] = ofmap_ch2[25];
        end
        20, 45, 70: begin
            add_a_ch1[5] = ofmap_ch1[19];
            add_a_ch1[6] = ofmap_ch1[20];
            add_a_ch1[7] = ofmap_ch1[25];
            add_a_ch1[8] = ofmap_ch1[26];
            add_a_ch2[5] = ofmap_ch2[19];
            add_a_ch2[6] = ofmap_ch2[20];
            add_a_ch2[7] = ofmap_ch2[25];
            add_a_ch2[8] = ofmap_ch2[26];
        end
        21, 46, 71: begin
            add_a_ch1[5] = ofmap_ch1[20];
            add_a_ch1[6] = ofmap_ch1[21];
            add_a_ch1[7] = ofmap_ch1[26];
            add_a_ch1[8] = ofmap_ch1[27];
            add_a_ch2[5] = ofmap_ch2[20];
            add_a_ch2[6] = ofmap_ch2[21];
            add_a_ch2[7] = ofmap_ch2[26];
            add_a_ch2[8] = ofmap_ch2[27];
        end
        22, 47, 72: begin
            add_a_ch1[5] = ofmap_ch1[21];
            add_a_ch1[6] = ofmap_ch1[22];
            add_a_ch1[7] = ofmap_ch1[27];
            add_a_ch1[8] = ofmap_ch1[28];
            add_a_ch2[5] = ofmap_ch2[21];
            add_a_ch2[6] = ofmap_ch2[22];
            add_a_ch2[7] = ofmap_ch2[27];
            add_a_ch2[8] = ofmap_ch2[28];
        end
        23, 48, 73: begin
            add_a_ch1[5] = ofmap_ch1[22];
            add_a_ch1[6] = ofmap_ch1[23];
            add_a_ch1[7] = ofmap_ch1[28];
            add_a_ch1[8] = ofmap_ch1[29];
            add_a_ch2[5] = ofmap_ch2[22];
            add_a_ch2[6] = ofmap_ch2[23];
            add_a_ch2[7] = ofmap_ch2[28];
            add_a_ch2[8] = ofmap_ch2[29];
        end
        24, 49, 74: begin
            add_a_ch1[5] = ofmap_ch1[24];
            add_a_ch1[6] = ofmap_ch1[25];
            add_a_ch1[7] = ofmap_ch1[30];
            add_a_ch1[8] = ofmap_ch1[31];
            add_a_ch2[5] = ofmap_ch2[24];
            add_a_ch2[6] = ofmap_ch2[25];
            add_a_ch2[7] = ofmap_ch2[30];
            add_a_ch2[8] = ofmap_ch2[31];
        end
        25, 50, 75: begin
            add_a_ch1[5] = ofmap_ch1[25];
            add_a_ch1[6] = ofmap_ch1[26];
            add_a_ch1[7] = ofmap_ch1[31];
            add_a_ch1[8] = ofmap_ch1[32];
            add_a_ch2[5] = ofmap_ch2[25];
            add_a_ch2[6] = ofmap_ch2[26];
            add_a_ch2[7] = ofmap_ch2[31];
            add_a_ch2[8] = ofmap_ch2[32];
        end
        26, 51, 76: begin
            add_a_ch1[5] = ofmap_ch1[26];
            add_a_ch1[6] = ofmap_ch1[27];
            add_a_ch1[7] = ofmap_ch1[32];
            add_a_ch1[8] = ofmap_ch1[33];
            add_a_ch2[5] = ofmap_ch2[26];
            add_a_ch2[6] = ofmap_ch2[27];
            add_a_ch2[7] = ofmap_ch2[32];
            add_a_ch2[8] = ofmap_ch2[33];
        end
        27, 52, 77: begin
            add_a_ch1[5] = ofmap_ch1[27];
            add_a_ch1[6] = ofmap_ch1[28];
            add_a_ch1[7] = ofmap_ch1[33];
            add_a_ch1[8] = ofmap_ch1[34];
            add_a_ch2[5] = ofmap_ch2[27];
            add_a_ch2[6] = ofmap_ch2[28];
            add_a_ch2[7] = ofmap_ch2[33];
            add_a_ch2[8] = ofmap_ch2[34];
        end
        28, 53, 78: begin
            add_a_ch1[5] = ofmap_ch1[28];
            add_a_ch1[6] = ofmap_ch1[29];
            add_a_ch1[7] = ofmap_ch1[34];
            add_a_ch1[8] = ofmap_ch1[35];
            add_a_ch2[5] = ofmap_ch2[28];
            add_a_ch2[6] = ofmap_ch2[29];
            add_a_ch2[7] = ofmap_ch2[34];
            add_a_ch2[8] = ofmap_ch2[35];
        end
        default: begin
            add_a_ch1[5] = 32'd0;
            add_a_ch1[6] = 32'd0;
            add_a_ch1[7] = 32'd0;
            add_a_ch1[8] = 32'd0;
            add_a_ch2[5] = 32'd0;
            add_a_ch2[6] = 32'd0;
            add_a_ch2[7] = 32'd0;
            add_a_ch2[8] = 32'd0;
        end
    endcase
end




always@(*) begin
    for(k = 0; k < 36; k++) begin
        next_ofmap_ch1[k] = ofmap_ch1[k];
        next_ofmap_ch2[k] = ofmap_ch2[k];
    end
    case(t)
         4, 29, 54: begin
            next_ofmap_ch1[0] = add_ch1_out[5];
            next_ofmap_ch1[1] = add_ch1_out[6];
            next_ofmap_ch1[6] = add_ch1_out[7];
            next_ofmap_ch1[7] = add_ch1_out[8];
            next_ofmap_ch2[0] = add_ch2_out[5];
            next_ofmap_ch2[1] = add_ch2_out[6];
            next_ofmap_ch2[6] = add_ch2_out[7];
            next_ofmap_ch2[7] = add_ch2_out[8];
        end
         5, 30, 55: begin
            next_ofmap_ch1[1] = add_ch1_out[5];
            next_ofmap_ch1[2] = add_ch1_out[6];
            next_ofmap_ch1[7] = add_ch1_out[7];
            next_ofmap_ch1[8] = add_ch1_out[8];
            next_ofmap_ch2[1] = add_ch2_out[5];
            next_ofmap_ch2[2] = add_ch2_out[6];
            next_ofmap_ch2[7] = add_ch2_out[7];
            next_ofmap_ch2[8] = add_ch2_out[8];
        end
         6, 31, 56: begin
            next_ofmap_ch1[2] = add_ch1_out[5];
            next_ofmap_ch1[3] = add_ch1_out[6];
            next_ofmap_ch1[8] = add_ch1_out[7];
            next_ofmap_ch1[9] = add_ch1_out[8];
            next_ofmap_ch2[2] = add_ch2_out[5];
            next_ofmap_ch2[3] = add_ch2_out[6];
            next_ofmap_ch2[8] = add_ch2_out[7];
            next_ofmap_ch2[9] = add_ch2_out[8];
        end
         7, 32, 57: begin
            next_ofmap_ch1[3] = add_ch1_out[5];
            next_ofmap_ch1[4] = add_ch1_out[6];
            next_ofmap_ch1[9] = add_ch1_out[7];
            next_ofmap_ch1[10] = add_ch1_out[8];
            next_ofmap_ch2[3] = add_ch2_out[5];
            next_ofmap_ch2[4] = add_ch2_out[6];
            next_ofmap_ch2[9] = add_ch2_out[7];
            next_ofmap_ch2[10] = add_ch2_out[8];
        end
         8, 33, 58: begin
            next_ofmap_ch1[4] = add_ch1_out[5];
            next_ofmap_ch1[5] = add_ch1_out[6];
            next_ofmap_ch1[10] = add_ch1_out[7];
            next_ofmap_ch1[11] = add_ch1_out[8];
            next_ofmap_ch2[4] = add_ch2_out[5];
            next_ofmap_ch2[5] = add_ch2_out[6];
            next_ofmap_ch2[10] = add_ch2_out[7];
            next_ofmap_ch2[11] = add_ch2_out[8];
        end
         9, 34, 59: begin
            next_ofmap_ch1[6] = add_ch1_out[5];
            next_ofmap_ch1[7] = add_ch1_out[6];
            next_ofmap_ch1[12] = add_ch1_out[7];
            next_ofmap_ch1[13] = add_ch1_out[8];
            next_ofmap_ch2[6] = add_ch2_out[5];
            next_ofmap_ch2[7] = add_ch2_out[6];
            next_ofmap_ch2[12] = add_ch2_out[7];
            next_ofmap_ch2[13] = add_ch2_out[8];
        end
        10, 35, 60: begin
            next_ofmap_ch1[7] = add_ch1_out[5];
            next_ofmap_ch1[8] = add_ch1_out[6];
            next_ofmap_ch1[13] = add_ch1_out[7];
            next_ofmap_ch1[14] = add_ch1_out[8];
            next_ofmap_ch2[7] = add_ch2_out[5];
            next_ofmap_ch2[8] = add_ch2_out[6];
            next_ofmap_ch2[13] = add_ch2_out[7];
            next_ofmap_ch2[14] = add_ch2_out[8];
        end
        11, 36, 61: begin
            next_ofmap_ch1[8] = add_ch1_out[5];
            next_ofmap_ch1[9] = add_ch1_out[6];
            next_ofmap_ch1[14] = add_ch1_out[7];
            next_ofmap_ch1[15] = add_ch1_out[8];
            next_ofmap_ch2[8] = add_ch2_out[5];
            next_ofmap_ch2[9] = add_ch2_out[6];
            next_ofmap_ch2[14] = add_ch2_out[7];
            next_ofmap_ch2[15] = add_ch2_out[8];
        end
        12, 37, 62: begin
            next_ofmap_ch1[9] = add_ch1_out[5];
            next_ofmap_ch1[10] = add_ch1_out[6];
            next_ofmap_ch1[15] = add_ch1_out[7];
            next_ofmap_ch1[16] = add_ch1_out[8];
            next_ofmap_ch2[9] = add_ch2_out[5];
            next_ofmap_ch2[10] = add_ch2_out[6];
            next_ofmap_ch2[15] = add_ch2_out[7];
            next_ofmap_ch2[16] = add_ch2_out[8];
        end
        13, 38, 63: begin
            next_ofmap_ch1[10] = add_ch1_out[5];
            next_ofmap_ch1[11] = add_ch1_out[6];
            next_ofmap_ch1[16] = add_ch1_out[7];
            next_ofmap_ch1[17] = add_ch1_out[8];
            next_ofmap_ch2[10] = add_ch2_out[5];
            next_ofmap_ch2[11] = add_ch2_out[6];
            next_ofmap_ch2[16] = add_ch2_out[7];
            next_ofmap_ch2[17] = add_ch2_out[8];
        end
        14, 39, 64: begin
            next_ofmap_ch1[12] = add_ch1_out[5];
            next_ofmap_ch1[13] = add_ch1_out[6];
            next_ofmap_ch1[18] = add_ch1_out[7];
            next_ofmap_ch1[19] = add_ch1_out[8];
            next_ofmap_ch2[12] = add_ch2_out[5];
            next_ofmap_ch2[13] = add_ch2_out[6];
            next_ofmap_ch2[18] = add_ch2_out[7];
            next_ofmap_ch2[19] = add_ch2_out[8];
        end
        15, 40, 65: begin
            next_ofmap_ch1[13] = add_ch1_out[5];
            next_ofmap_ch1[14] = add_ch1_out[6];
            next_ofmap_ch1[19] = add_ch1_out[7];
            next_ofmap_ch1[20] = add_ch1_out[8];
            next_ofmap_ch2[13] = add_ch2_out[5];
            next_ofmap_ch2[14] = add_ch2_out[6];
            next_ofmap_ch2[19] = add_ch2_out[7];
            next_ofmap_ch2[20] = add_ch2_out[8];
        end
        16, 41, 66: begin
            next_ofmap_ch1[14] = add_ch1_out[5];
            next_ofmap_ch1[15] = add_ch1_out[6];
            next_ofmap_ch1[20] = add_ch1_out[7];
            next_ofmap_ch1[21] = add_ch1_out[8];
            next_ofmap_ch2[14] = add_ch2_out[5];
            next_ofmap_ch2[15] = add_ch2_out[6];
            next_ofmap_ch2[20] = add_ch2_out[7];
            next_ofmap_ch2[21] = add_ch2_out[8];
        end
        17, 42, 67: begin
            next_ofmap_ch1[15] = add_ch1_out[5];
            next_ofmap_ch1[16] = add_ch1_out[6];
            next_ofmap_ch1[21] = add_ch1_out[7];
            next_ofmap_ch1[22] = add_ch1_out[8];
            next_ofmap_ch2[15] = add_ch2_out[5];
            next_ofmap_ch2[16] = add_ch2_out[6];
            next_ofmap_ch2[21] = add_ch2_out[7];
            next_ofmap_ch2[22] = add_ch2_out[8];
        end
        18, 43, 68: begin
            next_ofmap_ch1[16] = add_ch1_out[5];
            next_ofmap_ch1[17] = add_ch1_out[6];
            next_ofmap_ch1[22] = add_ch1_out[7];
            next_ofmap_ch1[23] = add_ch1_out[8];
            next_ofmap_ch2[16] = add_ch2_out[5];
            next_ofmap_ch2[17] = add_ch2_out[6];
            next_ofmap_ch2[22] = add_ch2_out[7];
            next_ofmap_ch2[23] = add_ch2_out[8];
        end
        19, 44, 69: begin
            next_ofmap_ch1[18] = add_ch1_out[5];
            next_ofmap_ch1[19] = add_ch1_out[6];
            next_ofmap_ch1[24] = add_ch1_out[7];
            next_ofmap_ch1[25] = add_ch1_out[8];
            next_ofmap_ch2[18] = add_ch2_out[5];
            next_ofmap_ch2[19] = add_ch2_out[6];
            next_ofmap_ch2[24] = add_ch2_out[7];
            next_ofmap_ch2[25] = add_ch2_out[8];
        end
        20, 45, 70: begin
            next_ofmap_ch1[19] = add_ch1_out[5];
            next_ofmap_ch1[20] = add_ch1_out[6];
            next_ofmap_ch1[25] = add_ch1_out[7];
            next_ofmap_ch1[26] = add_ch1_out[8];
            next_ofmap_ch2[19] = add_ch2_out[5];
            next_ofmap_ch2[20] = add_ch2_out[6];
            next_ofmap_ch2[25] = add_ch2_out[7];
            next_ofmap_ch2[26] = add_ch2_out[8];
        end
        21, 46, 71: begin
            next_ofmap_ch1[20] = add_ch1_out[5];
            next_ofmap_ch1[21] = add_ch1_out[6];
            next_ofmap_ch1[26] = add_ch1_out[7];
            next_ofmap_ch1[27] = add_ch1_out[8];
            next_ofmap_ch2[20] = add_ch2_out[5];
            next_ofmap_ch2[21] = add_ch2_out[6];
            next_ofmap_ch2[26] = add_ch2_out[7];
            next_ofmap_ch2[27] = add_ch2_out[8];
        end
        22, 47, 72: begin
            next_ofmap_ch1[21] = add_ch1_out[5];
            next_ofmap_ch1[22] = add_ch1_out[6];
            next_ofmap_ch1[27] = add_ch1_out[7];
            next_ofmap_ch1[28] = add_ch1_out[8];
            next_ofmap_ch2[21] = add_ch2_out[5];
            next_ofmap_ch2[22] = add_ch2_out[6];
            next_ofmap_ch2[27] = add_ch2_out[7];
            next_ofmap_ch2[28] = add_ch2_out[8];
        end
        23, 48, 73: begin
            next_ofmap_ch1[22] = add_ch1_out[5];
            next_ofmap_ch1[23] = add_ch1_out[6];
            next_ofmap_ch1[28] = add_ch1_out[7];
            next_ofmap_ch1[29] = add_ch1_out[8];
            next_ofmap_ch2[22] = add_ch2_out[5];
            next_ofmap_ch2[23] = add_ch2_out[6];
            next_ofmap_ch2[28] = add_ch2_out[7];
            next_ofmap_ch2[29] = add_ch2_out[8];
        end
        24, 49, 74: begin
            next_ofmap_ch1[24] = add_ch1_out[5];
            next_ofmap_ch1[25] = add_ch1_out[6];
            next_ofmap_ch1[30] = add_ch1_out[7];
            next_ofmap_ch1[31] = add_ch1_out[8];
            next_ofmap_ch2[24] = add_ch2_out[5];
            next_ofmap_ch2[25] = add_ch2_out[6];
            next_ofmap_ch2[30] = add_ch2_out[7];
            next_ofmap_ch2[31] = add_ch2_out[8];
        end
        25, 50, 75: begin
            next_ofmap_ch1[25] = add_ch1_out[5];
            next_ofmap_ch1[26] = add_ch1_out[6];
            next_ofmap_ch1[31] = add_ch1_out[7];
            next_ofmap_ch1[32] = add_ch1_out[8];
            next_ofmap_ch2[25] = add_ch2_out[5];
            next_ofmap_ch2[26] = add_ch2_out[6];
            next_ofmap_ch2[31] = add_ch2_out[7];
            next_ofmap_ch2[32] = add_ch2_out[8];
        end
        26, 51, 76: begin
            next_ofmap_ch1[26] = add_ch1_out[5];
            next_ofmap_ch1[27] = add_ch1_out[6];
            next_ofmap_ch1[32] = add_ch1_out[7];
            next_ofmap_ch1[33] = add_ch1_out[8];
            next_ofmap_ch2[26] = add_ch2_out[5];
            next_ofmap_ch2[27] = add_ch2_out[6];
            next_ofmap_ch2[32] = add_ch2_out[7];
            next_ofmap_ch2[33] = add_ch2_out[8];
        end
        27, 52, 77: begin
            next_ofmap_ch1[27] = add_ch1_out[5];
            next_ofmap_ch1[28] = add_ch1_out[6];
            next_ofmap_ch1[33] = add_ch1_out[7];
            next_ofmap_ch1[34] = add_ch1_out[8];
            next_ofmap_ch2[27] = add_ch2_out[5];
            next_ofmap_ch2[28] = add_ch2_out[6];
            next_ofmap_ch2[33] = add_ch2_out[7];
            next_ofmap_ch2[34] = add_ch2_out[8];
        end
        28, 53, 78: begin
            next_ofmap_ch1[28] = add_ch1_out[5];
            next_ofmap_ch1[29] = add_ch1_out[6];
            next_ofmap_ch1[34] = add_ch1_out[7];
            next_ofmap_ch1[35] = add_ch1_out[8];
            next_ofmap_ch2[28] = add_ch2_out[5];
            next_ofmap_ch2[29] = add_ch2_out[6];
            next_ofmap_ch2[34] = add_ch2_out[7];
            next_ofmap_ch2[35] = add_ch2_out[8];
        end
    endcase
end
////////////////////////////////////////////


//////////////// max pool //////////////////


DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) CMP1 ( .a(cmp_a_ch1[0]), .b(cmp_b_ch1[0]), .zctr(1'b1), .z0(cmp_out_ch1[0]));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) CMP2 ( .a(cmp_a_ch1[1]), .b(cmp_b_ch1[1]), .zctr(1'b1), .z0(cmp_out_ch1[1]));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) CMP3 ( .a(cmp_a_ch1[2]), .b(cmp_b_ch1[2]), .zctr(1'b1), .z0(cmp_out_ch1[2]));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) CMP7 ( .a(cmp_a_ch1[3]), .b(cmp_b_ch1[3]), .zctr(1'b1), .z0(cmp_out_ch1[3]));
//ch2
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) CMP4 ( .a(cmp_a_ch2[0]), .b(cmp_b_ch2[0]), .zctr(1'b1), .z0(cmp_out_ch2[0]));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) CMP5 ( .a(cmp_a_ch2[1]), .b(cmp_b_ch2[1]), .zctr(1'b1), .z0(cmp_out_ch2[1]));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) CMP6 ( .a(cmp_a_ch2[2]), .b(cmp_b_ch2[2]), .zctr(1'b1), .z0(cmp_out_ch2[2]));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) CMP8 ( .a(cmp_a_ch2[3]), .b(cmp_b_ch2[3]), .zctr(1'b1), .z0(cmp_out_ch2[3]));

always@(*) begin
    cmp_a_ch1[2] = cmp_out_ch1[0];
    cmp_b_ch1[2] = cmp_out_ch1[1];
    cmp_a_ch2[2] = cmp_out_ch2[0];
    cmp_b_ch2[2] = cmp_out_ch2[1];
    cmp_a_ch1[3] = cmp_out_ch1[2];
    cmp_a_ch2[3] = cmp_out_ch2[2];
    cmp_b_ch1[3] = cmp_out_ch1[2];
    cmp_b_ch2[3] = cmp_out_ch2[2];
    case(t)
        55: begin
            cmp_a_ch1[0] = ofmap_ch1[0];
            cmp_a_ch1[1] = ofmap_ch1[0];
            cmp_b_ch1[0] = ofmap_ch1[0];
            cmp_b_ch1[1] = ofmap_ch1[0];
            cmp_a_ch2[0] = ofmap_ch2[0];
            cmp_a_ch2[1] = ofmap_ch2[0];
            cmp_b_ch2[0] = ofmap_ch2[0];
            cmp_b_ch2[1] = ofmap_ch2[0];
        end
        56: begin
            cmp_a_ch1[0] = ofmap_ch1[1];
            cmp_a_ch1[1] = ofmap_ch1[1];
            cmp_b_ch1[0] = max_pool_ch1[0];
            cmp_b_ch1[1] = max_pool_ch1[0];
            cmp_a_ch2[0] = ofmap_ch2[1];
            cmp_a_ch2[1] = ofmap_ch2[1];
            cmp_b_ch2[0] = max_pool_ch2[0];
            cmp_b_ch2[1] = max_pool_ch2[0];
        end
        57: begin
            cmp_a_ch1[0] = ofmap_ch1[2];
            cmp_a_ch1[1] = ofmap_ch1[2];
            cmp_b_ch1[0] = max_pool_ch1[0];
            cmp_b_ch1[1] = max_pool_ch1[0];
            cmp_a_ch2[0] = ofmap_ch2[2];
            cmp_a_ch2[1] = ofmap_ch2[2];
            cmp_b_ch2[0] = max_pool_ch2[0];
            cmp_b_ch2[1] = max_pool_ch2[0];
        end
        58: begin
            cmp_a_ch1[0] = ofmap_ch1[3];
            cmp_a_ch1[1] = ofmap_ch1[3];
            cmp_b_ch1[0] = ofmap_ch1[3];
            cmp_b_ch1[1] = ofmap_ch1[3];
            cmp_a_ch2[0] = ofmap_ch2[3];
            cmp_a_ch2[1] = ofmap_ch2[3];
            cmp_b_ch2[0] = ofmap_ch2[3];
            cmp_b_ch2[1] = ofmap_ch2[3];
        end
        59: begin
            cmp_a_ch1[0] = ofmap_ch1[4];
            cmp_a_ch1[1] = ofmap_ch1[5];
            cmp_b_ch1[0] = max_pool_ch1[1];
            cmp_b_ch1[1] = max_pool_ch1[1];
            cmp_a_ch2[0] = ofmap_ch2[4];
            cmp_a_ch2[1] = ofmap_ch2[5];
            cmp_b_ch2[0] = max_pool_ch2[1];
            cmp_b_ch2[1] = max_pool_ch2[1];
        end
        60: begin
            cmp_a_ch1[0] = ofmap_ch1[6];
            cmp_a_ch1[1] = ofmap_ch1[6];
            cmp_b_ch1[0] = max_pool_ch1[0];
            cmp_b_ch1[1] = max_pool_ch1[0];
            cmp_a_ch2[0] = ofmap_ch2[6];
            cmp_a_ch2[1] = ofmap_ch2[6];
            cmp_b_ch2[0] = max_pool_ch2[0];
            cmp_b_ch2[1] = max_pool_ch2[0];
        end
        61: begin
            cmp_a_ch1[0] = ofmap_ch1[7];
            cmp_a_ch1[1] = ofmap_ch1[7];
            cmp_b_ch1[0] = max_pool_ch1[0];
            cmp_b_ch1[1] = max_pool_ch1[0];
            cmp_a_ch2[0] = ofmap_ch2[7];
            cmp_a_ch2[1] = ofmap_ch2[7];
            cmp_b_ch2[0] = max_pool_ch2[0];
            cmp_b_ch2[1] = max_pool_ch2[0];
        end
        62: begin
            cmp_a_ch1[0] = ofmap_ch1[8];
            cmp_a_ch1[1] = ofmap_ch1[8];
            cmp_b_ch1[0] = max_pool_ch1[0];
            cmp_b_ch1[1] = max_pool_ch1[0];
            cmp_a_ch2[0] = ofmap_ch2[8];
            cmp_a_ch2[1] = ofmap_ch2[8];
            cmp_b_ch2[0] = max_pool_ch2[0];
            cmp_b_ch2[1] = max_pool_ch2[0];
        end
        63: begin
            cmp_a_ch1[0] = ofmap_ch1[9];
            cmp_a_ch1[1] = ofmap_ch1[9];
            cmp_b_ch1[0] = max_pool_ch1[1];
            cmp_b_ch1[1] = max_pool_ch1[1];
            cmp_a_ch2[0] = ofmap_ch2[9];
            cmp_a_ch2[1] = ofmap_ch2[9];
            cmp_b_ch2[0] = max_pool_ch2[1];
            cmp_b_ch2[1] = max_pool_ch2[1];
        end
        64: begin
            cmp_a_ch1[0] = ofmap_ch1[10];
            cmp_a_ch1[1] = ofmap_ch1[11];
            cmp_b_ch1[0] = max_pool_ch1[1];
            cmp_b_ch1[1] = max_pool_ch1[1];
            cmp_a_ch2[0] = ofmap_ch2[10];
            cmp_a_ch2[1] = ofmap_ch2[11];
            cmp_b_ch2[0] = max_pool_ch2[1];
            cmp_b_ch2[1] = max_pool_ch2[1];
        end
        65: begin
            cmp_a_ch1[0] = ofmap_ch1[12];
            cmp_a_ch1[1] = ofmap_ch1[12];
            cmp_b_ch1[0] = max_pool_ch1[0];
            cmp_b_ch1[1] = max_pool_ch1[0];
            cmp_a_ch2[0] = ofmap_ch2[12];
            cmp_a_ch2[1] = ofmap_ch2[12];
            cmp_b_ch2[0] = max_pool_ch2[0];
            cmp_b_ch2[1] = max_pool_ch2[0];
        end
        66: begin
            cmp_a_ch1[0] = ofmap_ch1[13];
            cmp_a_ch1[1] = ofmap_ch1[13];
            cmp_b_ch1[0] = max_pool_ch1[0];
            cmp_b_ch1[1] = max_pool_ch1[0];
            cmp_a_ch2[0] = ofmap_ch2[13];
            cmp_a_ch2[1] = ofmap_ch2[13];
            cmp_b_ch2[0] = max_pool_ch2[0];
            cmp_b_ch2[1] = max_pool_ch2[0];
        end
        67: begin
            cmp_a_ch1[0] = ofmap_ch1[14];
            cmp_a_ch1[1] = ofmap_ch1[14];
            cmp_b_ch1[0] = max_pool_ch1[0];
            cmp_b_ch1[1] = max_pool_ch1[0];
            cmp_a_ch2[0] = ofmap_ch2[14];
            cmp_a_ch2[1] = ofmap_ch2[14];
            cmp_b_ch2[0] = max_pool_ch2[0];
            cmp_b_ch2[1] = max_pool_ch2[0];
        end
        68: begin
            cmp_a_ch1[0] = ofmap_ch1[15];
            cmp_a_ch1[1] = ofmap_ch1[15];
            cmp_b_ch1[0] = max_pool_ch1[1];
            cmp_b_ch1[1] = max_pool_ch1[1];
            cmp_a_ch2[0] = ofmap_ch2[15];
            cmp_a_ch2[1] = ofmap_ch2[15];
            cmp_b_ch2[0] = max_pool_ch2[1];
            cmp_b_ch2[1] = max_pool_ch2[1];
        end
        69: begin
            cmp_a_ch1[0] = ofmap_ch1[16];
            cmp_a_ch1[1] = ofmap_ch1[17];
            cmp_b_ch1[0] = max_pool_ch1[1];
            cmp_b_ch1[1] = max_pool_ch1[1];
            cmp_a_ch2[0] = ofmap_ch2[16];
            cmp_a_ch2[1] = ofmap_ch2[17];
            cmp_b_ch2[0] = max_pool_ch2[1];
            cmp_b_ch2[1] = max_pool_ch2[1];
        end
        70: begin
            cmp_a_ch1[0] = ofmap_ch1[18];
            cmp_a_ch1[1] = ofmap_ch1[18];
            cmp_b_ch1[0] = ofmap_ch1[18];
            cmp_b_ch1[1] = ofmap_ch1[18];
            cmp_a_ch2[0] = ofmap_ch2[18];
            cmp_a_ch2[1] = ofmap_ch2[18];
            cmp_b_ch2[0] = ofmap_ch2[18];
            cmp_b_ch2[1] = ofmap_ch2[18];
        end
        71: begin
            cmp_a_ch1[0] = ofmap_ch1[19];
            cmp_a_ch1[1] = ofmap_ch1[19];
            cmp_b_ch1[0] = max_pool_ch1[2];
            cmp_b_ch1[1] = max_pool_ch1[2];
            cmp_a_ch2[0] = ofmap_ch2[19];
            cmp_a_ch2[1] = ofmap_ch2[19];
            cmp_b_ch2[0] = max_pool_ch2[2];
            cmp_b_ch2[1] = max_pool_ch2[2];
        end
        72: begin
            cmp_a_ch1[0] = ofmap_ch1[20];
            cmp_a_ch1[1] = ofmap_ch1[20];
            cmp_b_ch1[0] = max_pool_ch1[2];
            cmp_b_ch1[1] = max_pool_ch1[2];
            cmp_a_ch2[0] = ofmap_ch2[20];
            cmp_a_ch2[1] = ofmap_ch2[20];
            cmp_b_ch2[0] = max_pool_ch2[2];
            cmp_b_ch2[1] = max_pool_ch2[2];
        end
        73: begin
            cmp_a_ch1[0] = ofmap_ch1[21];
            cmp_a_ch1[1] = ofmap_ch1[21];
            cmp_b_ch1[0] = ofmap_ch1[21];
            cmp_b_ch1[1] = ofmap_ch1[21];
            cmp_a_ch2[0] = ofmap_ch2[21];
            cmp_a_ch2[1] = ofmap_ch2[21];
            cmp_b_ch2[0] = ofmap_ch2[21];
            cmp_b_ch2[1] = ofmap_ch2[21];
        end
        74: begin
            cmp_a_ch1[0] = ofmap_ch1[22];
            cmp_a_ch1[1] = ofmap_ch1[23];
            cmp_b_ch1[0] = max_pool_ch1[3];
            cmp_b_ch1[1] = max_pool_ch1[3];
            cmp_a_ch2[0] = ofmap_ch2[22];
            cmp_a_ch2[1] = ofmap_ch2[23];
            cmp_b_ch2[0] = max_pool_ch2[3];
            cmp_b_ch2[1] = max_pool_ch2[3];
        end
        75: begin
            cmp_a_ch1[0] = ofmap_ch1[24];
            cmp_a_ch1[1] = ofmap_ch1[30];
            cmp_b_ch1[0] = max_pool_ch1[2];
            cmp_b_ch1[1] = max_pool_ch1[2];
            cmp_a_ch2[0] = ofmap_ch2[24];
            cmp_a_ch2[1] = ofmap_ch2[30];
            cmp_b_ch2[0] = max_pool_ch2[2];
            cmp_b_ch2[1] = max_pool_ch2[2];
        end
        76: begin
            cmp_a_ch1[0] = ofmap_ch1[25];
            cmp_a_ch1[1] = ofmap_ch1[31];
            cmp_b_ch1[0] = max_pool_ch1[2];
            cmp_b_ch1[1] = max_pool_ch1[2];
            cmp_a_ch2[0] = ofmap_ch2[25];
            cmp_a_ch2[1] = ofmap_ch2[31];
            cmp_b_ch2[0] = max_pool_ch2[2];
            cmp_b_ch2[1] = max_pool_ch2[2];
        end
        77: begin
            cmp_a_ch1[0] = ofmap_ch1[26];
            cmp_a_ch1[1] = ofmap_ch1[32];
            cmp_b_ch1[0] = max_pool_ch1[2];
            cmp_b_ch1[1] = max_pool_ch1[2];
            cmp_a_ch2[0] = ofmap_ch2[26];
            cmp_a_ch2[1] = ofmap_ch2[32];
            cmp_b_ch2[0] = max_pool_ch2[2];
            cmp_b_ch2[1] = max_pool_ch2[2];
        end
        78: begin
            cmp_a_ch1[0] = ofmap_ch1[27];
            cmp_a_ch1[1] = ofmap_ch1[33];
            cmp_b_ch1[0] = max_pool_ch1[3];
            cmp_b_ch1[1] = max_pool_ch1[3];
            cmp_a_ch2[0] = ofmap_ch2[27];
            cmp_a_ch2[1] = ofmap_ch2[33];
            cmp_b_ch2[0] = max_pool_ch2[3];
            cmp_b_ch2[1] = max_pool_ch2[3];
        end
        79: begin
            cmp_a_ch1[0] = ofmap_ch1[28];
            cmp_a_ch1[1] = ofmap_ch1[34];
            cmp_b_ch1[0] = ofmap_ch1[35];
            cmp_b_ch1[1] = max_pool_ch1[3];
            cmp_a_ch2[0] = ofmap_ch2[28];
            cmp_a_ch2[1] = ofmap_ch2[34];
            cmp_b_ch2[0] = ofmap_ch2[35];
            cmp_b_ch2[1] = max_pool_ch2[3];
            cmp_b_ch1[3] = ofmap_ch1[29];
            cmp_b_ch2[3] = ofmap_ch2[29];
        end
        default: begin
            cmp_a_ch1[0] = 32'd0;
            cmp_a_ch1[1] = 32'd0;
            cmp_b_ch1[0] = 32'd0;
            cmp_b_ch1[1] = 32'd0;
            cmp_a_ch2[0] = 32'd0;
            cmp_a_ch2[1] = 32'd0;
            cmp_b_ch2[0] = 32'd0;
            cmp_b_ch2[1] = 32'd0;
        end
    endcase
end



always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(k = 0; k < 4; k++) begin
            max_pool_ch1[k] <= 32'd0;
            max_pool_ch2[k] <= 32'd0;
        end
    end
    else if(State == CAL)begin
        for(k = 0; k < 4; k++) begin
            max_pool_ch1[k] <= next_max_pool_ch1[k];
            max_pool_ch2[k] <= next_max_pool_ch2[k];
        end
    end
end

always@(*) begin
    for(k = 0; k < 4; k++) begin
        next_max_pool_ch1[k] = max_pool_ch1[k];
        next_max_pool_ch2[k] = max_pool_ch2[k];
    end
    case(t)
        55,56,57,60,61,62,65,66,67: begin
            next_max_pool_ch1[0] = cmp_out_ch1[3];
            next_max_pool_ch2[0] = cmp_out_ch2[3];
        end
        58,59,63,64,68,69: begin
            next_max_pool_ch1[1] = cmp_out_ch1[3];
            next_max_pool_ch2[1] = cmp_out_ch2[3];
        end
        70,71,72,75,76,77: begin
            next_max_pool_ch1[2] = cmp_out_ch1[3];
            next_max_pool_ch2[2] = cmp_out_ch2[3];
        end
        73,74,78,79: begin
            next_max_pool_ch1[3] = cmp_out_ch1[3];
            next_max_pool_ch2[3] = cmp_out_ch2[3];
        end
    endcase
end



////////////////////////////////////////////


////////////////act fun ///////////////////




// DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A19 (.a(act_add_a_ch1[0]), .b(act_add_b_ch1[0]), .rnd(3'b000), .z(act_add_out_ch1[0]));
// DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A20 (.a(act_add_a_ch1[1]), .b(act_add_b_ch1[1]), .rnd(3'b000), .z(act_add_out_ch1[1]));
// DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) EXP0 (.a(act_exp_in_ch1),.z(act_exp_out_ch1));
// DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_faithful_round) DIV0( .a(act_div_a_ch1), .b(act_div_b_ch1), .rnd(3'b000), .z(act_div_out_ch1));

// DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A21 (.a(act_add_a_ch2[0]), .b(act_add_b_ch2[0]), .rnd(3'b000), .z(act_add_out_ch2[0]));
// DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A22 (.a(act_add_a_ch2[1]), .b(act_add_b_ch2[1]), .rnd(3'b000), .z(act_add_out_ch2[1]));
// DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) EXP1 (.a(act_exp_in_ch2),.z(act_exp_out_ch2));
// DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_faithful_round) DIV1( .a(act_div_a_ch2), .b(act_div_b_ch2), .rnd(3'b000), .z(act_div_out_ch2));


// always@(posedge clk or negedge rst_n) begin
//     if(!rst_n) begin
//         for(k = 0; k < 4; k++) begin
//             act_ch1[k] <= 32'd0;
//             act_ch2[k] <= 32'd0;
//         end  
//     end
//     else if(State == IDLE) begin
//         for(k = 0; k < 4; k++) begin
//             act_ch1[k] <= 32'd0;
//             act_ch2[k] <= 32'd0;
//         end
//     end
//     else begin
//         if(t == 68) begin
//             act_ch1[0] <= act_div_out_ch1;
//             act_ch2[0] <= act_div_out_ch2;
//         end
//         else if(t == 70)begin
//             act_ch1[1] <= act_div_out_ch1;
//             act_ch2[1] <= act_div_out_ch2;
//         end
//         else if(t == 78)begin
//             act_ch1[2] <= act_div_out_ch1;
//             act_ch2[2] <= act_div_out_ch2;
//         end
//         else if(t == 80)begin
//             act_ch1[3] <= act_div_out_ch1;
//             act_ch2[3] <= act_div_out_ch2;
//         end
//     end
// end


// always@(*) begin
//     if(t == 68) begin
//         z_ch1 = max_pool_ch1[0];
//         z_ch2 = max_pool_ch2[0];
//     end
//     else if(t == 70)begin
//         z_ch1 = max_pool_ch1[1];
//         z_ch2 = max_pool_ch2[1];
//     end
//     else if(t == 78)begin
//         z_ch1 = max_pool_ch1[2];
//         z_ch2 = max_pool_ch2[2];
//     end
//     else begin
//         z_ch1 = max_pool_ch1[3];
//         z_ch2 = max_pool_ch2[3];
//     end
// end

// always@(*) begin
//     act_add_b_ch1[0] = 32'h3f800000;
//     act_add_b_ch1[1] = 32'hbf800000;
//     act_div_b_ch1 = act_add_out_ch1[0];
//     act_add_b_ch2[0] = 32'h3f800000;
//     act_add_b_ch2[1] = 32'hbf800000;
//     act_div_b_ch2 = act_add_out_ch2[0];
//     if(Opt_in == 0) begin
//         act_div_a_ch1 = 32'h3f800000;
//         act_div_a_ch2 = 32'h3f800000;
//     end
//     else begin
//         act_div_a_ch1 = act_add_out_ch1[1];
//         act_div_a_ch2 = act_add_out_ch2[1];
//     end
// end
// always@(*) begin
//     if(Opt_in == 0)begin
//         act_exp_in_ch1 = {z_ch1[31]^1'b1, z_ch1[30:0]};
//         act_exp_in_ch2 = {z_ch2[31]^1'b1, z_ch2[30:0]};
        
//     end
//     else begin
//         act_exp_in_ch1 = {z_ch1[31],z_ch1[30:23]+8'd1 ,z_ch1[22:0]};
//         act_exp_in_ch2 = {z_ch2[31],z_ch2[30:23]+8'd1 ,z_ch2[22:0]};
//     end
//     act_add_a_ch1[0] = act_exp_out_ch1;
//     act_add_a_ch2[0] = act_exp_out_ch2;
//     act_add_a_ch1[1] = act_exp_out_ch1;
//     act_add_a_ch2[1] = act_exp_out_ch2;
// end

//////////////////////////////////////////


//////////////////// fc ///////////////////




DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M8 (.a(fc_mul_a[0]), .b(fc_mul_b[0]), .rnd(3'b000), .z(fc_mul_out[0])); //a
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M9 (.a(fc_mul_a[1]), .b(fc_mul_b[1]), .rnd(3'b000), .z(fc_mul_out[1])); //b
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M10 (.a(fc_mul_a[2]), .b(fc_mul_b[2]), .rnd(3'b000), .z(fc_mul_out[2])); //c
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M11 (.a(fc_mul_a[3]), .b(fc_mul_b[3]), .rnd(3'b000), .z(fc_mul_out[3])); //d
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M12 (.a(fc_mul_a[4]), .b(fc_mul_b[4]), .rnd(3'b000), .z(fc_mul_out[4])); //a_ch2
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M13 (.a(fc_mul_a[5]), .b(fc_mul_b[5]), .rnd(3'b000), .z(fc_mul_out[5])); //b_ch2

DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type) SUM0 (.a(fc_sum_3_a[0]),.b(fc_sum_3_b[0]),.c(fc_sum_3_c[0]),.rnd(3'b000),.z(fc_sum_3_out[0]) );
DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type) SUM1 (.a(fc_sum_3_a[1]),.b(fc_sum_3_b[1]),.c(fc_sum_3_c[1]),.rnd(3'b000),.z(fc_sum_3_out[1]) );
DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type) SUM2 (.a(fc_sum_3_a[2]),.b(fc_sum_3_b[2]),.c(fc_sum_3_c[2]),.rnd(3'b000),.z(fc_sum_3_out[2]) );
always@(*) begin
    fc_sum_3_a[0] = fc_mul_out[0];
    fc_sum_3_a[1] = fc_mul_out[2];
    fc_sum_3_a[2] = fc_mul_out[4];
    fc_sum_3_b[0] = fc_mul_out[1];
    fc_sum_3_b[1] = fc_mul_out[3];
    fc_sum_3_b[2] = fc_mul_out[5];
    fc_sum_3_c[0] = fc_out[0];
    fc_sum_3_c[1] = fc_out[1];
    fc_sum_3_c[2] = fc_out[2];
end
always@(*) begin
    if(t == 68) begin
        fc_mul_a[0] = act_ch1[0];
        fc_mul_a[1] = act_ch2[0];
        fc_mul_a[2] = act_ch1[0];
        fc_mul_a[3] = act_ch2[0];
        fc_mul_a[4] = act_ch1[0];
        fc_mul_a[5] = act_ch2[0];
        fc_mul_b[0] = Weight_mem[0];
        fc_mul_b[1] = Weight_mem[4];
        fc_mul_b[2] = Weight_mem[8];
        fc_mul_b[3] = Weight_mem[12];
        fc_mul_b[4] = Weight_mem[16];
        fc_mul_b[5] = Weight_mem[20];
        
    end
    else if(t == 70) begin
        fc_mul_a[0] = act_ch1[1];
        fc_mul_a[1] = act_ch2[1];
        fc_mul_a[2] = act_ch1[1];
        fc_mul_a[3] = act_ch2[1];
        fc_mul_a[4] = act_ch1[1];
        fc_mul_a[5] = act_ch2[1];
        fc_mul_b[0] = Weight_mem[1];
        fc_mul_b[1] = Weight_mem[5];
        fc_mul_b[2] = Weight_mem[9];
        fc_mul_b[3] = Weight_mem[13];
        fc_mul_b[4] = Weight_mem[17];
        fc_mul_b[5] = Weight_mem[21];
    end
    else if(t == 78) begin
        fc_mul_a[0] = act_ch1[2];
        fc_mul_a[1] = act_ch2[2];
        fc_mul_a[2] = act_ch1[2];
        fc_mul_a[3] = act_ch2[2];
        fc_mul_a[4] = act_ch1[2];
        fc_mul_a[5] = act_ch2[2];
        fc_mul_b[0] = Weight_mem[2];
        fc_mul_b[1] = Weight_mem[6];
        fc_mul_b[2] = Weight_mem[10];
        fc_mul_b[3] = Weight_mem[14];
        fc_mul_b[4] = Weight_mem[18];
        fc_mul_b[5] = Weight_mem[22];
    end
    else if(t == 80) begin
        fc_mul_a[0] = act_ch1[3];
        fc_mul_a[1] = act_ch2[3];
        fc_mul_a[2] = act_ch1[3];
        fc_mul_a[3] = act_ch2[3];
        fc_mul_a[4] = act_ch1[3];
        fc_mul_a[5] = act_ch2[3];
        fc_mul_b[0] = Weight_mem[3];
        fc_mul_b[1] = Weight_mem[7];
        fc_mul_b[2] = Weight_mem[11];
        fc_mul_b[3] = Weight_mem[15];
        fc_mul_b[4] = Weight_mem[19];
        fc_mul_b[5] = Weight_mem[23];
    end
    else begin
        fc_mul_a[0] = 32'd0;
        fc_mul_a[1] = 32'd0;
        fc_mul_a[2] = 32'd0;
        fc_mul_a[3] = 32'd0;
        fc_mul_a[4] = 32'd0;
        fc_mul_a[5] = 32'd0;
        fc_mul_b[0] = 32'd0;
        fc_mul_b[1] = 32'd0;
        fc_mul_b[2] = 32'd0;
        fc_mul_b[3] = 32'd0;
        fc_mul_b[4] = 32'd0;
        fc_mul_b[5] = 32'd0;
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(k = 0; k < 3; k++) begin
            fc_out[k] <= 32'd0;
        end  
    end
    else if(t == 68 ||t == 70|| t == 78 || t == 80)begin
        fc_out[0] <=  fc_sum_3_out[0];
        fc_out[1] <=  fc_sum_3_out[1];
        fc_out[2] <=  fc_sum_3_out[2];
    end
    else if(State == IDLE) begin
        for(k = 0; k < 3; k++) begin
            fc_out[k] <= 32'd0;
        end 
    end
end



//////////////////////////////////////////

///////////// soft max //////////////////

// DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) EXP2 (.a(soft_max_exp_in[0]),.z(soft_max_exp_out[0]));
// DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) EXP3 (.a(soft_max_exp_in[1]),.z(soft_max_exp_out[1]));
// DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) EXP4 (.a(soft_max_exp_in[2]),.z(soft_max_exp_out[2]));
// DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_faithful_round) DIV2( .a(soft_max_div_a[0]), .b(soft_max_div_b), .rnd(3'b000), .z(soft_max_div_out[0]));
// DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_faithful_round) DIV3( .a(soft_max_div_a[1]), .b(soft_max_div_b), .rnd(3'b000), .z(soft_max_div_out[1]));
// DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_faithful_round) DIV4( .a(soft_max_div_a[2]), .b(soft_max_div_b), .rnd(3'b000), .z(soft_max_div_out[2]));
// DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type) SUM3 (.a(soft_sum3_a),.b(soft_sum3_b),.c(soft_sum3_c),.rnd(3'b000),.z(soft_sum3_out) );

// always@(*) begin
//     soft_max_exp_in[0] = fc_out[0];
//     soft_max_exp_in[1] = fc_out[1];
//     soft_max_exp_in[2] = fc_out[2];
//     soft_max_div_a[0] = soft_max_exp_out[0];
//     soft_max_div_a[1] = soft_max_exp_out[1];
//     soft_max_div_a[2] = soft_max_exp_out[2];
//     soft_sum3_a = soft_max_exp_out[0];
//     soft_sum3_b = soft_max_exp_out[1];
//     soft_sum3_c = soft_max_exp_out[2];
//     soft_max_div_b = soft_sum3_out;
// end

// always@(posedge clk or negedge rst_n) begin
//     if(!rst_n) begin
//         for(k = 0; k < 3; k++) begin
//             soft_max_out[k] <= 32'd0;
//         end  
//     end
    
//     else if(t == 82) begin
//         for(k = 0; k < 3; k++) begin
//             soft_max_out[k] <= soft_max_div_out[k];
//         end  
//     end
//     else if(State == IDLE) begin
//         for(k = 0; k < 3; k++) begin
//             soft_max_out[k] <= 32'd0;
//         end 
//     end
// end


////////////////////////////////////////



///////////////// act & softmax //////////

reg[31:0] as_exp_in [0:2];
reg[31:0] as_exp_out [0:2];
reg[31:0] as_div_a [0:1];
reg[31:0] as_div_b [0:1];
reg[31:0] as_div_out [0:1];

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A19 (.a(act_add_a_ch1[0]), .b(act_add_b_ch1[0]), .rnd(3'b000), .z(act_add_out_ch1[0]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A20 (.a(act_add_a_ch1[1]), .b(act_add_b_ch1[1]), .rnd(3'b000), .z(act_add_out_ch1[1]));
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) EXP0 (.a(as_exp_in[0]),.z(as_exp_out[0]));
DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_faithful_round) DIV0( .a(as_div_a[0]), .b(as_div_b[0]), .rnd(3'b000), .z(as_div_out[0]));

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A21 (.a(act_add_a_ch2[0]), .b(act_add_b_ch2[0]), .rnd(3'b000), .z(act_add_out_ch2[0]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A22 (.a(act_add_a_ch2[1]), .b(act_add_b_ch2[1]), .rnd(3'b000), .z(act_add_out_ch2[1]));
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) EXP1 (.a(as_exp_in[1]),.z(as_exp_out[1]));
DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_faithful_round) DIV1( .a(as_div_a[1]), .b(as_div_b[1]), .rnd(3'b000), .z(as_div_out[1]));

DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) EXP2 (.a(as_exp_in[2]),.z(as_exp_out[2]));
DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type) SUM3 (.a(soft_sum3_a),.b(soft_sum3_b),.c(soft_sum3_c),.rnd(3'b000),.z(soft_sum3_out) );

always@(*) begin
    soft_sum3_a = as_exp_out[0];
    soft_sum3_b = as_exp_out[1];
    soft_sum3_c = as_exp_out[2];
end

always@(*) begin
    as_exp_in[2] = fc_out[2];
    if(t==82||t == 81) begin
        as_exp_in[0] = fc_out[0];
        as_exp_in[1] = fc_out[1];
    end
    else begin
        if(Opt_in == 0)begin
            as_exp_in[0] = {z_ch1[31]^1'b1, z_ch1[30:0]};
            as_exp_in[1] = {z_ch2[31]^1'b1, z_ch2[30:0]};
        end
        else begin
            as_exp_in[0] = {z_ch1[31],z_ch1[30:23]+8'd1 ,z_ch1[22:0]};
            as_exp_in[1] = {z_ch2[31],z_ch2[30:23]+8'd1 ,z_ch2[22:0]};
        end
    end
end

always@(*) begin
    as_exp_in[2] = fc_out[2];
    if(t==81) begin
        as_div_a[0] = as_exp_out[0];
        as_div_a[1] = as_exp_out[1];
    end
    else if(t == 82) begin
        as_div_a[0] = as_exp_out[2];
        as_div_a[1] = as_exp_out[1];
    end
    else begin
        if(Opt_in == 0) begin
            as_div_a[0] = 32'h3f800000;
            as_div_a[1] = 32'h3f800000;
        end
        else begin
            as_div_a[0] = act_add_out_ch1[1];
            as_div_a[1] = act_add_out_ch2[1];
        end
    end
end
always@(*) begin
    as_exp_in[2] = fc_out[2];
    if(t==81 || t == 82) begin
        as_div_b[0] = soft_sum3_out;
        as_div_b[1] = soft_sum3_out;
    end
    else begin
        as_div_b[0] = act_add_out_ch1[0];
        as_div_b[1] = act_add_out_ch2[0];
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(k = 0; k < 3; k++) begin
            soft_max_out[k] <= 32'd0;
        end  
    end
    
    else if(t == 81) begin
        soft_max_out[0] <= as_div_out[0];
        soft_max_out[1] <= as_div_out[1];
    end
    else if(t == 82) begin
        soft_max_out[2] <= as_div_out[0];
    end
    else if(State == IDLE) begin
        for(k = 0; k < 3; k++) begin
            soft_max_out[k] <= 32'd0;
        end 
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(k = 0; k < 4; k++) begin
            act_ch1[k] <= 32'd0;
            act_ch2[k] <= 32'd0;
        end  
    end
    else if(State == IDLE) begin
        for(k = 0; k < 4; k++) begin
            act_ch1[k] <= 32'd0;
            act_ch2[k] <= 32'd0;
        end
    end
    else begin
        if(t == 67) begin
            act_ch1[0] <= as_div_out[0];
            act_ch2[0] <= as_div_out[1];
        end
        else if(t == 69)begin
            act_ch1[1] <= as_div_out[0];
            act_ch2[1] <= as_div_out[1];
        end
        else if(t == 77)begin
            act_ch1[2] <= as_div_out[0];
            act_ch2[2] <= as_div_out[1];
        end
        else if(t == 79)begin
            act_ch1[3] <= as_div_out[0];
            act_ch2[3] <= as_div_out[1];
        end
    end
end


always@(*) begin
    z_ch1 = cmp_out_ch1[3];
    z_ch2 = cmp_out_ch2[3];
end


assign act_add_b_ch1[0] = 32'h3f800000;
assign act_add_b_ch1[1] = 32'hbf800000;
assign act_add_b_ch2[0] = 32'h3f800000;
assign act_add_b_ch2[1] = 32'hbf800000;

always@(*) begin
    act_add_a_ch1[0] = as_exp_out[0];
    act_add_a_ch2[0] = as_exp_out[1];
    act_add_a_ch1[1] = as_exp_out[0];
    act_add_a_ch2[1] = as_exp_out[1];
end

endmodule
