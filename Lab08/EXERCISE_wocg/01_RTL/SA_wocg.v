/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: SA
// FILE NAME: SA_wocg.v
// VERSRION: 1.0
// DATE: Nov 06, 2024
// AUTHOR: Yen-Ning Tung, NYCU AIG
// CODE TYPE: RTL or Behavioral Level (Verilog)
// DESCRIPTION: 2024 Spring IC Lab / Exersise Lab08 / SA_wocg
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/

module SA(
	// Input signals
	clk,
	rst_n,
	in_valid,
	T,
	in_data,
	w_Q,
	w_K,
	w_V,
	// Output signals
	out_valid,
	out_data
);

input clk;
input rst_n;
input in_valid;
input [3:0] T;
input signed [7:0] in_data;
input signed [7:0] w_Q;
input signed [7:0] w_K;
input signed [7:0] w_V;

output reg out_valid;
output reg signed [63:0] out_data;

//==============================================//
//       parameter & integer declaration        //
//==============================================//

parameter IDLE = 3'd0;
parameter READ_Q = 3'd2;
parameter READ_K = 3'd6;
parameter READ_V = 3'd4;
parameter AAA = 3'd5;
parameter DONE = 3'd1;

integer i;

//==============================================//
//           reg & wire declaration             //
//==============================================//
reg signed [7:0] data_in [0:63];
reg signed [7:0] w_in [0:63];
reg signed [18:0] xW [0:63];
reg signed [40:0] QK_T [0:63];

reg signed [40:0] MA0_in_a [0:7];
reg signed [18:0] MA0_in_b [0:7];
reg signed [18:0] MA1_in_a [0:7];
reg signed [18:0] MA1_in_b [0:7];
reg signed [18:0] MA2_in_a [0:7];
reg signed [18:0] MA2_in_b [0:7];
reg signed [18:0] MA3_in_a [0:7];
reg signed [18:0] MA3_in_b [0:7];
reg signed [18:0] MA4_in_a [0:7];
reg signed [18:0] MA4_in_b [0:7];
reg signed [18:0] MA5_in_a [0:7];
reg signed [18:0] MA5_in_b [0:7];
reg signed [18:0] MA6_in_a [0:7];
reg signed [18:0] MA6_in_b [0:7];
reg signed [18:0] MA7_in_a [0:7];
reg signed [18:0] MA7_in_b [0:7];

wire signed [62:0] MA0_result;
wire signed [40:0] MA_result [0:6];

reg signed [40:0] DR0_in;
wire signed [40:0] DR0_out;

reg [2:0] State , nextState;
reg [5:0] t, T_in;
reg signed [62:0] out_ff;

reg [7:0] MA0_in_8 [0:15];


reg [18:0] MA0_in_19 [0:15];


reg [40:0] MA0_in_41 [0:7];


//==============================================//
//                  design                      //
//==============================================//

///// State////

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		State <= IDLE;
	end
	else begin
		State <= nextState;
	end 
end

always@(*)begin
	case(State)
		IDLE: begin
			if(in_valid) nextState = READ_Q;
			else nextState = State;
		end
		READ_Q: begin
			if(t == 63) nextState = READ_K;
			else nextState = State;
		end
		READ_K: begin
			if(t == 63) nextState = READ_V;
			else nextState = State;
		end
		READ_V: begin
			if(t == 63) nextState = AAA;
			else nextState = State;
		end
		AAA:begin
			nextState = DONE;
		end
		DONE: begin
			if(t == T_in) nextState = IDLE;
			else nextState = State;
		end
		default : begin
			nextState = State;
		end
	endcase
end


//////////////

///// in out /////

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 64 ; i++) begin
			data_in[i] <= 0; 
		end
	end
	else if(State == IDLE || State == READ_Q) begin
		if(in_valid && t <= T_in) data_in[t] <= in_data;
		else data_in[t] <= 0; 
	end
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 64 ; i++) begin
			w_in[i] <= 0; 
		end
	end
	else if(in_valid) begin
		if(State == IDLE || State == READ_Q) w_in[t] <= w_Q;
		else if(State == READ_K) w_in[t] <= w_K;
		else if(State == READ_V) w_in[t] <= w_V;
	end
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		T_in <= 0;
	end
	else if(in_valid && State == IDLE) begin
		if(T[3]) T_in <= 63;
		else if(T[2]) T_in <= 31;
		else if(T[0]) T_in <= 7;
	end
end

always@(*) begin
	if(!rst_n) begin
		out_data = 0;
	end
	else if(State == DONE) begin
		out_data = {out_ff[62],out_ff};
	end
	else out_data = 0;
end

always@(*) begin
	if(!rst_n) begin
		out_valid = 0;
	end
	else if(State == DONE) begin
		out_valid = 1;
	end
	else out_valid = 0;
end

/////////////////

/////// module /////////

MA_41 MA0 (
    .M1_1(MA0_in_a[0]), .M1_2(MA0_in_a[1]), .M1_3(MA0_in_a[2]), .M1_4(MA0_in_a[3]),
    .M1_5(MA0_in_a[4]), .M1_6(MA0_in_a[5]), .M1_7(MA0_in_a[6]), .M1_8(MA0_in_a[7]),
    .M2_1(MA0_in_b[0]), .M2_2(MA0_in_b[1]), .M2_3(MA0_in_b[2]), .M2_4(MA0_in_b[3]),
    .M2_5(MA0_in_b[4]), .M2_6(MA0_in_b[5]), .M2_7(MA0_in_b[6]), .M2_8(MA0_in_b[7]),
    .result(MA0_result)
);

MA_19 MA1 (
    .M1_1(MA1_in_a[0]), .M1_2(MA1_in_a[1]), .M1_3(MA1_in_a[2]), .M1_4(MA1_in_a[3]),
    .M1_5(MA1_in_a[4]), .M1_6(MA1_in_a[5]), .M1_7(MA1_in_a[6]), .M1_8(MA1_in_a[7]),
    .M2_1(MA1_in_b[0]), .M2_2(MA1_in_b[1]), .M2_3(MA1_in_b[2]), .M2_4(MA1_in_b[3]),
    .M2_5(MA1_in_b[4]), .M2_6(MA1_in_b[5]), .M2_7(MA1_in_b[6]), .M2_8(MA1_in_b[7]),
    .result(MA_result[0])
);

MA_19 MA2 (
    .M1_1(MA2_in_a[0]), .M1_2(MA2_in_a[1]), .M1_3(MA2_in_a[2]), .M1_4(MA2_in_a[3]),
    .M1_5(MA2_in_a[4]), .M1_6(MA2_in_a[5]), .M1_7(MA2_in_a[6]), .M1_8(MA2_in_a[7]),
    .M2_1(MA2_in_b[0]), .M2_2(MA2_in_b[1]), .M2_3(MA2_in_b[2]), .M2_4(MA2_in_b[3]),
    .M2_5(MA2_in_b[4]), .M2_6(MA2_in_b[5]), .M2_7(MA2_in_b[6]), .M2_8(MA2_in_b[7]),
    .result(MA_result[1])
);

MA_19 MA3 (
    .M1_1(MA3_in_a[0]), .M1_2(MA3_in_a[1]), .M1_3(MA3_in_a[2]), .M1_4(MA3_in_a[3]),
    .M1_5(MA3_in_a[4]), .M1_6(MA3_in_a[5]), .M1_7(MA3_in_a[6]), .M1_8(MA3_in_a[7]),
    .M2_1(MA3_in_b[0]), .M2_2(MA3_in_b[1]), .M2_3(MA3_in_b[2]), .M2_4(MA3_in_b[3]),
    .M2_5(MA3_in_b[4]), .M2_6(MA3_in_b[5]), .M2_7(MA3_in_b[6]), .M2_8(MA3_in_b[7]),
    .result(MA_result[2])
);

MA_19 MA4 (
    .M1_1(MA4_in_a[0]), .M1_2(MA4_in_a[1]), .M1_3(MA4_in_a[2]), .M1_4(MA4_in_a[3]),
    .M1_5(MA4_in_a[4]), .M1_6(MA4_in_a[5]), .M1_7(MA4_in_a[6]), .M1_8(MA4_in_a[7]),
    .M2_1(MA4_in_b[0]), .M2_2(MA4_in_b[1]), .M2_3(MA4_in_b[2]), .M2_4(MA4_in_b[3]),
    .M2_5(MA4_in_b[4]), .M2_6(MA4_in_b[5]), .M2_7(MA4_in_b[6]), .M2_8(MA4_in_b[7]),
    .result(MA_result[3])
);

MA_19 MA5 (
    .M1_1(MA5_in_a[0]), .M1_2(MA5_in_a[1]), .M1_3(MA5_in_a[2]), .M1_4(MA5_in_a[3]),
    .M1_5(MA5_in_a[4]), .M1_6(MA5_in_a[5]), .M1_7(MA5_in_a[6]), .M1_8(MA5_in_a[7]),
    .M2_1(MA5_in_b[0]), .M2_2(MA5_in_b[1]), .M2_3(MA5_in_b[2]), .M2_4(MA5_in_b[3]),
    .M2_5(MA5_in_b[4]), .M2_6(MA5_in_b[5]), .M2_7(MA5_in_b[6]), .M2_8(MA5_in_b[7]),
    .result(MA_result[4])
);

MA_19 MA6 (
    .M1_1(MA6_in_a[0]), .M1_2(MA6_in_a[1]), .M1_3(MA6_in_a[2]), .M1_4(MA6_in_a[3]),
    .M1_5(MA6_in_a[4]), .M1_6(MA6_in_a[5]), .M1_7(MA6_in_a[6]), .M1_8(MA6_in_a[7]),
    .M2_1(MA6_in_b[0]), .M2_2(MA6_in_b[1]), .M2_3(MA6_in_b[2]), .M2_4(MA6_in_b[3]),
    .M2_5(MA6_in_b[4]), .M2_6(MA6_in_b[5]), .M2_7(MA6_in_b[6]), .M2_8(MA6_in_b[7]),
    .result(MA_result[5])
);

MA_19 MA7 (
    .M1_1(MA7_in_a[0]), .M1_2(MA7_in_a[1]), .M1_3(MA7_in_a[2]), .M1_4(MA7_in_a[3]),
    .M1_5(MA7_in_a[4]), .M1_6(MA7_in_a[5]), .M1_7(MA7_in_a[6]), .M1_8(MA7_in_a[7]),
    .M2_1(MA7_in_b[0]), .M2_2(MA7_in_b[1]), .M2_3(MA7_in_b[2]), .M2_4(MA7_in_b[3]),
    .M2_5(MA7_in_b[4]), .M2_6(MA7_in_b[5]), .M2_7(MA7_in_b[6]), .M2_8(MA7_in_b[7]),
    .result(MA_result[6])
);

DIV_RELU DR0(
	.in(DR0_in),

	.result(DR0_out)
);

///////////////////////



