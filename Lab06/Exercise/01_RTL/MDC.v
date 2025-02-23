//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2024/9
//		Version		: v1.0
//   	File Name   : MDC.v
//   	Module Name : MDC
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "HAMMING_IP.v"
//synopsys translate_on

module MDC(
    // Input signals
    clk,
	rst_n,
	in_valid,
    in_data, 
	in_mode,
    // Output signals
    out_valid, 
	out_data
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
input clk, rst_n, in_valid;
input [8:0] in_mode;
input [14:0] in_data;

output reg out_valid;
output reg [206:0] out_data;
// ===============================================================
// parameter Declaration
// ===============================================================
parameter IDLE = 2'd0;
parameter READ = 2'd1;
parameter CAL = 2'd2;
parameter DONE = 2'd3;

integer k;
// ===============================================================
// reg wire Declaration
// ===============================================================

reg [1:0] State, nextState;
reg [14:0] in_data_in;
reg [8:0] in_mode_in;
reg [10:0] input_matrix [0:14];
reg [2:0] mode;
wire [10:0] H1_out;
wire [4:0] H2_out;
reg [3:0] t;
reg [10:0] a,b,c,d,e,f,g,h,i;
reg [22:0] deter_2;
reg [35:0] deter_3;
// reg [48:0] temp_deter_4;

reg [206:0] result;

reg  [35:0] mul_in_1;
reg  [10:0] mul_in_2;
reg  [46:0] mul_res;
reg  [48:0] add_in_1, add_in_2;
reg  [48:0] add_res;
// ===============================================================
// in & out _reg Declaration
// ===============================================================

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) in_mode_in <= 0;
    else if(in_valid && State == IDLE) in_mode_in <= in_mode;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) in_data_in <= 0;
    else if(in_valid) in_data_in <= in_data;
end

always@(*)begin
    if(!rst_n) out_valid = 0;
    else if(State == DONE) out_valid = 1;
    else out_valid =0;
end

always@(*)begin
    if(!rst_n) out_data = 0;
    else if(State == DONE) begin
        if(mode == 3'b111) out_data = {{158{result[201]}},result[201:153]};
        else out_data = result;
    end
    else out_data =0;
end
// ===============================================================
// module Declaration
// ===============================================================
HAMMING_IP #(.IP_BIT(11)) H1 (.IN_code(in_data_in), .OUT_code(H1_out)); 
HAMMING_IP #(.IP_BIT(5)) H2 (.IN_code(in_mode_in), .OUT_code(H2_out)); 
determinant3 deter0 (.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .h(h), .i(i), .deter_2(deter_2), .deter_3(deter_3));

// ===============================================================
// FSM Declaration
// ===============================================================

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
            else  nextState = State;
        end
        READ: begin
            if(!in_valid) nextState = DONE;
            else nextState = State;
        end
        // CAL: begin
        //     nextState = DONE;
        // end
        default: begin
            nextState = IDLE;
        end
    endcase 
end


// ===============================================================
//  Design
// ===============================================================
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) t <=0;
    else if(State == READ) t <= t +1;
    else t <= 0;
end

// wire [50:0] df;
// assign df = result[203:153];

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(k = 0; k < 15; k ++) begin
            input_matrix[k] <= 0;
        end
    end
    else if(State == READ) input_matrix[t] <= H1_out;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mode <= 0;
    end
    else if(State == READ && t == 0) mode <= {H2_out[4],H2_out[2:1]};
end

