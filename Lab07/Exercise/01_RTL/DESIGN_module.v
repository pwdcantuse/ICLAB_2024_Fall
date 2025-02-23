module CLK_1_MODULE (
    clk,
    rst_n,
    in_valid,
	in_row,
    in_kernel,
    out_idle,
    handshake_sready,
    handshake_din,

    flag_handshake_to_clk1,
    flag_clk1_to_handshake,

	fifo_empty,
    fifo_rdata,
    fifo_rinc,
    out_valid,
    out_data,

    flag_clk1_to_fifo,
    flag_fifo_to_clk1
);
input clk;
input rst_n;
input in_valid;
input [17:0] in_row;
input [11:0] in_kernel;
input out_idle;
output reg handshake_sready;
output reg [29:0] handshake_din;
// You can use the the custom flag ports for your design
input  flag_handshake_to_clk1; //unuse
output flag_clk1_to_handshake; //unuse

input fifo_empty;
input [7:0] fifo_rdata;
output reg fifo_rinc;
output reg out_valid;
output reg [7:0] out_data;
// You can use the the custom flag ports for your design
output flag_clk1_to_fifo; //unuse
input flag_fifo_to_clk1;

////////////  parameter and integer ///////////

parameter IDLE = 3'd0;
parameter READ = 3'd1;
parameter PASS_DATA = 3'd2;
parameter WAIT = 3'd3;
parameter GET_RESULT = 3'd4;
parameter DONE = 3'd5;

integer i;
//////////////////////////////////////////////


//////////////reg and wire////////////////////

reg [2:0] State , nextState;
reg [7:0] t, next_t;
reg prev_out_idle;
reg [29:0] data_in [0:5]; 
reg [7:0] data_from_fifo;

/////////////////////////////////////////////


///////////////// State //////////////////////

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        State <= IDLE;
    end
    else begin
        State <= nextState;
    end
end

always@(*) begin
    case(State)
        IDLE: begin
            if(in_valid) nextState = READ;
            else nextState = State;
        end
        READ: begin
            if(!in_valid) nextState = PASS_DATA;
            else nextState = State;
        end
        PASS_DATA: begin
            if(t == 5 && out_idle&&!(prev_out_idle)) nextState = WAIT;
            else nextState = State;
        end
        WAIT: begin
            if(!fifo_empty) nextState = GET_RESULT;
            else nextState = State;
        end
        GET_RESULT: begin
            if(flag_fifo_to_clk1) nextState = DONE;
            else nextState = State;
        end
        DONE: begin
            if(t == 149) nextState = IDLE;
            else if(fifo_empty) nextState = WAIT;
            else nextState = GET_RESULT;
        end
        default: begin
            nextState = State;
        end
    endcase
end
/////////////////////////////////////////////


/////////////////Design///////////////////////


///////////  ouput port  /////////////////

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        handshake_sready <= 0;
    end
    else if(State == READ) begin
        handshake_sready <= 0;
    end
    else if(State == PASS_DATA) begin
        if(out_idle&&!(prev_out_idle)) handshake_sready <= 1;
        else handshake_sready <= out_idle;
    end
    else begin
        handshake_sready <= 0;
    end
end


always@(*) begin
    handshake_din = data_in[t];
end

always@(*) begin
    if(!rst_n) out_valid = 0;
    else if(State == DONE) out_valid = 1;
    else out_valid = 0;
end

always@(*) begin
    if(!rst_n) out_data = 0;
    else if(State == DONE) out_data = data_from_fifo;
    else out_data = 0;
end


always@(*) begin
    if(!rst_n) fifo_rinc = 0;
    else if(State == GET_RESULT) fifo_rinc = 1 && !fifo_empty;
    else fifo_rinc = 0;
end
///////////////////////////////////////////



always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 6; i = i+1) begin
            data_in[i] <= 0;
        end
    end
    else if(in_valid&&(State == IDLE||State == READ)) begin
        data_in[t] <= {in_row,in_kernel};
    end
end




always@(posedge clk) begin
    prev_out_idle <= out_idle;
end

always@(posedge clk) begin
    if(flag_fifo_to_clk1) data_from_fifo <= fifo_rdata;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        t <= 0;
    end
    else begin
        t <= next_t;
    end