always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_ff <= 0;
	end
	else if(State == READ_V || State ==DONE)begin
		out_ff <= {MA0_result[62], MA0_result};
	end 
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		t <= 0;
	end
	else if(State == IDLE) begin
		if(in_valid) t <= t+1;
		else t <= 0;
	end
	else if(!(State==AAA))begin
		t <= t+1;
	end 
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 64 ; i++) begin
			xW[i] <= 0; 
		end
	end
	else if(State == READ_K) begin
		case(t)
			0: begin
				xW[0] <= MA0_result;
				xW[8] <= MA_result[0];
				xW[16] <= MA_result[1];
				xW[24] <= MA_result[2];
				xW[32] <= MA_result[3];
				xW[40] <= MA_result[4];
				xW[48] <= MA_result[5];
				xW[56] <= MA_result[6];
			end
			1: begin
				xW[1] <= MA0_result;
				xW[9] <= MA_result[0];
				xW[17] <= MA_result[1];
				xW[25] <= MA_result[2];
				xW[33] <= MA_result[3];
				xW[41] <= MA_result[4];
				xW[49] <= MA_result[5];
				xW[57] <= MA_result[6];
			end
			2: begin
				xW[2] <= MA0_result;
				xW[10] <= MA_result[0];
				xW[18] <= MA_result[1];
				xW[26] <= MA_result[2];
				xW[34] <= MA_result[3];
				xW[42] <= MA_result[4];
				xW[50] <= MA_result[5];
				xW[58] <= MA_result[6];
			end
			3: begin
				xW[3] <= MA0_result;
				xW[11] <= MA_result[0];
				xW[19] <= MA_result[1];
				xW[27] <= MA_result[2];
				xW[35] <= MA_result[3];
				xW[43] <= MA_result[4];
				xW[51] <= MA_result[5];
				xW[59] <= MA_result[6];
			end
			4: begin
				xW[4] <= MA0_result;
				xW[12] <= MA_result[0];
				xW[20] <= MA_result[1];
				xW[28] <= MA_result[2];
				xW[36] <= MA_result[3];
				xW[44] <= MA_result[4];
				xW[52] <= MA_result[5];
				xW[60] <= MA_result[6];
			end
			5: begin
				xW[5] <= MA0_result;
				xW[13] <= MA_result[0];
				xW[21] <= MA_result[1];
				xW[29] <= MA_result[2];
				xW[37] <= MA_result[3];
				xW[45] <= MA_result[4];
				xW[53] <= MA_result[5];
				xW[61] <= MA_result[6];
			end
			6: begin
				xW[6] <= MA0_result;
				xW[14] <= MA_result[0];
				xW[22] <= MA_result[1];
				xW[30] <= MA_result[2];
				xW[38] <= MA_result[3];
				xW[46] <= MA_result[4];
				xW[54] <= MA_result[5];
				xW[62] <= MA_result[6];
			end
			7: begin
				xW[7] <= MA0_result;
				xW[15] <= MA_result[0];
				xW[23] <= MA_result[1];
				xW[31] <= MA_result[2];
				xW[39] <= MA_result[3];
				xW[47] <= MA_result[4];
				xW[55] <= MA_result[5];
				xW[63] <= MA_result[6];
			end
		endcase
	end
	else if(State == READ_V) begin
		case(t)
			57: begin
				xW[0] <= MA0_result;
				xW[8] <= MA_result[0];
				xW[16] <= MA_result[1];
				xW[24] <= MA_result[2];
				xW[32] <= MA_result[3];
				xW[40] <= MA_result[4];
				xW[48] <= MA_result[5];
				xW[56] <= MA_result[6];
			end
			58: begin
				xW[1] <= MA0_result;
				xW[9] <= MA_result[0];
				xW[17] <= MA_result[1];
				xW[25] <= MA_result[2];
				xW[33] <= MA_result[3];
				xW[41] <= MA_result[4];
				xW[49] <= MA_result[5];
				xW[57] <= MA_result[6];
			end
			59: begin
				xW[2] <= MA0_result;
				xW[10] <= MA_result[0];
				xW[18] <= MA_result[1];
				xW[26] <= MA_result[2];
				xW[34] <= MA_result[3];
				xW[42] <= MA_result[4];
				xW[50] <= MA_result[5];
				xW[58] <= MA_result[6];
			end
			60: begin
				xW[3] <= MA0_result;
				xW[11] <= MA_result[0];
				xW[19] <= MA_result[1];
				xW[27] <= MA_result[2];
				xW[35] <= MA_result[3];
				xW[43] <= MA_result[4];
				xW[51] <= MA_result[5];
				xW[59] <= MA_result[6];
			end
			61: begin
				xW[4] <= MA0_result;
				xW[12] <= MA_result[0];
				xW[20] <= MA_result[1];
				xW[28] <= MA_result[2];
				xW[36] <= MA_result[3];
				xW[44] <= MA_result[4];
				xW[52] <= MA_result[5];
				xW[60] <= MA_result[6];
			end
			62: begin
				xW[5] <= MA0_result;
				xW[13] <= MA_result[0];
				xW[21] <= MA_result[1];
				xW[29] <= MA_result[2];
				xW[37] <= MA_result[3];
				xW[45] <= MA_result[4];
				xW[53] <= MA_result[5];
				xW[61] <= MA_result[6];
			end
			63: begin
				xW[6 ] <= MA_result[0];
				xW[14] <= MA_result[1];
				xW[22] <= MA_result[2];
				xW[30] <= MA_result[3];
				xW[38] <= MA_result[4];
				xW[46] <= MA_result[5];
				xW[54] <= MA_result[6];
			end
		endcase
	end
	else if(State == DONE) begin
		if(t==0) begin
			xW[62] <= MA_result[0];
			xW[7 ] <= MA_result[1];
			xW[15] <= MA_result[2];
			xW[23] <= MA_result[3];
			xW[31] <= MA_result[4];
			xW[39] <= MA_result[5];
			xW[47] <= MA_result[6];
		end
		else if(t==1) begin
			xW[55] <= MA_result[0];
			xW[63] <= MA_result[1];
		end
	end
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 64 ; i++) begin
			QK_T[i] <= 0; 
		end
	end
	else if(State == READ_K) begin
		case(t)
			57: begin
				QK_T[0] <= MA0_result;
				QK_T[1] <= MA_result[0];
				QK_T[2] <= MA_result[1];
				QK_T[3] <= MA_result[2];
				QK_T[4] <= MA_result[3];
				QK_T[5] <= MA_result[4];
				QK_T[6] <= MA_result[5];
				QK_T[7] <= MA_result[6];
			end
			58: begin
				QK_T[8] <= MA0_result;
				QK_T[9] <= MA_result[0];
				QK_T[10] <= MA_result[1];
				QK_T[11] <= MA_result[2];
				QK_T[12] <= MA_result[3];
				QK_T[13] <= MA_result[4];
				QK_T[14] <= MA_result[5];
				QK_T[15] <= MA_result[6];
			end
			59: begin
				QK_T[16] <= MA0_result;
				QK_T[17] <= MA_result[0];
				QK_T[18] <= MA_result[1];
				QK_T[19] <= MA_result[2];
				QK_T[20] <= MA_result[3];
				QK_T[21] <= MA_result[4];
				QK_T[22] <= MA_result[5];
				QK_T[23] <= MA_result[6];
			end
			60: begin
				QK_T[24] <= MA0_result;
				QK_T[25] <= MA_result[0];
				QK_T[26] <= MA_result[1];
				QK_T[27] <= MA_result[2];
				QK_T[28] <= MA_result[3];
				QK_T[29] <= MA_result[4];
				QK_T[30] <= MA_result[5];
				QK_T[31] <= MA_result[6];
			end
			61: begin
				QK_T[32] <= MA0_result;
				QK_T[33] <= MA_result[0];
				QK_T[34] <= MA_result[1];
				QK_T[35] <= MA_result[2];
				QK_T[36] <= MA_result[3];
				QK_T[37] <= MA_result[4];
				QK_T[38] <= MA_result[5];
				QK_T[39] <= MA_result[6];
			end
			62: begin
				QK_T[40] <= MA0_result;
				QK_T[41] <= MA_result[0];
				QK_T[42] <= MA_result[1];
				QK_T[43] <= MA_result[2];
				QK_T[44] <= MA_result[3];
				QK_T[45] <= MA_result[4];
				QK_T[46] <= MA_result[5];
				QK_T[47] <= MA_result[6];
			end
			63: begin
				QK_T[48] <= MA0_result;
				QK_T[49] <= MA_result[0];
				QK_T[50] <= MA_result[1];
				QK_T[51] <= MA_result[2];
				QK_T[52] <= MA_result[3];
				QK_T[53] <= MA_result[4];
				QK_T[54] <= MA_result[5];
				QK_T[55] <= MA_result[6];
			end
			
		endcase

	end
	else if(State == READ_V) begin
		case(t)
			0: begin
				QK_T[56] <= MA0_result;
				QK_T[57] <= MA_result[0];
				QK_T[58] <= MA_result[1];
				QK_T[59] <= MA_result[2];
				QK_T[60] <= MA_result[3];
				QK_T[61] <= MA_result[4];
				QK_T[62] <= MA_result[5];
				QK_T[63] <= MA_result[6];
			end
			1: begin
				QK_T[0] <= MA0_result;
				QK_T[8] <= MA_result[0];
				QK_T[16] <= MA_result[1];
				QK_T[24] <= MA_result[2];
				QK_T[32] <= MA_result[3];
				QK_T[40] <= MA_result[4];
				QK_T[48] <= MA_result[5];
				QK_T[56] <= MA_result[6];
			end
			2: begin
				QK_T[1] <= MA0_result;
				QK_T[9] <= MA_result[0];
				QK_T[17] <= MA_result[1];
				QK_T[25] <= MA_result[2];
				QK_T[33] <= MA_result[3];
				QK_T[41] <= MA_result[4];
				QK_T[49] <= MA_result[5];
				QK_T[57] <= MA_result[6];
			end
			3: begin
				QK_T[2] <= MA0_result;
				QK_T[10] <= MA_result[0];
				QK_T[18] <= MA_result[1];
				QK_T[26] <= MA_result[2];
				QK_T[34] <= MA_result[3];
				QK_T[42] <= MA_result[4];
				QK_T[50] <= MA_result[5];
				QK_T[58] <= MA_result[6];
			end
			4: begin
				QK_T[3] <= MA0_result;
				QK_T[11] <= MA_result[0];
				QK_T[19] <= MA_result[1];
				QK_T[27] <= MA_result[2];
				QK_T[35] <= MA_result[3];
				QK_T[43] <= MA_result[4];
				QK_T[51] <= MA_result[5];
				QK_T[59] <= MA_result[6];
			end
			5: begin
				QK_T[4] <= MA0_result;
				QK_T[12] <= MA_result[0];
				QK_T[20] <= MA_result[1];
				QK_T[28] <= MA_result[2];
				QK_T[36] <= MA_result[3];
				QK_T[44] <= MA_result[4];
				QK_T[52] <= MA_result[5];
				QK_T[60] <= MA_result[6];
			end
			6: begin
				QK_T[5] <= MA0_result;
				QK_T[13] <= MA_result[0];
				QK_T[21] <= MA_result[1];
				QK_T[29] <= MA_result[2];
				QK_T[37] <= MA_result[3];
				QK_T[45] <= MA_result[4];
				QK_T[53] <= MA_result[5];
				QK_T[61] <= MA_result[6];
			end
			7: begin
				QK_T[6] <= MA0_result;
				QK_T[14] <= MA_result[0];
				QK_T[22] <= MA_result[1];
				QK_T[30] <= MA_result[2];
				QK_T[38] <= MA_result[3];
				QK_T[46] <= MA_result[4];
				QK_T[54] <= MA_result[5];
				QK_T[62] <= MA_result[6];
			end
			8: begin
				QK_T[7] <= MA0_result;
				QK_T[15] <= MA_result[0];
				QK_T[23] <= MA_result[1];
				QK_T[31] <= MA_result[2];
				QK_T[39] <= MA_result[3];
				QK_T[47] <= MA_result[4];
				QK_T[55] <= MA_result[5];
				QK_T[63] <= MA_result[6];
			end
		endcase
		case(t)
			// t = 2
			2: QK_T[0] <= DR0_out;

			// t = 3
			3: QK_T[1] <= DR0_out;

			// t = 4
			4: QK_T[2] <= DR0_out;

			// t = 5
			5: QK_T[3] <= DR0_out;

			// t = 6
			6: QK_T[4] <= DR0_out;

			// t = 7
			7: QK_T[5] <= DR0_out;

			// t = 8
			8: QK_T[6] <= DR0_out;

			// t = 9
			9: QK_T[7] <= DR0_out;

			// t = 10
			10: QK_T[8] <= DR0_out;

			// t = 11
			11: QK_T[9] <= DR0_out;

			// t = 12
			12: QK_T[10] <= DR0_out;

			// t = 13
			13: QK_T[11] <= DR0_out;

			// t = 14
			14: QK_T[12] <= DR0_out;

			// t = 15
			15: QK_T[13] <= DR0_out;

			// t = 16
			16: QK_T[14] <= DR0_out;

			// t = 17
			17: QK_T[15] <= DR0_out;

			// t = 18
			18: QK_T[16] <= DR0_out;

			// t = 19
			19: QK_T[17] <= DR0_out;

			// t = 20
			20: QK_T[18] <= DR0_out;

			// t = 21
			21: QK_T[19] <= DR0_out;

			// t = 22
			22: QK_T[20] <= DR0_out;

			// t = 23
			23: QK_T[21] <= DR0_out;

			// t = 24
			24: QK_T[22] <= DR0_out;

			// t = 25
			25: QK_T[23] <= DR0_out;

			// t = 26
			26: QK_T[24] <= DR0_out;

			// t = 27
			27: QK_T[25] <= DR0_out;

			// t = 28
			28: QK_T[26] <= DR0_out;

			// t = 29
			29: QK_T[27] <= DR0_out;

			// t = 30
			30: QK_T[28] <= DR0_out;

			// t = 31
			31: QK_T[29] <= DR0_out;

			// t = 32
			32: QK_T[30] <= DR0_out;

			// t = 33
			33: QK_T[31] <= DR0_out;

			// t = 34
			34: QK_T[32] <= DR0_out;

			// t = 35
			35: QK_T[33] <= DR0_out;

			// t = 36
			36: QK_T[34] <= DR0_out;

			// t = 37
			37: QK_T[35] <= DR0_out;

			// t = 38
			38: QK_T[36] <= DR0_out;

			// t = 39
			39: QK_T[37] <= DR0_out;

			// t = 40
			40: QK_T[38] <= DR0_out;

			// t = 41
			41: QK_T[39] <= DR0_out;

			// t = 42
			42: QK_T[40] <= DR0_out;

			// t = 43
			43: QK_T[41] <= DR0_out;

			// t = 44
			44: QK_T[42] <= DR0_out;

			// t = 45
			45: QK_T[43] <= DR0_out;

			// t = 46
			46: QK_T[44] <= DR0_out;

			// t = 47
			47: QK_T[45] <= DR0_out;

			// t = 48
			48: QK_T[46] <= DR0_out;

			// t = 49
			49: QK_T[47] <= DR0_out;

			// t = 50
			50: QK_T[48] <= DR0_out;

			// t = 51
			51: QK_T[49] <= DR0_out;

			// t = 52
			52: QK_T[50] <= DR0_out;

			// t = 53
			53: QK_T[51] <= DR0_out;

			// t = 54
			54: QK_T[52] <= DR0_out;

			// t = 55
			55: QK_T[53] <= DR0_out;

			// t = 56
			56: QK_T[54] <= DR0_out;

			// t = 57
			57: QK_T[55] <= DR0_out;

			// t = 58
			58: QK_T[56] <= DR0_out;

			// t = 59
			59: QK_T[57] <= DR0_out;

			// t = 60
			60: QK_T[58] <= DR0_out;

			// t = 61
			61: QK_T[59] <= DR0_out;

			// t = 62
			62: QK_T[60] <= DR0_out;

			// t = 63
			63: QK_T[61] <= DR0_out;
		endcase
	end
	else if(State == DONE) begin
		if(t == 0) QK_T[62] <= DR0_out;
		else if(t == 1)QK_T[63] <= DR0_out;
	end
end


always@(*) begin  //MA1
	case(State)
		READ_K: begin
			case(t)
				0,57: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA1_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA1_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA1_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA1_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA1_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA1_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA1_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				1,58: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA1_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA1_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA1_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA1_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA1_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA1_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA1_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				2,59: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA1_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA1_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA1_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA1_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA1_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA1_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA1_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				3,60: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA1_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA1_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA1_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA1_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA1_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA1_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA1_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				4,61: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA1_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA1_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA1_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA1_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA1_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA1_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA1_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				5,62: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA1_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA1_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA1_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA1_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA1_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA1_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA1_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				6,63: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA1_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA1_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA1_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA1_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA1_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA1_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA1_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end
				7: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA1_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA1_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA1_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA1_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA1_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA1_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA1_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end

				default: begin
					MA1_in_a[0] = 0;
					MA1_in_a[1] = 0;
					MA1_in_a[2] = 0;
					MA1_in_a[3] = 0;
					MA1_in_a[4] = 0;
					MA1_in_a[5] = 0;
					MA1_in_a[6] = 0;
					MA1_in_a[7] = 0;
					MA1_in_b[0] = 0;
					MA1_in_b[1] = 0;
					MA1_in_b[2] = 0;
					MA1_in_b[3] = 0;
					MA1_in_b[4] = 0;
					MA1_in_b[5] = 0;
					MA1_in_b[6] = 0;
					MA1_in_b[7] = 0;
				end
			endcase
		end
		READ_V: begin
			case(t)
				0: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA1_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA1_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA1_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA1_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA1_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA1_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA1_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				1: begin
					MA1_in_a[0] = xW[8];
					MA1_in_a[1] = xW[9];
					MA1_in_a[2] = xW[10];
					MA1_in_a[3] = xW[11];
					MA1_in_a[4] = xW[12];
					MA1_in_a[5] = xW[13];
					MA1_in_a[6] = xW[14];
					MA1_in_a[7] = xW[15];

					MA1_in_b[0] =  QK_T[0];
					MA1_in_b[1] =  QK_T[8];
					MA1_in_b[2] =  QK_T[16];
					MA1_in_b[3] =  QK_T[24];
					MA1_in_b[4] =  QK_T[32];
					MA1_in_b[5] =  QK_T[40];
					MA1_in_b[6] =  QK_T[48];
					MA1_in_b[7] =  QK_T[56];
				end
				2: begin
					MA1_in_a[0] = xW[8];
					MA1_in_a[1] = xW[9];
					MA1_in_a[2] = xW[10];
					MA1_in_a[3] = xW[11];
					MA1_in_a[4] = xW[12];
					MA1_in_a[5] = xW[13];
					MA1_in_a[6] = xW[14];
					MA1_in_a[7] = xW[15];

					MA1_in_b[0] =  QK_T[1];
					MA1_in_b[1] =  QK_T[9];
					MA1_in_b[2] =  QK_T[17];
					MA1_in_b[3] =  QK_T[25];
					MA1_in_b[4] =  QK_T[33];
					MA1_in_b[5] =  QK_T[41];
					MA1_in_b[6] =  QK_T[49];
					MA1_in_b[7] =  QK_T[57];
				end
				3: begin
					MA1_in_a[0] = xW[8];
					MA1_in_a[1] = xW[9];
					MA1_in_a[2] = xW[10];
					MA1_in_a[3] = xW[11];
					MA1_in_a[4] = xW[12];
					MA1_in_a[5] = xW[13];
					MA1_in_a[6] = xW[14];
					MA1_in_a[7] = xW[15];

					MA1_in_b[0] = QK_T[2];
					MA1_in_b[1] = QK_T[10];
					MA1_in_b[2] = QK_T[18];
					MA1_in_b[3] = QK_T[26];
					MA1_in_b[4] = QK_T[34];
					MA1_in_b[5] = QK_T[42];
					MA1_in_b[6] = QK_T[50];
					MA1_in_b[7] = QK_T[58];
				end

				4: begin
					MA1_in_a[0] = xW[8];
					MA1_in_a[1] = xW[9];
					MA1_in_a[2] = xW[10];
					MA1_in_a[3] = xW[11];
					MA1_in_a[4] = xW[12];
					MA1_in_a[5] = xW[13];
					MA1_in_a[6] = xW[14];
					MA1_in_a[7] = xW[15];

					MA1_in_b[0] = QK_T[3];
					MA1_in_b[1] = QK_T[11];
					MA1_in_b[2] = QK_T[19];
					MA1_in_b[3] = QK_T[27];
					MA1_in_b[4] = QK_T[35];
					MA1_in_b[5] = QK_T[43];
					MA1_in_b[6] = QK_T[51];
					MA1_in_b[7] = QK_T[59];
				end

				5: begin
					MA1_in_a[0] = xW[8];
					MA1_in_a[1] = xW[9];
					MA1_in_a[2] = xW[10];
					MA1_in_a[3] = xW[11];
					MA1_in_a[4] = xW[12];
					MA1_in_a[5] = xW[13];
					MA1_in_a[6] = xW[14];
					MA1_in_a[7] = xW[15];

					MA1_in_b[0] = QK_T[4];
					MA1_in_b[1] = QK_T[12];
					MA1_in_b[2] = QK_T[20];
					MA1_in_b[3] = QK_T[28];
					MA1_in_b[4] = QK_T[36];
					MA1_in_b[5] = QK_T[44];
					MA1_in_b[6] = QK_T[52];
					MA1_in_b[7] = QK_T[60];
				end

				6: begin
					MA1_in_a[0] = xW[8];
					MA1_in_a[1] = xW[9];
					MA1_in_a[2] = xW[10];
					MA1_in_a[3] = xW[11];
					MA1_in_a[4] = xW[12];
					MA1_in_a[5] = xW[13];
					MA1_in_a[6] = xW[14];
					MA1_in_a[7] = xW[15];

					MA1_in_b[0] = QK_T[5];
					MA1_in_b[1] = QK_T[13];
					MA1_in_b[2] = QK_T[21];
					MA1_in_b[3] = QK_T[29];
					MA1_in_b[4] = QK_T[37];
					MA1_in_b[5] = QK_T[45];
					MA1_in_b[6] = QK_T[53];
					MA1_in_b[7] = QK_T[61];
				end

				7: begin
					MA1_in_a[0] = xW[8];
					MA1_in_a[1] = xW[9];
					MA1_in_a[2] = xW[10];
					MA1_in_a[3] = xW[11];
					MA1_in_a[4] = xW[12];
					MA1_in_a[5] = xW[13];
					MA1_in_a[6] = xW[14];
					MA1_in_a[7] = xW[15];

					MA1_in_b[0] = QK_T[6];
					MA1_in_b[1] = QK_T[14];
					MA1_in_b[2] = QK_T[22];
					MA1_in_b[3] = QK_T[30];
					MA1_in_b[4] = QK_T[38];
					MA1_in_b[5] = QK_T[46];
					MA1_in_b[6] = QK_T[54];
					MA1_in_b[7] = QK_T[62];
				end

				8: begin
					MA1_in_a[0] = xW[8];
					MA1_in_a[1] = xW[9];
					MA1_in_a[2] = xW[10];
					MA1_in_a[3] = xW[11];
					MA1_in_a[4] = xW[12];
					MA1_in_a[5] = xW[13];
					MA1_in_a[6] = xW[14];
					MA1_in_a[7] = xW[15];

					MA1_in_b[0] = QK_T[7];
					MA1_in_b[1] = QK_T[15];
					MA1_in_b[2] = QK_T[23];
					MA1_in_b[3] = QK_T[31];
					MA1_in_b[4] = QK_T[39];
					MA1_in_b[5] = QK_T[47];
					MA1_in_b[6] = QK_T[55];
					MA1_in_b[7] = QK_T[63];
				end
				57: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA1_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA1_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA1_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA1_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA1_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA1_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA1_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				58: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA1_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA1_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA1_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA1_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA1_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA1_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA1_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				59: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA1_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA1_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA1_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA1_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA1_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA1_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA1_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				60: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA1_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA1_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA1_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA1_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA1_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA1_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA1_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				61: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA1_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA1_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA1_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA1_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA1_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA1_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA1_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				62: begin
					MA1_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA1_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA1_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA1_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA1_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA1_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA1_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA1_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA1_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA1_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA1_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA1_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA1_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA1_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA1_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA1_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				63: begin
					MA1_in_a[0] = {{11{data_in[0][7]}}, data_in[0]};
					MA1_in_a[1] = {{11{data_in[1][7]}}, data_in[1]};
					MA1_in_a[2] = {{11{data_in[2][7]}}, data_in[2]};
					MA1_in_a[3] = {{11{data_in[3][7]}}, data_in[3]};
					MA1_in_a[4] = {{11{data_in[4][7]}}, data_in[4]};
					MA1_in_a[5] = {{11{data_in[5][7]}}, data_in[5]};
					MA1_in_a[6] = {{11{data_in[6][7]}}, data_in[6]};
					MA1_in_a[7] = {{11{data_in[7][7]}}, data_in[7]};

					MA1_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA1_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA1_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA1_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA1_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA1_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA1_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA1_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end

				default: begin
					MA1_in_a[0] = 0;
					MA1_in_a[1] = 0;
					MA1_in_a[2] = 0;
					MA1_in_a[3] = 0;
					MA1_in_a[4] = 0;
					MA1_in_a[5] = 0;
					MA1_in_a[6] = 0;
					MA1_in_a[7] = 0;
					MA1_in_b[0] = 0;
					MA1_in_b[1] = 0;
					MA1_in_b[2] = 0;
					MA1_in_b[3] = 0;
					MA1_in_b[4] = 0;
					MA1_in_b[5] = 0;
					MA1_in_b[6] = 0;
					MA1_in_b[7] = 0;
				end
			endcase
		end
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		DONE: begin
			case(t)
				0: begin
					MA1_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA1_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA1_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA1_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA1_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA1_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA1_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA1_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA1_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA1_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA1_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA1_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA1_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA1_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA1_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA1_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end
				1: begin
					MA1_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA1_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA1_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA1_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA1_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA1_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA1_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA1_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA1_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA1_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA1_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA1_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA1_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA1_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA1_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA1_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				default: begin
					MA1_in_a[0] = 0;
					MA1_in_a[1] = 0;
					MA1_in_a[2] = 0;
					MA1_in_a[3] = 0;
					MA1_in_a[4] = 0;
					MA1_in_a[5] = 0;
					MA1_in_a[6] = 0;
					MA1_in_a[7] = 0;
					MA1_in_b[0] = 0;
					MA1_in_b[1] = 0;
					MA1_in_b[2] = 0;
					MA1_in_b[3] = 0;
					MA1_in_b[4] = 0;
					MA1_in_b[5] = 0;
					MA1_in_b[6] = 0;
					MA1_in_b[7] = 0;
				end
			endcase
		end
		default: begin
			MA1_in_a[0] = 0;
			MA1_in_a[1] = 0;
			MA1_in_a[2] = 0;
			MA1_in_a[3] = 0;
			MA1_in_a[4] = 0;
			MA1_in_a[5] = 0;
			MA1_in_a[6] = 0;
			MA1_in_a[7] = 0;
			MA1_in_b[0] = 0;
			MA1_in_b[1] = 0;
			MA1_in_b[2] = 0;
			MA1_in_b[3] = 0;
			MA1_in_b[4] = 0;
			MA1_in_b[5] = 0;
			MA1_in_b[6] = 0;
			MA1_in_b[7] = 0;
		end
	endcase