always@(*) begin
    case(t)
        
        5:begin
            a = input_matrix[0];
            b = input_matrix[1];
            c = 0;
            d = input_matrix[4];
            e = H1_out;
            f = 0;
            g = 0;
            h = 0;
            i = 0;
        end
        6:begin
            a = input_matrix[1];
            b = input_matrix[2];
            c = 0;
            d = input_matrix[5];
            e = H1_out;
            f = 0;
            g = 0;
            h = 0;
            i = 0;
        end
        7:begin
            a = input_matrix[2];
            b = input_matrix[3];
            c = 0;
            d = input_matrix[6];
            e = H1_out;
            f = 0;
            g = 0;
            h = 0;
            i = 0;
        end
        9:begin
            a = input_matrix[4];
            b = input_matrix[5];
            c = 0;
            d = input_matrix[8];
            e = H1_out;
            f = 0;
            g = 0;
            h = 0;
            i = 0;
        end
        10:begin
            if(mode == 3'b010) begin
                a = input_matrix[5];
                b = input_matrix[6];
                c = 0;
                d = input_matrix[9];
                e = H1_out;
                f = 0;
                g = 0;
                h = 0;
                i = 0;
            end
            else begin
                a = input_matrix[0];
                b = input_matrix[1];
                c = input_matrix[2];
                d = input_matrix[4];
                e = input_matrix[5];
                f = input_matrix[6];
                g = input_matrix[8];
                h = input_matrix[9];
                i = H1_out;
            end
            
        end
        11:begin
            if(mode == 3'b010) begin
                a = input_matrix[6];
                b = input_matrix[7];
                c = 0;
                d = input_matrix[10];
                e = H1_out;
                f = 0;
                g = 0;
                h = 0;
                i = 0;
            end
            else if (mode == 3'b011) begin
                a = input_matrix[1];
                b = input_matrix[2];
                c = input_matrix[3];
                d = input_matrix[5];
                e = input_matrix[6];
                f = input_matrix[7];
                g = input_matrix[9];
                h = input_matrix[10];
                i = H1_out;
            end
            else begin
                a = input_matrix[1];
                b = input_matrix[2];
                c = input_matrix[3];
                d = input_matrix[5];
                e = input_matrix[6];
                f = input_matrix[7];
                g = input_matrix[9];
                h = input_matrix[10];
                i = H1_out;
            end
        end
        12:begin
                a = input_matrix[0];
                b = input_matrix[2];
                c = input_matrix[3];
                d = input_matrix[4];
                e = input_matrix[6];
                f = input_matrix[7];
                g = input_matrix[8];
                h = input_matrix[10];
                i = input_matrix[11];
        end
        13:begin
            if(mode == 3'b010) begin
                a = input_matrix[8];
                b = input_matrix[9];
                c = 0;
                d = input_matrix[12];
                e = H1_out;
                f = 0;
                g = 0;
                h = 0;
                i = 0;
                
            end
            else begin
                a = input_matrix[0];
                b = input_matrix[1];
                c = input_matrix[3];
                d = input_matrix[4];
                e = input_matrix[5];
                f = input_matrix[7];
                g = input_matrix[8];
                h = input_matrix[9];
                i = input_matrix[11];
            end
        end
        14:begin
            if(mode == 3'b010) begin
                a = input_matrix[9];
                b = input_matrix[10];
                c = 0;
                d = input_matrix[13];
                e = H1_out;
                f = 0;
                g = 0;
                h = 0;
                i = 0;
            end
            else if (mode == 3'b011) begin
                a = input_matrix[4];
                b = input_matrix[5];
                c = input_matrix[6];
                d = input_matrix[8];
                e = input_matrix[9];
                f = input_matrix[10];
                g = input_matrix[12];
                h = input_matrix[13];
                i = H1_out;
            end
            else begin
                a = input_matrix[0];
                b = input_matrix[1];
                c = input_matrix[2];
                d = input_matrix[4];
                e = input_matrix[5];
                f = input_matrix[6];
                g = input_matrix[8];
                h = input_matrix[9];
                i = input_matrix[10];
            end
        end
        15:begin
            if(mode == 3'b010) begin
                a = input_matrix[10];
                b = input_matrix[11];
                c = 0;
                d = input_matrix[14];
                e = H1_out;
                f = 0;
                g = 0;
                h = 0;
                i = 0;
            end
            else begin
                a = input_matrix[5];
                b = input_matrix[6];
                c = input_matrix[7];
                d = input_matrix[9];
                e = input_matrix[10];
                f = input_matrix[11];
                g = input_matrix[13];
                h = input_matrix[14];
                i = H1_out;
            end
        end 
        default:begin
                a = 0;
                b = 0;
                c = 0;
                d = 0;
                e = 0;
                f = 0;
                g = 0;
                h = 0;
                i = 0;
        end 
    endcase
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        result <= 0;
    end
    else if(State == DONE) begin
        result<= 0;
    end
    else if(State == READ) begin
        case(t)
            5: begin
                if(mode == 3'b010) result[206:184] <= deter_2;
            end
            6: begin
                   if(mode == 3'b010) result[183:161] <= deter_2;
            end
            7: begin
                 if(mode == 3'b010)   result[160:138] <= deter_2;
            end
            9: begin
                 if(mode == 3'b010)   result[137:115] <= deter_2;
            end
            10: begin
                if(mode == 3'b010) begin
                    result[114:92] <= deter_2;
                end
                else if(mode == 3'b011) begin
                    result[203:153] <= {{15{deter_3[35]}},deter_3};
                end
            end
            11: begin
                if(mode == 3'b010) begin
                    result[91:69] <= deter_2;
                end
                else if(mode == 3'b011) begin
                    result[152:102] <= {{15{deter_3[35]}},deter_3};
                end
                else if(mode == 3'b111) begin
                    result[203:153] <= {{15{deter_3[35]}},deter_3};
                end
            end
            12: begin
                if(mode == 3'b111) begin
                    result[203:153] <= {{2{add_res[48]}},add_res};
                    result[152:102] <= {{15{deter_3[35]}},deter_3};
                end
            end
            13: begin
                if(mode == 3'b010) begin
                    result[68:46] <= deter_2;
                end
                else if(mode == 3'b111) begin
                    result[203:153] <= {{2{add_res[48]}},add_res};
                    result[101:51] <= {{15{deter_3[35]}},deter_3};
                end
            end
            14: begin
                if(mode == 3'b010) begin
                    result[45:23] <= deter_2;
                end
                else if(mode == 3'b011) begin
                    result[101:51] <= {{15{deter_3[35]}},deter_3};
                end
                else if(mode == 3'b111) begin
                    result[203:153] <= {{2{add_res[48]}},add_res};
                    result[50:0] <= {{15{deter_3[35]}},deter_3};
                end
            end
            15: begin
                if(mode == 3'b010) begin
                    result[22:0] <= deter_2;
                end
                else if(mode == 3'b011) begin
                    result[50:0] <= {{15{deter_3[35]}},deter_3};
                end
                else if(mode == 3'b111) begin
                    result[203:153] <= {{2{add_res[48]}},add_res};
                end
            end
        endcase
    end
end




always@(*) begin
    case(t)
        12: mul_in_1 = ((~result[188:153])+36'd1);
        13: mul_in_1 = result[137:102];
        14: mul_in_1 = ((~result[86:51])+36'd1);
        default: mul_in_1 = result[35:0];
    endcase

        mul_in_2 =  H1_out;

    mul_res = $signed(mul_in_1)*$signed(mul_in_2);
    add_in_1 = {{2{mul_res[46]}},mul_res};
    if(t == 12) add_in_2 = 0;
    else add_in_2 = result[201:153];
    add_res = add_in_1 + add_in_2;
end


endmodule

module determinant3(a, b, c, d, e, f, g, h, i, deter_2, deter_3);
    input signed [10:0] a, b, c, d, e, f, g, h, i;
    output reg signed [22:0] deter_2;
    output reg signed [35:0] deter_3;

    reg signed [22:0] det_2_1, det_2_2, det_2_3;
    reg signed [22:0] mul_2_1, mul_2_2, mul_2_3, mul_2_4, mul_2_5, mul_2_6;


    always@(*) begin
        mul_2_1 = b*f;
        mul_2_2 = e*c;
        mul_2_3 = a*f;
        mul_2_4 = c*d;
        mul_2_5 = a*e;
        mul_2_6 = b*d;
        det_2_1 = mul_2_1 - mul_2_2;
        det_2_2 = mul_2_3 - mul_2_4;
        det_2_3 = mul_2_5 - mul_2_6;
        deter_2 = det_2_3;
        deter_3 = g*det_2_1-h*det_2_2+i*det_2_3;
    end

endmodule