module BB(
    //Input Ports
    input clk,
    input rst_n,
    input in_valid,
    input [1:0] inning,   // Current inning number
    input half,           // 0: top of the inning, 1: bottom of the inning
    input [2:0] action,   // Action code

    //Output Ports
    output reg out_valid,  // Result output valid
    output reg [7:0] score_A,  // Score of team A (guest team)
    output reg [7:0] score_B,  // Score of team B (home team)
    output reg [1:0] result    // 0: Team A wins, 1: Team B wins, 2: Darw
);

//==============================================//
//             Action Memo for Students         //
// Action code interpretation:
// 3’d0: Walk (BB)
// 3’d1: 1H (single hit)
// 3’d2: 2H (double hit)
// 3’d3: 3H (triple hit)
// 3’d4: HR (home run)
// 3’d5: Bunt (short hit)
// 3’d6: Ground ball
// 3’d7: Fly ball
//==============================================//

//==============================================//
//             Parameter and Integer            //
//==============================================//
// State declaration for FSM
// Example: parameter IDLE = 3'b000;

parameter DONE = 2'd0;
parameter WAIT =  2'd1;
parameter READ =  2'd3;
parameter JUDGE = 2'd2;
//parameter DONE =  3'd4;RESET

//==============================================//
//                 reg declaration              //
//==============================================//

reg [1:0] current_inning;
reg [2:0] current_action;
reg current_half;
reg [1:0] State, nextState;

reg [3:0] get_score, score_A_in, score_B_in;
reg [2:0] base;
reg [2:0] next_base;
reg [1:0] out_num, next_out_num;

//==============================================//
//                 wire declaration             //
//==============================================//


reg three_out;



//==============================================//
//             Current State Block              //
//==============================================//

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) State <= WAIT;
    else State <= nextState;
end



//==============================================//
//              Next State Block                //
//==============================================//

always@(*) begin
    case(State)
        WAIT : begin
            if(in_valid) nextState = READ;
            else nextState = State;
        end
        READ : begin
            if(!in_valid) nextState = DONE;  //if I exchange this line with the below line , 03 will not pass
            else if(score_B_in>score_A_in&&current_inning == 2'd3&&three_out) nextState = JUDGE;
            else nextState = State;
        end
        JUDGE: begin
            if(!in_valid) nextState = DONE;
            else nextState = State;
        end
        default: nextState = WAIT;
    endcase
end

//==============================================//
//                register update               //
//==============================================//

    always@(posedge clk ) begin
        current_action <= action;
    end
    always@(posedge clk) begin
        current_half <= half;
    end
    always@(posedge clk ) begin
        current_inning <= inning;
    end



//==============================================//
//             Base and Score Logic             //
//==============================================//
// Handle base runner movements and score calculation.
// Update bases and score depending on the action:
// Example: Walk, Hits (1H, 2H, 3H), Home Runs, etc.



always@(posedge clk or negedge rst_n) begin
    if(!rst_n) base <= 3'd0;
    else if(three_out) base <= 3'd0;
    else if(State == READ) base <= next_base;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) out_num <= 2'd0;
    else if(three_out) out_num <= 2'd0;
    else if(State == READ) out_num <= next_out_num;
end