end

always@(*) begin  //MA2
	case(State)
		READ_K: begin
			case(t)
				0,57: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA2_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA2_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA2_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA2_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA2_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA2_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA2_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				1,58: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA2_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA2_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA2_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA2_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA2_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA2_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA2_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				2,59: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA2_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA2_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA2_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA2_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA2_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA2_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA2_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				3,60: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA2_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA2_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA2_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA2_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA2_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA2_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA2_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				4,61: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA2_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA2_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA2_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA2_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA2_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA2_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA2_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				5,62: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA2_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA2_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA2_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA2_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA2_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA2_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA2_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				6,63: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA2_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA2_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA2_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA2_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA2_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA2_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA2_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end
				7: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA2_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA2_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA2_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA2_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA2_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA2_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA2_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end

				default: begin
					MA2_in_a[0] = 0;
					MA2_in_a[1] = 0;
					MA2_in_a[2] = 0;
					MA2_in_a[3] = 0;
					MA2_in_a[4] = 0;
					MA2_in_a[5] = 0;
					MA2_in_a[6] = 0;
					MA2_in_a[7] = 0;
					MA2_in_b[0] = 0;
					MA2_in_b[1] = 0;
					MA2_in_b[2] = 0;
					MA2_in_b[3] = 0;
					MA2_in_b[4] = 0;
					MA2_in_b[5] = 0;
					MA2_in_b[6] = 0;
					MA2_in_b[7] = 0;
				end
			endcase
		end
		READ_V: begin
			case(t)
				0: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA2_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA2_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA2_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA2_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA2_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA2_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA2_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				1: begin
					MA2_in_a[0] = xW[16];
					MA2_in_a[1] = xW[17];
					MA2_in_a[2] = xW[18];
					MA2_in_a[3] = xW[19];
					MA2_in_a[4] = xW[20];
					MA2_in_a[5] = xW[21];
					MA2_in_a[6] = xW[22];
					MA2_in_a[7] = xW[23];

					MA2_in_b[0] =  QK_T[0];
					MA2_in_b[1] =  QK_T[8];
					MA2_in_b[2] =  QK_T[16];
					MA2_in_b[3] =  QK_T[24];
					MA2_in_b[4] =  QK_T[32];
					MA2_in_b[5] =  QK_T[40];
					MA2_in_b[6] =  QK_T[48];
					MA2_in_b[7] =  QK_T[56];
				end
				2: begin
					MA2_in_a[0] = xW[16];
					MA2_in_a[1] = xW[17];
					MA2_in_a[2] = xW[18];
					MA2_in_a[3] = xW[19];
					MA2_in_a[4] = xW[20];
					MA2_in_a[5] = xW[21];
					MA2_in_a[6] = xW[22];
					MA2_in_a[7] = xW[23];

					MA2_in_b[0] =  QK_T[1];
					MA2_in_b[1] =  QK_T[9];
					MA2_in_b[2] =  QK_T[17];
					MA2_in_b[3] =  QK_T[25];
					MA2_in_b[4] =  QK_T[33];
					MA2_in_b[5] =  QK_T[41];
					MA2_in_b[6] =  QK_T[49];
					MA2_in_b[7] =  QK_T[57];
				end
				3: begin
					MA2_in_a[0] = xW[16];
					MA2_in_a[1] = xW[17];
					MA2_in_a[2] = xW[18];
					MA2_in_a[3] = xW[19];
					MA2_in_a[4] = xW[20];
					MA2_in_a[5] = xW[21];
					MA2_in_a[6] = xW[22];
					MA2_in_a[7] = xW[23];

					MA2_in_b[0] = QK_T[2];
					MA2_in_b[1] = QK_T[10];
					MA2_in_b[2] = QK_T[18];
					MA2_in_b[3] = QK_T[26];
					MA2_in_b[4] = QK_T[34];
					MA2_in_b[5] = QK_T[42];
					MA2_in_b[6] = QK_T[50];
					MA2_in_b[7] = QK_T[58];
				end

				4: begin
					MA2_in_a[0] = xW[16];
					MA2_in_a[1] = xW[17];
					MA2_in_a[2] = xW[18];
					MA2_in_a[3] = xW[19];
					MA2_in_a[4] = xW[20];
					MA2_in_a[5] = xW[21];
					MA2_in_a[6] = xW[22];
					MA2_in_a[7] = xW[23];

					MA2_in_b[0] = QK_T[3];
					MA2_in_b[1] = QK_T[11];
					MA2_in_b[2] = QK_T[19];
					MA2_in_b[3] = QK_T[27];
					MA2_in_b[4] = QK_T[35];
					MA2_in_b[5] = QK_T[43];
					MA2_in_b[6] = QK_T[51];
					MA2_in_b[7] = QK_T[59];
				end

				5: begin
					MA2_in_a[0] = xW[16];
					MA2_in_a[1] = xW[17];
					MA2_in_a[2] = xW[18];
					MA2_in_a[3] = xW[19];
					MA2_in_a[4] = xW[20];
					MA2_in_a[5] = xW[21];
					MA2_in_a[6] = xW[22];
					MA2_in_a[7] = xW[23];

					MA2_in_b[0] = QK_T[4];
					MA2_in_b[1] = QK_T[12];
					MA2_in_b[2] = QK_T[20];
					MA2_in_b[3] = QK_T[28];
					MA2_in_b[4] = QK_T[36];
					MA2_in_b[5] = QK_T[44];
					MA2_in_b[6] = QK_T[52];
					MA2_in_b[7] = QK_T[60];
				end

				6: begin
					MA2_in_a[0] = xW[16];
					MA2_in_a[1] = xW[17];
					MA2_in_a[2] = xW[18];
					MA2_in_a[3] = xW[19];
					MA2_in_a[4] = xW[20];
					MA2_in_a[5] = xW[21];
					MA2_in_a[6] = xW[22];
					MA2_in_a[7] = xW[23];

					MA2_in_b[0] = QK_T[5];
					MA2_in_b[1] = QK_T[13];
					MA2_in_b[2] = QK_T[21];
					MA2_in_b[3] = QK_T[29];
					MA2_in_b[4] = QK_T[37];
					MA2_in_b[5] = QK_T[45];
					MA2_in_b[6] = QK_T[53];
					MA2_in_b[7] = QK_T[61];
				end

				7: begin
					MA2_in_a[0] = xW[16];
					MA2_in_a[1] = xW[17];
					MA2_in_a[2] = xW[18];
					MA2_in_a[3] = xW[19];
					MA2_in_a[4] = xW[20];
					MA2_in_a[5] = xW[21];
					MA2_in_a[6] = xW[22];
					MA2_in_a[7] = xW[23];

					MA2_in_b[0] = QK_T[6];
					MA2_in_b[1] = QK_T[14];
					MA2_in_b[2] = QK_T[22];
					MA2_in_b[3] = QK_T[30];
					MA2_in_b[4] = QK_T[38];
					MA2_in_b[5] = QK_T[46];
					MA2_in_b[6] = QK_T[54];
					MA2_in_b[7] = QK_T[62];
				end

				8: begin
					MA2_in_a[0] = xW[16];
					MA2_in_a[1] = xW[17];
					MA2_in_a[2] = xW[18];
					MA2_in_a[3] = xW[19];
					MA2_in_a[4] = xW[20];
					MA2_in_a[5] = xW[21];
					MA2_in_a[6] = xW[22];
					MA2_in_a[7] = xW[23];

					MA2_in_b[0] = QK_T[7];
					MA2_in_b[1] = QK_T[15];
					MA2_in_b[2] = QK_T[23];
					MA2_in_b[3] = QK_T[31];
					MA2_in_b[4] = QK_T[39];
					MA2_in_b[5] = QK_T[47];
					MA2_in_b[6] = QK_T[55];
					MA2_in_b[7] = QK_T[63];
				end
				57: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA2_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA2_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA2_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA2_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA2_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA2_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA2_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				58: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA2_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA2_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA2_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA2_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA2_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA2_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA2_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				59: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA2_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA2_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA2_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA2_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA2_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA2_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA2_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				60: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA2_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA2_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA2_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA2_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA2_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA2_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA2_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				61: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA2_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA2_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA2_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA2_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA2_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA2_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA2_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				62: begin
					MA2_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA2_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA2_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA2_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA2_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA2_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA2_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA2_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA2_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA2_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA2_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA2_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA2_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA2_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA2_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA2_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				63: begin
					MA2_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA2_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA2_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA2_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA2_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA2_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA2_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA2_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA2_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA2_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA2_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA2_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA2_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA2_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA2_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA2_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end


				default: begin
					MA2_in_a[0] = 0;
					MA2_in_a[1] = 0;
					MA2_in_a[2] = 0;
					MA2_in_a[3] = 0;
					MA2_in_a[4] = 0;
					MA2_in_a[5] = 0;
					MA2_in_a[6] = 0;
					MA2_in_a[7] = 0;
					MA2_in_b[0] = 0;
					MA2_in_b[1] = 0;
					MA2_in_b[2] = 0;
					MA2_in_b[3] = 0;
					MA2_in_b[4] = 0;
					MA2_in_b[5] = 0;
					MA2_in_b[6] = 0;
					MA2_in_b[7] = 0;
				end
			endcase
		end

		DONE: begin
			case(t)
				0: begin
					MA2_in_a[0] = {{11{data_in[0][7]}}, data_in[0]};
					MA2_in_a[1] = {{11{data_in[1][7]}}, data_in[1]};
					MA2_in_a[2] = {{11{data_in[2][7]}}, data_in[2]};
					MA2_in_a[3] = {{11{data_in[3][7]}}, data_in[3]};
					MA2_in_a[4] = {{11{data_in[4][7]}}, data_in[4]};
					MA2_in_a[5] = {{11{data_in[5][7]}}, data_in[5]};
					MA2_in_a[6] = {{11{data_in[6][7]}}, data_in[6]};
					MA2_in_a[7] = {{11{data_in[7][7]}}, data_in[7]};

					MA2_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA2_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA2_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA2_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA2_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA2_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA2_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA2_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				1: begin
					MA2_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA2_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA2_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA2_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA2_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA2_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA2_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA2_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA2_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA2_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA2_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA2_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA2_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA2_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA2_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA2_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				default: begin
					MA2_in_a[0] = 0;
					MA2_in_a[1] = 0;
					MA2_in_a[2] = 0;
					MA2_in_a[3] = 0;
					MA2_in_a[4] = 0;
					MA2_in_a[5] = 0;
					MA2_in_a[6] = 0;
					MA2_in_a[7] = 0;
					MA2_in_b[0] = 0;
					MA2_in_b[1] = 0;
					MA2_in_b[2] = 0;
					MA2_in_b[3] = 0;
					MA2_in_b[4] = 0;
					MA2_in_b[5] = 0;
					MA2_in_b[6] = 0;
					MA2_in_b[7] = 0;
				end
			endcase
		end
		default: begin
			MA2_in_a[0] = 0;
			MA2_in_a[1] = 0;
			MA2_in_a[2] = 0;
			MA2_in_a[3] = 0;
			MA2_in_a[4] = 0;
			MA2_in_a[5] = 0;
			MA2_in_a[6] = 0;
			MA2_in_a[7] = 0;
			MA2_in_b[0] = 0;
			MA2_in_b[1] = 0;
			MA2_in_b[2] = 0;
			MA2_in_b[3] = 0;
			MA2_in_b[4] = 0;
			MA2_in_b[5] = 0;
			MA2_in_b[6] = 0;
			MA2_in_b[7] = 0;
		end
	endcase
end

