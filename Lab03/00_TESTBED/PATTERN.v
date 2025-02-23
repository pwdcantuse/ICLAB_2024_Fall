/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: PATTERN
// FILE NAME: PATTERN.v
// VERSRION: 1.0
// DATE: August 15, 2024
// AUTHOR: Yu-Hsuan Hsu, NYCU IEE
// DESCRIPTION: ICLAB2024FALL / LAB3 / PATTERN
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/

`ifdef RTL
    `define CYCLE_TIME 3.8
`endif
`ifdef GATE
    `define CYCLE_TIME 4.7
`endif

module PATTERN(
	//OUTPUT
	rst_n,
	clk,
	in_valid,
	tetrominoes,
	position,
	//INPUT
	tetris_valid,
	score_valid,
	fail,
	score,
	tetris
);

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
output reg			rst_n, clk, in_valid;
output reg	[2:0]	tetrominoes;
output reg  [2:0]	position;
input 				tetris_valid, score_valid, fail;
input 		[3:0]	score;
input		[71:0]	tetris;

//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
integer total_latency;
real CYCLE = `CYCLE_TIME;
integer patnum ,f_in;
integer a,i,j,i_pat;
integer latency;

integer score_for_task;
integer total_score;
integer m, b;
//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------

reg [5:0] tetris_for_task [0:13];
reg [4:0] top_of_column [0:5];
reg prev_score_valid;
reg prev_tetris_valid;
reg fail_for_task;
reg[71:0] aa;
reg [3:0] floor_1, floor_2, floor_3, floor_4;
reg [3:0] pixel_1, pixel_2, pixel_3, pixel_4;
//---------------------------------------------------------------------
//  CLOCK
//---------------------------------------------------------------------
always #(CYCLE/2.0) clk = ~clk;

//---------------------------------------------------------------------
//  SIMULATION
//---------------------------------------------------------------------

	// initial begin
    //     #(CYCLE*10000) $finish;
    //     // All patterns passed
    //     //YOU_PASS_task;
    // end
always@(posedge clk) begin
	prev_score_valid <= score_valid;
	prev_tetris_valid <= tetris_valid;
end


	initial begin
        // Open input and output files
        f_in  = $fopen("../00_TESTBED/input.txt", "r");
        // f_in  = $fopen("../00_TESTBED/input_v2.txt", "r");
        if (f_in == 0) begin
            $display("Failed to open input.txt");
            $finish;
        end
		a = $fscanf(f_in, "%d", patnum);
        
        // Initialize signals
        reset_task;
        // Iterate through each pattern
       	for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1) begin
            input_task;    
			total_score += score_for_task;        
        end
		$display("                  Congratulations!               ");
		$display("              execution cycles = %7d", total_latency);
		$display("              clock period = %4fns", CYCLE);
        $finish;
        // All patterns passed
        //YOU_PASS_task;
    end

	task reset_task; begin 
        rst_n = 1'b1;
        in_valid = 1'b0;
        tetrominoes = 3'bxxx;
        position = 3'bxxx;
        total_latency = 0;
		total_score = 0;
        force clk = 0;

        // Apply reset
        #CYCLE; rst_n = 1'b0; 
        #CYCLE; rst_n = 1'b1;
        
        // Check initial conditions
		
        if (tetris_valid !== 1'b0 || score_valid !== 1'b0 || fail !== 1'b0 || score !== 4'b00 || tetris !== 72'd0) begin
            $display("                    SPEC-4 FAIL                   ");
            repeat (2) #CYCLE;
            $finish;
        end
        #CYCLE; release clk;
    end endtask






	task input_task; begin
        repeat (3) @(negedge clk);
		i = 0;
		score_for_task = 0;
		for(j = 0; j < 14; j++) begin
			tetris_for_task[j] = 0;
		end
		for(j = 0; j < 6; j++) begin
			top_of_column[j] = 0;
		end
		a = $fscanf(f_in, "%d", j);
		while(i < 16) begin
			
			a = $fscanf(f_in, "%d", tetrominoes);
			a = $fscanf(f_in, "%d", position);
			in_valid = 1'b1;
			@(negedge clk); in_valid = 1'b0;
			wait_out_valid_task;
			
			sim_cir_task;

			check_ans_task;
			i = i + 1;
			if(fail === 1'b1) begin
				in_valid = 1'b0;
				while(i < 16) begin
					a = $fscanf(f_in, "%d", tetrominoes);
					a = $fscanf(f_in, "%d", position);
					i = i + 1;
				end
			end
			repeat (3) @(negedge clk);
		end

    end endtask


    always@(negedge clk) begin
		if(score_valid===1'b0) begin
			if(fail===1'b1|tetris_valid===1'b1|(|score)===1'b1) begin
				$display("                    SPEC-5 FAIL                   ");
				$finish;
			end
		end
		if(tetris_valid===1'b0 && (|tetris)===1'b1) begin
			$display("                    SPEC-5 FAIL                   ");
			$finish;
		end
	end

	always@(posedge clk) begin
		if(prev_score_valid === score_valid && score_valid === 1'b1) begin
				$display("                    SPEC-8 FAIL                   ");
				$finish;		
		end
		if(prev_tetris_valid === tetris_valid && tetris_valid === 1'b1) begin
			$display("                    SPEC-8 FAIL                   ");
			$finish;
		end
	end
	task wait_out_valid_task; begin
        latency = 1;
        while (tetris_valid === 1'b0 && score_valid === 1'b0) begin
			
            latency = latency + 1;
            if (latency == 1000) begin
                $display("                    SPEC-6 FAIL                   ");
                repeat (2) @(negedge clk);
                $finish;
            end
            @(negedge clk);
        end
        total_latency = total_latency + latency;
    end endtask



	task sim_cir_task; begin
		
		case(tetrominoes)
			3'd0: begin
				floor_1 = top_of_column[position];
				floor_2 = top_of_column[position + 1];
				floor_3 = 4'd0;
				floor_4 = 4'd0;
			end
			3'd1: begin
				floor_1 = top_of_column[position];
				floor_2 = 4'd0;
				floor_3 = 4'd0;
				floor_4 = 4'd0;
			end
			3'd2: begin
				floor_1 = top_of_column[position];
				floor_2 = top_of_column[position+1];
				floor_3 = top_of_column[position+2];
				floor_4 = top_of_column[position+3];
			end
			3'd3: begin
				floor_1 = top_of_column[position];
				floor_2 = top_of_column[position + 1]+2;
				floor_3 = 4'd0;
				floor_4 = 4'd0;
			end
			3'd4: begin
				floor_1 = top_of_column[position]+1;
				floor_2 = top_of_column[position+1];
				floor_3 = top_of_column[position+2];
				floor_4 = 4'd0;
			end
			3'd5: begin
				floor_1 = top_of_column[position];
				floor_2 = top_of_column[position+1];
				floor_3 = 4'd0;
				floor_4 = 4'd0;
			end
			3'd6: begin
				floor_1 = top_of_column[position];
				floor_2 = top_of_column[position + 1]+1;
				floor_3 = 4'd0;
				floor_4 = 4'd0;
			end
			3'd7: begin
				floor_1 = top_of_column[position]+1;
				floor_2 = top_of_column[position + 1]+1;
				floor_3 = top_of_column[position+2];
				floor_4 = 4'd0;
			end
		endcase
		
		case(tetrominoes)
			3'd0: begin
				if(floor_1>=floor_2) begin
					pixel_1 = floor_1;
					pixel_2 = floor_1+1;
					pixel_3 = floor_1+1;
					pixel_4 = floor_1;
				end
				else begin
					pixel_1 = floor_2;
					pixel_2 = floor_2+1;
					pixel_3 = floor_2+1;
					pixel_4 = floor_2;
				end
			end
			3'd1: begin
				pixel_1 = floor_1;
				pixel_2 = floor_1+1;
				pixel_3 = floor_1+2;
				pixel_4 = floor_1+3;
			end
			3'd2: begin
				if(floor_1>=floor_2 && floor_1>= floor_3 && floor_1 >= floor_4) begin
					pixel_1 = floor_1;
					pixel_2 = floor_1;
					pixel_3 = floor_1;
					pixel_4 = floor_1;
				end
				else if(floor_2>=floor_1 && floor_2>= floor_3 && floor_2 >= floor_4) begin
					pixel_1 = floor_2;
					pixel_2 = floor_2;
					pixel_3 = floor_2;
					pixel_4 = floor_2;
				end
				else if(floor_3>=floor_2 && floor_3>= floor_1 && floor_3 >= floor_4) begin
					pixel_1 = floor_3;
					pixel_2 = floor_3;
					pixel_3 = floor_3;
					pixel_4 = floor_3;
				end
				else begin
					pixel_1 = floor_4;
					pixel_2 = floor_4;
					pixel_3 = floor_4;
					pixel_4 = floor_4;
				end
			end
			3'd3: begin
				if(floor_1>=floor_2) begin
					pixel_1 = floor_1;
					pixel_2 = floor_1;
					pixel_3 = floor_1-1;
					pixel_4 = floor_1-2;
				end
				else begin
					pixel_1 = floor_2;
					pixel_2 = floor_2;
					pixel_3 = floor_2-1;
					pixel_4 = floor_2-2;
				end
			end
			3'd4: begin
				if(floor_1>=floor_2 && floor_1>= floor_3) begin
					pixel_1 = floor_1-1;
					pixel_2 = floor_1;
					pixel_3 = floor_1;
					pixel_4 = floor_1;
				end
				else if(floor_2>=floor_1 && floor_2>= floor_3) begin
					pixel_1 = floor_2-1;
					pixel_2 = floor_2;
					pixel_3 = floor_2;
					pixel_4 = floor_2;
				end
				else begin
					pixel_1 = floor_3-1;
					pixel_2 = floor_3;
					pixel_3 = floor_3;
					pixel_4 = floor_3;
				end
			end
			3'd5: begin
				if(floor_1>=floor_2) begin
					pixel_1 = floor_1+2;
					pixel_2 = floor_1+1;
					pixel_3 = floor_1;
					pixel_4 = floor_1;
				end
				else begin
					pixel_1 = floor_2+2;
					pixel_2 = floor_2+1;
					pixel_3 = floor_2;
					pixel_4 = floor_2;
				end
			end
			3'd6: begin
				if(floor_1>=floor_2) begin
					pixel_1 = floor_1+1;
					pixel_2 = floor_1;
					pixel_3 = floor_1;
					pixel_4 = floor_1-1;
				end
				else begin
					pixel_1 = floor_2+1;
					pixel_2 = floor_2;
					pixel_3 = floor_2;
					pixel_4 = floor_2-1;
				end
			end
			3'd7: begin
				if(floor_1>=floor_2 && floor_1>= floor_3) begin
					pixel_1 = floor_1-1;
					pixel_2 = floor_1-1;
					pixel_3 = floor_1;
					pixel_4 = floor_1;
				end
				else if(floor_2>=floor_1 && floor_2>= floor_3) begin
					pixel_1 = floor_2-1;
					pixel_2 = floor_2-1;
					pixel_3 = floor_2;
					pixel_4 = floor_2;
				end
				else begin
					pixel_1 = floor_3-1;
					pixel_2 = floor_3-1;
					pixel_3 = floor_3;
					pixel_4 = floor_3;
				end
			end
		endcase

		case(tetrominoes)
			3'd0: begin
				if(pixel_1<14) begin
					tetris_for_task[pixel_1][position] = 1;
				end
				if(pixel_2<14) begin
					tetris_for_task[pixel_2][position] = 1;
					top_of_column[position] = pixel_2+1;
				end
				if(pixel_3<14) begin
					tetris_for_task[pixel_3][position+1] = 1;
					top_of_column[position+1] = pixel_3+1;
				end
				if(pixel_4<14) begin
					tetris_for_task[pixel_4][position+1] = 1;
				end
			end
			3'd1: begin
				if(pixel_1<14) begin
					tetris_for_task[pixel_1][position] = 1;
				end
				if(pixel_2<14) begin
					tetris_for_task[pixel_2][position] = 1;
				end
				if(pixel_3<14) begin
					tetris_for_task[pixel_3][position] = 1;
				end
				if(pixel_4<14) begin
					tetris_for_task[pixel_4][position] = 1;
					top_of_column[position] = pixel_4+1;
				end
			end
			3'd2: begin
				if(pixel_1<14) begin
					tetris_for_task[pixel_1][position] = 1;
					top_of_column[position] = pixel_1+1;
				end
				if(pixel_2<14) begin
					tetris_for_task[pixel_2][position+1] = 1;
					top_of_column[position+1] = pixel_2+1;
				end
				if(pixel_3<14) begin
					tetris_for_task[pixel_3][position+2] = 1;
					top_of_column[position+2] = pixel_3+1;
				end
				if(pixel_4<14) begin
					tetris_for_task[pixel_4][position+3] = 1;
					top_of_column[position+3] = pixel_4+1;
				end
			end
			3'd3: begin
				if(pixel_1<14) begin
					tetris_for_task[pixel_1][position] = 1;
					top_of_column[position] = pixel_1+1;
				end
				if(pixel_2<14) begin
					tetris_for_task[pixel_2][position+1] = 1;
					top_of_column[position+1] = pixel_2+1;
				end
				if(pixel_3<14) begin
					tetris_for_task[pixel_3][position+1] = 1;
				end
				if(pixel_4<14) begin
					tetris_for_task[pixel_4][position+1] = 1;
				end
			end
			3'd4: begin
				if(pixel_1<14) begin
					tetris_for_task[pixel_1][position] = 1;
				end
				if(pixel_2<14) begin
					tetris_for_task[pixel_2][position] = 1;
					top_of_column[position] = pixel_2+1;
				end
				if(pixel_3<14) begin
					tetris_for_task[pixel_3][position+1] = 1;
					top_of_column[position+1] = pixel_3+1;
				end
				if(pixel_4<14) begin
					tetris_for_task[pixel_4][position+2] = 1;
					top_of_column[position+2] = pixel_4+1;
				end
			end
			3'd5: begin
				if(pixel_1<14) begin
					tetris_for_task[pixel_1][position] = 1;
					top_of_column[position] = pixel_1+1;
				end
				if(pixel_2<14) begin
					tetris_for_task[pixel_2][position] = 1;
				end
				if(pixel_3<14) begin
					tetris_for_task[pixel_3][position] = 1;
				end
				if(pixel_4<14) begin
					tetris_for_task[pixel_4][position+1] = 1;
					top_of_column[position+1] = pixel_4+1;
				end
			end
			3'd6: begin
				if(pixel_1<14) begin
					tetris_for_task[pixel_1][position] = 1;
					top_of_column[position] = pixel_1+1;
				end
				if(pixel_2<14) begin
					tetris_for_task[pixel_2][position] = 1;
				end
				if(pixel_3<14) begin
					tetris_for_task[pixel_3][position+1] = 1;
					top_of_column[position+1] = pixel_3+1;
				end
				if(pixel_4<14) begin
					tetris_for_task[pixel_4][position+1] = 1;
				end
			end
			3'd7: begin
				if(pixel_1<14) begin
					tetris_for_task[pixel_1][position] = 1;
					top_of_column[position] = pixel_1+1;
				end
				if(pixel_2<14) begin
					tetris_for_task[pixel_2][position+1] = 1;
				end
				if(pixel_3<14) begin
					tetris_for_task[pixel_3][position+1] = 1;
					top_of_column[position+1] = pixel_3+1;
				end
				if(pixel_4<14) begin
					tetris_for_task[pixel_4][position+2] = 1;
					top_of_column[position+2] = pixel_4+1;
				end
			end
		endcase
		
		
		for(m = 0; m < 14; m++)begin
			
			if(&tetris_for_task[m]) begin
				score_for_task = score_for_task+1;
				for(b = m; b < 13; b++) begin
					tetris_for_task[b] = tetris_for_task[b+1];
				end
				m=-1;
				tetris_for_task[13] = 0;
			end
		end
		
		for(m = 0; m <6; m++)begin
			for(b = 11; b >= 0; b--) begin
				if(tetris_for_task[b][m]) begin
					top_of_column[m] = b+1 ;
					break;
				end
				top_of_column[m] = b;
			end
		end
		fail_for_task = (|tetris_for_task[12]) || (|tetris_for_task[13]) || (pixel_1 > 13)
		|| (pixel_2 > 13) || (pixel_3 > 13) || (pixel_4 > 13);
		
	end endtask

	task check_ans_task; begin
        // Only perform checks when out_valid is high
		
		aa = {tetris_for_task[11], tetris_for_task[10], tetris_for_task[9], tetris_for_task[8], tetris_for_task[7], tetris_for_task[6]
		, tetris_for_task[5], tetris_for_task[4], tetris_for_task[3], tetris_for_task[2], tetris_for_task[1], tetris_for_task[0]};

        if (score_valid === 1) begin
            if(fail_for_task !== fail) begin
				$display("                    SPEC-7 FAIL                   ");
				repeat (2) @(negedge clk);
				$finish;
			end
			if(fail === 1 && tetris_valid === 0) begin
				$display("                    SPEC-7 FAIL                   ");
				repeat (2) @(negedge clk);
				$finish;
			end
			if(i === 15 && tetris_valid === 0) begin
				$display("                    SPEC-7 FAIL                   ");
				repeat (2) @(negedge clk);
				$finish;
			end
			if(score_for_task !== score) begin
				$display("                    SPEC-7 FAIL                   ");
				repeat (2) @(negedge clk);
				$finish;
			end

			if(tetris_valid === 1) begin
				if(aa !== tetris) begin
					$display("                    SPEC-7 FAIL                   ");
					repeat (2) @(negedge clk);
					$finish;
				end
			end
        end

        
    end endtask
endmodule
// for spec check
// $display("                    SPEC-4 FAIL                   ");
// $display("                    SPEC-5 FAIL                   ");
// $display("                    SPEC-6 FAIL                   ");
// $display("                    SPEC-7 FAIL                   ");
// $display("                    SPEC-8 FAIL                   ");
// for successful design
// $display("                  Congratulations!               ");
// $display("              execution cycles = %7d", total_latency);
// $display("              clock period = %4fns", CYCLE);


