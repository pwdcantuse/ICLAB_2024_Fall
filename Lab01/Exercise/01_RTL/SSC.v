//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2024 Fall
//   Lab01 Exercise		: Snack Shopping Calculator
//   Author     		  : Yu-Hsiang Wang
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : SSC.v
//   Module Name : SSC
//   Release version : V1.0 (Release Date: 2024-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module SSC(
    // Input signals
    card_num,
    input_money,
    snack_num,
    price, 
    // Output signals
    out_valid,
    out_change
);

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
input [63:0] card_num;
input [8:0] input_money;
input [31:0] snack_num;
input [31:0] price;
output out_valid;
output [8:0] out_change;    

//================================================================
//    Wire & Registers 
//================================================================
// Declare the wire/reg you would use in your circuit
// remember 
// wire for port connection and cont. assignment
// reg for proc. assignment
wire [7:0]  sum;
wire [6:0]  sum_of_odd,sum_of_even;


reg [3:0] shift_1, shift_2, shift_3, shift_4, shift_5, shift_6, shift_7, shift_8;

wire [7:0] com_1, com_2, com_3, com_4,com_15, com_16, 
com_17, com_18;
reg [7:0] com_9,  com_12, com_13, com_14,
com_25, com_26, com_47, com_48;

reg [7:0] com_27, com_28, com_29, com_30, com_31, com_32, 
com_33, com_34, com_35, com_36, com_37, com_38, com_39, com_40, 
com_41, com_42, com_43, com_44, com_45, com_46;

reg [8:0] out_change_0;
reg out_valid_0;

wire [9:0] change_1, change_2, change_3, change_4, change_5, change_6, change_7, change_8;

wire [4:0] w1, w2, w3, w4, w5, w6, w7, w8;
wire [5:0] w9, w10, w11, w12;




//================================================================
//    DESIGN
//================================================================

//////////// port /////////////


assign out_valid = out_valid_0;
assign out_change = out_change_0;

always@(*) begin

    case(sum)
        8'd0: out_valid_0 = 1'b1;
        8'd10: out_valid_0 = 1'b1;
        8'd20:  out_valid_0 = 1'b1;
        8'd30:  out_valid_0 = 1'b1;
        8'd40:  out_valid_0 = 1'b1;
        8'd50:  out_valid_0 = 1'b1;
        8'd60:  out_valid_0 = 1'b1;
        8'd70:  out_valid_0 = 1'b1;
        8'd80:  out_valid_0 = 1'b1;
        8'd90:  out_valid_0 = 1'b1;
        8'd100: out_valid_0 = 1'b1;
        8'd110: out_valid_0 = 1'b1;
        8'd120: out_valid_0 = 1'b1;
        8'd130: out_valid_0 = 1'b1;
        8'd140: out_valid_0 = 1'b1;
        8'd150: out_valid_0 = 1'b1;
        default : out_valid_0 = 1'b0;
    endcase

end




//////////////////////////////
assign w1 = card_num[3:0] + card_num[11:8];
assign w2 =  card_num[19:16] + card_num[27:24];
assign w3 = card_num[35:32] + card_num[43:40];
assign w4 = card_num[51:48] + card_num[59:56];
assign w9 = w1+w2;
assign w10 = w3+w4;
assign sum_of_even = w9+w10;

assign w5 = shift_1 + shift_3;
assign w6 = shift_2 + shift_4;
assign w7 = shift_8 + shift_6;
assign w8 = shift_7 + shift_5 ;
assign w11 = w5 + w6;
assign w12 = w7 + w8;
assign sum_of_odd = w11+w12;

always@(*) begin
 
    if(!(|card_num[7:4]) || card_num[7:4] == 4'd1 || card_num[7:4] == 4'd2 || card_num[7:4] == 4'd3 || card_num[7:4] == 4'd4) begin
    case(card_num[7:4]) 
        4'd1 : shift_1 = 4'd2;
        4'd2 : shift_1 = 4'd4; 
        4'd3 : shift_1 = 4'd6; 
        4'd4 : shift_1 = 4'd8; 
        default: shift_1 = 4'd0;
    endcase