always@(*) begin  //MA3
	case(State)
		READ_K: begin
			case(t)
				0,57: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA3_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA3_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA3_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA3_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA3_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA3_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA3_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				1,58: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA3_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA3_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA3_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA3_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA3_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA3_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA3_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				2,59: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA3_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA3_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA3_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA3_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA3_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA3_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA3_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				3,60: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA3_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA3_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA3_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA3_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA3_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA3_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA3_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				4,61: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA3_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA3_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA3_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA3_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA3_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA3_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA3_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				5,62: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA3_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA3_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA3_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA3_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA3_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA3_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA3_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				6,63: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA3_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA3_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA3_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA3_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA3_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA3_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA3_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end
				7: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA3_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA3_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA3_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA3_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA3_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA3_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA3_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end

				default: begin
					MA3_in_a[0] = 0;
					MA3_in_a[1] = 0;
					MA3_in_a[2] = 0;
					MA3_in_a[3] = 0;
					MA3_in_a[4] = 0;
					MA3_in_a[5] = 0;
					MA3_in_a[6] = 0;
					MA3_in_a[7] = 0;
					MA3_in_b[0] = 0;
					MA3_in_b[1] = 0;
					MA3_in_b[2] = 0;
					MA3_in_b[3] = 0;
					MA3_in_b[4] = 0;
					MA3_in_b[5] = 0;
					MA3_in_b[6] = 0;
					MA3_in_b[7] = 0;
				end
			endcase
		end
		READ_V: begin
			case(t)
				0: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA3_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA3_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA3_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA3_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA3_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA3_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA3_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				1: begin
					MA3_in_a[0] = xW[24];
					MA3_in_a[1] = xW[25];
					MA3_in_a[2] = xW[26];
					MA3_in_a[3] = xW[27];
					MA3_in_a[4] = xW[28];
					MA3_in_a[5] = xW[29];
					MA3_in_a[6] = xW[30];
					MA3_in_a[7] = xW[31];

					MA3_in_b[0] =  QK_T[0];
					MA3_in_b[1] =  QK_T[8];
					MA3_in_b[2] =  QK_T[16];
					MA3_in_b[3] =  QK_T[24];
					MA3_in_b[4] =  QK_T[32];
					MA3_in_b[5] =  QK_T[40];
					MA3_in_b[6] =  QK_T[48];
					MA3_in_b[7] =  QK_T[56];
				end
				2: begin
					MA3_in_a[0] = xW[24];
					MA3_in_a[1] = xW[25];
					MA3_in_a[2] = xW[26];
					MA3_in_a[3] = xW[27];
					MA3_in_a[4] = xW[28];
					MA3_in_a[5] = xW[29];
					MA3_in_a[6] = xW[30];
					MA3_in_a[7] = xW[31];

					MA3_in_b[0] =  QK_T[1];
					MA3_in_b[1] =  QK_T[9];
					MA3_in_b[2] =  QK_T[17];
					MA3_in_b[3] =  QK_T[25];
					MA3_in_b[4] =  QK_T[33];
					MA3_in_b[5] =  QK_T[41];
					MA3_in_b[6] =  QK_T[49];
					MA3_in_b[7] =  QK_T[57];
				end
				3: begin
					MA3_in_a[0] = xW[24];
					MA3_in_a[1] = xW[25];
					MA3_in_a[2] = xW[26];
					MA3_in_a[3] = xW[27];
					MA3_in_a[4] = xW[28];
					MA3_in_a[5] = xW[29];
					MA3_in_a[6] = xW[30];
					MA3_in_a[7] = xW[31];

					MA3_in_b[0] = QK_T[2];
					MA3_in_b[1] = QK_T[10];
					MA3_in_b[2] = QK_T[18];
					MA3_in_b[3] = QK_T[26];
					MA3_in_b[4] = QK_T[34];
					MA3_in_b[5] = QK_T[42];
					MA3_in_b[6] = QK_T[50];
					MA3_in_b[7] = QK_T[58];
				end

				4: begin
					MA3_in_a[0] = xW[24];
					MA3_in_a[1] = xW[25];
					MA3_in_a[2] = xW[26];
					MA3_in_a[3] = xW[27];
					MA3_in_a[4] = xW[28];
					MA3_in_a[5] = xW[29];
					MA3_in_a[6] = xW[30];
					MA3_in_a[7] = xW[31];

					MA3_in_b[0] = QK_T[3];
					MA3_in_b[1] = QK_T[11];
					MA3_in_b[2] = QK_T[19];
					MA3_in_b[3] = QK_T[27];
					MA3_in_b[4] = QK_T[35];
					MA3_in_b[5] = QK_T[43];
					MA3_in_b[6] = QK_T[51];
					MA3_in_b[7] = QK_T[59];
				end

				5: begin
					MA3_in_a[0] = xW[24];
					MA3_in_a[1] = xW[25];
					MA3_in_a[2] = xW[26];
					MA3_in_a[3] = xW[27];
					MA3_in_a[4] = xW[28];
					MA3_in_a[5] = xW[29];
					MA3_in_a[6] = xW[30];
					MA3_in_a[7] = xW[31];

					MA3_in_b[0] = QK_T[4];
					MA3_in_b[1] = QK_T[12];
					MA3_in_b[2] = QK_T[20];
					MA3_in_b[3] = QK_T[28];
					MA3_in_b[4] = QK_T[36];
					MA3_in_b[5] = QK_T[44];
					MA3_in_b[6] = QK_T[52];
					MA3_in_b[7] = QK_T[60];
				end

				6: begin
					MA3_in_a[0] = xW[24];
					MA3_in_a[1] = xW[25];
					MA3_in_a[2] = xW[26];
					MA3_in_a[3] = xW[27];
					MA3_in_a[4] = xW[28];
					MA3_in_a[5] = xW[29];
					MA3_in_a[6] = xW[30];
					MA3_in_a[7] = xW[31];

					MA3_in_b[0] = QK_T[5];
					MA3_in_b[1] = QK_T[13];
					MA3_in_b[2] = QK_T[21];
					MA3_in_b[3] = QK_T[29];
					MA3_in_b[4] = QK_T[37];
					MA3_in_b[5] = QK_T[45];
					MA3_in_b[6] = QK_T[53];
					MA3_in_b[7] = QK_T[61];
				end

				7: begin
					MA3_in_a[0] = xW[24];
					MA3_in_a[1] = xW[25];
					MA3_in_a[2] = xW[26];
					MA3_in_a[3] = xW[27];
					MA3_in_a[4] = xW[28];
					MA3_in_a[5] = xW[29];
					MA3_in_a[6] = xW[30];
					MA3_in_a[7] = xW[31];

					MA3_in_b[0] = QK_T[6];
					MA3_in_b[1] = QK_T[14];
					MA3_in_b[2] = QK_T[22];
					MA3_in_b[3] = QK_T[30];
					MA3_in_b[4] = QK_T[38];
					MA3_in_b[5] = QK_T[46];
					MA3_in_b[6] = QK_T[54];
					MA3_in_b[7] = QK_T[62];
				end

				8: begin
					MA3_in_a[0] = xW[24];
					MA3_in_a[1] = xW[25];
					MA3_in_a[2] = xW[26];
					MA3_in_a[3] = xW[27];
					MA3_in_a[4] = xW[28];
					MA3_in_a[5] = xW[29];
					MA3_in_a[6] = xW[30];
					MA3_in_a[7] = xW[31];

					MA3_in_b[0] = QK_T[7];
					MA3_in_b[1] = QK_T[15];
					MA3_in_b[2] = QK_T[23];
					MA3_in_b[3] = QK_T[31];
					MA3_in_b[4] = QK_T[39];
					MA3_in_b[5] = QK_T[47];
					MA3_in_b[6] = QK_T[55];
					MA3_in_b[7] = QK_T[63];
				end
				57: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA3_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA3_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA3_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA3_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA3_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA3_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA3_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				58: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA3_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA3_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA3_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA3_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA3_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA3_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA3_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				59: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA3_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA3_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA3_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA3_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA3_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA3_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA3_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				60: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA3_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA3_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA3_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA3_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA3_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA3_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA3_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				61: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA3_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA3_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA3_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA3_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA3_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA3_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA3_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				62: begin
					MA3_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA3_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA3_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA3_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA3_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA3_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA3_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA3_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA3_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA3_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA3_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA3_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA3_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA3_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA3_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA3_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				63: begin
					MA3_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA3_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA3_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA3_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA3_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA3_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA3_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA3_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA3_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA3_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA3_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA3_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA3_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA3_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA3_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA3_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end


				default: begin
					MA3_in_a[0] = 0;
					MA3_in_a[1] = 0;
					MA3_in_a[2] = 0;
					MA3_in_a[3] = 0;
					MA3_in_a[4] = 0;
					MA3_in_a[5] = 0;
					MA3_in_a[6] = 0;
					MA3_in_a[7] = 0;
					MA3_in_b[0] = 0;
					MA3_in_b[1] = 0;
					MA3_in_b[2] = 0;
					MA3_in_b[3] = 0;
					MA3_in_b[4] = 0;
					MA3_in_b[5] = 0;
					MA3_in_b[6] = 0;
					MA3_in_b[7] = 0;
				end
			endcase
		end

		DONE: begin
			case(t)
				0: begin
					MA3_in_a[0] = {{11{data_in[8][7]}}, data_in[8]};
					MA3_in_a[1] = {{11{data_in[9][7]}}, data_in[9]};
					MA3_in_a[2] = {{11{data_in[10][7]}}, data_in[10]};
					MA3_in_a[3] = {{11{data_in[11][7]}}, data_in[11]};
					MA3_in_a[4] = {{11{data_in[12][7]}}, data_in[12]};
					MA3_in_a[5] = {{11{data_in[13][7]}}, data_in[13]};
					MA3_in_a[6] = {{11{data_in[14][7]}}, data_in[14]};
					MA3_in_a[7] = {{11{data_in[15][7]}}, data_in[15]};

					MA3_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA3_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA3_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA3_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA3_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA3_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA3_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA3_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				default: begin
					MA3_in_a[0] = 0;
					MA3_in_a[1] = 0;
					MA3_in_a[2] = 0;
					MA3_in_a[3] = 0;
					MA3_in_a[4] = 0;
					MA3_in_a[5] = 0;
					MA3_in_a[6] = 0;
					MA3_in_a[7] = 0;
					MA3_in_b[0] = 0;
					MA3_in_b[1] = 0;
					MA3_in_b[2] = 0;
					MA3_in_b[3] = 0;
					MA3_in_b[4] = 0;
					MA3_in_b[5] = 0;
					MA3_in_b[6] = 0;
					MA3_in_b[7] = 0;
				end
			endcase
		end
		default: begin
			MA3_in_a[0] = 0;
			MA3_in_a[1] = 0;
			MA3_in_a[2] = 0;
			MA3_in_a[3] = 0;
			MA3_in_a[4] = 0;
			MA3_in_a[5] = 0;
			MA3_in_a[6] = 0;
			MA3_in_a[7] = 0;
			MA3_in_b[0] = 0;
			MA3_in_b[1] = 0;
			MA3_in_b[2] = 0;
			MA3_in_b[3] = 0;
			MA3_in_b[4] = 0;
			MA3_in_b[5] = 0;
			MA3_in_b[6] = 0;
			MA3_in_b[7] = 0;
		end
	endcase
end

always@(*) begin  //MA4
	case(State)
		READ_K: begin
			case(t)
				0,57: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA4_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA4_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA4_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA4_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA4_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA4_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA4_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				1,58: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA4_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA4_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA4_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA4_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA4_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA4_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA4_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				2,59: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA4_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA4_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA4_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA4_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA4_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA4_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA4_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				3,60: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA4_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA4_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA4_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA4_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA4_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA4_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA4_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				4,61: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA4_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA4_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA4_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA4_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA4_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA4_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA4_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				5,62: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA4_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA4_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA4_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA4_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA4_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA4_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA4_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				6,63: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA4_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA4_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA4_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA4_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA4_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA4_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA4_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end
				7: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA4_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA4_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA4_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA4_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA4_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA4_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA4_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end

				default: begin
					MA4_in_a[0] = 0;
					MA4_in_a[1] = 0;
					MA4_in_a[2] = 0;
					MA4_in_a[3] = 0;
					MA4_in_a[4] = 0;
					MA4_in_a[5] = 0;
					MA4_in_a[6] = 0;
					MA4_in_a[7] = 0;
					MA4_in_b[0] = 0;
					MA4_in_b[1] = 0;
					MA4_in_b[2] = 0;
					MA4_in_b[3] = 0;
					MA4_in_b[4] = 0;
					MA4_in_b[5] = 0;
					MA4_in_b[6] = 0;
					MA4_in_b[7] = 0;
				end
			endcase
		end
		READ_V: begin
			case(t)
				0: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA4_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA4_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA4_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA4_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA4_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA4_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA4_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				1: begin
					MA4_in_a[0] = xW[32];
					MA4_in_a[1] = xW[33];
					MA4_in_a[2] = xW[34];
					MA4_in_a[3] = xW[35];
					MA4_in_a[4] = xW[36];
					MA4_in_a[5] = xW[37];
					MA4_in_a[6] = xW[38];
					MA4_in_a[7] = xW[39];

					MA4_in_b[0] =  QK_T[0];
					MA4_in_b[1] =  QK_T[8];
					MA4_in_b[2] =  QK_T[16];
					MA4_in_b[3] =  QK_T[24];
					MA4_in_b[4] =  QK_T[32];
					MA4_in_b[5] =  QK_T[40];
					MA4_in_b[6] =  QK_T[48];
					MA4_in_b[7] =  QK_T[56];
				end
				2: begin
					MA4_in_a[0] = xW[32];
					MA4_in_a[1] = xW[33];
					MA4_in_a[2] = xW[34];
					MA4_in_a[3] = xW[35];
					MA4_in_a[4] = xW[36];
					MA4_in_a[5] = xW[37];
					MA4_in_a[6] = xW[38];
					MA4_in_a[7] = xW[39];

					MA4_in_b[0] =  QK_T[1];
					MA4_in_b[1] =  QK_T[9];
					MA4_in_b[2] =  QK_T[17];
					MA4_in_b[3] =  QK_T[25];
					MA4_in_b[4] =  QK_T[33];
					MA4_in_b[5] =  QK_T[41];
					MA4_in_b[6] =  QK_T[49];
					MA4_in_b[7] =  QK_T[57];
				end
				3: begin
					MA4_in_a[0] = xW[32];
					MA4_in_a[1] = xW[33];
					MA4_in_a[2] = xW[34];
					MA4_in_a[3] = xW[35];
					MA4_in_a[4] = xW[36];
					MA4_in_a[5] = xW[37];
					MA4_in_a[6] = xW[38];
					MA4_in_a[7] = xW[39];

					MA4_in_b[0] = QK_T[2];
					MA4_in_b[1] = QK_T[10];
					MA4_in_b[2] = QK_T[18];
					MA4_in_b[3] = QK_T[26];
					MA4_in_b[4] = QK_T[34];
					MA4_in_b[5] = QK_T[42];
					MA4_in_b[6] = QK_T[50];
					MA4_in_b[7] = QK_T[58];
				end

				4: begin
					MA4_in_a[0] = xW[32];
					MA4_in_a[1] = xW[33];
					MA4_in_a[2] = xW[34];
					MA4_in_a[3] = xW[35];
					MA4_in_a[4] = xW[36];
					MA4_in_a[5] = xW[37];
					MA4_in_a[6] = xW[38];
					MA4_in_a[7] = xW[39];

					MA4_in_b[0] = QK_T[3];
					MA4_in_b[1] = QK_T[11];
					MA4_in_b[2] = QK_T[19];
					MA4_in_b[3] = QK_T[27];
					MA4_in_b[4] = QK_T[35];
					MA4_in_b[5] = QK_T[43];
					MA4_in_b[6] = QK_T[51];
					MA4_in_b[7] = QK_T[59];
				end

				5: begin
					MA4_in_a[0] = xW[32];
					MA4_in_a[1] = xW[33];
					MA4_in_a[2] = xW[34];
					MA4_in_a[3] = xW[35];
					MA4_in_a[4] = xW[36];
					MA4_in_a[5] = xW[37];
					MA4_in_a[6] = xW[38];
					MA4_in_a[7] = xW[39];

					MA4_in_b[0] = QK_T[4];
					MA4_in_b[1] = QK_T[12];
					MA4_in_b[2] = QK_T[20];
					MA4_in_b[3] = QK_T[28];
					MA4_in_b[4] = QK_T[36];
					MA4_in_b[5] = QK_T[44];
					MA4_in_b[6] = QK_T[52];
					MA4_in_b[7] = QK_T[60];
				end

				6: begin
					MA4_in_a[0] = xW[32];
					MA4_in_a[1] = xW[33];
					MA4_in_a[2] = xW[34];
					MA4_in_a[3] = xW[35];
					MA4_in_a[4] = xW[36];
					MA4_in_a[5] = xW[37];
					MA4_in_a[6] = xW[38];
					MA4_in_a[7] = xW[39];

					MA4_in_b[0] = QK_T[5];
					MA4_in_b[1] = QK_T[13];
					MA4_in_b[2] = QK_T[21];
					MA4_in_b[3] = QK_T[29];
					MA4_in_b[4] = QK_T[37];
					MA4_in_b[5] = QK_T[45];
					MA4_in_b[6] = QK_T[53];
					MA4_in_b[7] = QK_T[61];
				end

				7: begin
					MA4_in_a[0] = xW[32];
					MA4_in_a[1] = xW[33];
					MA4_in_a[2] = xW[34];
					MA4_in_a[3] = xW[35];
					MA4_in_a[4] = xW[36];
					MA4_in_a[5] = xW[37];
					MA4_in_a[6] = xW[38];
					MA4_in_a[7] = xW[39];

					MA4_in_b[0] = QK_T[6];
					MA4_in_b[1] = QK_T[14];
					MA4_in_b[2] = QK_T[22];
					MA4_in_b[3] = QK_T[30];
					MA4_in_b[4] = QK_T[38];
					MA4_in_b[5] = QK_T[46];
					MA4_in_b[6] = QK_T[54];
					MA4_in_b[7] = QK_T[62];
				end

				8: begin
					MA4_in_a[0] = xW[32];
					MA4_in_a[1] = xW[33];
					MA4_in_a[2] = xW[34];
					MA4_in_a[3] = xW[35];
					MA4_in_a[4] = xW[36];
					MA4_in_a[5] = xW[37];
					MA4_in_a[6] = xW[38];
					MA4_in_a[7] = xW[39];

					MA4_in_b[0] = QK_T[7];
					MA4_in_b[1] = QK_T[15];
					MA4_in_b[2] = QK_T[23];
					MA4_in_b[3] = QK_T[31];
					MA4_in_b[4] = QK_T[39];
					MA4_in_b[5] = QK_T[47];
					MA4_in_b[6] = QK_T[55];
					MA4_in_b[7] = QK_T[63];
				end
				57: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA4_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA4_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA4_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA4_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA4_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA4_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA4_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				58: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA4_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA4_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA4_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA4_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA4_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA4_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA4_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				59: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA4_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA4_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA4_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA4_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA4_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA4_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA4_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				60: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA4_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA4_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA4_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA4_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA4_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA4_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA4_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				61: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA4_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA4_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA4_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA4_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA4_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA4_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA4_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				62: begin
					MA4_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA4_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA4_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA4_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA4_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA4_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA4_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA4_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA4_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA4_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA4_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA4_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA4_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA4_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA4_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA4_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				63: begin
					MA4_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA4_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA4_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA4_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA4_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA4_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA4_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA4_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA4_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA4_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA4_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA4_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA4_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA4_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA4_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA4_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end


				default: begin
					MA4_in_a[0] = 0;
					MA4_in_a[1] = 0;
					MA4_in_a[2] = 0;
					MA4_in_a[3] = 0;
					MA4_in_a[4] = 0;
					MA4_in_a[5] = 0;
					MA4_in_a[6] = 0;
					MA4_in_a[7] = 0;
					MA4_in_b[0] = 0;
					MA4_in_b[1] = 0;
					MA4_in_b[2] = 0;
					MA4_in_b[3] = 0;
					MA4_in_b[4] = 0;
					MA4_in_b[5] = 0;
					MA4_in_b[6] = 0;
					MA4_in_b[7] = 0;
				end
			endcase
		end

		DONE: begin
			case(t)
				0: begin
					MA4_in_a[0] = {{11{data_in[16][7]}}, data_in[16]};
					MA4_in_a[1] = {{11{data_in[17][7]}}, data_in[17]};
					MA4_in_a[2] = {{11{data_in[18][7]}}, data_in[18]};
					MA4_in_a[3] = {{11{data_in[19][7]}}, data_in[19]};
					MA4_in_a[4] = {{11{data_in[20][7]}}, data_in[20]};
					MA4_in_a[5] = {{11{data_in[21][7]}}, data_in[21]};
					MA4_in_a[6] = {{11{data_in[22][7]}}, data_in[22]};
					MA4_in_a[7] = {{11{data_in[23][7]}}, data_in[23]};

					MA4_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA4_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA4_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA4_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA4_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA4_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA4_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA4_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				default: begin
					MA4_in_a[0] = 0;
					MA4_in_a[1] = 0;
					MA4_in_a[2] = 0;
					MA4_in_a[3] = 0;
					MA4_in_a[4] = 0;
					MA4_in_a[5] = 0;
					MA4_in_a[6] = 0;
					MA4_in_a[7] = 0;
					MA4_in_b[0] = 0;
					MA4_in_b[1] = 0;
					MA4_in_b[2] = 0;
					MA4_in_b[3] = 0;
					MA4_in_b[4] = 0;
					MA4_in_b[5] = 0;
					MA4_in_b[6] = 0;
					MA4_in_b[7] = 0;
				end
			endcase
		end
		default: begin
			MA4_in_a[0] = 0;
			MA4_in_a[1] = 0;
			MA4_in_a[2] = 0;
			MA4_in_a[3] = 0;
			MA4_in_a[4] = 0;
			MA4_in_a[5] = 0;
			MA4_in_a[6] = 0;
			MA4_in_a[7] = 0;
			MA4_in_b[0] = 0;
			MA4_in_b[1] = 0;
			MA4_in_b[2] = 0;
			MA4_in_b[3] = 0;
			MA4_in_b[4] = 0;
			MA4_in_b[5] = 0;
			MA4_in_b[6] = 0;
			MA4_in_b[7] = 0;
		end
	endcase
