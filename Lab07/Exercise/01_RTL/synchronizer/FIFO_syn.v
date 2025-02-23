module FIFO_syn #(parameter WIDTH=8, parameter WORDS=64) (
    wclk,
    rclk,
    rst_n,
    winc,
    wdata,
    wfull,
    rinc,
    rdata,
    rempty,

    flag_fifo_to_clk2,
    flag_clk2_to_fifo,

    flag_fifo_to_clk1,
	flag_clk1_to_fifo
);

input wclk, rclk;
input rst_n;
input winc;
input [WIDTH-1:0] wdata;
output reg wfull;
input rinc;
output reg [WIDTH-1:0] rdata;
output reg rempty;

// You can change the input / output of the custom flag ports
output reg  flag_fifo_to_clk2;
input flag_clk2_to_fifo;

output reg flag_fifo_to_clk1;
input flag_clk1_to_fifo;

wire [WIDTH-1:0] rdata_q;

// Remember: 
//   wptr and rptr should be gray coded
//   Don't modify the signal name
reg [$clog2(WORDS):0] wptr;
reg [$clog2(WORDS):0] rptr;

reg [6:0] waddr, raddr, waddr_syn, raddr_syn;

reg [$clog2(WORDS):0] wptr_syn;
reg [$clog2(WORDS):0] rptr_syn;
reg [1:0] t_wclk;
reg [1:0] t_rclk;
reg wen;
wire [7:0] rdata_in;
wire [5:0] temp;

DUAL_64X8X1BM1 u_dual_sram(.A0(raddr[0]),.A1(raddr[1]),.A2(raddr[2]),.A3(raddr[3]),.A4(raddr[4]),.A5(raddr[5]),.B0(waddr[0]),.B1(waddr[1]),.B2(waddr[2]),.B3(waddr[3]),.B4(waddr[4]),.B5(waddr[5]),.DOA0(rdata_in[0]),.DOA1(rdata_in[1]),.DOA2(rdata_in[2]),
                       .DOA3(rdata_in[3]),.DOA4(rdata_in[4]),.DOA5(rdata_in[5]),.DOA6(rdata_in[6]),.DOA7(rdata_in[7]),.DOB0(),.DOB1(),.DOB2(),
                       .DOB3(),.DOB4(),.DOB5(),.DOB6(),.DOB7(),.DIA0(),.DIA1(),.DIA2(),
                       .DIA3(),.DIA4(),.DIA5(),.DIA6(),.DIA7(),.DIB0(wdata[0]),.DIB1(wdata[1]),.DIB2(wdata[2]),
                       .DIB3(wdata[3]),.DIB4(wdata[4]),.DIB5(wdata[5]),.DIB6(wdata[6]),.DIB7(wdata[7]),.WEAN(1'b1),.WEBN(wen),.CKA(rclk),.CKB(wclk),.CSA(1'b1),.CSB(1'b1),.OEA(1'b1),.OEB(1'b1));

NDFF_BUS_syn #(7) ndff_syn0(.D(wptr), .Q(wptr_syn), .clk(rclk), .rst_n(rst_n));
NDFF_BUS_syn #(7) ndff_syn1(.D(rptr), .Q(rptr_syn), .clk(wclk), .rst_n(rst_n));

//////////////// addr conversion //////////////////

gray_to_bin gtb0(.gray(wptr_syn), .bin(waddr_syn));
gray_to_bin gtb1(.gray(rptr_syn), .bin(raddr_syn));

bin_to_gray btg0(.bin(waddr), .gray(wptr));
bin_to_gray btg1(.bin(raddr), .gray(rptr));

//////////////////////////////////////////////////


//////////////// rclk //////////////////


always@(*) begin
    flag_fifo_to_clk1 = (t_rclk == 2 && !rempty);
end
always@(posedge rclk) begin
    rdata <= rdata_in;
end

always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        t_rclk <= 0;
    end 
    else if(rinc) begin
        if(t_rclk == 2) t_rclk <= 0;
        else t_rclk <= t_rclk + 1;
    end
end

always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        rempty <= 1;
    end 
    else begin
        if(waddr_syn[5:0] == raddr[5:0]) begin
            rempty <= 1;
        end
        else begin
            rempty <= 0;
        end
    end
end


always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        raddr <= 0;
    end 
    else begin
        if(flag_fifo_to_clk1) begin
            raddr <= raddr + 1;
        end
    end
end


//////////////// wclk //////////////////

always@(*) begin
    flag_fifo_to_clk2 = (t_wclk == 2 && !wfull);
    wen = !flag_fifo_to_clk2;
end
always@(posedge wclk or negedge rst_n) begin
    if(!rst_n) begin
        t_wclk <= 0;
    end 
    else if (winc||flag_fifo_to_clk2) begin
        if(t_wclk == 2) t_wclk <= 0;
        else t_wclk <= t_wclk + 1;
    end
end

assign temp = raddr_syn[5:0] - 1;

always@(posedge wclk or negedge rst_n) begin
    if(!rst_n) begin
        wfull <= 0;
    end 
    else begin
        if(waddr[5:0] == (temp)) begin
            wfull <= 1;
        end
        else begin
            wfull <= 0;
        end
    end
end


always@(posedge wclk or negedge rst_n) begin
    if(!rst_n) begin
        waddr <= 0;
    end 
    else begin
        if(!wen) begin
            waddr <= waddr + 1;
        end
    end
end

endmodule

module bin_to_gray (input [6:0] bin, output [6:0] gray);
    assign gray = bin ^ (bin >> 1);
endmodule
module gray_to_bin (input [6:0] gray, output [6:0] bin);
    genvar i;
    generate
        assign bin[6] = gray[6];
        for (i = 0; i < 6; i = i + 1) begin
            assign bin[5-i] = bin[6-i] ^ gray[5-i];
        end
    endgenerate
endmodule