end
else begin
    case(card_num[7:4])
        4'd5 : shift_1 = 4'd1; 
        4'd6 : shift_1 = 4'd3; 
        4'd7 : shift_1 = 4'd5; 
        4'd8 : shift_1 = 4'd7; 
        default: shift_1 = 4'd9;
    endcase
end

if(!(|card_num[15:12]) || card_num[15:12] == 4'd1 || card_num[15:12] == 4'd2 || card_num[15:12] == 4'd3 || card_num[15:12] == 4'd4) begin
    case(card_num[15:12]) 
        4'd1 : shift_2 = 4'd2;
        4'd2 : shift_2 = 4'd4; 
        4'd3 : shift_2 = 4'd6; 
        4'd4 : shift_2 = 4'd8; 
        default: shift_2 = 4'd0;
    endcase
end
else begin
    case(card_num[15:12])
        4'd5 : shift_2 = 4'd1; 
        4'd6 : shift_2 = 4'd3; 
        4'd7 : shift_2 = 4'd5; 
        4'd8 : shift_2 = 4'd7; 
        default: shift_2 = 4'd9;
    endcase
end

if(!(|card_num[23:20]) || card_num[23:20] == 4'd1 || card_num[23:20] == 4'd2 || card_num[23:20] == 4'd3 || card_num[23:20] == 4'd4) begin
    case(card_num[23:20]) 
        4'd1 : shift_3 = 4'd2;
        4'd2 : shift_3 = 4'd4; 
        4'd3 : shift_3 = 4'd6; 
        4'd4 : shift_3 = 4'd8; 
        default: shift_3 = 4'd0;
    endcase
end
else begin
    case(card_num[23:20])
        4'd5 : shift_3 = 4'd1; 
        4'd6 : shift_3 = 4'd3; 
        4'd7 : shift_3 = 4'd5; 
        4'd8 : shift_3 = 4'd7; 
        default: shift_3 = 4'd9;
    endcase
end

if(!(|card_num[31:28]) || card_num[31:28] == 4'd1 || card_num[31:28] == 4'd2 || card_num[31:28] == 4'd3 || card_num[31:28] == 4'd4) begin
    case(card_num[31:28]) 
        4'd1 : shift_4 = 4'd2;
        4'd2 : shift_4 = 4'd4; 
        4'd3 : shift_4 = 4'd6; 
        4'd4 : shift_4 = 4'd8; 
        default: shift_4 = 4'd0;
    endcase
end
else begin
    case(card_num[31:28])
        4'd5 : shift_4 = 4'd1; 
        4'd6 : shift_4 = 4'd3; 
        4'd7 : shift_4 = 4'd5; 
        4'd8 : shift_4 = 4'd7; 
        default: shift_4 = 4'd9;
    endcase
end

if(!(|card_num[39:36]) || card_num[39:36] == 4'd1 || card_num[39:36] == 4'd2 || card_num[39:36] == 4'd3 || card_num[39:36] == 4'd4) begin
    case(card_num[39:36]) 
        4'd1 : shift_5 = 4'd2;
        4'd2 : shift_5 = 4'd4; 
        4'd3 : shift_5 = 4'd6; 
        4'd4 : shift_5 = 4'd8; 
        default: shift_5 = 4'd0;
    endcase
end
else begin
    case(card_num[39:36])
        4'd5 : shift_5 = 4'd1; 
        4'd6 : shift_5 = 4'd3; 
        4'd7 : shift_5 = 4'd5; 
        4'd8 : shift_5 = 4'd7; 
        default: shift_5 = 4'd9;
    endcase
end

if(!(|card_num[47:44]) || card_num[47:44] == 4'd1 || card_num[47:44] == 4'd2 || card_num[47:44] == 4'd3 || card_num[47:44] == 4'd4) begin
    case(card_num[47:44]) 
        4'd1 : shift_6 = 4'd2;
        4'd2 : shift_6 = 4'd4; 
        4'd3 : shift_6 = 4'd6; 
        4'd4 : shift_6 = 4'd8; 
        default: shift_6 = 4'd0;
    endcase