end

always@(*) begin  //MA5
	case(State)
		READ_K: begin
			case(t)
				0,57: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA5_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA5_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA5_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA5_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA5_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA5_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA5_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				1,58: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA5_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA5_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA5_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA5_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA5_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA5_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA5_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				2,59: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA5_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA5_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA5_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA5_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA5_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA5_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA5_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				3,60: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA5_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA5_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA5_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA5_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA5_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA5_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA5_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				4,61: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA5_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA5_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA5_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA5_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA5_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA5_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA5_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				5,62: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA5_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA5_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA5_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA5_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA5_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA5_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA5_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				6,63: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA5_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA5_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA5_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA5_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA5_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA5_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA5_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end
				7: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA5_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA5_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA5_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA5_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA5_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA5_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA5_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end

				default: begin
					MA5_in_a[0] = 0;
					MA5_in_a[1] = 0;
					MA5_in_a[2] = 0;
					MA5_in_a[3] = 0;
					MA5_in_a[4] = 0;
					MA5_in_a[5] = 0;
					MA5_in_a[6] = 0;
					MA5_in_a[7] = 0;
					MA5_in_b[0] = 0;
					MA5_in_b[1] = 0;
					MA5_in_b[2] = 0;
					MA5_in_b[3] = 0;
					MA5_in_b[4] = 0;
					MA5_in_b[5] = 0;
					MA5_in_b[6] = 0;
					MA5_in_b[7] = 0;
				end
			endcase
		end
		READ_V: begin
			case(t)
				0: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA5_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA5_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA5_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA5_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA5_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA5_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA5_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				1: begin
					MA5_in_a[0] = xW[40];
					MA5_in_a[1] = xW[41];
					MA5_in_a[2] = xW[42];
					MA5_in_a[3] = xW[43];
					MA5_in_a[4] = xW[44];
					MA5_in_a[5] = xW[45];
					MA5_in_a[6] = xW[46];
					MA5_in_a[7] = xW[47];

					MA5_in_b[0] =  QK_T[0];
					MA5_in_b[1] =  QK_T[8];
					MA5_in_b[2] =  QK_T[16];
					MA5_in_b[3] =  QK_T[24];
					MA5_in_b[4] =  QK_T[32];
					MA5_in_b[5] =  QK_T[40];
					MA5_in_b[6] =  QK_T[48];
					MA5_in_b[7] =  QK_T[56];
				end
				2: begin
					MA5_in_a[0] = xW[40];
					MA5_in_a[1] = xW[41];
					MA5_in_a[2] = xW[42];
					MA5_in_a[3] = xW[43];
					MA5_in_a[4] = xW[44];
					MA5_in_a[5] = xW[45];
					MA5_in_a[6] = xW[46];
					MA5_in_a[7] = xW[47];

					MA5_in_b[0] =  QK_T[1];
					MA5_in_b[1] =  QK_T[9];
					MA5_in_b[2] =  QK_T[17];
					MA5_in_b[3] =  QK_T[25];
					MA5_in_b[4] =  QK_T[33];
					MA5_in_b[5] =  QK_T[41];
					MA5_in_b[6] =  QK_T[49];
					MA5_in_b[7] =  QK_T[57];
				end
				3: begin
					MA5_in_a[0] = xW[40];
					MA5_in_a[1] = xW[41];
					MA5_in_a[2] = xW[42];
					MA5_in_a[3] = xW[43];
					MA5_in_a[4] = xW[44];
					MA5_in_a[5] = xW[45];
					MA5_in_a[6] = xW[46];
					MA5_in_a[7] = xW[47];

					MA5_in_b[0] = QK_T[2];
					MA5_in_b[1] = QK_T[10];
					MA5_in_b[2] = QK_T[18];
					MA5_in_b[3] = QK_T[26];
					MA5_in_b[4] = QK_T[34];
					MA5_in_b[5] = QK_T[42];
					MA5_in_b[6] = QK_T[50];
					MA5_in_b[7] = QK_T[58];
				end

				4: begin
					MA5_in_a[0] = xW[40];
					MA5_in_a[1] = xW[41];
					MA5_in_a[2] = xW[42];
					MA5_in_a[3] = xW[43];
					MA5_in_a[4] = xW[44];
					MA5_in_a[5] = xW[45];
					MA5_in_a[6] = xW[46];
					MA5_in_a[7] = xW[47];

					MA5_in_b[0] = QK_T[3];
					MA5_in_b[1] = QK_T[11];
					MA5_in_b[2] = QK_T[19];
					MA5_in_b[3] = QK_T[27];
					MA5_in_b[4] = QK_T[35];
					MA5_in_b[5] = QK_T[43];
					MA5_in_b[6] = QK_T[51];
					MA5_in_b[7] = QK_T[59];
				end

				5: begin
					MA5_in_a[0] = xW[40];
					MA5_in_a[1] = xW[41];
					MA5_in_a[2] = xW[42];
					MA5_in_a[3] = xW[43];
					MA5_in_a[4] = xW[44];
					MA5_in_a[5] = xW[45];
					MA5_in_a[6] = xW[46];
					MA5_in_a[7] = xW[47];

					MA5_in_b[0] = QK_T[4];
					MA5_in_b[1] = QK_T[12];
					MA5_in_b[2] = QK_T[20];
					MA5_in_b[3] = QK_T[28];
					MA5_in_b[4] = QK_T[36];
					MA5_in_b[5] = QK_T[44];
					MA5_in_b[6] = QK_T[52];
					MA5_in_b[7] = QK_T[60];
				end

				6: begin
					MA5_in_a[0] = xW[40];
					MA5_in_a[1] = xW[41];
					MA5_in_a[2] = xW[42];
					MA5_in_a[3] = xW[43];
					MA5_in_a[4] = xW[44];
					MA5_in_a[5] = xW[45];
					MA5_in_a[6] = xW[46];
					MA5_in_a[7] = xW[47];

					MA5_in_b[0] = QK_T[5];
					MA5_in_b[1] = QK_T[13];
					MA5_in_b[2] = QK_T[21];
					MA5_in_b[3] = QK_T[29];
					MA5_in_b[4] = QK_T[37];
					MA5_in_b[5] = QK_T[45];
					MA5_in_b[6] = QK_T[53];
					MA5_in_b[7] = QK_T[61];
				end

				7: begin
					MA5_in_a[0] = xW[40];
					MA5_in_a[1] = xW[41];
					MA5_in_a[2] = xW[42];
					MA5_in_a[3] = xW[43];
					MA5_in_a[4] = xW[44];
					MA5_in_a[5] = xW[45];
					MA5_in_a[6] = xW[46];
					MA5_in_a[7] = xW[47];

					MA5_in_b[0] = QK_T[6];
					MA5_in_b[1] = QK_T[14];
					MA5_in_b[2] = QK_T[22];
					MA5_in_b[3] = QK_T[30];
					MA5_in_b[4] = QK_T[38];
					MA5_in_b[5] = QK_T[46];
					MA5_in_b[6] = QK_T[54];
					MA5_in_b[7] = QK_T[62];
				end

				8: begin
					MA5_in_a[0] = xW[40];
					MA5_in_a[1] = xW[41];
					MA5_in_a[2] = xW[42];
					MA5_in_a[3] = xW[43];
					MA5_in_a[4] = xW[44];
					MA5_in_a[5] = xW[45];
					MA5_in_a[6] = xW[46];
					MA5_in_a[7] = xW[47];

					MA5_in_b[0] = QK_T[7];
					MA5_in_b[1] = QK_T[15];
					MA5_in_b[2] = QK_T[23];
					MA5_in_b[3] = QK_T[31];
					MA5_in_b[4] = QK_T[39];
					MA5_in_b[5] = QK_T[47];
					MA5_in_b[6] = QK_T[55];
					MA5_in_b[7] = QK_T[63];
				end
				57: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA5_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA5_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA5_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA5_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA5_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA5_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA5_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				58: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA5_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA5_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA5_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA5_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA5_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA5_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA5_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				59: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA5_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA5_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA5_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA5_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA5_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA5_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA5_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				60: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA5_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA5_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA5_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA5_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA5_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA5_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA5_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				61: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA5_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA5_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA5_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA5_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA5_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA5_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA5_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				62: begin
					MA5_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA5_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA5_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA5_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA5_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA5_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA5_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA5_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA5_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA5_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA5_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA5_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA5_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA5_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA5_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA5_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				63: begin
					MA5_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA5_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA5_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA5_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA5_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA5_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA5_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA5_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA5_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA5_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA5_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA5_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA5_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA5_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA5_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA5_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end


				default: begin
					MA5_in_a[0] = 0;
					MA5_in_a[1] = 0;
					MA5_in_a[2] = 0;
					MA5_in_a[3] = 0;
					MA5_in_a[4] = 0;
					MA5_in_a[5] = 0;
					MA5_in_a[6] = 0;
					MA5_in_a[7] = 0;
					MA5_in_b[0] = 0;
					MA5_in_b[1] = 0;
					MA5_in_b[2] = 0;
					MA5_in_b[3] = 0;
					MA5_in_b[4] = 0;
					MA5_in_b[5] = 0;
					MA5_in_b[6] = 0;
					MA5_in_b[7] = 0;
				end
			endcase
		end

		DONE: begin
			case(t)
				0: begin
					MA5_in_a[0] = {{11{data_in[24][7]}}, data_in[24]};
					MA5_in_a[1] = {{11{data_in[25][7]}}, data_in[25]};
					MA5_in_a[2] = {{11{data_in[26][7]}}, data_in[26]};
					MA5_in_a[3] = {{11{data_in[27][7]}}, data_in[27]};
					MA5_in_a[4] = {{11{data_in[28][7]}}, data_in[28]};
					MA5_in_a[5] = {{11{data_in[29][7]}}, data_in[29]};
					MA5_in_a[6] = {{11{data_in[30][7]}}, data_in[30]};
					MA5_in_a[7] = {{11{data_in[31][7]}}, data_in[31]};

					MA5_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA5_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA5_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA5_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA5_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA5_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA5_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA5_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				default: begin
					MA5_in_a[0] = 0;
					MA5_in_a[1] = 0;
					MA5_in_a[2] = 0;
					MA5_in_a[3] = 0;
					MA5_in_a[4] = 0;
					MA5_in_a[5] = 0;
					MA5_in_a[6] = 0;
					MA5_in_a[7] = 0;
					MA5_in_b[0] = 0;
					MA5_in_b[1] = 0;
					MA5_in_b[2] = 0;
					MA5_in_b[3] = 0;
					MA5_in_b[4] = 0;
					MA5_in_b[5] = 0;
					MA5_in_b[6] = 0;
					MA5_in_b[7] = 0;
				end
			endcase
		end
		default: begin
			MA5_in_a[0] = 0;
			MA5_in_a[1] = 0;
			MA5_in_a[2] = 0;
			MA5_in_a[3] = 0;
			MA5_in_a[4] = 0;
			MA5_in_a[5] = 0;
			MA5_in_a[6] = 0;
			MA5_in_a[7] = 0;
			MA5_in_b[0] = 0;
			MA5_in_b[1] = 0;
			MA5_in_b[2] = 0;
			MA5_in_b[3] = 0;
			MA5_in_b[4] = 0;
			MA5_in_b[5] = 0;
			MA5_in_b[6] = 0;
			MA5_in_b[7] = 0;
		end
	endcase
end