//next base
always@(*) begin
    case(current_action)
        3'd0: begin
            case(base)
                3'b000: next_base = 3'b001;
                3'b001: next_base = 3'b011;
                3'b010: next_base = 3'b011;
                3'b011: next_base = 3'b111;
                3'b100: next_base = 3'b101;
                3'b101: next_base = 3'b111;
                3'b110: next_base = 3'b111;
                3'b111: next_base = 3'b111;
            endcase
        end
        3'd1: begin
            if(out_num[1]) begin
                next_base = {base[0],2'b01}; 
            end
            else begin
                next_base = {base[1:0],1'b1}; 
            end
            
        end
        3'd2: begin
            if(out_num[1]) begin
                next_base = 3'b010; 
            end
            else begin
                next_base = {base[0],2'b10};
            end
        end
        3'd3: begin
            next_base = 3'b100;          
        end
        3'd4: begin
            next_base = 3'b000;
        end
        3'd5: begin
            next_base = {base[1:0],1'b0}; 
        end
        3'd6: begin
            if(out_num[1]) begin
                next_base = 3'd0; 
            end
            else begin
                next_base = {base[1],2'b00}; 
            end
        end
        3'd7: begin
            if(out_num[1]) begin
                next_base = 3'd0; 
            end
            else begin
                next_base = {1'b0,base[1:0]}; 
            end
        end
    endcase
end

//three_out

always@(*) begin
    case(current_action)
        3'd5,3'd7: begin
            three_out = out_num[1];
        end
        3'd6: begin
            if(base[0]&& (|out_num)) three_out = 1'b1;
            else three_out = out_num[1];
        end
        default: three_out = 1'b0;
    endcase
end

//next_out_num
always@(*) begin
    case(current_action)
        3'd5: begin
            if(out_num[1]) next_out_num = 2'd0;
            else next_out_num = out_num + 2'd1;
        end
        3'd6: begin
            if(base[0]) next_out_num = {!(|out_num),1'b0};
            else next_out_num = out_num + 2'd1;
        end
        3'd7: begin
            if(out_num[1]) next_out_num = 2'd0;
            else next_out_num = out_num + 2'd1;
        end
        default: next_out_num = out_num;
    endcase
end

// get score


always@(*) begin
    case(current_action)
        3'd0: begin
            get_score = {3'd0, &base};
        end
        3'd1: begin
            if(out_num[1]) begin
                if(base[2:1]==2'b01||base[2:1]==2'b10) get_score = 4'd1;
                else if(base[2:1]==2'b11) get_score = 4'd2;
                else get_score = 4'd0;
            end
            else begin
                if(base[2]) get_score = 4'd1;
                else get_score = 4'd0;
            end
        end
        3'd2: begin
            if(out_num[1]) begin
                case(base)
                    3'b000: get_score = 4'd0;
                    3'b001: get_score = 4'd1;
                    3'b010: get_score = 4'd1;
                    3'b011: get_score = 4'd2;
                    3'b100: get_score = 4'd1;
                    3'b101: get_score = 4'd2;
                    3'b110: get_score = 4'd2;
                    3'b111: get_score = 4'd3;
                endcase
            end
            else begin
                if(base[2:1]==2'b01||base[2:1]==2'b10) get_score = 4'd1;
                else if(base[2:1]==2'b11) get_score = 4'd2;
                else get_score = 4'd0;
            end
        end
        3'd3: begin
            case(base)
                3'b000: get_score = 4'd0;
                3'b001: get_score = 4'd1;
                3'b010: get_score = 4'd1;
                3'b011: get_score = 4'd2;
                3'b100: get_score = 4'd1;
                3'b101: get_score = 4'd2;
                3'b110: get_score = 4'd2;
                3'b111: get_score = 4'd3;
            endcase
        end
        3'd4: begin
            case(base)
                3'b000: get_score = 4'd1;
                3'b001: get_score = 4'd2;
                3'b010: get_score = 4'd2;
                3'b011: get_score = 4'd3;
                3'b100: get_score = 4'd2;
                3'b101: get_score = 4'd3;
                3'b110: get_score = 4'd3;
                3'b111: get_score = 4'd4;
            endcase
        end
        default: begin
            if(base[2]) get_score = 4'd1;
            else get_score = 4'd0;
        end
    endcase  
end
/*
always@(*) begin
    case(current_action)
        3'd0: begin
        end
        3'd1: begin
        end
        3'd2: begin
        end
        3'd3: begin
        end
        3'd4: begin
        end
        3'd5: begin
        end
        3'd6: begin
        end
        3'd7: begin
        end
    endcase
end
*/



//==============================================//
//                Output Block                  //
//==============================================//
// Decide when to set out_valid high, and output score_A, score_B, and result.

always@(*) begin
    out_valid = (State == DONE);
end
always@(*) begin
    score_A = {4'd0, score_A_in};
    score_B = {4'd0, score_B_in};
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) score_A_in <= 4'd0;
    else if(State == READ && !current_half &&!three_out) score_A_in <= score_A_in + get_score;
    else if(State == DONE) score_A_in <= 4'd0;
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) score_B_in <= 4'd0;
    else if(State == READ && current_half&&!three_out)  score_B_in <= score_B_in + get_score;
    else if(State == DONE) score_B_in <= 4'd0;
end

always@(*) begin
    if(!rst_n) result = 2'd0;
    else if(score_A_in == score_B_in) result = 2'd2;
    else if(score_A_in < score_B_in) result = 2'd1;
    else result = 2'd0;
end



endmodule
