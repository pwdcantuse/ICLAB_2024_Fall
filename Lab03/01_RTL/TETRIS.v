/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: TETRIS
// FILE NAME: TETRIS.v
// VERSRION: 1.0
// DATE: August 15, 2024
// AUTHOR: Yu-Hsuan Hsu, NYCU IEE
// DESCRIPTION: ICLAB2024FALL / LAB3 / TETRIS
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/
module TETRIS (
	//INPUT
	rst_n,
	clk,
	in_valid,
	tetrominoes,
	position,
	//OUTPUT
	tetris_valid,
	score_valid,
	fail,
	score,
	tetris
);

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
input				rst_n, clk, in_valid;
input		[2:0]	tetrominoes;
input		[2:0]	position;
output reg			tetris_valid, score_valid, fail;
output reg	[3:0]	score;
output reg 	[71:0]	tetris;


//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------

parameter IDLE = 3'd0,
		  PUT = 3'd1,
		  SHIFT = 3'd2,
		  DONE = 3'd4;

integer col;
integer i;
//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------

reg [2:0] in_tetrominoes;
reg [2:0] in_position;


reg [2:0] State, nextState;
// reg [5:0] tetris_mem [0:13];
reg [5:0] tetris_mem [0:11];
reg [5:0] tetris_mem_1 [0:1];
reg [3:0] pixel [0:3];
// reg [3:0] pixel_mem [0:3];
reg [3:0] top_of_column [0:5];
reg [3:0] next_top_of_column [0:5];
reg [3:0] round;
reg [3:0] score_mem;

// reg [3:0] posi_add [0:3];
reg [5:0] next_tetris_mem [0:13];


wire get_score;

////// port /////////




