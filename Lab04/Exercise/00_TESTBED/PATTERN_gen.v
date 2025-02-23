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

`define CYCLE_TIME      50.0
`define SEED_NUMBER     28825252
`define PATTERN_NUMBER 500

module PATTERN(
    //Output Port
    clk,
    rst_n,
    in_valid,
    Img,
    Kernel_ch1,
    Kernel_ch2,
	Weight,
    Opt,
    //Input Port
    out_valid,
    out
    );

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
output  logic        clk, rst_n, in_valid;
output  logic[31:0]  Img;
output  logic[31:0]  Kernel_ch1;
output  logic[31:0]  Kernel_ch2;
output  logic[31:0]  Weight;
output  logic        Opt;
input           out_valid;
input   [31:0]  out;

//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
parameter seed = `SEED_NUMBER;
parameter seed1 = `SEED_NUMBER +50;
parameter seed2 = `SEED_NUMBER +15162;
parameter seed3 = `SEED_NUMBER +2618;

real CYCLE = `CYCLE_TIME;
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;

integer f_Image, f_kernel_1, f_kernel_2 , f_weight, f_opt, f_out;
integer i_pat;
integer i , j ,k, a;
real delay_time = 1;
//---------------------------------------------------------------------
//   Reg & Wires
//---------------------------------------------------------------------

reg [31:0] Kernel_ch1_for_task [0:11];
reg [31:0] Kernel_ch2_for_task [0:11];
reg [31:0] ofmap_ch1_for_task [0:35];
reg [31:0] ofmap_ch2_for_task [0:35];
reg [31:0] Img_for_task [0:74];
reg Opt_for_task ;
reg [31:0] Weight_for_task [0:23]; 
reg [31:0] Golden [0:2];

reg [31:0] max_pool_ch1_for_task[0:3];
reg [31:0] max_pool_ch2_for_task[0:3];

reg [31:0] act_ch1_for_task[0:3];
reg [31:0] act_ch2_for_task[0:3];

//================================================================
// clock
//================================================================

always #(CYCLE/2.0) clk = ~clk;
initial	clk = 0;

//---------------------------------------------------------------------
//   Pattern_Design
//---------------------------------------------------------------------

real a1, a2;
real output_num, golden_num;
real abs_error;
reg [31:0] convert[0:1];
reg[31:0] mult_a [0:7];
reg[31:0] mult_b [0:7];
reg[31:0] mult_out [0:7];
reg[31:0] add_a_ch1 [0:8];
reg[31:0] add_b_ch1 [0:8];
reg[31:0] add_ch1_out [0:8];
reg[31:0] add_a_ch2 [0:8];
reg[31:0] add_b_ch2 [0:8];
reg[31:0] add_ch2_out [0:8];

reg [31:0] cmp_a_ch1, cmp_a_ch2, cmp_b_ch1, cmp_b_ch2, cmp_out_ch1, cmp_out_ch2;
reg [31:0] act_add_2_out;
reg [31:0] z;
reg [31:0] act_exp_in [0:1];
reg [31:0] act_exp_out [0:1];
reg [31:0] act_ln_in [0:1];
reg [31:0] act_ln_out [0:1];
reg [31:0] act_add_a [0:1];
reg [31:0] act_add_b [0:1];
reg [31:0] act_add_out [0:1];
reg [31:0] act_addsub_a ;
reg [31:0] act_addsub_b ;
reg [31:0] act_addsub_out ;

reg [31:0] x [0:7];
reg [31:0] fc_for_task [0:2];

reg[31:0] mac_a[0:2];
reg[31:0] mac_b[0:2];
reg[31:0] mac_c[0:2];
reg[31:0] mac_out[0:2]; 