always@(*) begin  //MA6
	case(State)
		READ_K: begin
			case(t)
				0,57: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA6_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA6_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA6_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA6_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA6_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA6_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA6_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				1,58: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA6_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA6_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA6_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA6_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA6_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA6_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA6_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				2,59: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA6_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA6_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA6_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA6_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA6_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA6_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA6_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				3,60: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA6_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA6_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA6_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA6_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA6_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA6_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA6_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				4,61: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA6_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA6_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA6_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA6_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA6_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA6_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA6_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				5,62: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA6_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA6_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA6_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA6_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA6_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA6_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA6_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				6,63: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA6_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA6_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA6_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA6_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA6_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA6_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA6_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end
				7: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA6_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA6_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA6_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA6_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA6_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA6_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA6_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end

				default: begin
					MA6_in_a[0] = 0;
					MA6_in_a[1] = 0;
					MA6_in_a[2] = 0;
					MA6_in_a[3] = 0;
					MA6_in_a[4] = 0;
					MA6_in_a[5] = 0;
					MA6_in_a[6] = 0;
					MA6_in_a[7] = 0;
					MA6_in_b[0] = 0;
					MA6_in_b[1] = 0;
					MA6_in_b[2] = 0;
					MA6_in_b[3] = 0;
					MA6_in_b[4] = 0;
					MA6_in_b[5] = 0;
					MA6_in_b[6] = 0;
					MA6_in_b[7] = 0;
				end
			endcase
		end
		READ_V: begin
			case(t)
				0: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA6_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA6_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA6_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA6_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA6_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA6_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA6_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				1: begin
					MA6_in_a[0] = xW[48];
					MA6_in_a[1] = xW[49];
					MA6_in_a[2] = xW[50];
					MA6_in_a[3] = xW[51];
					MA6_in_a[4] = xW[52];
					MA6_in_a[5] = xW[53];
					MA6_in_a[6] = xW[54];
					MA6_in_a[7] = xW[55];

					MA6_in_b[0] =  QK_T[0];
					MA6_in_b[1] =  QK_T[8];
					MA6_in_b[2] =  QK_T[16];
					MA6_in_b[3] =  QK_T[24];
					MA6_in_b[4] =  QK_T[32];
					MA6_in_b[5] =  QK_T[40];
					MA6_in_b[6] =  QK_T[48];
					MA6_in_b[7] =  QK_T[56];
				end
				2: begin
					MA6_in_a[0] = xW[48];
					MA6_in_a[1] = xW[49];
					MA6_in_a[2] = xW[50];
					MA6_in_a[3] = xW[51];
					MA6_in_a[4] = xW[52];
					MA6_in_a[5] = xW[53];
					MA6_in_a[6] = xW[54];
					MA6_in_a[7] = xW[55];

					MA6_in_b[0] =  QK_T[1];
					MA6_in_b[1] =  QK_T[9];
					MA6_in_b[2] =  QK_T[17];
					MA6_in_b[3] =  QK_T[25];
					MA6_in_b[4] =  QK_T[33];
					MA6_in_b[5] =  QK_T[41];
					MA6_in_b[6] =  QK_T[49];
					MA6_in_b[7] =  QK_T[57];
				end
				3: begin
					MA6_in_a[0] = xW[48];
					MA6_in_a[1] = xW[49];
					MA6_in_a[2] = xW[50];
					MA6_in_a[3] = xW[51];
					MA6_in_a[4] = xW[52];
					MA6_in_a[5] = xW[53];
					MA6_in_a[6] = xW[54];
					MA6_in_a[7] = xW[55];

					MA6_in_b[0] = QK_T[2];
					MA6_in_b[1] = QK_T[10];
					MA6_in_b[2] = QK_T[18];
					MA6_in_b[3] = QK_T[26];
					MA6_in_b[4] = QK_T[34];
					MA6_in_b[5] = QK_T[42];
					MA6_in_b[6] = QK_T[50];
					MA6_in_b[7] = QK_T[58];
				end

				4: begin
					MA6_in_a[0] = xW[48];
					MA6_in_a[1] = xW[49];
					MA6_in_a[2] = xW[50];
					MA6_in_a[3] = xW[51];
					MA6_in_a[4] = xW[52];
					MA6_in_a[5] = xW[53];
					MA6_in_a[6] = xW[54];
					MA6_in_a[7] = xW[55];

					MA6_in_b[0] = QK_T[3];
					MA6_in_b[1] = QK_T[11];
					MA6_in_b[2] = QK_T[19];
					MA6_in_b[3] = QK_T[27];
					MA6_in_b[4] = QK_T[35];
					MA6_in_b[5] = QK_T[43];
					MA6_in_b[6] = QK_T[51];
					MA6_in_b[7] = QK_T[59];
				end

				5: begin
					MA6_in_a[0] = xW[48];
					MA6_in_a[1] = xW[49];
					MA6_in_a[2] = xW[50];
					MA6_in_a[3] = xW[51];
					MA6_in_a[4] = xW[52];
					MA6_in_a[5] = xW[53];
					MA6_in_a[6] = xW[54];
					MA6_in_a[7] = xW[55];

					MA6_in_b[0] = QK_T[4];
					MA6_in_b[1] = QK_T[12];
					MA6_in_b[2] = QK_T[20];
					MA6_in_b[3] = QK_T[28];
					MA6_in_b[4] = QK_T[36];
					MA6_in_b[5] = QK_T[44];
					MA6_in_b[6] = QK_T[52];
					MA6_in_b[7] = QK_T[60];
				end

				6: begin
					MA6_in_a[0] = xW[48];
					MA6_in_a[1] = xW[49];
					MA6_in_a[2] = xW[50];
					MA6_in_a[3] = xW[51];
					MA6_in_a[4] = xW[52];
					MA6_in_a[5] = xW[53];
					MA6_in_a[6] = xW[54];
					MA6_in_a[7] = xW[55];

					MA6_in_b[0] = QK_T[5];
					MA6_in_b[1] = QK_T[13];
					MA6_in_b[2] = QK_T[21];
					MA6_in_b[3] = QK_T[29];
					MA6_in_b[4] = QK_T[37];
					MA6_in_b[5] = QK_T[45];
					MA6_in_b[6] = QK_T[53];
					MA6_in_b[7] = QK_T[61];
				end

				7: begin
					MA6_in_a[0] = xW[48];
					MA6_in_a[1] = xW[49];
					MA6_in_a[2] = xW[50];
					MA6_in_a[3] = xW[51];
					MA6_in_a[4] = xW[52];
					MA6_in_a[5] = xW[53];
					MA6_in_a[6] = xW[54];
					MA6_in_a[7] = xW[55];

					MA6_in_b[0] = QK_T[6];
					MA6_in_b[1] = QK_T[14];
					MA6_in_b[2] = QK_T[22];
					MA6_in_b[3] = QK_T[30];
					MA6_in_b[4] = QK_T[38];
					MA6_in_b[5] = QK_T[46];
					MA6_in_b[6] = QK_T[54];
					MA6_in_b[7] = QK_T[62];
				end

				8: begin
					MA6_in_a[0] = xW[48];
					MA6_in_a[1] = xW[49];
					MA6_in_a[2] = xW[50];
					MA6_in_a[3] = xW[51];
					MA6_in_a[4] = xW[52];
					MA6_in_a[5] = xW[53];
					MA6_in_a[6] = xW[54];
					MA6_in_a[7] = xW[55];

					MA6_in_b[0] = QK_T[7];
					MA6_in_b[1] = QK_T[15];
					MA6_in_b[2] = QK_T[23];
					MA6_in_b[3] = QK_T[31];
					MA6_in_b[4] = QK_T[39];
					MA6_in_b[5] = QK_T[47];
					MA6_in_b[6] = QK_T[55];
					MA6_in_b[7] = QK_T[63];
				end
				57: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA6_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA6_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA6_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA6_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA6_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA6_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA6_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				58: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA6_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA6_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA6_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA6_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA6_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA6_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA6_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				59: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA6_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA6_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA6_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA6_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA6_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA6_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA6_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				60: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA6_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA6_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA6_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA6_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA6_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA6_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA6_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				61: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA6_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA6_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA6_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA6_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA6_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA6_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA6_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				62: begin
					MA6_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA6_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA6_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA6_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA6_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA6_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA6_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA6_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA6_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA6_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA6_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA6_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA6_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA6_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA6_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA6_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				63: begin
					MA6_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA6_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA6_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA6_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA6_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA6_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA6_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA6_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA6_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA6_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA6_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA6_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA6_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA6_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA6_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA6_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end


				default: begin
					MA6_in_a[0] = 0;
					MA6_in_a[1] = 0;
					MA6_in_a[2] = 0;
					MA6_in_a[3] = 0;
					MA6_in_a[4] = 0;
					MA6_in_a[5] = 0;
					MA6_in_a[6] = 0;
					MA6_in_a[7] = 0;
					MA6_in_b[0] = 0;
					MA6_in_b[1] = 0;
					MA6_in_b[2] = 0;
					MA6_in_b[3] = 0;
					MA6_in_b[4] = 0;
					MA6_in_b[5] = 0;
					MA6_in_b[6] = 0;
					MA6_in_b[7] = 0;
				end
			endcase
		end

		DONE: begin
			case(t)
				0: begin
					MA6_in_a[0] = {{11{data_in[32][7]}}, data_in[32]};
					MA6_in_a[1] = {{11{data_in[33][7]}}, data_in[33]};
					MA6_in_a[2] = {{11{data_in[34][7]}}, data_in[34]};
					MA6_in_a[3] = {{11{data_in[35][7]}}, data_in[35]};
					MA6_in_a[4] = {{11{data_in[36][7]}}, data_in[36]};
					MA6_in_a[5] = {{11{data_in[37][7]}}, data_in[37]};
					MA6_in_a[6] = {{11{data_in[38][7]}}, data_in[38]};
					MA6_in_a[7] = {{11{data_in[39][7]}}, data_in[39]};

					MA6_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA6_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA6_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA6_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA6_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA6_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA6_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA6_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				default: begin
					MA6_in_a[0] = 0;
					MA6_in_a[1] = 0;
					MA6_in_a[2] = 0;
					MA6_in_a[3] = 0;
					MA6_in_a[4] = 0;
					MA6_in_a[5] = 0;
					MA6_in_a[6] = 0;
					MA6_in_a[7] = 0;
					MA6_in_b[0] = 0;
					MA6_in_b[1] = 0;
					MA6_in_b[2] = 0;
					MA6_in_b[3] = 0;
					MA6_in_b[4] = 0;
					MA6_in_b[5] = 0;
					MA6_in_b[6] = 0;
					MA6_in_b[7] = 0;
				end
			endcase
		end
		default: begin
			MA6_in_a[0] = 0;
			MA6_in_a[1] = 0;
			MA6_in_a[2] = 0;
			MA6_in_a[3] = 0;
			MA6_in_a[4] = 0;
			MA6_in_a[5] = 0;
			MA6_in_a[6] = 0;
			MA6_in_a[7] = 0;
			MA6_in_b[0] = 0;
			MA6_in_b[1] = 0;
			MA6_in_b[2] = 0;
			MA6_in_b[3] = 0;
			MA6_in_b[4] = 0;
			MA6_in_b[5] = 0;
			MA6_in_b[6] = 0;
			MA6_in_b[7] = 0;
		end
	endcase
end

always@(*) begin  //MA7
	case(State)
		READ_K: begin
			case(t)
				0,57: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA7_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA7_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA7_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA7_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA7_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA7_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA7_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				1,58: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA7_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA7_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA7_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA7_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA7_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA7_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA7_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				2,59: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA7_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA7_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA7_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA7_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA7_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA7_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA7_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				3,60: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA7_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA7_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA7_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA7_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA7_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA7_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA7_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				4,61: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA7_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA7_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA7_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA7_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA7_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA7_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA7_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				5,62: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA7_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA7_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA7_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA7_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA7_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA7_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA7_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				6,63: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA7_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA7_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA7_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA7_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA7_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA7_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA7_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end
				7: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA7_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA7_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA7_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA7_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA7_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA7_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA7_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end

				default: begin
					MA7_in_a[0] = 0;
					MA7_in_a[1] = 0;
					MA7_in_a[2] = 0;
					MA7_in_a[3] = 0;
					MA7_in_a[4] = 0;
					MA7_in_a[5] = 0;
					MA7_in_a[6] = 0;
					MA7_in_a[7] = 0;
					MA7_in_b[0] = 0;
					MA7_in_b[1] = 0;
					MA7_in_b[2] = 0;
					MA7_in_b[3] = 0;
					MA7_in_b[4] = 0;
					MA7_in_b[5] = 0;
					MA7_in_b[6] = 0;
					MA7_in_b[7] = 0;
				end
			endcase
		end
		READ_V: begin
			case(t)
				0: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA7_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA7_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA7_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA7_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA7_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA7_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA7_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				1: begin
					MA7_in_a[0] = xW[56];
					MA7_in_a[1] = xW[57];
					MA7_in_a[2] = xW[58];
					MA7_in_a[3] = xW[59];
					MA7_in_a[4] = xW[60];
					MA7_in_a[5] = xW[61];
					MA7_in_a[6] = xW[62];
					MA7_in_a[7] = xW[63];

					MA7_in_b[0] =  QK_T[0];
					MA7_in_b[1] =  QK_T[8];
					MA7_in_b[2] =  QK_T[16];
					MA7_in_b[3] =  QK_T[24];
					MA7_in_b[4] =  QK_T[32];
					MA7_in_b[5] =  QK_T[40];
					MA7_in_b[6] =  QK_T[48];
					MA7_in_b[7] =  QK_T[56];
				end
				2: begin
					MA7_in_a[0] = xW[56];
					MA7_in_a[1] = xW[57];
					MA7_in_a[2] = xW[58];
					MA7_in_a[3] = xW[59];
					MA7_in_a[4] = xW[60];
					MA7_in_a[5] = xW[61];
					MA7_in_a[6] = xW[62];
					MA7_in_a[7] = xW[63];

					MA7_in_b[0] =  QK_T[1];
					MA7_in_b[1] =  QK_T[9];
					MA7_in_b[2] =  QK_T[17];
					MA7_in_b[3] =  QK_T[25];
					MA7_in_b[4] =  QK_T[33];
					MA7_in_b[5] =  QK_T[41];
					MA7_in_b[6] =  QK_T[49];
					MA7_in_b[7] =  QK_T[57];
				end
				3: begin
					MA7_in_a[0] = xW[56];
					MA7_in_a[1] = xW[57];
					MA7_in_a[2] = xW[58];
					MA7_in_a[3] = xW[59];
					MA7_in_a[4] = xW[60];
					MA7_in_a[5] = xW[61];
					MA7_in_a[6] = xW[62];
					MA7_in_a[7] = xW[63];

					MA7_in_b[0] = QK_T[2];
					MA7_in_b[1] = QK_T[10];
					MA7_in_b[2] = QK_T[18];
					MA7_in_b[3] = QK_T[26];
					MA7_in_b[4] = QK_T[34];
					MA7_in_b[5] = QK_T[42];
					MA7_in_b[6] = QK_T[50];
					MA7_in_b[7] = QK_T[58];
				end

				4: begin
					MA7_in_a[0] = xW[56];
					MA7_in_a[1] = xW[57];
					MA7_in_a[2] = xW[58];
					MA7_in_a[3] = xW[59];
					MA7_in_a[4] = xW[60];
					MA7_in_a[5] = xW[61];
					MA7_in_a[6] = xW[62];
					MA7_in_a[7] = xW[63];

					MA7_in_b[0] = QK_T[3];
					MA7_in_b[1] = QK_T[11];
					MA7_in_b[2] = QK_T[19];
					MA7_in_b[3] = QK_T[27];
					MA7_in_b[4] = QK_T[35];
					MA7_in_b[5] = QK_T[43];
					MA7_in_b[6] = QK_T[51];
					MA7_in_b[7] = QK_T[59];
				end

				5: begin
					MA7_in_a[0] = xW[56];
					MA7_in_a[1] = xW[57];
					MA7_in_a[2] = xW[58];
					MA7_in_a[3] = xW[59];
					MA7_in_a[4] = xW[60];
					MA7_in_a[5] = xW[61];
					MA7_in_a[6] = xW[62];
					MA7_in_a[7] = xW[63];

					MA7_in_b[0] = QK_T[4];
					MA7_in_b[1] = QK_T[12];
					MA7_in_b[2] = QK_T[20];
					MA7_in_b[3] = QK_T[28];
					MA7_in_b[4] = QK_T[36];
					MA7_in_b[5] = QK_T[44];
					MA7_in_b[6] = QK_T[52];
					MA7_in_b[7] = QK_T[60];
				end

				6: begin
					MA7_in_a[0] = xW[56];
					MA7_in_a[1] = xW[57];
					MA7_in_a[2] = xW[58];
					MA7_in_a[3] = xW[59];
					MA7_in_a[4] = xW[60];
					MA7_in_a[5] = xW[61];
					MA7_in_a[6] = xW[62];
					MA7_in_a[7] = xW[63];

					MA7_in_b[0] = QK_T[5];
					MA7_in_b[1] = QK_T[13];
					MA7_in_b[2] = QK_T[21];
					MA7_in_b[3] = QK_T[29];
					MA7_in_b[4] = QK_T[37];
					MA7_in_b[5] = QK_T[45];
					MA7_in_b[6] = QK_T[53];
					MA7_in_b[7] = QK_T[61];
				end

				7: begin
					MA7_in_a[0] = xW[56];
					MA7_in_a[1] = xW[57];
					MA7_in_a[2] = xW[58];
					MA7_in_a[3] = xW[59];
					MA7_in_a[4] = xW[60];
					MA7_in_a[5] = xW[61];
					MA7_in_a[6] = xW[62];
					MA7_in_a[7] = xW[63];

					MA7_in_b[0] = QK_T[6];
					MA7_in_b[1] = QK_T[14];
					MA7_in_b[2] = QK_T[22];
					MA7_in_b[3] = QK_T[30];
					MA7_in_b[4] = QK_T[38];
					MA7_in_b[5] = QK_T[46];
					MA7_in_b[6] = QK_T[54];
					MA7_in_b[7] = QK_T[62];
				end

				8: begin
					MA7_in_a[0] = xW[56];
					MA7_in_a[1] = xW[57];
					MA7_in_a[2] = xW[58];
					MA7_in_a[3] = xW[59];
					MA7_in_a[4] = xW[60];
					MA7_in_a[5] = xW[61];
					MA7_in_a[6] = xW[62];
					MA7_in_a[7] = xW[63];

					MA7_in_b[0] = QK_T[7];
					MA7_in_b[1] = QK_T[15];
					MA7_in_b[2] = QK_T[23];
					MA7_in_b[3] = QK_T[31];
					MA7_in_b[4] = QK_T[39];
					MA7_in_b[5] = QK_T[47];
					MA7_in_b[6] = QK_T[55];
					MA7_in_b[7] = QK_T[63];
				end
				57: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[0][7]}}, w_in[0]};
					MA7_in_b[1] = {{11{w_in[8][7]}}, w_in[8]};
					MA7_in_b[2] = {{11{w_in[16][7]}}, w_in[16]};
					MA7_in_b[3] = {{11{w_in[24][7]}}, w_in[24]};
					MA7_in_b[4] = {{11{w_in[32][7]}}, w_in[32]};
					MA7_in_b[5] = {{11{w_in[40][7]}}, w_in[40]};
					MA7_in_b[6] = {{11{w_in[48][7]}}, w_in[48]};
					MA7_in_b[7] = {{11{w_in[56][7]}}, w_in[56]};
				end
				58: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[1][7]}}, w_in[1]};
					MA7_in_b[1] = {{11{w_in[9][7]}}, w_in[9]};
					MA7_in_b[2] = {{11{w_in[17][7]}}, w_in[17]};
					MA7_in_b[3] = {{11{w_in[25][7]}}, w_in[25]};
					MA7_in_b[4] = {{11{w_in[33][7]}}, w_in[33]};
					MA7_in_b[5] = {{11{w_in[41][7]}}, w_in[41]};
					MA7_in_b[6] = {{11{w_in[49][7]}}, w_in[49]};
					MA7_in_b[7] = {{11{w_in[57][7]}}, w_in[57]};
				end
				59: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[2][7]}}, w_in[2]};
					MA7_in_b[1] = {{11{w_in[10][7]}}, w_in[10]};
					MA7_in_b[2] = {{11{w_in[18][7]}}, w_in[18]};
					MA7_in_b[3] = {{11{w_in[26][7]}}, w_in[26]};
					MA7_in_b[4] = {{11{w_in[34][7]}}, w_in[34]};
					MA7_in_b[5] = {{11{w_in[42][7]}}, w_in[42]};
					MA7_in_b[6] = {{11{w_in[50][7]}}, w_in[50]};
					MA7_in_b[7] = {{11{w_in[58][7]}}, w_in[58]};
				end
				60: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[3][7]}}, w_in[3]};
					MA7_in_b[1] = {{11{w_in[11][7]}}, w_in[11]};
					MA7_in_b[2] = {{11{w_in[19][7]}}, w_in[19]};
					MA7_in_b[3] = {{11{w_in[27][7]}}, w_in[27]};
					MA7_in_b[4] = {{11{w_in[35][7]}}, w_in[35]};
					MA7_in_b[5] = {{11{w_in[43][7]}}, w_in[43]};
					MA7_in_b[6] = {{11{w_in[51][7]}}, w_in[51]};
					MA7_in_b[7] = {{11{w_in[59][7]}}, w_in[59]};
				end
				61: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[4][7]}}, w_in[4]};
					MA7_in_b[1] = {{11{w_in[12][7]}}, w_in[12]};
					MA7_in_b[2] = {{11{w_in[20][7]}}, w_in[20]};
					MA7_in_b[3] = {{11{w_in[28][7]}}, w_in[28]};
					MA7_in_b[4] = {{11{w_in[36][7]}}, w_in[36]};
					MA7_in_b[5] = {{11{w_in[44][7]}}, w_in[44]};
					MA7_in_b[6] = {{11{w_in[52][7]}}, w_in[52]};
					MA7_in_b[7] = {{11{w_in[60][7]}}, w_in[60]};
				end
				62: begin
					MA7_in_a[0] = {{11{data_in[56][7]}}, data_in[56]};
					MA7_in_a[1] = {{11{data_in[57][7]}}, data_in[57]};
					MA7_in_a[2] = {{11{data_in[58][7]}}, data_in[58]};
					MA7_in_a[3] = {{11{data_in[59][7]}}, data_in[59]};
					MA7_in_a[4] = {{11{data_in[60][7]}}, data_in[60]};
					MA7_in_a[5] = {{11{data_in[61][7]}}, data_in[61]};
					MA7_in_a[6] = {{11{data_in[62][7]}}, data_in[62]};
					MA7_in_a[7] = {{11{data_in[63][7]}}, data_in[63]};

					MA7_in_b[0] = {{11{w_in[5][7]}}, w_in[5]};
					MA7_in_b[1] = {{11{w_in[13][7]}}, w_in[13]};
					MA7_in_b[2] = {{11{w_in[21][7]}}, w_in[21]};
					MA7_in_b[3] = {{11{w_in[29][7]}}, w_in[29]};
					MA7_in_b[4] = {{11{w_in[37][7]}}, w_in[37]};
					MA7_in_b[5] = {{11{w_in[45][7]}}, w_in[45]};
					MA7_in_b[6] = {{11{w_in[53][7]}}, w_in[53]};
					MA7_in_b[7] = {{11{w_in[61][7]}}, w_in[61]};
				end
				63: begin
					MA7_in_a[0] = {{11{data_in[48][7]}}, data_in[48]};
					MA7_in_a[1] = {{11{data_in[49][7]}}, data_in[49]};
					MA7_in_a[2] = {{11{data_in[50][7]}}, data_in[50]};
					MA7_in_a[3] = {{11{data_in[51][7]}}, data_in[51]};
					MA7_in_a[4] = {{11{data_in[52][7]}}, data_in[52]};
					MA7_in_a[5] = {{11{data_in[53][7]}}, data_in[53]};
					MA7_in_a[6] = {{11{data_in[54][7]}}, data_in[54]};
					MA7_in_a[7] = {{11{data_in[55][7]}}, data_in[55]};

					MA7_in_b[0] = {{11{w_in[6][7]}}, w_in[6]};
					MA7_in_b[1] = {{11{w_in[14][7]}}, w_in[14]};
					MA7_in_b[2] = {{11{w_in[22][7]}}, w_in[22]};
					MA7_in_b[3] = {{11{w_in[30][7]}}, w_in[30]};
					MA7_in_b[4] = {{11{w_in[38][7]}}, w_in[38]};
					MA7_in_b[5] = {{11{w_in[46][7]}}, w_in[46]};
					MA7_in_b[6] = {{11{w_in[54][7]}}, w_in[54]};
					MA7_in_b[7] = {{11{w_in[62][7]}}, w_in[62]};
				end


				default: begin
					MA7_in_a[0] = 0;
					MA7_in_a[1] = 0;
					MA7_in_a[2] = 0;
					MA7_in_a[3] = 0;
					MA7_in_a[4] = 0;
					MA7_in_a[5] = 0;
					MA7_in_a[6] = 0;
					MA7_in_a[7] = 0;
					MA7_in_b[0] = 0;
					MA7_in_b[1] = 0;
					MA7_in_b[2] = 0;
					MA7_in_b[3] = 0;
					MA7_in_b[4] = 0;
					MA7_in_b[5] = 0;
					MA7_in_b[6] = 0;
					MA7_in_b[7] = 0;
				end
			endcase
		end

		DONE: begin
			case(t)
				0: begin
					MA7_in_a[0] = {{11{data_in[40][7]}}, data_in[40]};
					MA7_in_a[1] = {{11{data_in[41][7]}}, data_in[41]};
					MA7_in_a[2] = {{11{data_in[42][7]}}, data_in[42]};
					MA7_in_a[3] = {{11{data_in[43][7]}}, data_in[43]};
					MA7_in_a[4] = {{11{data_in[44][7]}}, data_in[44]};
					MA7_in_a[5] = {{11{data_in[45][7]}}, data_in[45]};
					MA7_in_a[6] = {{11{data_in[46][7]}}, data_in[46]};
					MA7_in_a[7] = {{11{data_in[47][7]}}, data_in[47]};

					MA7_in_b[0] = {{11{w_in[7][7]}}, w_in[7]};
					MA7_in_b[1] = {{11{w_in[15][7]}}, w_in[15]};
					MA7_in_b[2] = {{11{w_in[23][7]}}, w_in[23]};
					MA7_in_b[3] = {{11{w_in[31][7]}}, w_in[31]};
					MA7_in_b[4] = {{11{w_in[39][7]}}, w_in[39]};
					MA7_in_b[5] = {{11{w_in[47][7]}}, w_in[47]};
					MA7_in_b[6] = {{11{w_in[55][7]}}, w_in[55]};
					MA7_in_b[7] = {{11{w_in[63][7]}}, w_in[63]};
				end
				default: begin
					MA7_in_a[0] = 0;
					MA7_in_a[1] = 0;
					MA7_in_a[2] = 0;
					MA7_in_a[3] = 0;
					MA7_in_a[4] = 0;
					MA7_in_a[5] = 0;
					MA7_in_a[6] = 0;
					MA7_in_a[7] = 0;
					MA7_in_b[0] = 0;
					MA7_in_b[1] = 0;
					MA7_in_b[2] = 0;
					MA7_in_b[3] = 0;
					MA7_in_b[4] = 0;
					MA7_in_b[5] = 0;
					MA7_in_b[6] = 0;
					MA7_in_b[7] = 0;
				end
			endcase
		end
		default: begin
			MA7_in_a[0] = 0;
			MA7_in_a[1] = 0;
			MA7_in_a[2] = 0;
			MA7_in_a[3] = 0;
			MA7_in_a[4] = 0;
			MA7_in_a[5] = 0;
			MA7_in_a[6] = 0;
			MA7_in_a[7] = 0;
			MA7_in_b[0] = 0;
			MA7_in_b[1] = 0;
			MA7_in_b[2] = 0;
			MA7_in_b[3] = 0;
			MA7_in_b[4] = 0;
			MA7_in_b[5] = 0;
			MA7_in_b[6] = 0;
			MA7_in_b[7] = 0;
		end
	endcase