end

always@(*) begin
    case(State)
        IDLE: begin
            if(in_valid) next_t = t+1;
            else next_t = t;
        end
        READ: begin
            if(in_valid) next_t = t+1;
            else next_t = 0;
        end
        PASS_DATA: begin
            if(t == 5 && out_idle&&!(prev_out_idle)) next_t = 0;
            else if(out_idle&&!(prev_out_idle)) next_t = t+1;
            else next_t = t;
        end
        WAIT: begin
            next_t = t;
        end
        GET_RESULT: begin
            next_t = t;
        end
        DONE: begin
            if(t == 149) next_t = 0;
            else next_t = t+1;
        end
        default: begin
            next_t = t;
        end
    endcase
end




endmodule

module CLK_2_MODULE (
    clk,
    rst_n,
    in_valid,
    fifo_full,
    in_data,
    out_valid,
    out_data,
    busy,

    flag_handshake_to_clk2,
    flag_clk2_to_handshake,

    flag_fifo_to_clk2,
    flag_clk2_to_fifo
);

input clk;
input rst_n;
input in_valid;
input fifo_full;
input [29:0] in_data;
output reg out_valid;
output reg [7:0] out_data;
output reg busy;

// You can use the the custom flag ports for your design
input  flag_handshake_to_clk2;
output flag_clk2_to_handshake;

input  flag_fifo_to_clk2;
output flag_clk2_to_fifo;



////////////  parameter and integer ///////////

parameter IDLE = 2'd0;
parameter READ = 2'd1;
parameter CAL = 2'd2;
parameter WRITE = 2'd3;


integer i;
//////////////////////////////////////////////


//////////////reg and wire////////////////////

reg [1:0] State , nextState;
reg [4:0] t, next_t;
reg [2:0] kernel_t;
reg [17:0] ifmap [0:5];
reg [11:0] kernel [0:5];
reg [11:0] current_kernel;
reg [11:0] current_ifmap;
reg [7:0] conv_result;
/////////////////////////////////////////////


///////////////// State //////////////////////





always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        State <= IDLE;
    end
    else begin
        State <= nextState;
    end
end

always@(*) begin
    case(State)
        IDLE: begin
            if(in_valid) nextState = READ;
            else nextState = State;
        end
        READ: begin
            if(in_valid && t == 5) nextState = CAL;
            else nextState = State;
        end
        CAL: begin
            if(!fifo_full) nextState = WRITE;
            else nextState = State;
        end
        WRITE: begin
            if(t == 24 && kernel_t == 5 && flag_fifo_to_clk2) nextState = IDLE;
            else if(flag_fifo_to_clk2) nextState = CAL;
            else nextState = State;
        end
    endcase
end




/////////////////////////////////////////////


/////////////////Design///////////////////////


///////////  ouput port  /////////////////

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_data <= 0;
    end
    else if(State == IDLE) begin
        out_data <= 0;
    end
    else if(State == CAL) begin
        if(!fifo_full) out_data <= conv_result;
    end
end

always@(*) begin
    if(!rst_n) begin
        out_valid = 0;
    end
    else if(State == WRITE) begin
        if(flag_fifo_to_clk2) out_valid = 0;
        else out_valid = 1 && !fifo_full;
    end
    else out_valid = 0;
end

always@(*) begin
    if(!rst_n) begin
        busy = 0;
    end
    else if(State == IDLE || State == READ) begin
        busy = 0;
    end
    else busy = 1;
end

///////////////////////////////////////////



always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        kernel_t <= 0;
    end
    else if(State == IDLE) begin
        kernel_t <= 0;
    end
    else if(State == WRITE && flag_fifo_to_clk2) begin
        if(t == 24&& kernel_t == 5) kernel_t <= 0;
        else if(t == 24) kernel_t <= kernel_t+1;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        t <= 0;
    end
    else begin
        t <= next_t;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 6; i = i+1) begin
            ifmap[i] <= 0;
            kernel[i] <= 0;
        end
    end
    else if(in_valid) begin
        {ifmap[t],kernel[t]} <= in_data;
    end
end