reg[31:0] denominator ;
reg[31:0] soft_exp_in[0:3];
reg[31:0] soft_exp_out[0:3];
reg[31:0] soft_add_a[0:1];
reg[31:0] soft_add_b[0:1];
reg[31:0] soft_add_out[0:1];
reg[31:0] soft_ln_out, soft_ln_in;
reg[31:0] soft_addsub_a;
reg[31:0] soft_addsub_b;
reg[31:0] soft_addsub_out;
reg [31:0] softmax_for_task[0:2];

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M0 (.a(mult_a[0]), .b(mult_b[0]), .rnd(3'b000), .z(mult_out[0])); //a
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M1 (.a(mult_a[1]), .b(mult_b[1]), .rnd(3'b000), .z(mult_out[1])); //b
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M2 (.a(mult_a[2]), .b(mult_b[2]), .rnd(3'b000), .z(mult_out[2])); //c
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M3 (.a(mult_a[3]), .b(mult_b[3]), .rnd(3'b000), .z(mult_out[3])); //d
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M4 (.a(mult_a[4]), .b(mult_b[4]), .rnd(3'b000), .z(mult_out[4])); //a_ch2
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M5 (.a(mult_a[5]), .b(mult_b[5]), .rnd(3'b000), .z(mult_out[5])); //b_ch2
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M6 (.a(mult_a[6]), .b(mult_b[6]), .rnd(3'b000), .z(mult_out[6])); //c_ch2
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M7 (.a(mult_a[7]), .b(mult_b[7]), .rnd(3'b000), .z(mult_out[7])); //d_ch2

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

DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) CMP1 ( .a(cmp_a_ch1), .b(cmp_b_ch1), .zctr(1'b1), .unordered(unordered_inst), .z0(cmp_out_ch1));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) CMP2 ( .a(cmp_a_ch2), .b(cmp_b_ch2), .zctr(1'b1), .unordered(unordered_inst), .z0(cmp_out_ch2));

/////////////// activaiton funciton ///////////////////

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A19 (.a(act_add_a[0]), .b(act_add_b[0]), .rnd(3'b000), .z(act_add_out[0]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A20 (.a(act_add_a[1]), .b(act_add_b[1]), .rnd(3'b000), .z(act_add_out[1]));
DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance) ADDSUB0 ( .a(act_addsub_a), .b(act_addsub_b), .rnd(3'b000),.op(1'b1), .z(act_addsub_out));


DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, 1) EXP0 (.a(act_exp_in[0]),.z(act_exp_out[0]));
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, 1) EXP1 (.a(act_exp_in[1]),.z(act_exp_out[1]));

DW_fp_ln #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) LN0 (.a(act_ln_in[0]),.z(act_ln_out[0]) );
DW_fp_ln #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) LN1 (.a(act_ln_in[1]),.z(act_ln_out[1]) );

//////////////////////////////////////////////////////

DW_fp_mac #(inst_sig_width, inst_exp_width, inst_ieee_compliance) MAC0 (.a(mac_a[0]),.b(mac_b[0]),.c(mac_c[0]),.rnd(3'b000),.z(mac_out[0]));
DW_fp_mac #(inst_sig_width, inst_exp_width, inst_ieee_compliance) MAC1 (.a(mac_a[1]),.b(mac_b[1]),.c(mac_c[1]),.rnd(3'b000),.z(mac_out[1]));
DW_fp_mac #(inst_sig_width, inst_exp_width, inst_ieee_compliance) MAC2 (.a(mac_a[2]),.b(mac_b[2]),.c(mac_c[2]),.rnd(3'b000),.z(mac_out[2]));

////////////////////soft max //////////////////////////

DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, 1) EXP2 (.a(soft_exp_in[0]),.z(soft_exp_out[0]));
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, 1) EXP3 (.a(soft_exp_in[1]),.z(soft_exp_out[1]));
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, 1) EXP4 (.a(soft_exp_in[2]),.z(soft_exp_out[2]));
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, 1) EXP5 (.a(soft_exp_in[3]),.z(soft_exp_out[3]));


DW_fp_ln #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) LN2 (.a(soft_ln_in),.z(soft_ln_out) );

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A21 (.a(soft_add_a[0]), .b(soft_add_b[0]), .rnd(3'b000), .z(soft_add_out[0]));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A22 (.a(soft_add_a[1]), .b(soft_add_b[1]), .rnd(3'b000), .z(soft_add_out[1]));

DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance) ADDSUB1 ( .a(soft_addsub_a), .b(soft_addsub_b), .rnd(3'b000),.op(1'b1), .z(soft_addsub_out));


////////////////////////golden /////////////////////////////

ieee754_to_float convert_golden(.ieee754(convert[0]),.result(a1));
ieee754_to_float convert_output(.ieee754(convert[1]),.result(a2));

////////////////////////////////////////////////////////

initial begin
    f_Image = $fopen("../00_TESTBED/pattern_gen_txt/Img.txt", "r");
    f_kernel_1 = $fopen("../00_TESTBED/pattern_gen_txt/Kernel_ch1.txt", "r");
    f_kernel_2 = $fopen("../00_TESTBED/pattern_gen_txt/Kernel_ch2.txt", "r");
    f_opt = $fopen("../00_TESTBED/pattern_gen_txt/Opt.txt", "r");
    f_weight = $fopen("../00_TESTBED/pattern_gen_txt/Weight.txt", "r");
    f_out = $fopen("../00_TESTBED/pattern_gen_txt/Out.txt", "w");


	if (f_Image == 0) begin
		$display("Failed to open Img.txt");
		$finish;
	end
    if (f_kernel_1 == 0) begin
		$display("Failed to open Kernel_ch1.txt");
		$finish;
	end
    if (f_kernel_2 == 0) begin
		$display("Failed to open Kernel_ch2.txt");
		$finish;
	end
    if (f_opt == 0) begin
		$display("Failed to open Opt.txt");
		$finish;
	end
    if (f_out == 0) begin
		$display("Failed to open Out.txt");
		$finish;
	end
    if (f_weight == 0) begin
		$display("Failed to open Weight.txt");
		$finish;
	end
end

initial begin
    reset_task;
    for (i_pat = 0; i_pat < `PATTERN_NUMBER; i_pat = i_pat + 1) begin
        input_task;  
        
        sim_cir_task;
        golden_task;
        // check_ans_task;
    end
    repeat(2) @(negedge clk)
    $finish;
end


task check_ans_task;
begin
    for(i =0; i < 3; i++) begin
        convert[0] = Golden[i];
        convert[1] = softmax_for_task[i];
        #delay_time;
        golden_num = a1;
        output_num = a2;
        abs_error =(golden_num-output_num);
        if(abs_error>=0.0001||abs_error<=-0.0001) begin
            $display("Wrong answer at %d: output : %f    ans : %f   abs_error = %f", i_pat, output_num, golden_num, abs_error);
            repeat(2) @(negedge clk);
            $finish;
        end
        else begin
            $display("pass !!! output : %f    ans : %f   abs_error = %f", golden_num, output_num, abs_error);
        end
    end
end
endtask



task reset_task;
begin
    
    rst_n = 1'b1;
    in_valid = 1'b0;
    Img = 32'hxxxxxxxx;
    Kernel_ch1 = 32'hxxxxxxxx;
    Kernel_ch2 = 32'hxxxxxxxx;
    Weight = 32'hxxxxxxxx;
    Opt = 1'bx;
    

    force clk = 0;

    #CYCLE; rst_n = 1'b0; 
    #CYCLE; rst_n = 1'b1; 


    #CYCLE;
    

    // if (out_valid !== 1'b0 || out !== 32'd0) begin
	// 	$display("************************************************************");
    //     $display("            output should be 0 after reset                  ");
    //     $display("************************************************************");
	// 	repeat (2) #CYCLE;
    //     $finish;  
    // end

    #CYCLE;release clk;
end
endtask

task input_task; begin
    repeat ($urandom_range(1, 4)) @(negedge clk);
    a = $fscanf(f_Image, "%d", j);
    a = $fscanf(f_kernel_1, "%d", j);
    a = $fscanf(f_kernel_2, "%d", j);
    a = $fscanf(f_opt, "%d", j);
    a = $fscanf(f_weight, "%d", j);
    in_valid = 1'b1;
    for(i = 0; i < 75; i++) begin
        if(i == 0 ) begin
            a = $fscanf(f_opt, "%b", Opt);
            Opt_for_task = Opt;
        end
        else begin
            Opt = 1'bx;
        end
        if(i < 12) begin
            a = $fscanf(f_Image, "%h", Img);
            a = $fscanf(f_kernel_1, "%h", Kernel_ch1);
            a = $fscanf(f_kernel_2, "%h", Kernel_ch2);
            a = $fscanf(f_weight, "%h", Weight);
            Img_for_task[i] = Img;
            Kernel_ch1_for_task [i] = Kernel_ch1;
            Kernel_ch2_for_task [i] = Kernel_ch2;
            Weight_for_task[i] = Weight;
        end
        else if(i < 24) begin
            a = $fscanf(f_Image, "%h", Img);
            Kernel_ch1 = 32'hxxxxxxxx;
            Kernel_ch2 = 32'hxxxxxxxx;
            a = $fscanf(f_weight, "%h", Weight);
            Img_for_task[i] = Img;
            Weight_for_task[i] = Weight;
        end
        else begin
            a = $fscanf(f_Image, "%h", Img);
            Kernel_ch1 = 32'hxxxxxxxx;
            Kernel_ch2 = 32'hxxxxxxxx;
            Weight = 32'hxxxxxxxx;
            Img_for_task[i] = Img;
        end  
        @(negedge clk);
    end
    in_valid = 1'b0;
    Img = 32'hxxxxxxxx;
end endtask
task sim_cir_task; begin
    for(i = 0; i< 36; i++) begin
        ofmap_ch1_for_task[i] = 0;
        ofmap_ch2_for_task[i] = 0;
    end
    
    // #0.1;
    conv;
    for(i = 0; i<3 ; i++) begin
        max_pool_ch1_for_task[i] = 0;
        max_pool_ch2_for_task[i] = 0;
    end
    max_pool;
    Act;
    for(i =0; i < 4; i++) begin
        x[i] = act_ch1_for_task[i];
        x[i+4] = act_ch2_for_task[i];
    end
    for(i =0; i <3; i++) begin
        fc_for_task[i] = 0;
    end

    fc;
    softmax;
end endtask

task conv; begin
    for(k = 0; k<3; k++) begin
        for(i = 0; i < 5; i++) begin
            for(j = 0; j< 5; j++) begin
                mult_a[0] = Img_for_task[k*25+i*5+j];
                mult_a[1] = Img_for_task[k*25+i*5+j];
                mult_a[2] = Img_for_task[k*25+i*5+j];
                mult_a[3] = Img_for_task[k*25+i*5+j];
                mult_a[4] = Img_for_task[k*25+i*5+j]; // kernel 2 below
                mult_a[5] = Img_for_task[k*25+i*5+j];
                mult_a[6] = Img_for_task[k*25+i*5+j];
                mult_a[7] = Img_for_task[k*25+i*5+j];

                mult_b[0] = Kernel_ch1_for_task[k*4+0];
                mult_b[1] = Kernel_ch1_for_task[k*4+1];
                mult_b[2] = Kernel_ch1_for_task[k*4+2];
                mult_b[3] = Kernel_ch1_for_task[k*4+3];
                mult_b[4] = Kernel_ch2_for_task[k*4+0]; // kernel 2 below
                mult_b[5] = Kernel_ch2_for_task[k*4+1];
                mult_b[6] = Kernel_ch2_for_task[k*4+2];
                mult_b[7] = Kernel_ch2_for_task[k*4+3];
                #delay_time;
                add_a_ch1[0] = mult_out[0];
                add_b_ch1[0] = mult_out[1];
                add_a_ch1[1] = mult_out[2];
                add_b_ch1[1] = mult_out[3];
                add_a_ch1[3] = mult_out[0];
                add_b_ch1[3] = mult_out[2];
                add_a_ch1[4] = mult_out[1];
                add_b_ch1[4] = mult_out[3];
                add_a_ch1[5] = ofmap_ch1_for_task[i*6+j];   //i,j
                add_a_ch1[6] = ofmap_ch1_for_task[i*6+j+1]; //i,j+1
                add_a_ch1[7] = ofmap_ch1_for_task[(i+1)*6+j]; //i+1,j
                add_a_ch1[8] = ofmap_ch1_for_task[(i+1)*6+j+1]; //i+1,j+1



                add_a_ch2[0] = mult_out[4];
                add_b_ch2[0] = mult_out[5];
                add_a_ch2[1] = mult_out[6];
                add_b_ch2[1] = mult_out[7];
                
                add_a_ch2[3] = mult_out[4];
                add_b_ch2[3] = mult_out[6];
                add_a_ch2[4] = mult_out[5];
                add_b_ch2[4] = mult_out[7];
                add_a_ch2[5] = ofmap_ch2_for_task[i*6+j];   //i,j
                add_a_ch2[6] = ofmap_ch2_for_task[i*6+j+1]; //i,j+1
                add_a_ch2[7] = ofmap_ch2_for_task[(i+1)*6+j]; //i+1,j
                add_a_ch2[8] = ofmap_ch2_for_task[(i+1)*6+j+1]; //i+1,j+1

                #delay_time;
                add_a_ch1[2] = add_ch1_out[0];
                add_b_ch1[2] = add_ch1_out[1];
                add_a_ch2[2] = add_ch2_out[0];
                add_b_ch2[2] = add_ch2_out[1];
                #delay_time;
                if(Opt_for_task == 0) begin
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
                //// add to mem
                

                //////////////ch 2 //////////////
                
                
                if(Opt_for_task == 0) begin
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
                //// add to mem
                #delay_time;
                ofmap_ch1_for_task[i*6+j] = add_ch1_out[5];
                ofmap_ch1_for_task[i*6+j+1] = add_ch1_out[6];
                ofmap_ch1_for_task[(i+1)*6+j] = add_ch1_out[7];
                ofmap_ch1_for_task[(i+1)*6+j+1] =  add_ch1_out[8];


                ofmap_ch2_for_task[i*6+j] = add_ch2_out[5];
                ofmap_ch2_for_task[i*6+j+1] = add_ch2_out[6];
                ofmap_ch2_for_task[(i+1)*6+j] = add_ch2_out[7];
                ofmap_ch2_for_task[(i+1)*6+j+1] =  add_ch2_out[8];
                ////////////////////////////////
                 #delay_time;
            end
        end
    end
end endtask



task max_pool; begin
    for(i = 0; i < 6; i++) begin
        for(j = 0; j < 6; j++) begin
            cmp_a_ch1 = ofmap_ch1_for_task[i*6+j];
            cmp_a_ch2 = ofmap_ch2_for_task[i*6+j];
            if((i == 0|| i == 3)&&(j == 0|| j == 3)) begin
                cmp_b_ch1 = ofmap_ch1_for_task[i*6+j];
                cmp_b_ch2 = ofmap_ch2_for_task[i*6+j];
            end
            else if(i < 3 && j < 3) begin
                cmp_b_ch1 = max_pool_ch1_for_task[0];
                cmp_b_ch2 = max_pool_ch2_for_task[0];
            end
            else if(i < 3 && j >= 3) begin
                cmp_b_ch1 = max_pool_ch1_for_task[1];
                cmp_b_ch2 = max_pool_ch2_for_task[1];
            end
            else if(i >= 3 && j < 3) begin
                cmp_b_ch1 = max_pool_ch1_for_task[2];
                cmp_b_ch2 = max_pool_ch2_for_task[2];
            end
            else  begin
                cmp_b_ch1 = max_pool_ch1_for_task[3];
                cmp_b_ch2 = max_pool_ch2_for_task[3];
            end
            #delay_time;
            
            if(i < 3 && j < 3) begin
                max_pool_ch1_for_task[0] = cmp_out_ch1;
                max_pool_ch2_for_task[0] = cmp_out_ch2;
            end
            else if(i < 3 && j >= 3) begin
                max_pool_ch1_for_task[1]= cmp_out_ch1;
                max_pool_ch2_for_task[1]= cmp_out_ch2;
            end
            else if(i >= 3 && j < 3) begin
                max_pool_ch1_for_task[2]= cmp_out_ch1;
                max_pool_ch2_for_task[2]= cmp_out_ch2;
            end
            else  begin
                max_pool_ch1_for_task[3]= cmp_out_ch1;
                max_pool_ch2_for_task[3]= cmp_out_ch2;
            end
            #delay_time;
        end
    end
        
end endtask





task Act; begin
    for(i = 0; i < 4; i++) begin
        z = max_pool_ch1_for_task[i];
        act_add_b[0] = 32'h3f800000;
        act_add_b[1] = 32'hbf800000;
        
        if(Opt_for_task == 0) begin //sigmoid
            z[31] = z[31]^1'b1;
            #delay_time;
            act_exp_in[0] = z;
            #delay_time;
            act_add_a[0] = act_exp_out[0];
            act_add_a[1] = act_exp_out[0];
            #delay_time;
            act_ln_in[1] = act_add_out[1];
            act_ln_in[0] = act_add_out[0];
            #delay_time;
            act_addsub_a = 32'd0;
            act_addsub_b = act_ln_out[0];
            #delay_time;
            act_exp_in[1] = act_addsub_out;
            #delay_time;
        end
        else begin
            z[30:23] = z[30:23]+1;
            #delay_time;
            act_exp_in[0] = z;
            #delay_time;
            act_add_a[0] = act_exp_out[0];
            act_add_a[1] = act_exp_out[0];
            #delay_time;
            act_add_2_out = {act_add_out[1][31]^act_add_out[1][31], act_add_out[1][30:0]};
            act_ln_in[1] = act_add_2_out;
            act_ln_in[0] = act_add_out[0];
            #delay_time;
            act_addsub_a = act_ln_out[1];
            act_addsub_b = act_ln_out[0];
            #delay_time;
            act_exp_in[1] = act_addsub_out;
            #delay_time;
        end
        if(Opt_for_task == 0) act_ch1_for_task[i] = act_exp_out[1];
        else act_ch1_for_task[i] = {act_add_out[1][31]^act_exp_out[1][31], act_exp_out[1][30:0]};
        #delay_time;
    end  
    for(i = 0; i < 4; i++) begin
        z = max_pool_ch2_for_task[i];
        act_add_b[0] = 32'h3f800000;
        act_add_b[1] = 32'hbf800000;
        
        if(Opt_for_task == 0) begin //sigmoid
            z[31] = z[31]^1'b1;
            #delay_time;
            act_exp_in[0] = z;
            #delay_time;
            act_add_a[0] = act_exp_out[0];
            act_add_a[1] = act_exp_out[0];
            #delay_time;
            act_ln_in[1] = act_add_out[1];
            act_ln_in[0] = act_add_out[0];
            #delay_time;
            act_addsub_a = 32'd0;
            act_addsub_b = act_ln_out[0];
            #delay_time;
            act_exp_in[1] = act_addsub_out;
            #delay_time;
        end
        else begin
            z[30:23] = z[30:23]+1;
            #delay_time;
            act_exp_in[0] = z;
            #delay_time;
            act_add_a[0] = act_exp_out[0];
            act_add_a[1] = act_exp_out[0];
            #delay_time;
            act_add_2_out = {act_add_out[1][31]^act_add_out[1][31], act_add_out[1][30:0]};
            act_ln_in[1] = act_add_2_out;
            act_ln_in[0] = act_add_out[0];
            #delay_time;
            act_addsub_a = act_ln_out[1];
            act_addsub_b = act_ln_out[0];
            #delay_time;
            act_exp_in[1] = act_addsub_out;
            #delay_time;
        end
        if(Opt_for_task == 0) act_ch2_for_task[i] = act_exp_out[1];
        else act_ch2_for_task[i] = {act_add_out[1][31]^act_exp_out[1][31], act_exp_out[1][30:0]};
        
        #delay_time;
    end 
end endtask

task fc; begin
    for(i = 0; i <8; i++) begin
        mac_a[0] = x[i];
        mac_a[1] = x[i];
        mac_a[2] = x[i];
        mac_b[0] = Weight_for_task[i];
        mac_b[1] = Weight_for_task[i+8];
        mac_b[2] = Weight_for_task[i+16];
        mac_c[0] = fc_for_task[0];
        mac_c[1] = fc_for_task[1];
        mac_c[2] = fc_for_task[2];
        #delay_time;
        fc_for_task[0] = mac_out[0];
        fc_for_task[1] = mac_out[1];
        fc_for_task[2] = mac_out[2];
        #delay_time;
    end   
end endtask


task softmax; begin
    soft_exp_in[0] = fc_for_task[0];
    soft_exp_in[1] = fc_for_task[1];
    soft_exp_in[2] = fc_for_task[2];
    #delay_time;
    soft_add_a[0] = soft_exp_out[0];
    soft_add_b[0] = soft_exp_out[1];
    #delay_time;
    soft_add_a[1] = soft_add_out[0];
    soft_add_b[1] = soft_exp_out[2];
    #delay_time;
    soft_ln_in = soft_add_out[1];
    #delay_time;
    denominator = soft_ln_out;
    #delay_time;

    for(i = 0; i < 3; i++) begin
        soft_addsub_a = fc_for_task[i];
        soft_addsub_b = denominator;
        #delay_time;
        soft_exp_in[3] = soft_addsub_out;
        #delay_time;
        softmax_for_task[i] = soft_exp_out[3];
        #delay_time;
    end

end endtask

task golden_task; begin

     $fdisplay(f_out, "%d", i_pat);
    for(i = 0; i < 3; i++) begin
        $fdisplay(f_out, "%h", softmax_for_task[i]);
        #delay_time;
    end
     $fdisplay(f_out, "\n");

end endtask

endmodule

module ieee754_to_float (
    input [31:0] ieee754,  // IEEE 754 32-bit 浮點數表示
    output reg sign,       // 符號位
    output reg [7:0] exponent,  // 指數部分
    output reg [23:0] mantissa, // 尾數部分（含隱含位1）
    output real result     // 最終浮點數值
    );

    // 將輸入的 IEEE 754 浮點數拆解
    always @(*) begin
        // 符號位
        sign = ieee754[31];
        // 指數部分
        exponent = ieee754[30:23];
        // 尾數部分，加上隱含的1
        mantissa = {1'b1, ieee754[22:0]};

        // 計算浮點數結果
        if (exponent == 8'h00 && ieee754[22:0] == 23'h000000) begin
            // 特殊情況：零
            result = 0.0;
        end  else begin
            // 正常情況：計算實際數值
            result = ((sign == 1) ? -1.0 : 1.0) * 
                     (mantissa / (2.0**23)) * 
                     (2.0**$signed(exponent - 8'd127));
        end
    end
endmodule