end

always@(*) begin  //DR0
	case(State)
		READ_V: begin
			case(t)
				// t = 2
				2: begin
					DR0_in = QK_T[0];
				end

				// t = 3
				3: begin
					DR0_in = QK_T[1];
				end

				// t = 4
				4: begin
					DR0_in = QK_T[2];
				end

				// t = 5
				5: begin
					DR0_in = QK_T[3];
				end

				// t = 6
				6: begin
					DR0_in = QK_T[4];
				end

				// t = 7
				7: begin
					DR0_in = QK_T[5];
				end

				// t = 8
				8: begin
					DR0_in = QK_T[6];
				end

				// t = 9
				9: begin
					DR0_in = QK_T[7];
				end

				// t = 10
				10: begin
					DR0_in = QK_T[8];
				end

				// t = 11
				11: begin
					DR0_in = QK_T[9];
				end

				// t = 12
				12: begin
					DR0_in = QK_T[10];
				end

				// t = 13
				13: begin
					DR0_in = QK_T[11];
				end

				// t = 14
				14: begin
					DR0_in = QK_T[12];
				end

				// t = 15
				15: begin
					DR0_in = QK_T[13];
				end

				// t = 16
				16: begin
					DR0_in = QK_T[14];
				end

				// t = 17
				17: begin
					DR0_in = QK_T[15];
				end

				// t = 18
				18: begin
					DR0_in = QK_T[16];
				end

				// t = 19
				19: begin
					DR0_in = QK_T[17];
				end

				// t = 20
				20: begin
					DR0_in = QK_T[18];
				end

				// t = 21
				21: begin
					DR0_in = QK_T[19];
				end

				// t = 22
				22: begin
					DR0_in = QK_T[20];
				end

				// t = 23
				23: begin
					DR0_in = QK_T[21];
				end

				// t = 24
				24: begin
					DR0_in = QK_T[22];
				end

				// t = 25
				25: begin
					DR0_in = QK_T[23];
				end

				// t = 26
				26: begin
					DR0_in = QK_T[24];
				end

				// t = 27
				27: begin
					DR0_in = QK_T[25];
				end

				// t = 28
				28: begin
					DR0_in = QK_T[26];
				end

				// t = 29
				29: begin
					DR0_in = QK_T[27];
				end

				// t = 30
				30: begin
					DR0_in = QK_T[28];
				end

				// t = 31
				31: begin
					DR0_in = QK_T[29];
				end

				// t = 32
				32: begin
					DR0_in = QK_T[30];
				end

				// t = 33
				33: begin
					DR0_in = QK_T[31];
				end

				// t = 34
				34: begin
					DR0_in = QK_T[32];
				end

				// t = 35
				35: begin
					DR0_in = QK_T[33];
				end

				// t = 36
				36: begin
					DR0_in = QK_T[34];
				end

				// t = 37
				37: begin
					DR0_in = QK_T[35];
				end

				// t = 38
				38: begin
					DR0_in = QK_T[36];
				end

				// t = 39
				39: begin
					DR0_in = QK_T[37];
				end

				// t = 40
				40: begin
					DR0_in = QK_T[38];
				end

				// t = 41
				41: begin
					DR0_in = QK_T[39];
				end

				// t = 42
				42: begin
					DR0_in = QK_T[40];
				end

				// t = 43
				43: begin
					DR0_in = QK_T[41];
				end

				// t = 44
				44: begin
					DR0_in = QK_T[42];
				end

				// t = 45
				45: begin
					DR0_in = QK_T[43];
				end

				// t = 46
				46: begin
					DR0_in = QK_T[44];
				end

				// t = 47
				47: begin
					DR0_in = QK_T[45];
				end

				// t = 48
				48: begin
					DR0_in = QK_T[46];
				end

				// t = 49
				49: begin
					DR0_in = QK_T[47];
				end

				// t = 50
				50: begin
					DR0_in = QK_T[48];
				end

				// t = 51
				51: begin
					DR0_in = QK_T[49];
				end

				// t = 52
				52: begin
					DR0_in = QK_T[50];
				end

				// t = 53
				53: begin
					DR0_in = QK_T[51];
				end

				// t = 54
				54: begin
					DR0_in = QK_T[52];
				end

				// t = 55
				55: begin
					DR0_in = QK_T[53];
				end

				// t = 56
				56: begin
					DR0_in = QK_T[54];
				end

				// t = 57
				57: begin
					DR0_in = QK_T[55];
				end

				// t = 58
				58: begin
					DR0_in = QK_T[56];
				end

				// t = 59
				59: begin
					DR0_in = QK_T[57];
				end

				// t = 60
				60: begin
					DR0_in = QK_T[58];
				end

				// t = 61
				61: begin
					DR0_in = QK_T[59];
				end

				// t = 62
				62: begin
					DR0_in = QK_T[60];
				end

				// t = 63
				63: begin
					DR0_in = QK_T[61];
				end

				default: begin
					// Optional: Assign a default value to DR0_in
					DR0_in = 0;
				end
			endcase
		end

		DONE: begin
			case(t)
				0: begin
					DR0_in = QK_T[62];
				end
				1: begin
					DR0_in = QK_T[63];
				end
				default: begin
					DR0_in = 0;
				end
			endcase
		end
		default: begin
			DR0_in = 0;
		end
	endcase
end






always@(*) begin  //MA0_8
	MA0_in_8[0] = data_in[0];
	MA0_in_8[1] = data_in[1];
	MA0_in_8[2] = data_in[2];
	MA0_in_8[3] = data_in[3];
	MA0_in_8[4] = data_in[4];
	MA0_in_8[5] = data_in[5];
	MA0_in_8[6] = data_in[6];
	MA0_in_8[7] = data_in[7];

	if(State == READ_V && t == 0)begin
		MA0_in_8[8] =  w_in[7];
		MA0_in_8[9] =   w_in[15];
		MA0_in_8[10] =  w_in[23];
		MA0_in_8[11] =  w_in[31];
		MA0_in_8[12] =  w_in[39];
		MA0_in_8[13] =  w_in[47];
		MA0_in_8[14] =  w_in[55];
		MA0_in_8[15] =  w_in[63];
	end
	else begin
		case(t)
			0,57: begin
				MA0_in_8[8] =  w_in[0];
				MA0_in_8[9] =  w_in[8];
				MA0_in_8[10] = w_in[16];
				MA0_in_8[11] = w_in[24];
				MA0_in_8[12] = w_in[32];
				MA0_in_8[13] = w_in[40];
				MA0_in_8[14] = w_in[48];
				MA0_in_8[15] = w_in[56];
			end
			1,58: begin

				MA0_in_8[8] =  w_in[1];
				MA0_in_8[9] =  w_in[9];
				MA0_in_8[10] = w_in[17];
				MA0_in_8[11] = w_in[25];
				MA0_in_8[12] = w_in[33];
				MA0_in_8[13] = w_in[41];
				MA0_in_8[14] = w_in[49];
				MA0_in_8[15] = w_in[57];
			end
			2,59: begin
				MA0_in_8[8] =  w_in[2];
				MA0_in_8[9] =   w_in[10];
				MA0_in_8[10] =  w_in[18];
				MA0_in_8[11] =  w_in[26];
				MA0_in_8[12] =  w_in[34];
				MA0_in_8[13] =  w_in[42];
				MA0_in_8[14] =  w_in[50];
				MA0_in_8[15] =  w_in[58];
			end
			3,60: begin
				MA0_in_8[8] =  w_in[3];
				MA0_in_8[9] =   w_in[11];
				MA0_in_8[10] =  w_in[19];
				MA0_in_8[11] =  w_in[27];
				MA0_in_8[12] =  w_in[35];
				MA0_in_8[13] =  w_in[43];
				MA0_in_8[14] =  w_in[51];
				MA0_in_8[15] =  w_in[59];
			end
			4,61: begin
				MA0_in_8[8] = w_in[4];
				MA0_in_8[9] =  w_in[12];
				MA0_in_8[10] = w_in[20];
				MA0_in_8[11] = w_in[28];
				MA0_in_8[12] = w_in[36];
				MA0_in_8[13] = w_in[44];
				MA0_in_8[14] = w_in[52];
				MA0_in_8[15] = w_in[60];
			end
			5,62: begin
				MA0_in_8[8] =  w_in[5];
				MA0_in_8[9] =   w_in[13];
				MA0_in_8[10] =  w_in[21];
				MA0_in_8[11] =  w_in[29];
				MA0_in_8[12] =  w_in[37];
				MA0_in_8[13] =  w_in[45];
				MA0_in_8[14] =  w_in[53];
				MA0_in_8[15] =  w_in[61];
			end
			6,63: begin
				MA0_in_8[8] =  w_in[6];
				MA0_in_8[9] =   w_in[14];
				MA0_in_8[10] =  w_in[22];
				MA0_in_8[11] =  w_in[30];
				MA0_in_8[12] =  w_in[38];
				MA0_in_8[13] =  w_in[46];
				MA0_in_8[14] =  w_in[54];
				MA0_in_8[15] =  w_in[62];
			end
			7: begin


				MA0_in_8[8] = w_in[7];
				MA0_in_8[9] =  w_in[15];
				MA0_in_8[10] = w_in[23];
				MA0_in_8[11] = w_in[31];
				MA0_in_8[12] = w_in[39];
				MA0_in_8[13] = w_in[47];
				MA0_in_8[14] = w_in[55];
				MA0_in_8[15] = w_in[63];
			end

			default: begin
				MA0_in_8[8] =  0;
				MA0_in_8[9] =  0;
				MA0_in_8[10] = 0;
				MA0_in_8[11] = 0;
				MA0_in_8[12] = 0;
				MA0_in_8[13] = 0;
				MA0_in_8[14] = 0;
				MA0_in_8[15] = 0;
			end
		endcase
	end
end