always@(*) begin
    case(State)
        IDLE: begin
            if(in_valid) next_t = t+1;
            else next_t = t;
        end
        READ: begin
            if(in_valid && t == 5) next_t = 0;
            else if(in_valid) next_t = t+1;
            else next_t = t;
        end
        CAL: begin
            next_t = t;
        end
        WRITE: begin
            if(t == 24&&flag_fifo_to_clk2) next_t = 0;
            else if(flag_fifo_to_clk2) next_t = t+1;
            else next_t = t;
        end
    endcase
end


always@(*) begin
    case(kernel_t)
        0: begin
            current_kernel = kernel[0];
        end
        1: begin
            current_kernel = kernel[1];
        end
        2: begin
            current_kernel = kernel[2];
        end
        3: begin
            current_kernel = kernel[3];
        end
        4: begin
            current_kernel = kernel[4];
        end
        5: begin
            current_kernel = kernel[5];
        end
        default: begin
            current_kernel = 0;
        end
    endcase
end

always@(*) begin
    case(t)
        4: begin
            current_ifmap[11:9] = ifmap[1][17:15];
            current_ifmap[8:6] = ifmap[1][14:12];
            current_ifmap[5:3] = ifmap[0][17:15];
            current_ifmap[2:0] = ifmap[0][14:12];
        end
        3: begin
            current_ifmap[11:9] = ifmap[1][14:12];
            current_ifmap[8:6] = ifmap[1][11:9];
            current_ifmap[5:3] = ifmap[0][14:12];
            current_ifmap[2:0] = ifmap[0][11:9];
        end
        2: begin
            current_ifmap[11:9] = ifmap[1][11:9];
            current_ifmap[8:6] = ifmap[1][8:6];
            current_ifmap[5:3] = ifmap[0][11:9];
            current_ifmap[2:0] = ifmap[0][8:6];
        end
        1: begin
            current_ifmap[11:9] = ifmap[1][8:6];
            current_ifmap[8:6] = ifmap[1][5:3];
            current_ifmap[5:3] = ifmap[0][8:6];
            current_ifmap[2:0] = ifmap[0][5:3];
        end
        0: begin
            current_ifmap[11:9] = ifmap[1][5:3];
            current_ifmap[8:6] = ifmap[1][2:0];
            current_ifmap[5:3] = ifmap[0][5:3];
            current_ifmap[2:0] = ifmap[0][2:0];
        end
        9: begin
            current_ifmap[11:9] = ifmap[2][17:15];
            current_ifmap[8:6] = ifmap[2][14:12];
            current_ifmap[5:3] = ifmap[1][17:15];
            current_ifmap[2:0] = ifmap[1][14:12];
        end
        8: begin
            current_ifmap[11:9] = ifmap[2][14:12];
            current_ifmap[8:6] = ifmap[2][11:9];
            current_ifmap[5:3] = ifmap[1][14:12];
            current_ifmap[2:0] = ifmap[1][11:9];
        end
        7: begin
            current_ifmap[11:9] = ifmap[2][11:9];
            current_ifmap[8:6] = ifmap[2][8:6];
            current_ifmap[5:3] = ifmap[1][11:9];
            current_ifmap[2:0] = ifmap[1][8:6];
        end
        6: begin
            current_ifmap[11:9] = ifmap[2][8:6];
            current_ifmap[8:6] = ifmap[2][5:3];
            current_ifmap[5:3] = ifmap[1][8:6];
            current_ifmap[2:0] = ifmap[1][5:3];
        end
        5: begin
            current_ifmap[11:9] = ifmap[2][5:3];
            current_ifmap[8:6] = ifmap[2][2:0];
            current_ifmap[5:3] = ifmap[1][5:3];
            current_ifmap[2:0] = ifmap[1][2:0];
        end
        14: begin
            current_ifmap[11:9] = ifmap[3][17:15];
            current_ifmap[8:6] = ifmap[3][14:12];
            current_ifmap[5:3] = ifmap[2][17:15];
            current_ifmap[2:0] = ifmap[2][14:12];
        end
        13: begin
            current_ifmap[11:9] = ifmap[3][14:12];
            current_ifmap[8:6] = ifmap[3][11:9];
            current_ifmap[5:3] = ifmap[2][14:12];
            current_ifmap[2:0] = ifmap[2][11:9];
        end
        12: begin
            current_ifmap[11:9] = ifmap[3][11:9];
            current_ifmap[8:6] = ifmap[3][8:6];
            current_ifmap[5:3] = ifmap[2][11:9];
            current_ifmap[2:0] = ifmap[2][8:6];
        end
        11: begin
            current_ifmap[11:9] = ifmap[3][8:6];
            current_ifmap[8:6] = ifmap[3][5:3];
            current_ifmap[5:3] = ifmap[2][8:6];
            current_ifmap[2:0] = ifmap[2][5:3];
        end
        10: begin
            current_ifmap[11:9] = ifmap[3][5:3];
            current_ifmap[8:6] = ifmap[3][2:0];
            current_ifmap[5:3] = ifmap[2][5:3];
            current_ifmap[2:0] = ifmap[2][2:0];
        end
        19: begin
            current_ifmap[11:9] = ifmap[4][17:15];
            current_ifmap[8:6] = ifmap[4][14:12];
            current_ifmap[5:3] = ifmap[3][17:15];
            current_ifmap[2:0] = ifmap[3][14:12];
        end
        18: begin
            current_ifmap[11:9] = ifmap[4][14:12];
            current_ifmap[8:6] = ifmap[4][11:9];
            current_ifmap[5:3] = ifmap[3][14:12];
            current_ifmap[2:0] = ifmap[3][11:9];
        end
        17: begin
            current_ifmap[11:9] = ifmap[4][11:9];
            current_ifmap[8:6] = ifmap[4][8:6];
            current_ifmap[5:3] = ifmap[3][11:9];
            current_ifmap[2:0] = ifmap[3][8:6];
        end
        16: begin
            current_ifmap[11:9] = ifmap[4][8:6];
            current_ifmap[8:6] = ifmap[4][5:3];
            current_ifmap[5:3] = ifmap[3][8:6];
            current_ifmap[2:0] = ifmap[3][5:3];
        end
        15: begin
            current_ifmap[11:9] = ifmap[4][5:3];
            current_ifmap[8:6] = ifmap[4][2:0];
            current_ifmap[5:3] = ifmap[3][5:3];
            current_ifmap[2:0] = ifmap[3][2:0];
        end
        24: begin
            current_ifmap[11:9] = ifmap[5][17:15];
            current_ifmap[8:6] = ifmap[5][14:12];
            current_ifmap[5:3] = ifmap[4][17:15];
            current_ifmap[2:0] = ifmap[4][14:12];
        end
        23: begin
            current_ifmap[11:9] = ifmap[5][14:12];
            current_ifmap[8:6] = ifmap[5][11:9];
            current_ifmap[5:3] = ifmap[4][14:12];
            current_ifmap[2:0] = ifmap[4][11:9];
        end
        22: begin
            current_ifmap[11:9] = ifmap[5][11:9];
            current_ifmap[8:6] = ifmap[5][8:6];
            current_ifmap[5:3] = ifmap[4][11:9];
            current_ifmap[2:0] = ifmap[4][8:6];
        end
        21: begin
            current_ifmap[11:9] = ifmap[5][8:6];
            current_ifmap[8:6] = ifmap[5][5:3];
            current_ifmap[5:3] = ifmap[4][8:6];
            current_ifmap[2:0] = ifmap[4][5:3];
        end
        20: begin
            current_ifmap[11:9] = ifmap[5][5:3];
            current_ifmap[8:6] = ifmap[5][2:0];
            current_ifmap[5:3] = ifmap[4][5:3];
            current_ifmap[2:0] = ifmap[4][2:0];
        end
        default: begin
            current_ifmap[11:9] = 0;
            current_ifmap[8:6] =  0;
            current_ifmap[5:3] =  0;
            current_ifmap[2:0] =  0;
        end
    endcase
end

always@(*) begin
    conv_result = current_kernel[11:9]*current_ifmap[11:9] + current_kernel[8:6]*current_ifmap[8:6] + current_kernel[5:3]*current_ifmap[5:3] + current_kernel[2:0]*current_ifmap[2:0];
end

endmodule