end
else begin
    case(card_num[47:44])
        4'd5 : shift_6 = 4'd1; 
        4'd6 : shift_6 = 4'd3; 
        4'd7 : shift_6 = 4'd5; 
        4'd8 : shift_6 = 4'd7; 
        default: shift_6 = 4'd9;
    endcase
end

if(!(|card_num[55:52]) || card_num[55:52] == 4'd1 || card_num[55:52] == 4'd2 || card_num[55:52] == 4'd3 || card_num[55:52] == 4'd4) begin
    case(card_num[55:52]) 
        4'd1 : shift_7 = 4'd2;
        4'd2 : shift_7 = 4'd4; 
        4'd3 : shift_7 = 4'd6; 
        4'd4 : shift_7 = 4'd8; 
        default: shift_7 = 4'd0;
    endcase
end
else begin
    case(card_num[55:52])
        4'd5 : shift_7 = 4'd1; 
        4'd6 : shift_7 = 4'd3; 
        4'd7 : shift_7 = 4'd5; 
        4'd8 : shift_7 = 4'd7; 
        default: shift_7 = 4'd9;
    endcase
end

if(!(|card_num[63:60]) || card_num[63:60] == 4'd1 || card_num[63:60] == 4'd2 || card_num[63:60] == 4'd3 || card_num[63:60] == 4'd4) begin
    case(card_num[63:60]) 
        4'd1 : shift_8 = 4'd2;
        4'd2 : shift_8 = 4'd4; 
        4'd3 : shift_8 = 4'd6; 
        4'd4 : shift_8 = 4'd8; 
        default: shift_8 = 4'd0;
    endcase
end
else begin
    case(card_num[63:60])
        4'd5 : shift_8 = 4'd1; 
        4'd6 : shift_8 = 4'd3; 
        4'd7 : shift_8 = 4'd5; 
        4'd8 : shift_8 = 4'd7; 
        default: shift_8 = 4'd9;
    endcase
end

 
end



assign sum = sum_of_even + sum_of_odd;


assign change_1 = input_money-com_34;
assign change_2 = change_1-com_40;
assign change_3 = change_2-com_44;
assign change_4 = change_3-com_46;
assign change_5 = change_4-com_45;
assign change_6 = change_5-com_41;
assign change_7 = change_6-com_35;
assign change_8 = change_7-com_27;