always@(*) begin  //MA0_19
	MA0_in_19[0] = xW[0];
	MA0_in_19[1] = xW[1];
	MA0_in_19[2] = xW[2];
	MA0_in_19[3] = xW[3];
	MA0_in_19[4] = xW[4];
	MA0_in_19[5] = xW[5];
	MA0_in_19[6] = xW[6];
	MA0_in_19[7] = xW[7];

	if(State == READ_V && !(t == 63)) begin
		case(t)
			1: begin
				MA0_in_19[8]  =  QK_T[0][18:0];
				MA0_in_19[9]  =  QK_T[8][18:0];
				MA0_in_19[10] =  QK_T[16][18:0];
				MA0_in_19[11] =  QK_T[24][18:0];
				MA0_in_19[12] =  QK_T[32][18:0];
				MA0_in_19[13] =  QK_T[40][18:0];
				MA0_in_19[14] =  QK_T[48][18:0];
				MA0_in_19[15] =  QK_T[56][18:0];
			end
			2: begin
				MA0_in_19[8]  =  QK_T[1][18:0];
				MA0_in_19[9]  =  QK_T[9][18:0];
				MA0_in_19[10] =  QK_T[17][18:0];
				MA0_in_19[11] =  QK_T[25][18:0];
				MA0_in_19[12] =  QK_T[33][18:0];
				MA0_in_19[13] =  QK_T[41][18:0];
				MA0_in_19[14] =  QK_T[49][18:0];
				MA0_in_19[15] =  QK_T[57][18:0];
			end
			3: begin
				MA0_in_19[8]  = QK_T[2][18:0];
				MA0_in_19[9]  = QK_T[10][18:0];
				MA0_in_19[10] = QK_T[18][18:0];
				MA0_in_19[11] = QK_T[26][18:0];
				MA0_in_19[12] = QK_T[34][18:0];
				MA0_in_19[13] = QK_T[42][18:0];
				MA0_in_19[14] = QK_T[50][18:0];
				MA0_in_19[15] = QK_T[58][18:0];
			end

			4: begin
				MA0_in_19[8]  = QK_T[3][18:0];
				MA0_in_19[9]  = QK_T[11][18:0];
				MA0_in_19[10] = QK_T[19][18:0];
				MA0_in_19[11] = QK_T[27][18:0];
				MA0_in_19[12] = QK_T[35][18:0];
				MA0_in_19[13] = QK_T[43][18:0];
				MA0_in_19[14] = QK_T[51][18:0];
				MA0_in_19[15] = QK_T[59][18:0];
			end

			5: begin
				MA0_in_19[8]  = QK_T[4][18:0];
				MA0_in_19[9]  = QK_T[12][18:0];
				MA0_in_19[10] = QK_T[20][18:0];
				MA0_in_19[11] = QK_T[28][18:0];
				MA0_in_19[12] = QK_T[36][18:0];
				MA0_in_19[13] = QK_T[44][18:0];
				MA0_in_19[14] = QK_T[52][18:0];
				MA0_in_19[15] = QK_T[60][18:0];
			end

			6: begin
				MA0_in_19[8]  = QK_T[5][18:0];
				MA0_in_19[9]  = QK_T[13][18:0];
				MA0_in_19[10] = QK_T[21][18:0];
				MA0_in_19[11] = QK_T[29][18:0];
				MA0_in_19[12] = QK_T[37][18:0];
				MA0_in_19[13] = QK_T[45][18:0];
				MA0_in_19[14] = QK_T[53][18:0];
				MA0_in_19[15] = QK_T[61][18:0];
			end

			7: begin
				MA0_in_19[8]  = QK_T[6][18:0];
				MA0_in_19[9]  = QK_T[14][18:0];
				MA0_in_19[10] = QK_T[22][18:0];
				MA0_in_19[11] = QK_T[30][18:0];
				MA0_in_19[12] = QK_T[38][18:0];
				MA0_in_19[13] = QK_T[46][18:0];
				MA0_in_19[14] = QK_T[54][18:0];
				MA0_in_19[15] = QK_T[62][18:0];
			end

			8: begin
				MA0_in_19[8]  = QK_T[7][18:0];
				MA0_in_19[9]  = QK_T[15][18:0];
				MA0_in_19[10] = QK_T[23][18:0];
				MA0_in_19[11] = QK_T[31][18:0];
				MA0_in_19[12] = QK_T[39][18:0];
				MA0_in_19[13] = QK_T[47][18:0];
				MA0_in_19[14] = QK_T[55][18:0];
				MA0_in_19[15] = QK_T[63][18:0];
			end
			default: begin
				MA0_in_19[8]  = 0;
				MA0_in_19[9]  = 0;
				MA0_in_19[10] = 0;
				MA0_in_19[11] = 0;
				MA0_in_19[12] = 0;
				MA0_in_19[13] = 0;
				MA0_in_19[14] = 0;
				MA0_in_19[15] = 0;
			end
		endcase
	end
	else begin
		case(t[2:0])
			0: begin


				MA0_in_19[8]  =  xW[1];
				MA0_in_19[9]  =  xW[9];
				MA0_in_19[10] =  xW[17];
				MA0_in_19[11] =  xW[25];
				MA0_in_19[12] =  xW[33];
				MA0_in_19[13] =  xW[41];
				MA0_in_19[14] =  xW[49];
				MA0_in_19[15] =  xW[57];
			end
			1: begin


				MA0_in_19[8]  =  xW[2];
				MA0_in_19[9]  =  xW[10];
				MA0_in_19[10] =  xW[18];
				MA0_in_19[11] =  xW[26];
				MA0_in_19[12] =  xW[34];
				MA0_in_19[13] =  xW[42];
				MA0_in_19[14] =  xW[50];
				MA0_in_19[15] =  xW[58];
			end
			2: begin


				MA0_in_19[8]  = xW[3];
				MA0_in_19[9]  = xW[11];
				MA0_in_19[10] = xW[19];
				MA0_in_19[11] = xW[27];
				MA0_in_19[12] = xW[35];
				MA0_in_19[13] = xW[43];
				MA0_in_19[14] = xW[51];
				MA0_in_19[15] = xW[59];
			end
			3: begin


				MA0_in_19[8]  = xW[4];
				MA0_in_19[9]  = xW[12];
				MA0_in_19[10] = xW[20];
				MA0_in_19[11] = xW[28];
				MA0_in_19[12] = xW[36];
				MA0_in_19[13] = xW[44];
				MA0_in_19[14] = xW[52];
				MA0_in_19[15] = xW[60];
			end
			4: begin


				MA0_in_19[8]  = xW[5];
				MA0_in_19[9]  = xW[13];
				MA0_in_19[10] = xW[21];
				MA0_in_19[11] = xW[29];
				MA0_in_19[12] = xW[37];
				MA0_in_19[13] = xW[45];
				MA0_in_19[14] = xW[53];
				MA0_in_19[15] = xW[61];
			end
			5: begin


				MA0_in_19[8]  = xW[6];
				MA0_in_19[9]  = xW[14];
				MA0_in_19[10] = xW[22];
				MA0_in_19[11] = xW[30];
				MA0_in_19[12] = xW[38];
				MA0_in_19[13] = xW[46];
				MA0_in_19[14] = xW[54];
				MA0_in_19[15] = xW[62];
			end
			6: begin


				MA0_in_19[8]  = xW[7];
				MA0_in_19[9]  = xW[15];
				MA0_in_19[10] = xW[23];
				MA0_in_19[11] = xW[31];
				MA0_in_19[12] = xW[39];
				MA0_in_19[13] = xW[47];
				MA0_in_19[14] = xW[55];
				MA0_in_19[15] = xW[63];
			end
			7: begin
				MA0_in_19[8]  = xW[0];
				MA0_in_19[9]  = xW[8];
				MA0_in_19[10] = xW[16];
				MA0_in_19[11] = xW[24];
				MA0_in_19[12] = xW[32];
				MA0_in_19[13] = xW[40];
				MA0_in_19[14] = xW[48];
				MA0_in_19[15] = xW[56];
			end
		endcase
	end
end

always@(*) begin  //MA0_41
	case(t)
		63, 0, 1, 2, 3, 4, 5, 6: begin
			MA0_in_41[0]  = QK_T[0];
			MA0_in_41[1]  = QK_T[1];
			MA0_in_41[2]  = QK_T[2];
			MA0_in_41[3]  = QK_T[3];
			MA0_in_41[4]  = QK_T[4];
			MA0_in_41[5]  = QK_T[5];
			MA0_in_41[6]  = QK_T[6];
			MA0_in_41[7]  = QK_T[7];
		end
		7, 8, 9, 10, 11, 12, 13, 14: begin
			MA0_in_41[0]  = QK_T[8];
			MA0_in_41[1]  = QK_T[9];
			MA0_in_41[2]  = QK_T[10];
			MA0_in_41[3]  = QK_T[11];
			MA0_in_41[4]  = QK_T[12];
			MA0_in_41[5]  = QK_T[13];
			MA0_in_41[6]  = QK_T[14];
			MA0_in_41[7]  = QK_T[15];
		end
		15, 16, 17, 18, 19, 20, 21, 22: begin
			MA0_in_41[0]  = QK_T[16];
			MA0_in_41[1]  = QK_T[17];
			MA0_in_41[2]  = QK_T[18];
			MA0_in_41[3]  = QK_T[19];
			MA0_in_41[4]  = QK_T[20];
			MA0_in_41[5]  = QK_T[21];
			MA0_in_41[6]  = QK_T[22];
			MA0_in_41[7]  = QK_T[23];
		end
		23, 24, 25, 26, 27, 28, 29, 30: begin
			MA0_in_41[0]  = QK_T[24];
			MA0_in_41[1]  = QK_T[25];
			MA0_in_41[2]  = QK_T[26];
			MA0_in_41[3]  = QK_T[27];
			MA0_in_41[4]  = QK_T[28];
			MA0_in_41[5]  = QK_T[29];
			MA0_in_41[6]  = QK_T[30];
			MA0_in_41[7]  = QK_T[31];
		end
		31, 32, 33, 34, 35, 36, 37, 38: begin
			MA0_in_41[0]  = QK_T[32];
			MA0_in_41[1]  = QK_T[33];
			MA0_in_41[2]  = QK_T[34];
			MA0_in_41[3]  = QK_T[35];
			MA0_in_41[4]  = QK_T[36];
			MA0_in_41[5]  = QK_T[37];
			MA0_in_41[6]  = QK_T[38];
			MA0_in_41[7]  = QK_T[39];
		end
		39, 40, 41, 42, 43, 44, 45, 46: begin
			MA0_in_41[0]  = QK_T[40];
			MA0_in_41[1]  = QK_T[41];
			MA0_in_41[2]  = QK_T[42];
			MA0_in_41[3]  = QK_T[43];
			MA0_in_41[4]  = QK_T[44];
			MA0_in_41[5]  = QK_T[45];
			MA0_in_41[6]  = QK_T[46];
			MA0_in_41[7]  = QK_T[47];
		end
		47, 48, 49, 50, 51, 52, 53, 54: begin
			MA0_in_41[0]  = QK_T[48];
			MA0_in_41[1]  = QK_T[49];
			MA0_in_41[2]  = QK_T[50];
			MA0_in_41[3]  = QK_T[51];
			MA0_in_41[4]  = QK_T[52];
			MA0_in_41[5]  = QK_T[53];
			MA0_in_41[6]  = QK_T[54];
			MA0_in_41[7]  = QK_T[55];
		end
		55, 56, 57, 58, 59, 60, 61, 62: begin
			MA0_in_41[0]  = QK_T[56];
			MA0_in_41[1]  = QK_T[57];
			MA0_in_41[2]  = QK_T[58];
			MA0_in_41[3]  = QK_T[59];
			MA0_in_41[4]  = QK_T[60];
			MA0_in_41[5]  = QK_T[61];
			MA0_in_41[6]  = QK_T[62];
			MA0_in_41[7]  = QK_T[63];
		end
	endcase
end


always@(*) begin
	if((State == READ_V&&t == 63) || State == DONE) begin
		MA0_in_a[0] = MA0_in_41[0];
		MA0_in_a[1] = MA0_in_41[1];
		MA0_in_a[2] = MA0_in_41[2];
		MA0_in_a[3] = MA0_in_41[3];
		MA0_in_a[4] = MA0_in_41[4];
		MA0_in_a[5] = MA0_in_41[5];
		MA0_in_a[6] = MA0_in_41[6];
		MA0_in_a[7] = MA0_in_41[7];
	end
	else if(State == READ_V && t>0&&t<9)begin
		MA0_in_a[0] = {{22{MA0_in_19[0][18]}},MA0_in_19[0]};
		MA0_in_a[1] = {{22{MA0_in_19[1][18]}},MA0_in_19[1]};
		MA0_in_a[2] = {{22{MA0_in_19[2][18]}},MA0_in_19[2]};
		MA0_in_a[3] = {{22{MA0_in_19[3][18]}},MA0_in_19[3]};
		MA0_in_a[4] = {{22{MA0_in_19[4][18]}},MA0_in_19[4]};
		MA0_in_a[5] = {{22{MA0_in_19[5][18]}},MA0_in_19[5]};
		MA0_in_a[6] = {{22{MA0_in_19[6][18]}},MA0_in_19[6]};
		MA0_in_a[7] = {{22{MA0_in_19[7][18]}},MA0_in_19[7]};
	end
	else begin
		MA0_in_a[0] = {{33{MA0_in_8[0][7]}},MA0_in_8[0]};
		MA0_in_a[1] = {{33{MA0_in_8[1][7]}},MA0_in_8[1]};
		MA0_in_a[2] = {{33{MA0_in_8[2][7]}},MA0_in_8[2]};
		MA0_in_a[3] = {{33{MA0_in_8[3][7]}},MA0_in_8[3]};
		MA0_in_a[4] = {{33{MA0_in_8[4][7]}},MA0_in_8[4]};
		MA0_in_a[5] = {{33{MA0_in_8[5][7]}},MA0_in_8[5]};
		MA0_in_a[6] = {{33{MA0_in_8[6][7]}},MA0_in_8[6]};
		MA0_in_a[7] = {{33{MA0_in_8[7][7]}},MA0_in_8[7]};
	end
end

always@(*) begin
	if((State == READ_V&&t == 63) || State == DONE) begin
		MA0_in_b[0] = MA0_in_19[8];
		MA0_in_b[1] = MA0_in_19[9];
		MA0_in_b[2] = MA0_in_19[10];
		MA0_in_b[3] = MA0_in_19[11];
		MA0_in_b[4] = MA0_in_19[12];
		MA0_in_b[5] = MA0_in_19[13];
		MA0_in_b[6] = MA0_in_19[14];
		MA0_in_b[7] = MA0_in_19[15];
	end
	else if(State == READ_V && t>0&&t<9)begin
		MA0_in_b[0] = MA0_in_19[8];
		MA0_in_b[1] = MA0_in_19[9];
		MA0_in_b[2] = MA0_in_19[10];
		MA0_in_b[3] = MA0_in_19[11];
		MA0_in_b[4] = MA0_in_19[12];
		MA0_in_b[5] = MA0_in_19[13];
		MA0_in_b[6] = MA0_in_19[14];
		MA0_in_b[7] = MA0_in_19[15];
	end
	else begin
		MA0_in_b[0] = {{11{MA0_in_8[8][7]}},MA0_in_8[8]};
		MA0_in_b[1] = {{11{MA0_in_8[9][7]}},MA0_in_8[9]};
		MA0_in_b[2] = {{11{MA0_in_8[10][7]}},MA0_in_8[10]};
		MA0_in_b[3] = {{11{MA0_in_8[11][7]}},MA0_in_8[11]};
		MA0_in_b[4] = {{11{MA0_in_8[12][7]}},MA0_in_8[12]};
		MA0_in_b[5] = {{11{MA0_in_8[13][7]}},MA0_in_8[13]};
		MA0_in_b[6] = {{11{MA0_in_8[14][7]}},MA0_in_8[14]};
		MA0_in_b[7] = {{11{MA0_in_8[15][7]}},MA0_in_8[15]};
	end
end















endmodule



module MA_41(
	M1_1, M1_2, M1_3, M1_4, M1_5, M1_6, M1_7, M1_8,
	M2_1, M2_2, M2_3, M2_4, M2_5, M2_6, M2_7, M2_8,

	result
);

input signed [40:0] M1_1, M1_2, M1_3, M1_4, M1_5, M1_6, M1_7, M1_8;
input signed [18:0]	M2_1, M2_2, M2_3, M2_4, M2_5, M2_6, M2_7, M2_8;

output reg signed [62:0] result;

wire signed [59:0] temp[0:7];

reg signed [60:0] sum0;
reg signed [60:0] sum1;
reg signed [60:0] sum2;
reg signed [60:0] sum3;
reg signed [61:0] sum4;
reg signed [62:0] sum5;

assign temp[0] = M1_1*M2_1;
assign temp[1] = M1_2*M2_2;
assign temp[2] = M1_3*M2_3;
assign temp[3] = M1_4*M2_4;
assign temp[4] = M1_5*M2_5;
assign temp[5] = M1_6*M2_6;
assign temp[6] = M1_7*M2_7;
assign temp[7] = M1_8*M2_8;

// assign result = ((((temp[0])+(temp[1]))+((temp[2])+(temp[3])))+(((temp[4])+(temp[5]))+((temp[6])+(temp[7]))));

always @(*) begin
    sum0 = temp[0] + temp[1];
    sum1 = temp[2] + temp[3];
    sum2 = temp[4] + temp[5];
    sum3 = temp[6] + temp[7];

    sum4 = sum0 + sum1;
    sum5 = sum2 + sum3;
    
    result = sum4 + sum5;
end

endmodule

module MA_19(
	M1_1, M1_2, M1_3, M1_4, M1_5, M1_6, M1_7, M1_8,
	M2_1, M2_2, M2_3, M2_4, M2_5, M2_6, M2_7, M2_8,

	result
);

input signed [18:0] M1_1, M1_2, M1_3, M1_4, M1_5, M1_6, M1_7, M1_8;
input signed [18:0]	M2_1, M2_2, M2_3, M2_4, M2_5, M2_6, M2_7, M2_8;

output reg signed [40:0] result;

wire signed [37:0] temp[0:7];

assign temp[0] = M1_1*M2_1;
assign temp[1] = M1_2*M2_2;
assign temp[2] = M1_3*M2_3;
assign temp[3] = M1_4*M2_4;
assign temp[4] = M1_5*M2_5;
assign temp[5] = M1_6*M2_6;
assign temp[6] = M1_7*M2_7;
assign temp[7] = M1_8*M2_8;





assign result = temp[0]+temp[1]+temp[2]+temp[3]+temp[4]+temp[5]+temp[6]+temp[7];



endmodule




module DIV_RELU(
	in,

	result
);

input signed [40:0] in;


output signed [40:0] result;

wire signed [40:0] temp;

assign temp = in/3;


assign result = (temp[40])? 0: temp;

endmodule












