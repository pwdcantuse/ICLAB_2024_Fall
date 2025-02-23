//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2024/10
//		Version		: v1.0
//   	File Name   : HAMMING_IP.v
//   	Module Name : HAMMING_IP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module HAMMING_IP #(parameter IP_BIT = 8) (
    // Input signals
    IN_code,
    // Output signals
    OUT_code
);

// ===============================================================
// Input & Output
// ===============================================================
input [IP_BIT+4-1:0]  IN_code;

output reg [IP_BIT-1:0] OUT_code;

// ===============================================================
// Design
// ===============================================================



genvar i;

generate
    case(IP_BIT)
        5: begin : hamming_code_5
            wire [3:0] result;
            reg [IP_BIT+4-1:0] temp;
            assign result[0] = IN_code[8]^IN_code[6]^IN_code[4]^IN_code[2]^IN_code[0];
            assign result[1] = IN_code[7]^IN_code[6]^IN_code[3]^IN_code[2];
            assign result[2] = IN_code[5]^IN_code[4]^IN_code[3]^IN_code[2];
            assign result[3] = IN_code[1]^IN_code[0];
            
            always@(*) begin
                temp = IN_code;
                temp[IP_BIT+4-result] = ~temp[IP_BIT+4-result];
                OUT_code = {temp[6],temp[4:2],temp[0]};
            end
        end
        6: begin : hamming_code_6
            wire [3:0] result;
            reg [IP_BIT+4-1:0] temp;
            assign result[0] = IN_code[9]^IN_code[7]^IN_code[5]^IN_code[3]^IN_code[1];
            assign result[1] = IN_code[8]^IN_code[7]^IN_code[4]^IN_code[3]^IN_code[0];
            assign result[2] = IN_code[6]^IN_code[5]^IN_code[4]^IN_code[3];
            assign result[3] = IN_code[2]^IN_code[1]^IN_code[0];
            always@(*) begin
                temp = IN_code;
                temp[IP_BIT+4-result] = ~temp[IP_BIT+4-result];
                OUT_code = {temp[7],temp[5:3],temp[1:0]};
            end
        end
        7: begin : hamming_code_7
            wire [3:0] result;
            reg [IP_BIT+4-1:0] temp;
            assign result[0] = IN_code[10]^IN_code[8]^IN_code[6]^IN_code[4]^IN_code[2]^IN_code[0];
            assign result[1] = IN_code[9]^IN_code[8]^IN_code[5]^IN_code[4]^IN_code[1]^IN_code[0];
            assign result[2] = IN_code[7]^IN_code[6]^IN_code[5]^IN_code[4];
            assign result[3] = IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
            always@(*) begin
                temp = IN_code;
                temp[IP_BIT+4-result] = ~temp[IP_BIT+4-result];
                OUT_code = {temp[8],temp[6:4],temp[2:0]};
            end
        end
        8: begin : hamming_code_8
            wire [3:0] result;
            reg [IP_BIT+4-1:0] temp;
            assign result[0] = IN_code[11]^IN_code[9]^IN_code[7]^IN_code[5]^IN_code[3]^IN_code[1];
            assign result[1] = IN_code[10]^IN_code[9]^IN_code[6]^IN_code[5]^IN_code[2]^IN_code[1];
            assign result[2] = IN_code[8]^IN_code[7]^IN_code[6]^IN_code[5]^IN_code[0];
            assign result[3] = IN_code[4]^IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
            always@(*) begin
                temp = IN_code;
                temp[IP_BIT+4-result] = ~temp[IP_BIT+4-result];
                OUT_code = {temp[9],temp[7:5],temp[3:0]};
            end
        end
        9: begin : hamming_code_9
            wire [3:0] result;
            reg [IP_BIT+4-1:0] temp;
            assign result[0] = IN_code[12]^IN_code[10]^IN_code[8]^IN_code[6]^IN_code[4]^IN_code[2]^IN_code[0];
            assign result[1] = IN_code[11]^IN_code[10]^IN_code[7]^IN_code[6]^IN_code[3]^IN_code[2];
            assign result[2] = IN_code[9]^IN_code[8]^IN_code[7]^IN_code[6]^IN_code[1]^IN_code[0];
            assign result[3] = IN_code[5]^IN_code[4]^IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
            always@(*) begin
                temp = IN_code;
                temp[IP_BIT+4-result] = ~temp[IP_BIT+4-result];
                OUT_code = {temp[10],temp[8:6],temp[4:0]};
            end
        end
        10: begin : hamming_code_10
            wire [3:0] result;
            reg [IP_BIT+4-1:0] temp;
            assign result[0] = IN_code[13]^IN_code[11]^IN_code[9]^IN_code[7]^IN_code[5]^IN_code[3]^IN_code[1];
            assign result[1] = IN_code[12]^IN_code[11]^IN_code[8]^IN_code[7]^IN_code[4]^IN_code[3]^IN_code[0];
            assign result[2] = IN_code[10]^IN_code[9]^IN_code[8]^IN_code[7]^IN_code[2]^IN_code[1]^IN_code[0];
            assign result[3] = IN_code[6]^IN_code[5]^IN_code[4]^IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
            always@(*) begin
                temp = IN_code;
                temp[IP_BIT+4-result] = ~temp[IP_BIT+4-result];
                OUT_code = {temp[11],temp[9:7],temp[5:0]};
            end
        end
        11: begin : hamming_code_11
            wire [3:0] result;
            reg [IP_BIT+4-1:0] temp;
            assign result[0] = IN_code[14]^IN_code[12]^IN_code[10]^IN_code[8]^IN_code[6]^IN_code[4]^IN_code[2]^IN_code[0];
            assign result[1] = IN_code[13]^IN_code[12]^IN_code[9]^IN_code[8]^IN_code[5]^IN_code[4]^IN_code[1]^IN_code[0];
            assign result[2] = IN_code[11]^IN_code[10]^IN_code[9]^IN_code[8]^IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
            assign result[3] = IN_code[7]^IN_code[6]^IN_code[5]^IN_code[4]^IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
            always@(*) begin
                temp = IN_code;
                temp[IP_BIT+4-result] = ~temp[IP_BIT+4-result];
                OUT_code = {temp[12],temp[10:8],temp[6:0]};
            end
        end
    endcase