DW02_mult_oper m1(snack_num[3:0], price[3:0], 1'b0,com_1);
DW02_mult_oper m2(snack_num[7:4], price[7:4], 1'b0,com_2);
DW02_mult_oper m3(snack_num[11:8], price[11:8], 1'b0,com_3);
DW02_mult_oper m4(snack_num[15:12], price[15:12], 1'b0,com_4);
DW02_mult_oper m5(snack_num[19:16], price[19:16], 1'b0,com_15);
DW02_mult_oper m6(snack_num[23:20], price[23:20], 1'b0,com_16);
DW02_mult_oper m7(snack_num[27:24], price[27:24], 1'b0,com_17);
DW02_mult_oper m8(snack_num[31:28] , price[31:28] , 1'b0,com_18);

always@(*) begin
    if(change_1[9]||!out_valid) begin
        out_change_0 = input_money;
    end
    else if(change_2[9]) begin
        out_change_0 = change_1[8:0];
    end
    else if(change_3[9])begin
        out_change_0 = change_2[8:0];
    end
    else if(change_4[9])begin
        out_change_0 = change_3[8:0];
    end
    else if(change_5[9])begin
        out_change_0 = change_4[8:0];
    end
    else if(change_6[9])begin
        out_change_0 = change_5[8:0];
    end
    else if(change_7[9])begin
        out_change_0 = change_6[8:0];
    end
    else if(change_8[9])begin
        out_change_0 = change_7[8:0];
    end
    else begin
        out_change_0 = change_8[8:0];
    end
end





//////////////// sort /////////////////////

always@(*) begin
    if(com_1 >= com_2 && com_1 >= com_3 && com_1 >= com_4) begin
        if(com_2 >= com_3 && com_2 >= com_4) begin
            if(com_3 >= com_4) begin
                com_9 = com_4;
                com_13 = com_3;
                com_14 = com_2;
                com_12 = com_1;
            end
            else begin
                com_9 = com_3;
                com_13 = com_4;
                com_14 = com_2;
                com_12 = com_1;
            end
        end
        else if(com_3 >= com_2 && com_3 >= com_4) begin
            if(com_2 >= com_4) begin
                com_9 = com_4;
                com_13 = com_2;
                com_14 = com_3;
                com_12 = com_1;
            end
            else begin
                com_9 = com_2;
                com_13 = com_4;
                com_14 = com_3;
                com_12 = com_1;
            end
        end 
        else begin
            if(com_2 >= com_3) begin
                com_9 = com_3;
                com_13 = com_2;
                com_14 = com_4;
                com_12 = com_1;
            end
            else begin
                com_9 = com_2;
                com_13 = com_3;
                com_14 = com_4;
                com_12 = com_1;
            end
        end
    end
    else if(com_2 >= com_1 && com_2 >= com_3 && com_2 >= com_4) begin
        if(com_1 >= com_3 && com_1 >= com_4) begin
            if(com_3 >= com_4) begin
                com_9 = com_4;
                com_13 = com_3;
                com_14 = com_1;
                com_12 = com_2;
            end
            else begin
                com_9 = com_3;
                com_13 = com_4;
                com_14 = com_1;
                com_12 = com_2;
            end
        end
        else if(com_3 >= com_1 && com_3 >= com_4) begin
            if(com_1 >= com_4) begin
                com_9 = com_4;
                com_13 = com_1;
                com_14 = com_3;
                com_12 = com_2;
            end
            else begin
                com_9 = com_1;
                com_13 = com_4;
                com_14 = com_3;
                com_12 = com_2;
            end
        end 
        else begin
            if(com_1 >= com_3) begin
                com_9 = com_3;
                com_13 = com_1;
                com_14 = com_4;
                com_12 = com_2;
            end
            else begin
                com_9 = com_1;
                com_13 = com_3;
                com_14 = com_4;
                com_12 = com_2;
            end
        end
    end
    else if(com_3 >= com_1 && com_3 >= com_2 && com_3 >= com_4) begin
        if(com_1 >= com_2 && com_1 >= com_4) begin
            if(com_2 >= com_4) begin
                com_9 = com_4;
                com_13 = com_2;
                com_14 = com_1;
                com_12 = com_3;
            end
            else begin
                com_9 = com_2;
                com_13 = com_4;
                com_14 = com_1;
                com_12 = com_3;
            end
        end
        else if(com_2 >= com_1 && com_2 >= com_4) begin
            if(com_1 >= com_4) begin
                com_9 = com_4;
                com_13 = com_1;
                com_14 = com_2;
                com_12 = com_3;
            end
            else begin
                com_9 = com_1;
                com_13 = com_4;
                com_14 = com_2;
                com_12 = com_3;
            end
        end 
        else begin
            if(com_1 >= com_2) begin
                com_9 = com_2;
                com_13 = com_1;
                com_14 = com_4;
                com_12 = com_3;
            end
            else begin
                com_9 = com_1;
                com_13 = com_2;
                com_14 = com_4;
                com_12 = com_3;
            end
        end
    end
    else begin
        if(com_1 >= com_2 && com_1 >= com_3) begin
            if(com_2 >= com_3) begin
                com_9 = com_3;
                com_13 = com_2;
                com_14 = com_1;
                com_12 = com_4;
            end
            else begin
                com_9 = com_2;
                com_13 = com_3;
                com_14 = com_1;
                com_12 = com_4;
            end
        end
        else if(com_2 >= com_1 && com_2 >= com_3) begin
            if(com_1 >= com_3) begin
                com_9 = com_3;
                com_13 = com_1;
                com_14 = com_2;
                com_12 = com_4;
            end
            else begin
                com_9 = com_1;
                com_13 = com_3;
                com_14 = com_2;
                com_12 = com_4;
            end
        end 
        else begin
            if(com_1 >= com_2) begin
                com_9 = com_2;
                com_13 = com_1;
                com_14 = com_3;
                com_12 = com_4;
            end
            else begin
                com_9 = com_1;
                com_13 = com_2;
                com_14 = com_3;
                com_12 = com_4;
            end
        end
    end

end


always@(*) begin
    if(com_15 >= com_16 && com_15 >= com_17 && com_15 >= com_18) begin
        if(com_16 >= com_17 && com_16 >= com_18) begin
            if(com_17 >= com_18) begin
                com_47 = com_18;
                com_25 = com_17;
                com_26 = com_16;
                com_48 = com_15;
            end
            else begin
                com_47 = com_17;
                com_25 = com_18;
                com_26 = com_16;
                com_48 = com_15;
            end
        end
        else if(com_17 >= com_16 && com_17 >= com_18) begin
            if(com_16 >= com_18) begin
                com_47 = com_18;
                com_25 = com_16;
                com_26 = com_17;
                com_48 = com_15;
            end
            else begin
                com_47 = com_16;
                com_25 = com_18;
                com_26 = com_17;
                com_48 = com_15;
            end
        end 
        else begin
            if(com_16 >= com_17) begin
                com_47 = com_17;
                com_25 = com_16;
                com_26 = com_18;
                com_48 = com_15;
            end
            else begin
                com_47 = com_16;
                com_25 = com_17;
                com_26 = com_18;
                com_48 = com_15;
            end
        end
    end
    else if(com_16 >= com_15 && com_16 >= com_17 && com_16 >= com_18) begin
        if(com_15 >= com_17 && com_15 >= com_18) begin
            if(com_17 >= com_18) begin
                com_47 = com_18;
                com_25 = com_17;
                com_26 = com_15;
                com_48 = com_16;
            end
            else begin
                com_47 = com_17;
                com_25 = com_18;
                com_26 = com_15;
                com_48 = com_16;
            end
        end
        else if(com_17 >= com_15 && com_17 >= com_18) begin
            if(com_15 >= com_18) begin
                com_47 = com_18;
                com_25 = com_15;
                com_26 = com_17;
                com_48 = com_16;
            end
            else begin
                com_47 = com_15;
                com_25 = com_18;
                com_26 = com_17;
                com_48 = com_16;
            end
        end 
        else begin
            if(com_15 >= com_17) begin
                com_47 = com_17;
                com_25 = com_15;
                com_26 = com_18;
                com_48 = com_16;
            end
            else begin
                com_47 = com_15;
                com_25 = com_17;
                com_26 = com_18;
                com_48 = com_16;
            end
        end
    end
    else if(com_17 >= com_15 && com_17 >= com_16 && com_17 >= com_18) begin
        if(com_15 >= com_16 && com_15 >= com_18) begin
            if(com_16 >= com_18) begin
                com_47 = com_18;
                com_25 = com_16;
                com_26 = com_15;
                com_48 = com_17;
            end
            else begin
                com_47 = com_16;
                com_25 = com_18;
                com_26 = com_15;
                com_48 = com_17;
            end
        end
        else if(com_16 >= com_15 && com_16 >= com_18) begin
            if(com_15 >= com_18) begin
                com_47 = com_18;
                com_25 = com_15;
                com_26 = com_16;
                com_48 = com_17;
            end
            else begin
                com_47 = com_15;
                com_25 = com_18;
                com_26 = com_16;
                com_48 = com_17;
            end
        end 
        else begin
            if(com_15 >= com_16) begin
                com_47 = com_16;
                com_25 = com_15;
                com_26 = com_18;
                com_48 = com_17;
            end
            else begin
                com_47 = com_15;
                com_25 = com_16;
                com_26 = com_18;
                com_48 = com_17;
            end
        end
    end
    else begin
        if(com_15 >= com_16 && com_15 >= com_17) begin
            if(com_16 >= com_17) begin
                com_47 = com_17;
                com_25 = com_16;
                com_26 = com_15;
                com_48 = com_18;
            end
            else begin
                com_47 = com_16;
                com_25 = com_17;
                com_26 = com_15;
                com_48 = com_18;
            end
        end
        else if(com_16 >= com_15 && com_16 >= com_17) begin
            if(com_15 >= com_17) begin
                com_47 = com_17;
                com_25 = com_15;
                com_26 = com_16;
                com_48 = com_18;
            end
            else begin
                com_47 = com_15;
                com_25 = com_17;
                com_26 = com_16;
                com_48 = com_18;
            end
        end 
        else begin
            if(com_15 >= com_16) begin
                com_47 = com_16;
                com_25 = com_15;
                com_26 = com_17;
                com_48 = com_18;
            end
            else begin
                com_47 = com_15;
                com_25 = com_16;
                com_26 = com_17;
                com_48 = com_18;
            end
        end
    end

 
end



wire comp_result[0:9];

DW01_cmp2_oper comp_1(com_12, com_48, 1'b0, comp_result[0]);
DW01_cmp2_oper comp_2(com_9, com_47, 1'b0, comp_result[1]);
DW01_cmp2_oper comp_3(com_13, com_25, 1'b0, comp_result[2]);
DW01_cmp2_oper comp_4(com_14, com_26, 1'b0, comp_result[3]);
DW01_cmp2_oper comp_5(com_28, com_29, 1'b0, comp_result[4]);
DW01_cmp2_oper comp_6(com_30, com_31, 1'b0, comp_result[5]);
DW01_cmp2_oper comp_7(com_32, com_33, 1'b0, comp_result[6]);
DW01_cmp2_oper comp_8(com_36, com_37, 1'b0, comp_result[7]);
DW01_cmp2_oper comp_9(com_38, com_39, 1'b0, comp_result[8]);
DW01_cmp2_oper comp_10(com_42, com_43,1'b0, comp_result[9]);

always@(*) begin
    
    if(comp_result[0]) begin
        com_34 = com_12;
        com_33 = com_48;
    end
    else begin
        com_34 = com_48;
        com_33 = com_12;
    end
    if(comp_result[1]) begin
        com_27 = com_47;
        com_28 = com_9;
    end
    else begin
        com_27 = com_9;
        com_28 = com_47;
    end
    if(comp_result[2]) begin
        com_29 = com_25;
        com_30 = com_13;
    end
    else begin
        com_29 = com_13;
        com_30 = com_25;
    end
    if(comp_result[3]) begin
        com_31 = com_26;
        com_32 = com_14;
    end
    else begin
        com_31 = com_14;
        com_32 = com_26;
    end
    if(comp_result[4]) begin
        com_35 = com_29;
        com_36 = com_28;
    end
    else begin
        com_35 = com_28;
        com_36 = com_29;
    end
    if(comp_result[5]) begin
        com_37 = com_31;
        com_38 = com_30;
    end
    else begin
        com_37 = com_30;
        com_38 = com_31;
    end
    if(comp_result[6]) begin
        com_39 = com_33;
        com_40 = com_32;
    end
    else begin
        com_39 = com_32;
        com_40 = com_33;
    end
    if(comp_result[7]) begin
        com_41 = com_37;
        com_42 = com_36;
    end
    else begin
        com_41 = com_36;
        com_42 = com_37;
    end
    if(comp_result[8]) begin
        com_43 = com_39;
        com_44 = com_38;
    end
    else begin
        com_43 = com_38;
        com_44 = com_39;
    end
    if(comp_result[9]) begin
        com_45 = com_43;
        com_46 = com_42;
    end
    else begin
        com_45 = com_42;
        com_46 = com_43;
    end
end

//////////////////////////////////////////



endmodule

module DW01_cmp2_oper(in1, in2, instruction, comparison);
  parameter wordlength = 8;

  input [wordlength-1:0] in1, in2;
  input instruction;
  output comparison;
  reg comparison;
 
  always @ (in1 or in2 or instruction)
  begin
    if (instruction == 0)
      comparison = (in1 > in2);
    else
      comparison = (in1 >= in2);
  end
endmodule

module DW02_mult_oper (in1, in2, control, product);
  parameter wordlength1 = 4, wordlength2 = 4;
  input [wordlength1-1:0] in1; 
  input [wordlength2-1:0] in2; 
  input control; 

  output [wordlength1+wordlength2-1:0] product;
  wire signed [wordlength1+wordlength2-1:0] product_sig; 
  wire [wordlength1+wordlength2-1:0] product_usig;

  assign product_sig = $signed(in1) * $signed(in2); 
  assign product_usig = in1 * in2;
  assign product = (control == 1'b1) ? $unsigned(product_sig) : product_usig;
endmodule