always@ (*) begin
	// if(!rst_n) tetris_valid = 0;
	// else if(State == DONE &&(fail || round == 4'd15)) tetris_valid = (State == DONE &&(fail || round == 4'd15));
	// else tetris_valid = 0;
	tetris_valid = (score_valid &&(fail || round == 4'd15));
end
always@ (*) begin
	// if(!rst_n) score_valid = 0;
	// else if(State == DONE ) score_valid = (State == DONE );
	// else score_valid = 0;
	score_valid = (State == DONE );
end

always@ (*) begin
	// if(!rst_n) fail = 0;
	// else if(State == DONE) fail = (State == DONE)&& (|tetris_mem_1[0])|| (|tetris_mem_1[1]);
	// else fail = 0;
	fail = score_valid&& ((|tetris_mem_1[0])|| (|tetris_mem_1[1]));
end

always@ (*) begin
	if(score_valid) score = score_mem;
	else score = 4'd0;
end
always@ (*) begin
	if(score_valid&&(fail || round == 4'd15)) tetris = {tetris_mem[11], tetris_mem[10], tetris_mem[9], tetris_mem[8], tetris_mem[7], tetris_mem[6]
		, tetris_mem[5], tetris_mem[4], tetris_mem[3], tetris_mem[2], tetris_mem[1], tetris_mem[0]};
	else tetris = 72'd0;
end


//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------

always@(*)begin
	case(State) 
		IDLE: begin
			if(in_valid) nextState = PUT;
			else nextState = State;
		end
		DONE: begin
			nextState = IDLE;
		end
		default: begin
			if(get_score ) nextState = SHIFT;
			else nextState = DONE;
		end
		// default : begin
		// 	nextState = IDLE;
		// end
	endcase
end




assign get_score = (&next_tetris_mem[0]) || (&next_tetris_mem[1]) || (&next_tetris_mem[2]) || (&next_tetris_mem[3]) ||
(&next_tetris_mem[4]) || (&next_tetris_mem[5]) || (&next_tetris_mem[6]) || (&next_tetris_mem[7]) ||
(&next_tetris_mem[8]) || (&next_tetris_mem[9]) || (&next_tetris_mem[10]) || (&next_tetris_mem[11]) ;



always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) State <= IDLE;
	else State <= nextState;
end
always@ (posedge clk ) begin
	in_tetrominoes <= tetrominoes;
	in_position <= position;
end

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		score_mem <= 4'd0;
	end
	else if(State == SHIFT) begin
		score_mem <= score_mem + 4'd1;
	end
	else if(State == DONE&&(fail || round == 4'd15)) begin
		score_mem <= 4'd0;
	end
end

// always@ (posedge clk or negedge rst_n) begin
// 	if(!rst_n) begin
// 		shift_num <= 3'd0;
// 	end
// 	else if(State == CAL) begin
// 		shift_num <= next_shift_num;
// 	end
// 	else if(State == SHIFT) begin
// 		shift_num <= shift_num -3'd1;
// 	end
// end

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		round <= 4'd0;
	end
	else if(State == DONE) begin
		if(fail) round <= 4'd0;
		else round <= round +4'd1;
	end
end

// always@ (posedge clk ) begin
// 	if(State == PUT) begin
// 		for(i = 0; i < 4; i++) begin
// 			if(!(pixel[i]==4'd14||pixel[i]==4'd15)) pixel_mem[i] <= pixel[i];
// 			else pixel_mem[i] <= 4'd13;
// 		end
// 	end
// end

// always@(posedge clk ) begin
// 		if(tetris_mem[11][0]) top_of_column[0] <= 4'd12;
// 		else if(tetris_mem[10][0]) top_of_column[0] <= 4'd11;
// 		else if(tetris_mem[9][0]) top_of_column[0] <= 4'd10;
// 		else if(tetris_mem[8][0]) top_of_column[0] <= 4'd9;
// 		else if(tetris_mem[7][0]) top_of_column[0] <= 4'd8;
// 		else if(tetris_mem[6][0]) top_of_column[0] <= 4'd7;
// 		else if(tetris_mem[5][0]) top_of_column[0] <= 4'd6;
// 		else if(tetris_mem[4][0]) top_of_column[0] <= 4'd5;
// 		else if(tetris_mem[3][0]) top_of_column[0] <= 4'd4;
// 		else if(tetris_mem[2][0]) top_of_column[0] <= 4'd3;
// 		else if(tetris_mem[1][0]) top_of_column[0] <= 4'd2;
// 		else if(tetris_mem[0][0]) top_of_column[0] <= 4'd1;
// 		else top_of_column[0] <= 4'd0;
// 		if(tetris_mem[11][1]) top_of_column[1] <= 4'd12;
// 		else if(tetris_mem[10][1]) top_of_column[1] <= 4'd11;
// 		else if(tetris_mem[9][1]) top_of_column[1] <= 4'd10;
// 		else if(tetris_mem[8][1]) top_of_column[1] <= 4'd9;
// 		else if(tetris_mem[7][1]) top_of_column[1] <= 4'd8;
// 		else if(tetris_mem[6][1]) top_of_column[1] <= 4'd7;
// 		else if(tetris_mem[5][1]) top_of_column[1] <= 4'd6;
// 		else if(tetris_mem[4][1]) top_of_column[1] <= 4'd5;
// 		else if(tetris_mem[3][1]) top_of_column[1] <= 4'd4;
// 		else if(tetris_mem[2][1]) top_of_column[1] <= 4'd3;
// 		else if(tetris_mem[1][1]) top_of_column[1] <= 4'd2;
// 		else if(tetris_mem[0][1]) top_of_column[1] <= 4'd1;
// 		else top_of_column[1] <= 4'd0;
// 		if(tetris_mem[11][2]) top_of_column[2] <= 4'd12;
// 		else if(tetris_mem[10][2]) top_of_column[2] <= 4'd11;
// 		else if(tetris_mem[9][2]) top_of_column[2] <= 4'd10;
// 		else if(tetris_mem[8][2]) top_of_column[2] <= 4'd9;
// 		else if(tetris_mem[7][2]) top_of_column[2] <= 4'd8;
// 		else if(tetris_mem[6][2]) top_of_column[2] <= 4'd7;
// 		else if(tetris_mem[5][2]) top_of_column[2] <= 4'd6;
// 		else if(tetris_mem[4][2]) top_of_column[2] <= 4'd5;
// 		else if(tetris_mem[3][2]) top_of_column[2] <= 4'd4;
// 		else if(tetris_mem[2][2]) top_of_column[2] <= 4'd3;
// 		else if(tetris_mem[1][2]) top_of_column[2] <= 4'd2;
// 		else if(tetris_mem[0][2]) top_of_column[2] <= 4'd1;
// 		else top_of_column[2] <= 4'd0;
// 		if(tetris_mem[11][3]) top_of_column[3] <= 4'd12;
// 		else if(tetris_mem[10][3]) top_of_column[3] <= 4'd11;
// 		else if(tetris_mem[9][3]) top_of_column[3] <= 4'd10;
// 		else if(tetris_mem[8][3]) top_of_column[3] <= 4'd9;
// 		else if(tetris_mem[7][3]) top_of_column[3] <= 4'd8;
// 		else if(tetris_mem[6][3]) top_of_column[3] <= 4'd7;
// 		else if(tetris_mem[5][3]) top_of_column[3] <= 4'd6;
// 		else if(tetris_mem[4][3]) top_of_column[3] <= 4'd5;
// 		else if(tetris_mem[3][3]) top_of_column[3] <= 4'd4;
// 		else if(tetris_mem[2][3]) top_of_column[3] <= 4'd3;
// 		else if(tetris_mem[1][3]) top_of_column[3] <= 4'd2;
// 		else if(tetris_mem[0][3]) top_of_column[3] <= 4'd1;
// 		else top_of_column[3] <= 4'd0;
// 		if(tetris_mem[11][4]) top_of_column[4] <= 4'd12;
// 		else if(tetris_mem[10][4]) top_of_column[4] <= 4'd11;
// 		else if(tetris_mem[9][4]) top_of_column[4] <= 4'd10;
// 		else if(tetris_mem[8][4]) top_of_column[4] <= 4'd9;
// 		else if(tetris_mem[7][4]) top_of_column[4] <= 4'd8;
// 		else if(tetris_mem[6][4]) top_of_column[4] <= 4'd7;
// 		else if(tetris_mem[5][4]) top_of_column[4] <= 4'd6;
// 		else if(tetris_mem[4][4]) top_of_column[4] <= 4'd5;
// 		else if(tetris_mem[3][4]) top_of_column[4] <= 4'd4;
// 		else if(tetris_mem[2][4]) top_of_column[4] <= 4'd3;
// 		else if(tetris_mem[1][4]) top_of_column[4] <= 4'd2;
// 		else if(tetris_mem[0][4]) top_of_column[4] <= 4'd1;
// 		else top_of_column[4] <= 4'd0;
// 		if(tetris_mem[11][5]) top_of_column[5] <= 4'd12;
// 		else if(tetris_mem[10][5]) top_of_column[5] <= 4'd11;
// 		else if(tetris_mem[9][5]) top_of_column[5] <= 4'd10;
// 		else if(tetris_mem[8][5]) top_of_column[5] <= 4'd9;
// 		else if(tetris_mem[7][5]) top_of_column[5] <= 4'd8;
// 		else if(tetris_mem[6][5]) top_of_column[5] <= 4'd7;
// 		else if(tetris_mem[5][5]) top_of_column[5] <= 4'd6;
// 		else if(tetris_mem[4][5]) top_of_column[5] <= 4'd5;
// 		else if(tetris_mem[3][5]) top_of_column[5] <= 4'd4;
// 		else if(tetris_mem[2][5]) top_of_column[5] <= 4'd3;
// 		else if(tetris_mem[1][5]) top_of_column[5] <= 4'd2;
// 		else if(tetris_mem[0][5]) top_of_column[5] <= 4'd1;
// 		else top_of_column[5] <= 4'd0;

// 	// else if(State == DONE&&(fail || round == 4'd15)) begin
// 	// 	for(i = 0; i < 6; i++) begin
// 	// 		top_of_column[i] <= 4'd0;
// 	// 	end
// 	// end
// end


always @(posedge clk) begin
    for (col = 0; col < 6; col = col + 1) begin
        if(tetris_mem[11][col]) 
            top_of_column[col] <= 4'd12;
        else if(tetris_mem[10][col]) 
            top_of_column[col] <= 4'd11;
        else if(tetris_mem[9][col]) 
            top_of_column[col] <= 4'd10;
        else if(tetris_mem[8][col]) 
            top_of_column[col] <= 4'd9;
        else if(tetris_mem[7][col]) 
            top_of_column[col] <= 4'd8;
        else if(tetris_mem[6][col]) 
            top_of_column[col] <= 4'd7;
        else if(tetris_mem[5][col]) 
            top_of_column[col] <= 4'd6;
        else if(tetris_mem[4][col]) 
            top_of_column[col] <= 4'd5;
        else if(tetris_mem[3][col]) 
            top_of_column[col] <= 4'd4;
        else if(tetris_mem[2][col]) 
            top_of_column[col] <= 4'd3;
        else if(tetris_mem[1][col]) 
            top_of_column[col] <= 4'd2;
        else if(tetris_mem[0][col]) 
            top_of_column[col] <= 4'd1;
        else 
            top_of_column[col] <= 4'd0;
    end
end

// always@(posedge clk or negedge rst_n) begin
// 	if(!rst_n) begin
// 		for(i = 0; i < 14; i++) begin
// 			tetris_mem[i] <= 6'd0;
// 		end
// 	end
// 	else if(State == PUT)begin
// 		for(i = 0; i < 14; i++) begin
// 			tetris_mem[i] <= next_tetris_mem[i];
// 		end
// 	end
// 	else if(State == SHIFT) begin
// 		for(i = 0; i < 14; i++) begin
// 			tetris_mem[i] <= next_tetris_mem[i];
// 		end
		
// 	end
// 	else if(State == DONE&&(fail || round == 4'd15)) begin
// 		for(i = 0; i < 14; i++) begin
// 			tetris_mem[i] <= 6'd0;
// 		end
// 	end
// end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 12; i++) begin
			tetris_mem[i] <= 6'd0;
		end
	end
	else if(State == PUT)begin
		for(i = 0; i < 12; i++) begin
			tetris_mem[i] <= next_tetris_mem[i];
		end
	end
	else if(State == SHIFT) begin
		for(i = 0; i < 12; i++) begin
			tetris_mem[i] <= next_tetris_mem[i];
		end
	end
	else if(State == DONE&&(fail || round == 4'd15)) begin
		for(i = 0; i < 12; i++) begin
			tetris_mem[i] <= 6'd0;
		end
	end
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		tetris_mem_1[0] <= 6'd0;
		tetris_mem_1[1] <= 6'd0;
	end
	// else if(State == PUT)begin
	// 	tetris_mem_1[0] <= next_tetris_mem[12];
	// 	tetris_mem_1[1] <= next_tetris_mem[13];
	// end
	// else if(State == SHIFT) begin
	// 	tetris_mem_1[0] <= next_tetris_mem[12];
	// 	tetris_mem_1[1] <= next_tetris_mem[13];
		
	// end
	else if(State == DONE&&(fail || round == 4'd15)) begin
		tetris_mem_1[0] <= 6'd0;
		tetris_mem_1[1] <= 6'd0;
	end
	else begin
		tetris_mem_1[0] <= next_tetris_mem[12];
		tetris_mem_1[1] <= next_tetris_mem[13];
	end
end
//--------------------------------------------------------------------


	
	


//////////////////


// always@(*) begin
// 	for(i = 0; i <12 ; i++)begin
// 		next_tetris_mem[i] = tetris_mem[i];
// 	end
// 	next_tetris_mem[12] = tetris_mem_1[0];
// 	next_tetris_mem[13] = tetris_mem_1[1];
// 	pixel[0] = top_of_column[in_position] ;
// 	pixel[1] = top_of_column[in_position] ;
// 	pixel[2] = top_of_column[in_position] ;
// 	pixel[3] = top_of_column[in_position] ;
// 	if(State == PUT) begin
// 		case(in_tetrominoes) 
// 			3'd0: begin
// 				if(top_of_column[in_position] >= top_of_column[in_position + 1]) begin
// 					pixel[1] = top_of_column[in_position] + 4'd1;
// 					pixel[2] = top_of_column[in_position] + 4'd1;
// 					pixel[0] = top_of_column[in_position];
// 					pixel[3] = top_of_column[in_position];
// 				end
// 				else begin
// 					pixel[1] = top_of_column[in_position + 1]+ 4'd1;
// 					pixel[2] = top_of_column[in_position + 1] + 4'd1;
// 					pixel[0] = top_of_column[in_position + 1];
// 					pixel[3] = top_of_column[in_position + 1];
// 				end
// 				next_tetris_mem[pixel[0]][in_position] = 1;
// 				next_tetris_mem[pixel[1]][in_position] = 1;
// 				next_tetris_mem[pixel[2]][in_position +1 ] = 1;
// 				next_tetris_mem[pixel[3]][in_position +1] = 1;
// 			end
// 			3'd1: begin
// 					pixel[0] = top_of_column[in_position] + 4'd3;
// 					pixel[1] = top_of_column[in_position] + 4'd2;
// 					pixel[2] = top_of_column[in_position] + 4'd1;
// 					pixel[3] = top_of_column[in_position] ;
// 					next_tetris_mem[pixel[0]][in_position] = 1;
// 					next_tetris_mem[pixel[1]][in_position] = 1;
// 					next_tetris_mem[pixel[2]][in_position] = 1;
// 					next_tetris_mem[pixel[3]][in_position] = 1;
// 			end
// 			3'd2: begin
// 				if(top_of_column[in_position+3] >= top_of_column[in_position] && top_of_column[in_position+3] >= top_of_column[in_position + 2] && top_of_column[in_position+3] >= top_of_column[in_position + 1]) begin
					
// 					pixel[0] = top_of_column[in_position + 3];
// 					pixel[1] = top_of_column[in_position + 3];
// 					pixel[2] = top_of_column[in_position + 3];
// 					pixel[3] = top_of_column[in_position + 3];
// 				end
// 				else if( top_of_column[in_position + 2] >= top_of_column[in_position + 1] && top_of_column[in_position + 2] >= top_of_column[in_position ]) begin
// 					pixel[0] = top_of_column[in_position + 2];
// 					pixel[1] = top_of_column[in_position + 2];
// 					pixel[2] = top_of_column[in_position + 2];
// 					pixel[3] = top_of_column[in_position + 2];
// 				end
// 				else if(  top_of_column[in_position ] >= top_of_column[in_position + 1]) begin
					
// 					pixel[0] = top_of_column[in_position];
// 					pixel[1] = top_of_column[in_position];
// 					pixel[2] = top_of_column[in_position];
// 					pixel[3] = top_of_column[in_position];
// 				end
// 				else begin
// 					pixel[0] = top_of_column[in_position + 1];
// 					pixel[1] = top_of_column[in_position + 1];
// 					pixel[2] = top_of_column[in_position + 1];
// 					pixel[3] = top_of_column[in_position + 1];
// 				end
// 					next_tetris_mem[pixel[0]][in_position] = 1;
// 					next_tetris_mem[pixel[1]][in_position + 1] = 1;
// 					next_tetris_mem[pixel[2]][in_position + 2] = 1;
// 					next_tetris_mem[pixel[3]][in_position + 3] = 1;
// 			end
// 			3'd3: begin
// 				if(top_of_column[in_position] >= top_of_column[in_position + 1] + 2) begin
// 					pixel[0] = top_of_column[in_position];
// 					pixel[1] = top_of_column[in_position];
// 					pixel[2] = top_of_column[in_position]  +4'd15;
// 					pixel[3] = top_of_column[in_position]  +4'd14;
// 				end
// 				else begin
// 					pixel[0] = top_of_column[in_position + 1] + 2;
// 					pixel[1] = top_of_column[in_position + 1] + 2;
// 					pixel[2] = top_of_column[in_position + 1] + 1;
// 					pixel[3] = top_of_column[in_position + 1] ;
// 				end
// 					next_tetris_mem[pixel[0]][in_position] = 1;
// 					next_tetris_mem[pixel[1]][in_position + 1] = 1;
// 					next_tetris_mem[pixel[2]][in_position + 1] = 1;
// 					next_tetris_mem[pixel[3]][in_position + 1] = 1;
// 			end
// 			3'd4: begin
// 				if(top_of_column[in_position + 2] >= top_of_column[in_position + 1] && top_of_column[in_position+2]  >= top_of_column[in_position ] + 1) begin
// 					pixel[0] = top_of_column[in_position + 2] ;
// 					pixel[1] = top_of_column[in_position + 2];
// 					pixel[2] = top_of_column[in_position + 2];
// 					pixel[3] = top_of_column[in_position + 2] + 4'd15;
// 				end
// 				else if(top_of_column[in_position] + 1 >= top_of_column[in_position + 1] ) begin
// 					pixel[0] = top_of_column[in_position] + 1;
// 					pixel[1] = top_of_column[in_position] + 1;
// 					pixel[2] = top_of_column[in_position] + 1;
// 					pixel[3] = top_of_column[in_position] ;
					
// 				end
// 				else begin
// 					pixel[0] = top_of_column[in_position + 1] ;
// 					pixel[1] = top_of_column[in_position + 1];
// 					pixel[2] = top_of_column[in_position + 1];
// 					pixel[3] = top_of_column[in_position + 1]+ 4'd15;
// 				end
// 					next_tetris_mem[pixel[0]][in_position] = 1;
// 					next_tetris_mem[pixel[1]][in_position + 1] = 1;
// 					next_tetris_mem[pixel[2]][in_position + 2] = 1;
// 					next_tetris_mem[pixel[3]][in_position] = 1;
// 			end
// 			3'd5: begin
// 				if(top_of_column[in_position] >= top_of_column[in_position + 1]) begin
// 					pixel[2] = top_of_column[in_position] + 4'd2;
// 					pixel[1] = top_of_column[in_position] + 4'd1;
// 					pixel[0] = top_of_column[in_position];
// 					pixel[3] = top_of_column[in_position];
// 				end
// 				else begin
// 					pixel[2] = top_of_column[in_position + 1] + 4'd2;
// 					pixel[1] = top_of_column[in_position + 1] + 4'd1;
// 					pixel[0] = top_of_column[in_position + 1];
// 					pixel[3] = top_of_column[in_position + 1];
// 				end
// 				next_tetris_mem[pixel[0]][in_position] = 1;
// 				next_tetris_mem[pixel[1]][in_position] = 1;
// 				next_tetris_mem[pixel[2]][in_position] = 1;
// 				next_tetris_mem[pixel[3]][in_position + 1] = 1;

// 			end
// 			3'd6: begin
// 				if(top_of_column[in_position] >= top_of_column[in_position + 1] + 1) begin
// 					pixel[1] = top_of_column[in_position] + 4'd1;
// 					pixel[0] = top_of_column[in_position];
// 					pixel[2] = top_of_column[in_position];
// 					pixel[3] = top_of_column[in_position] + 4'd15;
// 				end
// 				else begin
// 					pixel[1] = top_of_column[in_position + 1] + 2;
// 					pixel[0] = top_of_column[in_position + 1] + 1;
// 					pixel[2] = top_of_column[in_position + 1] + 1;
// 					pixel[3] = top_of_column[in_position + 1] ;
// 				end
// 				next_tetris_mem[pixel[0]][in_position] = 1;
// 				next_tetris_mem[pixel[1]][in_position] = 1;
// 				next_tetris_mem[pixel[2]][in_position + 1] = 1;
// 				next_tetris_mem[pixel[3]][in_position + 1] = 1;
// 			end
// 			3'd7: begin
// 				if( top_of_column[in_position + 2] >= top_of_column[in_position + 1] +1 && top_of_column[in_position+2] >= top_of_column[in_position]+ 1) begin
// 					pixel[0] = top_of_column[in_position + 2] ;
// 					pixel[1] = top_of_column[in_position + 2] ;
// 					pixel[2] = top_of_column[in_position + 2]+ 4'd15;
// 					pixel[3] = top_of_column[in_position + 2]+ 4'd15;
					
// 				end
// 				else if( top_of_column[in_position] + 1 >= top_of_column[in_position + 1] + 1) begin
// 					pixel[0] = top_of_column[in_position] + 1 ;
// 					pixel[1] = top_of_column[in_position] + 1 ;
// 					pixel[2] = top_of_column[in_position] ;
// 					pixel[3] = top_of_column[in_position] ;
					
// 				end
// 				else begin
// 					pixel[0] = top_of_column[in_position + 1] + 1 ;
// 					pixel[1] = top_of_column[in_position + 1] + 1 ;
// 					pixel[2] = top_of_column[in_position + 1] ;
// 					pixel[3] = top_of_column[in_position + 1] ;
// 				end
// 				next_tetris_mem[pixel[0]][in_position + 2] = 1;
// 				next_tetris_mem[pixel[1]][in_position + 1] = 1;
// 				next_tetris_mem[pixel[2]][in_position + 1] = 1;
// 				next_tetris_mem[pixel[3]][in_position ] = 1;
// 			end
// 		endcase
// 	end
// 	else if(State == SHIFT) begin
// 		if(&tetris_mem[11]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 		end
// 		else if(&tetris_mem[10]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 		end
// 		else if(&tetris_mem[9]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 		end
// 		else if(&tetris_mem[8]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 		end
// 		else if(&tetris_mem[7]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 		end
// 		else if(&tetris_mem[6]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 		end
// 		else if(&tetris_mem[5]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 		end
// 		else if(&tetris_mem[4]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 			next_tetris_mem[4] = tetris_mem[5];
// 		end
// 		else if(&tetris_mem[3]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 			next_tetris_mem[4] = tetris_mem[5];
// 			next_tetris_mem[3] = tetris_mem[4];
// 		end
// 		else if(&tetris_mem[2]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 			next_tetris_mem[4] = tetris_mem[5];
// 			next_tetris_mem[3] = tetris_mem[4];
// 			next_tetris_mem[2] = tetris_mem[3];
// 		end
// 		else if(&tetris_mem[1]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 			next_tetris_mem[4] = tetris_mem[5];
// 			next_tetris_mem[3] = tetris_mem[4];
// 			next_tetris_mem[2] = tetris_mem[3];
// 			next_tetris_mem[1] = tetris_mem[2];
// 		end
// 		else if(&tetris_mem[0]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 			next_tetris_mem[4] = tetris_mem[5];
// 			next_tetris_mem[3] = tetris_mem[4];
// 			next_tetris_mem[2] = tetris_mem[3];
// 			next_tetris_mem[1] = tetris_mem[2];
// 			next_tetris_mem[0] = tetris_mem[1];
// 		end
// 	end
// end


// always@(*) begin
// 	for(i = 0; i <12 ; i++)begin
// 		next_tetris_mem[i] = tetris_mem[i];
// 	end
// 	next_tetris_mem[12] = tetris_mem_1[0];
// 	next_tetris_mem[13] = tetris_mem_1[1];
// 	pixel[0] = top_of_column[in_position] ;
// 	pixel[1] = top_of_column[in_position] ;
// 	pixel[2] = top_of_column[in_position] ;
// 	pixel[3] = top_of_column[in_position] ;
// 	if(State == PUT) begin
// 		case(in_tetrominoes) 
// 			3'd0: begin
// 				if(top_of_column[in_position] >= top_of_column[in_position + 1]) begin
// 					pixel[1] = top_of_column[in_position] + 4'd1;
// 					pixel[2] = top_of_column[in_position] + 4'd1;
// 					pixel[0] = top_of_column[in_position];
// 					pixel[3] = top_of_column[in_position];
// 				end
// 				else begin
// 					pixel[1] = top_of_column[in_position + 1]+ 4'd1;
// 					pixel[2] = top_of_column[in_position + 1] + 4'd1;
// 					pixel[0] = top_of_column[in_position + 1];
// 					pixel[3] = top_of_column[in_position + 1];
// 				end
// 				next_tetris_mem[pixel[0]][in_position] = 1;
// 				next_tetris_mem[pixel[1]][in_position] = 1;
// 				next_tetris_mem[pixel[2]][in_position +1 ] = 1;
// 				next_tetris_mem[pixel[3]][in_position +1] = 1;
// 			end
// 			3'd1: begin
// 					pixel[0] = top_of_column[in_position] + 4'd3;
// 					pixel[1] = top_of_column[in_position] + 4'd2;
// 					pixel[2] = top_of_column[in_position] + 4'd1;
// 					pixel[3] = top_of_column[in_position] ;
// 					next_tetris_mem[pixel[0]][in_position] = 1;
// 					next_tetris_mem[pixel[1]][in_position] = 1;
// 					next_tetris_mem[pixel[2]][in_position] = 1;
// 					next_tetris_mem[pixel[3]][in_position] = 1;
// 			end
// 			3'd2: begin
// 				if(top_of_column[in_position+3] >= top_of_column[in_position] && top_of_column[in_position+3] >= top_of_column[in_position + 2] && top_of_column[in_position+3] >= top_of_column[in_position + 1]) begin
					
// 					pixel[0] = top_of_column[in_position + 3];
// 					pixel[1] = top_of_column[in_position + 3];
// 					pixel[2] = top_of_column[in_position + 3];
// 					pixel[3] = top_of_column[in_position + 3];
// 				end
// 				else if( top_of_column[in_position+2] >= top_of_column[in_position] && top_of_column[in_position+2] >= top_of_column[in_position + 1]) begin
// 					pixel[0] = top_of_column[in_position + 2];
// 					pixel[1] = top_of_column[in_position + 2];
// 					pixel[2] = top_of_column[in_position + 2];
// 					pixel[3] = top_of_column[in_position + 2];
// 				end
// 				else if(  top_of_column[in_position] >= top_of_column[in_position + 1]) begin
					
// 					pixel[0] = top_of_column[in_position];
// 					pixel[1] = top_of_column[in_position];
// 					pixel[2] = top_of_column[in_position];
// 					pixel[3] = top_of_column[in_position];
// 				end
// 				else begin
// 					pixel[0] = top_of_column[in_position + 1];
// 					pixel[1] = top_of_column[in_position + 1];
// 					pixel[2] = top_of_column[in_position + 1];
// 					pixel[3] = top_of_column[in_position + 1];
// 				end
// 					next_tetris_mem[pixel[0]][in_position] = 1;
// 					next_tetris_mem[pixel[1]][in_position + 1] = 1;
// 					next_tetris_mem[pixel[2]][in_position + 2] = 1;
// 					next_tetris_mem[pixel[3]][in_position + 3] = 1;
// 			end
// 			3'd3: begin
// 				if(top_of_column[in_position] >= top_of_column[in_position + 1] + 2) begin
// 					pixel[0] = top_of_column[in_position];
// 					pixel[1] = top_of_column[in_position];
// 					pixel[2] = top_of_column[in_position]  +4'd15;
// 					pixel[3] = top_of_column[in_position]  +4'd14;
// 				end
// 				else begin
// 					pixel[0] = top_of_column[in_position + 1] + 2;
// 					pixel[1] = top_of_column[in_position + 1] + 2;
// 					pixel[2] = top_of_column[in_position + 1] + 1;
// 					pixel[3] = top_of_column[in_position + 1] ;
// 				end
// 					next_tetris_mem[pixel[0]][in_position] = 1;
// 					next_tetris_mem[pixel[1]][in_position + 1] = 1;
// 					next_tetris_mem[pixel[2]][in_position + 1] = 1;
// 					next_tetris_mem[pixel[3]][in_position + 1] = 1;
// 			end
// 			3'd4: begin
// 				if(top_of_column[in_position + 2] >= top_of_column[in_position + 1] && top_of_column[in_position+2]  >= top_of_column[in_position ] + 1) begin
// 					pixel[0] = top_of_column[in_position + 2] ;
// 					pixel[1] = top_of_column[in_position + 2];
// 					pixel[2] = top_of_column[in_position + 2];
// 					pixel[3] = top_of_column[in_position + 2] + 4'd15;
// 				end
// 				else if(top_of_column[in_position ] + 1>= top_of_column[in_position + 1]) begin
// 					pixel[0] = top_of_column[in_position] + 1;
// 					pixel[1] = top_of_column[in_position] + 1;
// 					pixel[2] = top_of_column[in_position] + 1;
// 					pixel[3] = top_of_column[in_position] ;
					
// 				end
// 				else begin
// 					pixel[0] = top_of_column[in_position + 1] ;
// 					pixel[1] = top_of_column[in_position + 1];
// 					pixel[2] = top_of_column[in_position + 1];
// 					pixel[3] = top_of_column[in_position + 1]+ 4'd15;
// 				end
// 					next_tetris_mem[pixel[0]][in_position] = 1;
// 					next_tetris_mem[pixel[1]][in_position + 1] = 1;
// 					next_tetris_mem[pixel[2]][in_position + 2] = 1;
// 					next_tetris_mem[pixel[3]][in_position] = 1;
// 			end
// 			3'd5: begin
// 				if(top_of_column[in_position] >= top_of_column[in_position + 1]) begin
// 					pixel[2] = top_of_column[in_position] + 4'd2;
// 					pixel[1] = top_of_column[in_position] + 4'd1;
// 					pixel[0] = top_of_column[in_position];
// 					pixel[3] = top_of_column[in_position];
// 				end
// 				else begin
// 					pixel[2] = top_of_column[in_position + 1] + 4'd2;
// 					pixel[1] = top_of_column[in_position + 1] + 4'd1;
// 					pixel[0] = top_of_column[in_position + 1];
// 					pixel[3] = top_of_column[in_position + 1];
// 				end
// 				next_tetris_mem[pixel[0]][in_position] = 1;
// 				next_tetris_mem[pixel[1]][in_position] = 1;
// 				next_tetris_mem[pixel[2]][in_position] = 1;
// 				next_tetris_mem[pixel[3]][in_position + 1] = 1;

// 			end
// 			3'd6: begin
// 				if(top_of_column[in_position] >= top_of_column[in_position + 1] + 1) begin
// 					pixel[1] = top_of_column[in_position] + 4'd1;
// 					pixel[0] = top_of_column[in_position];
// 					pixel[2] = top_of_column[in_position];
// 					pixel[3] = top_of_column[in_position] + 4'd15;
// 				end
// 				else begin
// 					pixel[1] = top_of_column[in_position + 1] + 2;
// 					pixel[0] = top_of_column[in_position + 1] + 1;
// 					pixel[2] = top_of_column[in_position + 1] + 1;
// 					pixel[3] = top_of_column[in_position + 1] ;
// 				end
// 				next_tetris_mem[pixel[0]][in_position] = 1;
// 				next_tetris_mem[pixel[1]][in_position] = 1;
// 				next_tetris_mem[pixel[2]][in_position + 1] = 1;
// 				next_tetris_mem[pixel[3]][in_position + 1] = 1;
// 			end
// 			3'd7: begin
// 				if( top_of_column[in_position + 2] >= top_of_column[in_position + 1] +1 && top_of_column[in_position+2] >= top_of_column[in_position]+ 1) begin
// 					pixel[0] = top_of_column[in_position + 2] ;
// 					pixel[1] = top_of_column[in_position + 2] ;
// 					pixel[2] = top_of_column[in_position + 2]+ 4'd15;
// 					pixel[3] = top_of_column[in_position + 2]+ 4'd15;
					
// 				end
// 				else if( top_of_column[in_position]+ 1 >= top_of_column[in_position + 1] +1) begin
// 					pixel[0] = top_of_column[in_position] + 1 ;
// 					pixel[1] = top_of_column[in_position] + 1 ;
// 					pixel[2] = top_of_column[in_position] ;
// 					pixel[3] = top_of_column[in_position] ;
					
// 				end
// 				else begin
// 					pixel[0] = top_of_column[in_position + 1] + 1 ;
// 					pixel[1] = top_of_column[in_position + 1] + 1 ;
// 					pixel[2] = top_of_column[in_position + 1] ;
// 					pixel[3] = top_of_column[in_position + 1] ;
// 				end
// 				next_tetris_mem[pixel[0]][in_position + 2] = 1;
// 				next_tetris_mem[pixel[1]][in_position + 1] = 1;
// 				next_tetris_mem[pixel[2]][in_position + 1] = 1;
// 				next_tetris_mem[pixel[3]][in_position ] = 1;
// 			end
// 		endcase
// 	end
// 	else if(State == SHIFT) begin
// 		if(&tetris_mem[0]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 			next_tetris_mem[4] = tetris_mem[5];
// 			next_tetris_mem[3] = tetris_mem[4];
// 			next_tetris_mem[2] = tetris_mem[3];
// 			next_tetris_mem[1] = tetris_mem[2];
// 			next_tetris_mem[0] = tetris_mem[1];
// 		end
// 		else if(&tetris_mem[1]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 			next_tetris_mem[4] = tetris_mem[5];
// 			next_tetris_mem[3] = tetris_mem[4];
// 			next_tetris_mem[2] = tetris_mem[3];
// 			next_tetris_mem[1] = tetris_mem[2];
// 		end
// 		else if(&tetris_mem[2]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 			next_tetris_mem[4] = tetris_mem[5];
// 			next_tetris_mem[3] = tetris_mem[4];
// 			next_tetris_mem[2] = tetris_mem[3];
// 		end
// 		else if(&tetris_mem[3]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 			next_tetris_mem[4] = tetris_mem[5];
// 			next_tetris_mem[3] = tetris_mem[4];
// 		end
// 		else if(&tetris_mem[4]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 			next_tetris_mem[4] = tetris_mem[5];
// 		end
// 		else if(&tetris_mem[5]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 			next_tetris_mem[5] = tetris_mem[6];
// 		end
// 		else if(&tetris_mem[6]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 			next_tetris_mem[6] = tetris_mem[7];
// 		end
// 		else if(&tetris_mem[7]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 			next_tetris_mem[7] = tetris_mem[8];
// 		end
// 		else if(&tetris_mem[8]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 			next_tetris_mem[8] = tetris_mem[9];
// 		end
// 		else if(&tetris_mem[9]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 			next_tetris_mem[9] = tetris_mem[10];
// 		end
// 		else if(&tetris_mem[10]) begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 			next_tetris_mem[10] = tetris_mem[11];
// 		end
// 		else  begin
// 			next_tetris_mem[13] = 0;
// 			next_tetris_mem[12] = tetris_mem_1[1];
// 			next_tetris_mem[11] = tetris_mem_1[0];
// 		end
// 	end
// end
always@(*) begin
	for(i = 0; i <12 ; i++)begin
		next_tetris_mem[i] = tetris_mem[i];
	end
	next_tetris_mem[12] = tetris_mem_1[0];
	next_tetris_mem[13] = tetris_mem_1[1];
	pixel[0] = top_of_column[in_position] ;
	pixel[1] = top_of_column[in_position] ;
	pixel[2] = top_of_column[in_position] ;
	pixel[3] = top_of_column[in_position] ;
	if(State == PUT) begin
		case(in_tetrominoes) 
			3'd0: begin
				if(top_of_column[in_position] < top_of_column[in_position + 1]) begin
					pixel[1] = top_of_column[in_position + 1]+ 4'd1;
					pixel[2] = top_of_column[in_position + 1] + 4'd1;
					pixel[0] = top_of_column[in_position + 1];
					pixel[3] = top_of_column[in_position + 1];
					
				end
				else begin
					pixel[1] = top_of_column[in_position] + 4'd1;
					pixel[2] = top_of_column[in_position] + 4'd1;
					pixel[0] = top_of_column[in_position];
					pixel[3] = top_of_column[in_position];
				end
				next_tetris_mem[pixel[0]][in_position] = 1;
				next_tetris_mem[pixel[1]][in_position] = 1;
				next_tetris_mem[pixel[2]][in_position +1 ] = 1;
				next_tetris_mem[pixel[3]][in_position +1] = 1;
			end
			3'd1: begin
					pixel[0] = top_of_column[in_position] + 4'd3;
					pixel[1] = top_of_column[in_position] + 4'd2;
					pixel[2] = top_of_column[in_position] + 4'd1;
					pixel[3] = top_of_column[in_position] ;
					next_tetris_mem[pixel[0]][in_position] = 1;
					next_tetris_mem[pixel[1]][in_position] = 1;
					next_tetris_mem[pixel[2]][in_position] = 1;
					next_tetris_mem[pixel[3]][in_position] = 1;
			end
			3'd2: begin
				if(top_of_column[in_position] >= top_of_column[in_position+3] && top_of_column[in_position] >= top_of_column[in_position + 2] && top_of_column[in_position] >= top_of_column[in_position + 1]) begin
					pixel[0] = top_of_column[in_position];
					pixel[1] = top_of_column[in_position];
					pixel[2] = top_of_column[in_position];
					pixel[3] = top_of_column[in_position];
					
				end
				else if( top_of_column[in_position+2] >= top_of_column[in_position+3] && top_of_column[in_position+2] >= top_of_column[in_position + 1]) begin
					pixel[0] = top_of_column[in_position + 2];
					pixel[1] = top_of_column[in_position + 2];
					pixel[2] = top_of_column[in_position + 2];
					pixel[3] = top_of_column[in_position + 2];
				end
				else if(  top_of_column[in_position+3] >= top_of_column[in_position + 1]) begin
					pixel[0] = top_of_column[in_position + 3];
					pixel[1] = top_of_column[in_position + 3];
					pixel[2] = top_of_column[in_position + 3];
					pixel[3] = top_of_column[in_position + 3];
				end
				else begin
					pixel[0] = top_of_column[in_position + 1];
					pixel[1] = top_of_column[in_position + 1];
					pixel[2] = top_of_column[in_position + 1];
					pixel[3] = top_of_column[in_position + 1];
				end
				next_tetris_mem[pixel[0]][in_position] = 1;
				next_tetris_mem[pixel[1]][in_position + 1] = 1;
				next_tetris_mem[pixel[2]][in_position + 2] = 1;
				next_tetris_mem[pixel[3]][in_position + 3] = 1;
			end
			3'd3: begin
				if(top_of_column[in_position] >= top_of_column[in_position + 1] + 2) begin
					pixel[0] = top_of_column[in_position];
					pixel[1] = top_of_column[in_position];
					pixel[2] = top_of_column[in_position]  +4'd15;
					pixel[3] = top_of_column[in_position]  +4'd14;
				end
				else begin
					pixel[0] = top_of_column[in_position + 1] + 2;
					pixel[1] = top_of_column[in_position + 1] + 2;
					pixel[2] = top_of_column[in_position + 1] + 1;
					pixel[3] = top_of_column[in_position + 1] ;
				end
					next_tetris_mem[pixel[0]][in_position] = 1;
					next_tetris_mem[pixel[1]][in_position + 1] = 1;
					next_tetris_mem[pixel[2]][in_position + 1] = 1;
					next_tetris_mem[pixel[3]][in_position + 1] = 1;
			end
			3'd4: begin
				if(top_of_column[in_position + 2] >= top_of_column[in_position + 1] && top_of_column[in_position+2]  >= top_of_column[in_position ] + 1) begin
					pixel[0] = top_of_column[in_position + 2] ;
					pixel[1] = top_of_column[in_position + 2];
					pixel[2] = top_of_column[in_position + 2];
					pixel[3] = top_of_column[in_position + 2] + 4'd15;
				end
				else if(top_of_column[in_position ] + 1>= top_of_column[in_position + 1]) begin
					pixel[0] = top_of_column[in_position] + 1;
					pixel[1] = top_of_column[in_position] + 1;
					pixel[2] = top_of_column[in_position] + 1;
					pixel[3] = top_of_column[in_position] ;
					
				end
				else begin
					pixel[0] = top_of_column[in_position + 1] ;
					pixel[1] = top_of_column[in_position + 1];
					pixel[2] = top_of_column[in_position + 1];
					pixel[3] = top_of_column[in_position + 1]+ 4'd15;
				end
					next_tetris_mem[pixel[0]][in_position] = 1;
					next_tetris_mem[pixel[1]][in_position + 1] = 1;
					next_tetris_mem[pixel[2]][in_position + 2] = 1;
					next_tetris_mem[pixel[3]][in_position] = 1;
			end
			3'd5: begin
				if(top_of_column[in_position] >= top_of_column[in_position + 1]) begin
					pixel[2] = top_of_column[in_position] + 4'd2;
					pixel[1] = top_of_column[in_position] + 4'd1;
					pixel[0] = top_of_column[in_position];
					pixel[3] = top_of_column[in_position];
				end
				else begin
					pixel[2] = top_of_column[in_position + 1] + 4'd2;
					pixel[1] = top_of_column[in_position + 1] + 4'd1;
					pixel[0] = top_of_column[in_position + 1];
					pixel[3] = top_of_column[in_position + 1];
				end
				next_tetris_mem[pixel[0]][in_position] = 1;
				next_tetris_mem[pixel[1]][in_position] = 1;
				next_tetris_mem[pixel[2]][in_position] = 1;
				next_tetris_mem[pixel[3]][in_position + 1] = 1;

			end
			3'd6: begin
				if(top_of_column[in_position] >= top_of_column[in_position + 1] + 1) begin
					pixel[1] = top_of_column[in_position] + 4'd1;
					pixel[0] = top_of_column[in_position];
					pixel[2] = top_of_column[in_position];
					pixel[3] = top_of_column[in_position] + 4'd15;
				end
				else begin
					pixel[1] = top_of_column[in_position + 1] + 2;
					pixel[0] = top_of_column[in_position + 1] + 1;
					pixel[2] = top_of_column[in_position + 1] + 1;
					pixel[3] = top_of_column[in_position + 1] ;
				end
				next_tetris_mem[pixel[0]][in_position] = 1;
				next_tetris_mem[pixel[1]][in_position] = 1;
				next_tetris_mem[pixel[2]][in_position + 1] = 1;
				next_tetris_mem[pixel[3]][in_position + 1] = 1;
			end
			3'd7: begin
				if( top_of_column[in_position + 2] >= top_of_column[in_position + 1] +1 && top_of_column[in_position+2] >= top_of_column[in_position]+ 1) begin
					pixel[0] = top_of_column[in_position + 2] ;
					pixel[1] = top_of_column[in_position + 2] ;
					pixel[2] = top_of_column[in_position + 2]+ 4'd15;
					pixel[3] = top_of_column[in_position + 2]+ 4'd15;
					
				end
				else if( top_of_column[in_position]+ 1 >= top_of_column[in_position + 1] +1) begin
					pixel[0] = top_of_column[in_position] + 1 ;
					pixel[1] = top_of_column[in_position] + 1 ;
					pixel[2] = top_of_column[in_position] ;
					pixel[3] = top_of_column[in_position] ;
					
				end
				else begin
					pixel[0] = top_of_column[in_position + 1] + 1 ;
					pixel[1] = top_of_column[in_position + 1] + 1 ;
					pixel[2] = top_of_column[in_position + 1] ;
					pixel[3] = top_of_column[in_position + 1] ;
				end
				next_tetris_mem[pixel[0]][in_position + 2] = 1;
				next_tetris_mem[pixel[1]][in_position + 1] = 1;
				next_tetris_mem[pixel[2]][in_position + 1] = 1;
				next_tetris_mem[pixel[3]][in_position ] = 1;
			end
		endcase
	end
	else if(State == SHIFT) begin
		if(&tetris_mem[0]) begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
			next_tetris_mem[10] = tetris_mem[11];
			next_tetris_mem[9] = tetris_mem[10];
			next_tetris_mem[8] = tetris_mem[9];
			next_tetris_mem[7] = tetris_mem[8];
			next_tetris_mem[6] = tetris_mem[7];
			next_tetris_mem[5] = tetris_mem[6];
			next_tetris_mem[4] = tetris_mem[5];
			next_tetris_mem[3] = tetris_mem[4];
			next_tetris_mem[2] = tetris_mem[3];
			next_tetris_mem[1] = tetris_mem[2];
			next_tetris_mem[0] = tetris_mem[1];
		end
		else if(&tetris_mem[1]) begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
			next_tetris_mem[10] = tetris_mem[11];
			next_tetris_mem[9] = tetris_mem[10];
			next_tetris_mem[8] = tetris_mem[9];
			next_tetris_mem[7] = tetris_mem[8];
			next_tetris_mem[6] = tetris_mem[7];
			next_tetris_mem[5] = tetris_mem[6];
			next_tetris_mem[4] = tetris_mem[5];
			next_tetris_mem[3] = tetris_mem[4];
			next_tetris_mem[2] = tetris_mem[3];
			next_tetris_mem[1] = tetris_mem[2];
		end
		else if(&tetris_mem[2]) begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
			next_tetris_mem[10] = tetris_mem[11];
			next_tetris_mem[9] = tetris_mem[10];
			next_tetris_mem[8] = tetris_mem[9];
			next_tetris_mem[7] = tetris_mem[8];
			next_tetris_mem[6] = tetris_mem[7];
			next_tetris_mem[5] = tetris_mem[6];
			next_tetris_mem[4] = tetris_mem[5];
			next_tetris_mem[3] = tetris_mem[4];
			next_tetris_mem[2] = tetris_mem[3];
		end
		else if(&tetris_mem[3]) begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
			next_tetris_mem[10] = tetris_mem[11];
			next_tetris_mem[9] = tetris_mem[10];
			next_tetris_mem[8] = tetris_mem[9];
			next_tetris_mem[7] = tetris_mem[8];
			next_tetris_mem[6] = tetris_mem[7];
			next_tetris_mem[5] = tetris_mem[6];
			next_tetris_mem[4] = tetris_mem[5];
			next_tetris_mem[3] = tetris_mem[4];
		end
		else if(&tetris_mem[4]) begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
			next_tetris_mem[10] = tetris_mem[11];
			next_tetris_mem[9] = tetris_mem[10];
			next_tetris_mem[8] = tetris_mem[9];
			next_tetris_mem[7] = tetris_mem[8];
			next_tetris_mem[6] = tetris_mem[7];
			next_tetris_mem[5] = tetris_mem[6];
			next_tetris_mem[4] = tetris_mem[5];
		end
		else if(&tetris_mem[5]) begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
			next_tetris_mem[10] = tetris_mem[11];
			next_tetris_mem[9] = tetris_mem[10];
			next_tetris_mem[8] = tetris_mem[9];
			next_tetris_mem[7] = tetris_mem[8];
			next_tetris_mem[6] = tetris_mem[7];
			next_tetris_mem[5] = tetris_mem[6];
		end
		else if(&tetris_mem[6]) begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
			next_tetris_mem[10] = tetris_mem[11];
			next_tetris_mem[9] = tetris_mem[10];
			next_tetris_mem[8] = tetris_mem[9];
			next_tetris_mem[7] = tetris_mem[8];
			next_tetris_mem[6] = tetris_mem[7];
		end
		else if(&tetris_mem[7]) begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
			next_tetris_mem[10] = tetris_mem[11];
			next_tetris_mem[9] = tetris_mem[10];
			next_tetris_mem[8] = tetris_mem[9];
			next_tetris_mem[7] = tetris_mem[8];
		end
		else if(&tetris_mem[8]) begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
			next_tetris_mem[10] = tetris_mem[11];
			next_tetris_mem[9] = tetris_mem[10];
			next_tetris_mem[8] = tetris_mem[9];
		end
		else if(&tetris_mem[9]) begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
			next_tetris_mem[10] = tetris_mem[11];
			next_tetris_mem[9] = tetris_mem[10];
		end
		else if(&tetris_mem[10]) begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
			next_tetris_mem[10] = tetris_mem[11];
		end
		else  begin
			next_tetris_mem[13] = 0;
			next_tetris_mem[12] = tetris_mem_1[1];
			next_tetris_mem[11] = tetris_mem_1[0];
		end
	end
end


endmodule