endgenerate

// always@(*) begin
//     case(IP_BIT)
//         5: begin
//             result[0] = IN_code[8]^IN_code[6]^IN_code[4]^IN_code[2]^IN_code[0];
//             result[1] = IN_code[7]^IN_code[6]^IN_code[3]^IN_code[2];
//             result[2] = IN_code[5]^IN_code[4]^IN_code[3]^IN_code[2];
//             result[3] = IN_code[1]^IN_code[0];
//         end
//         6: begin
//             result[0] = IN_code[9]^IN_code[7]^IN_code[5]^IN_code[3]^IN_code[1];
//             result[1] = IN_code[8]^IN_code[7]^IN_code[4]^IN_code[3]^IN_code[0];
//             result[2] = IN_code[6]^IN_code[5]^IN_code[4]^IN_code[3];
//             result[3] = IN_code[2]^IN_code[1]^IN_code[0];
//         end
//         7: begin
//             result[0] = IN_code[10]^IN_code[8]^IN_code[6]^IN_code[4]^IN_code[2]^IN_code[0];
//             result[1] = IN_code[9]^IN_code[8]^IN_code[5]^IN_code[4]^IN_code[1]^IN_code[0];
//             result[2] = IN_code[7]^IN_code[6]^IN_code[5]^IN_code[4];
//             result[3] = IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
//         end
//         8: begin
//             result[0] = IN_code[11]^IN_code[9]^IN_code[7]^IN_code[5]^IN_code[3]^IN_code[1];
//             result[1] = IN_code[10]^IN_code[9]^IN_code[6]^IN_code[5]^IN_code[2]^IN_code[1];
//             result[2] = IN_code[8]^IN_code[7]^IN_code[6]^IN_code[5]^IN_code[0];
//             result[3] = IN_code[4]^IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
//         end
//         9: begin
//             result[0] = IN_code[12]^IN_code[10]^IN_code[8]^IN_code[6]^IN_code[4]^IN_code[2]^IN_code[0];
//             result[1] = IN_code[11]^IN_code[10]^IN_code[7]^IN_code[6]^IN_code[3]^IN_code[2];
//             result[2] = IN_code[9]^IN_code[8]^IN_code[7]^IN_code[6]^IN_code[1]^IN_code[0];
//             result[3] = IN_code[5]^IN_code[4]^IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
//         end
//         10: begin
//             result[0] = IN_code[13]^IN_code[11]^IN_code[9]^IN_code[7]^IN_code[5]^IN_code[3]^IN_code[1];
//             result[1] = IN_code[12]^IN_code[11]^IN_code[8]^IN_code[7]^IN_code[4]^IN_code[3]^IN_code[0];
//             result[2] = IN_code[10]^IN_code[9]^IN_code[8]^IN_code[7]^IN_code[2]^IN_code[1]^IN_code[0];
//             result[3] = IN_code[6]^IN_code[5]^IN_code[4]^IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
//         end
//         11: begin
//             result[0] = IN_code[14]^IN_code[12]^IN_code[10]^IN_code[8]^IN_code[6]^IN_code[4]^IN_code[2]^IN_code[0];
//             result[1] = IN_code[13]^IN_code[12]^IN_code[9]^IN_code[8]^IN_code[5]^IN_code[4]^IN_code[1]^IN_code[0];
//             result[2] = IN_code[11]^IN_code[10]^IN_code[9]^IN_code[8]^IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
//             result[3] = IN_code[7]^IN_code[6]^IN_code[5]^IN_code[4]^IN_code[3]^IN_code[2]^IN_code[1]^IN_code[0];
//         end
//     endcase
// end

endmodule