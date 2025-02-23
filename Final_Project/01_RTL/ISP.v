module ISP(
    // Input Signals
    input clk,
    input rst_n,
    input in_valid,
    input [3:0] in_pic_no,
    input  [1:0]     in_mode,
    input [1:0] in_ratio_mode,

    // Output Signals
    output reg out_valid,
    output reg [7:0] out_data,
    
    // DRAM Signals
    // axi write address channel
    // src master
    output [3:0]  awid_s_inf,
    output [31:0] awaddr_s_inf,
    output [2:0]  awsize_s_inf,
    output [1:0]  awburst_s_inf,
    output [7:0]  awlen_s_inf,
    output       awvalid_s_inf,
    // src slave
    input         awready_s_inf,
    // -----------------------------
  
    // axi write data channel 
    // src master
    output [127:0] wdata_s_inf,
    output         wlast_s_inf,
    output         wvalid_s_inf,
    // src slave
    input          wready_s_inf,
  
    // axi write response channel 
    // src slave
    input [3:0]    bid_s_inf,
    input [1:0]    bresp_s_inf,
    input          bvalid_s_inf,
    // src master 
    output         bready_s_inf,
    // -----------------------------


    // axi read address channel 
    // src master
    output [3:0]   arid_s_inf,
    output [31:0]  araddr_s_inf,
    output [7:0]   arlen_s_inf,
    output [2:0]   arsize_s_inf,
    output [1:0]   arburst_s_inf,
    output         arvalid_s_inf,
    // src slave
    input          arready_s_inf,
    // -----------------------------
  
    // axi read data channel 
    // slave
    input [3:0]    rid_s_inf,
    input [127:0]  rdata_s_inf,
    input [1:0]    rresp_s_inf,
    input          rlast_s_inf,
    input          rvalid_s_inf,
    // master
    output         rready_s_inf
);
//========= parameter and integer =========//
parameter IDLE = 3'd0;
parameter READ = 3'd1;
parameter PASS_ADDR_R = 3'd2;
parameter PASS_ADDR_W = 3'd3;
parameter WAIT = 3'd4;
parameter CAL = 3'd5;
parameter AA = 3'd6;
parameter DONE = 3'd7;
integer i;

//=========================================//

//============= reg and wire ==============//
reg w, w1,w2,w3;
reg [127:0] d1, d2,d3;
reg [2:0] State , nextState;
reg [3:0] pic_no_in;
reg  [1:0] mode_in;
reg [1:0] ratio_mode_in;
reg [31:0] begin_addr;
reg [7:0] read_num, write_num;
reg read_addr_valid, write_addr_valid;

reg pic_flag [0:15];
reg zero_flag [0:15];

reg [1:0] focus_ans [0:15];
reg [7:0] ratio_ans [0:15];

reg [7:0] focus_map [0:35];
reg [7:0] next_focus_map [0:35];

reg [127:0] data_to_dram;
wire [127:0] data_from_dram;
reg valid_to_dram;
wire valid_from_dram;
reg [1:0] rgb_count;
reg [5:0] t;
reg [7:0] scaled_pixel_without_rgb [0:15]; 
reg [7:0] scaled_pixel [0:15]; 
reg [17:0] ratio_sum;
reg [7:0] a [0:7];
reg [8:0] temp_sum [0:3];
reg [10:0] temp_sum_1_a ;
reg [7:0] pix [0:2];
reg [7:0] b [0:2];
reg [7:0] gray_focus [0:2];
reg [3:0] t_for_focus;

reg [4:0] t_focus_cal;
reg [7:0] focus_a [0:2];
reg [7:0] focus_b [0:2];
reg [7:0] focus_a_in [0:2];
reg [7:0] focus_b_in [0:2];

reg [7:0] temp_sub_focus_1 [0:2];
reg [9:0] temp_sum_focus_6_1;

reg [8:0] temp_sum_focus_4_1;
reg [127:0] cal_data;

reg [7:0] temp_sum_focus_2_1;

reg [1:0] index;
reg [13:0] focus_sum_6;
reg [12:0] focus_sum_4;
reg [9:0] focus_sum_2;

wire [7:0] sub_out [0:2];



wire [7:0] cmp_wire [0:39];
reg [7:0] max_num;
reg [7:0] min_num;
reg [7:0] cmp_wire_ff[0:19];
reg [9:0] max_sum;
reg [9:0] min_sum;
reg [7:0] max_div;
reg [7:0] min_div; 
reg [8:0] sum_minmax;
reg [7:0] average_res [0:15];
//=========================================//


//============= module ==============//

 AXI_READ axi_read(
    .clk(clk), .rst_n(rst_n),
    .begin_addr(begin_addr), .read_num(read_num), .addr_valid(read_addr_valid), .data(data_from_dram), .data_valid(valid_from_dram),
    .arid_s_inf(arid_s_inf), .araddr_s_inf(araddr_s_inf), .arlen_s_inf(arlen_s_inf), 
    .arsize_s_inf(arsize_s_inf), .arburst_s_inf(arburst_s_inf), .arvalid_s_inf(arvalid_s_inf), 
    .arready_s_inf(arready_s_inf), .rid_s_inf(rid_s_inf), .rdata_s_inf(rdata_s_inf), .rresp_s_inf(rresp_s_inf), 
    .rlast_s_inf(rlast_s_inf), .rvalid_s_inf(rvalid_s_inf), .rready_s_inf(rready_s_inf)
);

AXI_WRITE axi_write(
    .clk(clk), .rst_n(rst_n),
    .begin_addr(begin_addr), .write_num(write_num), .addr_valid(write_addr_valid), .data(data_to_dram), .data_valid(valid_to_dram),
    .awid_s_inf(awid_s_inf), .awaddr_s_inf(awaddr_s_inf), .awsize_s_inf(awsize_s_inf),
    .awburst_s_inf(awburst_s_inf), .awlen_s_inf(awlen_s_inf), .awvalid_s_inf(awvalid_s_inf),
    .awready_s_inf(awready_s_inf), .wdata_s_inf(wdata_s_inf), .wlast_s_inf(wlast_s_inf),
    .wvalid_s_inf(wvalid_s_inf), .wready_s_inf(wready_s_inf), .bid_s_inf(bid_s_inf),
    .bresp_s_inf(bresp_s_inf), .bvalid_s_inf(bvalid_s_inf), .bready_s_inf(bready_s_inf)
);
//=========================================//




//================= State =================//

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
            if(in_valid) begin
                nextState = READ;
            end
            else begin
                nextState = State;
            end
        end
        READ: begin
            if(((mode_in[0] && (!(ratio_mode_in==2))) || (!pic_flag[pic_no_in]))&&!zero_flag[pic_no_in]) nextState = PASS_ADDR_R;
            else nextState = DONE;
        end
        PASS_ADDR_R: begin
            nextState = PASS_ADDR_W;
        end
        PASS_ADDR_W: begin
            nextState = WAIT;
        end
        WAIT: begin
            if(valid_from_dram) nextState = CAL;
            else nextState = State;
        end
        CAL: begin
            if(t_focus_cal == 31) nextState = DONE;
            else nextState = State;
        end
        DONE: begin
            nextState = IDLE;
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 16; i++) begin
            pic_flag[i] <= 0;
        end
    end
    else if(State == CAL) begin
        pic_flag[pic_no_in] <= 1;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 16; i++) begin
            zero_flag[i] <= 0;
        end
    end
    else if(State == WAIT) begin
        zero_flag[pic_no_in] <= 1;
    end
    else if(State == CAL) begin
        if(|d1) zero_flag[pic_no_in] <= 0;
    end
end

//=========================================//


//================= Design ================//


//============== in and out ===============//
reg [7:0] out_temp;


always@(posedge clk)begin
    if(in_valid) begin
        pic_no_in <= in_pic_no;
    end
end
always@(posedge clk)begin
    if(in_valid) begin
        mode_in <= in_mode;
    end
end
always@(posedge clk)begin
    if(in_valid) begin
        if(in_mode) ratio_mode_in <= in_ratio_mode;
        else ratio_mode_in <= 2;
    end
end

always@(*)begin
    if(!rst_n) out_valid = 0;
    else if(State == DONE) out_valid = 1;
    else out_valid = 0;
end

always@(*)begin
    if(!rst_n) out_data = 0;
    else if(State == DONE) begin
        out_data = out_temp;
    end
    else out_data = 0;
end

always@(posedge clk)begin
    if(mode_in[0]) out_temp <= ratio_ans[pic_no_in];
    else if(mode_in[1]) out_temp <= average_res[pic_no_in];
    else out_temp <= focus_ans[pic_no_in];
end

//=========================================//



//============== data in and out   dram ===============//



always@(posedge clk)begin
    if(valid_from_dram) begin
        cal_data <= data_from_dram;
    end
    else begin
        cal_data <= 0;
    end
end

always@(*)begin
    if(!rst_n) begin
        read_addr_valid = 0;

    end
    else if(State == PASS_ADDR_R) begin
        read_addr_valid = 1;

    end
    else begin
        read_addr_valid = 0;

    end
end
always@(*)begin
    if(!rst_n) begin
  
        write_addr_valid = 0;
    end
    else if(State == PASS_ADDR_W) begin

        write_addr_valid = 1;
    end
    else begin

        write_addr_valid = 0;
    end
end
always@(*)begin
    case (pic_no_in)
        0: begin
            begin_addr = 32'h00010000;
        end
        1: begin
            begin_addr = 32'h00010C00;
        end
        2: begin
            begin_addr = 32'h00011800;
        end
        3: begin
            begin_addr = 32'h00012400;
        end
        4: begin
            begin_addr = 32'h00013000;
        end
        5: begin
            begin_addr = 32'h00013C00;
        end
        6: begin
            begin_addr = 32'h00014800;
        end
        7: begin
            begin_addr = 32'h00015400;
        end
        8: begin
            begin_addr = 32'h00016000;
        end
        9: begin
            begin_addr = 32'h00016C00;
        end
        10: begin
            begin_addr = 32'h00017800;
        end
        11: begin
            begin_addr = 32'h00018400;
        end
        12: begin
            begin_addr = 32'h00019000;
        end
        13: begin
            begin_addr = 32'h00019C00;
        end
        14: begin
            begin_addr = 32'h0001A800;
        end
        15: begin
            begin_addr = 32'h0001B400;
        end
    endcase
end

always@(*)begin
    if(!rst_n) begin
        read_num = 0;

    end
    else if(State == PASS_ADDR_R) begin
        read_num = 191;

    end
    else begin
        read_num = 0;

    end
end

always@(*)begin
    if(!rst_n) begin

        write_num = 0;
    end
    else if(State == PASS_ADDR_W) begin

        write_num = 191;
    end
    else begin

        write_num = 0;
    end
end



always@(*) begin
    if(!rst_n) begin
        w = 0;
    end
    else if(State == CAL && t_focus_cal < 27) w = 1;
    else w = 0;
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        w1 <= 0;
        w2 <= 0;
        w3 <= 0;
    end
    else if(nextState == CAL) begin
        w1 <= 1;
        w2 <= 1;
        w3 <= 1;
    end
    else begin
        w1 <= w;
        w2 <= w1;
        w3 <= w2;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        d1 <= 0;
        d2 <= 0;
        d3 <= 0;
    end
    else begin
        d1 <= {scaled_pixel_without_rgb[15],scaled_pixel_without_rgb[14],scaled_pixel_without_rgb[13],scaled_pixel_without_rgb[12],scaled_pixel_without_rgb[11],scaled_pixel_without_rgb[10],scaled_pixel_without_rgb[9],scaled_pixel_without_rgb[8],scaled_pixel_without_rgb[7],scaled_pixel_without_rgb[6],scaled_pixel_without_rgb[5],scaled_pixel_without_rgb[4],scaled_pixel_without_rgb[3],scaled_pixel_without_rgb[2],scaled_pixel_without_rgb[1],scaled_pixel_without_rgb[0]};
        d2 <= d1;
        d3 <= d2;
    end
end

always@(*) begin
    data_to_dram = d3;
    valid_to_dram = w3;
end

//=========================================//

//============== counter   ===============//


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        t <= 0;
    end
    else if(State == CAL && t_focus_cal ==0) begin
        t <= t+1;
    end
    else if(State == CAL) begin
        t <= t;
    end
    else begin
        t <= 0;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rgb_count <= 0;
    end
    else if(State == CAL) begin
        if(t == 63) begin
            rgb_count <= rgb_count +1;
        end
    end
    else begin
        rgb_count <= 0;
    end
end


//=========================================//


//============== ratio ===============// maybe can pipeline

// reg [17:0] temp_sum_1_b ;


genvar k;

generate
    for(k = 0; k <16; k++) begin: ratio_shift
        wire [7:0] a;
        assign a = cal_data[7+8*k:8*k];
        always@(*)begin
            scaled_pixel_without_rgb[k] = a;
            if(mode_in[0]) begin
                if(a[7]&&ratio_mode_in == 3) scaled_pixel_without_rgb[k] = 8'd255;
                else begin
                    case(ratio_mode_in)
                        0: begin
                            scaled_pixel_without_rgb[k] = {2'b00, a[7:2]};
                        end
                        1: begin
                            scaled_pixel_without_rgb[k] = {1'b0, a[7:1]};
                        end
                        3: begin
                            scaled_pixel_without_rgb[k] = {a[6:0],1'b0};
                        end
                    endcase
                end
            end
            case(rgb_count[0])
                0: begin
                    scaled_pixel[k] = {2'b00, scaled_pixel_without_rgb[k][7:2]};
                end
                1: begin
                    scaled_pixel[k] = {1'b0, scaled_pixel_without_rgb[k][7:1]};
                end
            endcase
        end
    end
endgenerate



always@(posedge clk) begin
    a[0] <= (scaled_pixel[0]+scaled_pixel[1]); 
    a[1] <= (scaled_pixel[2]+scaled_pixel[3]);
    a[2] <= (scaled_pixel[4]+scaled_pixel[5]);
    a[3] <= (scaled_pixel[6]+scaled_pixel[7]);
    a[4] <= (scaled_pixel[8]+scaled_pixel[9]); 
    a[5] <= (scaled_pixel[10]+scaled_pixel[11]);
    a[6] <= (scaled_pixel[12]+scaled_pixel[13]);
    a[7] <= (scaled_pixel[14]+scaled_pixel[15]);
end



always@(posedge clk) begin
    if(State == IDLE) begin
        temp_sum[0] <= 0;
        temp_sum[1] <= 0;
        temp_sum[2] <= 0;
        temp_sum[3] <= 0;
    end
    else begin
        temp_sum[0] <= a[0]+a[1];
        temp_sum[1] <= a[2]+a[3];
        temp_sum[2] <= a[4]+a[5];
        temp_sum[3] <= a[6]+a[7];
    end
    
end

always@(posedge clk ) begin
    if(State == IDLE) begin
        temp_sum_1_a <= 0;
    end
    else begin
        temp_sum_1_a <= (temp_sum[0]+temp_sum[1])+(temp_sum[2]+temp_sum[3]);
    end
    
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ratio_sum <= 0;
    end
    else if(State == CAL)begin
        ratio_sum <= ratio_sum + (temp_sum_1_a);
    end
    else begin
        ratio_sum <= 0; //ratio_sum[17:10] is answer
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 16; i++) begin
            ratio_ans[i] <= 0;
        end
    end
    else if(t_focus_cal == 30)begin
        ratio_ans[pic_no_in] <= ratio_sum[17:10];
    end
end



//=========================================//

//============== focus ===============//



always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        t_for_focus <= 0;
    end
    else if(t >= 25 && t<=37) begin
        t_for_focus <= t_for_focus +1;
    end
    else begin
        t_for_focus <= 0;
    end
end



// focus sum



always@(*) begin
    if(t[0]) begin
        pix[0] = scaled_pixel[0];
        pix[1] = scaled_pixel[1];
        pix[2] = scaled_pixel[2];
    end
    else begin
        pix[0] = scaled_pixel[13];
        pix[1] = scaled_pixel[14];
        pix[2] = scaled_pixel[15];
    end
end

always@(*) begin
    case(t_for_focus)
        1:begin
            b[0] = focus_map[0];
            b[1] = focus_map[1];
            b[2] = focus_map[2];
        end
        2: begin
            b[0] = focus_map[3] ;
            b[1] = focus_map[4] ;
            b[2] = focus_map[5] ;
        end
        3: begin
            b[0] = focus_map[6];
            b[1] = focus_map[7];
            b[2] = focus_map[8];
        end
        4: begin
            b[0] = focus_map[9] ;
            b[1] = focus_map[10] ;
            b[2] = focus_map[11] ;
        end
        5: begin
            b[0] = focus_map[12];
            b[1] = focus_map[13];
            b[2] = focus_map[14];
        end
        6: begin
            b[0] = focus_map[15] ;
            b[1] = focus_map[16] ;
            b[2] = focus_map[17] ;
        end
        7: begin
            b[0] = focus_map[18];
            b[1] = focus_map[19];
            b[2] = focus_map[20];
        end
        8: begin
            b[0] = focus_map[21];
            b[1] = focus_map[22];
            b[2] = focus_map[23];
        end
        9: begin
            b[0] = focus_map[24];
            b[1] = focus_map[25];
            b[2] = focus_map[26];
        end
        10: begin
            b[0] = focus_map[27];
            b[1] = focus_map[28];
            b[2] = focus_map[29];
        end
        11: begin
            b[0] = focus_map[30];
            b[1] = focus_map[31];
            b[2] = focus_map[32];
        end
        12: begin
            b[0] = focus_map[33] ;
            b[1] = focus_map[34] ;
            b[2] = focus_map[35] ;
        end
        default : begin
            b[0] = 0;
            b[1] = 0;
            b[2] = 0;
        end
    endcase
end

reg [7:0] mmm [0:5];

always@(posedge clk) begin
    mmm[0] <= pix[0];
    mmm[1] <= pix[1];
    mmm[2] <= pix[2];
    mmm[3] <= b[0];
    mmm[4] <= b[1];
    mmm[5] <= b[2];
end


always@(*) begin

    gray_focus[0] = mmm[0] + mmm[3];
    gray_focus[1] = mmm[1] + mmm[4];
    gray_focus[2] = mmm[2] + mmm[5];

end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 36; i++) begin
            focus_map[i] <= 0;
        end
    end
    else if(State == CAL)begin
        for(i = 0; i < 36; i++) begin
            focus_map[i] <= next_focus_map[i];
        end
    end
    else if(State == IDLE) begin
        for(i = 0; i < 36; i++) begin
            focus_map[i] <= 0;
        end
    end
end
always@(*) begin
    for(i = 0; i < 36; i++) begin
        next_focus_map[i] = focus_map[i];
    end
    if(State == CAL)begin
        case(t_for_focus)
            2:begin
                next_focus_map[0] = gray_focus[0];
                next_focus_map[1] = gray_focus[1];
                next_focus_map[2] = gray_focus[2];
            end
            3: begin
                next_focus_map[3] = gray_focus[0];
                next_focus_map[4] = gray_focus[1];
                next_focus_map[5] = gray_focus[2];
            end
            4: begin
                next_focus_map[6] = gray_focus[0];
                next_focus_map[7] = gray_focus[1];
                next_focus_map[8] = gray_focus[2];
            end
            5: begin
                next_focus_map[9] =  gray_focus[0];
                next_focus_map[10] = gray_focus[1];
                next_focus_map[11] = gray_focus[2];
            end
            6: begin
                next_focus_map[12] = gray_focus[0];
                next_focus_map[13] = gray_focus[1];
                next_focus_map[14] = gray_focus[2];
            end
            7: begin
                next_focus_map[15] = gray_focus[0];
                next_focus_map[16] = gray_focus[1];
                next_focus_map[17] = gray_focus[2];
            end
            8: begin
                next_focus_map[18] = gray_focus[0];
                next_focus_map[19] = gray_focus[1];
                next_focus_map[20] = gray_focus[2];
            end
            9: begin
                next_focus_map[21] = gray_focus[0];
                next_focus_map[22] = gray_focus[1];
                next_focus_map[23] = gray_focus[2];
            end
            10: begin
                next_focus_map[24] = gray_focus[0];
                next_focus_map[25] = gray_focus[1];
                next_focus_map[26] = gray_focus[2];
            end
            11: begin
                next_focus_map[27] = gray_focus[0];
                next_focus_map[28] = gray_focus[1];
                next_focus_map[29] = gray_focus[2];
            end
            12: begin
                next_focus_map[30] = gray_focus[0];
                next_focus_map[31] = gray_focus[1];
                next_focus_map[32] = gray_focus[2];
            end
            13: begin
                next_focus_map[33] = gray_focus[0];
                next_focus_map[34] = gray_focus[1];
                next_focus_map[35] = gray_focus[2];
            end
        endcase
    end
end


// focus cal




always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        t_focus_cal <= 0;
    end
    else if(t>=38 && rgb_count == 2) begin
        t_focus_cal <= t_focus_cal+1;
    end
    else begin
        t_focus_cal <= 0;
    end
end 




always@(posedge clk) begin
    case(t_focus_cal)
        1:begin
            focus_a[0] <= focus_map[0];
            focus_a[1] <= focus_map[1];
            focus_a[2] <= focus_map[2];
            focus_b[0] <= focus_map[6];
            focus_b[1] <= focus_map[7];
            focus_b[2] <= focus_map[8];
        end
        2: begin
            focus_a[0] <= focus_map[5];
            focus_a[1] <= focus_map[4];
            focus_a[2] <= focus_map[3];
            focus_b[0] <= focus_map[11];
            focus_b[1] <= focus_map[10];
            focus_b[2] <= focus_map[9];
        end
        3: begin
            focus_a[0] <= focus_map[6];
            focus_a[1] <= focus_map[7];
            focus_a[2] <= focus_map[8];
            focus_b[0] <= focus_map[12];
            focus_b[1] <= focus_map[13];
            focus_b[2] <= focus_map[14];
        end
        4: begin
            focus_a[0] <= focus_map[11];
            focus_a[1] <= focus_map[10];
            focus_a[2] <= focus_map[9];
            focus_b[0] <= focus_map[17];
            focus_b[1] <= focus_map[16];
            focus_b[2] <= focus_map[15];
        end
        5: begin
            focus_a[0] <= focus_map[12];
            focus_a[1] <= focus_map[13];
            focus_a[2] <= focus_map[14];
            focus_b[0] <= focus_map[18];
            focus_b[1] <= focus_map[19];
            focus_b[2] <= focus_map[20];
        end
        6: begin
            focus_a[0] <= focus_map[17];
            focus_a[1] <= focus_map[16];
            focus_a[2] <= focus_map[15];
            focus_b[0] <= focus_map[23];
            focus_b[1] <= focus_map[22];
            focus_b[2] <= focus_map[21];
        end
        7: begin
            focus_a[0] <= focus_map[18];
            focus_a[1] <= focus_map[19];
            focus_a[2] <= focus_map[20];
            focus_b[0] <= focus_map[24];
            focus_b[1] <= focus_map[25];
            focus_b[2] <= focus_map[26];
        end
        8: begin
            focus_a[0] <= focus_map[23];
            focus_a[1] <= focus_map[22];
            focus_a[2] <= focus_map[21];
            focus_b[0] <= focus_map[29];
            focus_b[1] <= focus_map[28];
            focus_b[2] <= focus_map[27];
        end
        9: begin
            focus_a[0] <= focus_map[24];
            focus_a[1] <= focus_map[25];
            focus_a[2] <= focus_map[26];
            focus_b[0] <= focus_map[30];
            focus_b[1] <= focus_map[31];
            focus_b[2] <= focus_map[32];
        end
        10: begin
            focus_a[0] <= focus_map[29];
            focus_a[1] <= focus_map[28];
            focus_a[2] <= focus_map[27];
            focus_b[0] <= focus_map[35];
            focus_b[1] <= focus_map[34];
            focus_b[2] <= focus_map[33];
        end
        11: begin
            focus_a[0] <= focus_map[0];
            focus_a[1] <= focus_map[6];
            focus_a[2] <= focus_map[12];
            focus_b[0] <= focus_map[1];
            focus_b[1] <= focus_map[7];
            focus_b[2] <= focus_map[13];
        end
        12 : begin
            focus_a[0] <= focus_map[1];
            focus_a[1] <= focus_map[7];
            focus_a[2] <= focus_map[13];
            focus_b[0] <= focus_map[2];
            focus_b[1] <= focus_map[8];
            focus_b[2] <= focus_map[14];
        end
        13: begin
            focus_a[0] <= focus_map[2];
            focus_a[1] <= focus_map[8];
            focus_a[2] <= focus_map[14];
            focus_b[0] <= focus_map[3];
            focus_b[1] <= focus_map[9];
            focus_b[2] <= focus_map[15];
        end
        14: begin
            focus_a[0] <= focus_map[3];
            focus_a[1] <= focus_map[9];
            focus_a[2] <= focus_map[15];
            focus_b[0] <= focus_map[4];
            focus_b[1] <= focus_map[10];
            focus_b[2] <= focus_map[16];
        end
        15: begin
            focus_a[0] <= focus_map[4];
            focus_a[1] <= focus_map[10];
            focus_a[2] <= focus_map[16];
            focus_b[0] <= focus_map[5];
            focus_b[1] <= focus_map[11];
            focus_b[2] <= focus_map[17];
        end
        16: begin
            focus_a[0] <= focus_map[30];
            focus_a[1] <= focus_map[24];
            focus_a[2] <= focus_map[18];
            focus_b[0] <= focus_map[31];
            focus_b[1] <= focus_map[25];
            focus_b[2] <= focus_map[19];
        end
        17: begin
            focus_a[0] <= focus_map[31];
            focus_a[1] <= focus_map[25];
            focus_a[2] <= focus_map[19];
            focus_b[0] <= focus_map[32];
            focus_b[1] <= focus_map[26];
            focus_b[2] <= focus_map[20];
        end
        18: begin
            focus_a[0] <= focus_map[32];
            focus_a[1] <= focus_map[26];
            focus_a[2] <= focus_map[20];
            focus_b[0] <= focus_map[33];
            focus_b[1] <= focus_map[27];
            focus_b[2] <= focus_map[21];
        end
        19: begin
            focus_a[0] <= focus_map[33];
            focus_a[1] <= focus_map[27];
            focus_a[2] <= focus_map[21];
            focus_b[0] <= focus_map[34];
            focus_b[1] <= focus_map[28];
            focus_b[2] <= focus_map[22];
        end
        20: begin
            focus_a[0] <= focus_map[34];
            focus_a[1] <= focus_map[28];
            focus_a[2] <= focus_map[22];
            focus_b[0] <= focus_map[35];
            focus_b[1] <= focus_map[29];
            focus_b[2] <= focus_map[23];
        end
        default: begin
            focus_a[0] <= 0;
            focus_a[1] <= 0;
            focus_a[2] <= 0;
            focus_b[0] <= 0;
            focus_b[1] <= 0;
            focus_b[2] <= 0;
        end
    endcase
    
end

always@(*) begin
    if(focus_a[0] >= focus_b[0]) begin
        focus_a_in[0] = focus_a[0];
        focus_b_in[0] = focus_b[0];
    end
    else begin
        focus_a_in[0] = focus_b[0];
        focus_b_in[0] = focus_a[0];
    end
    if(focus_a[1] >= focus_b[1]) begin
        focus_a_in[1] = focus_a[1];
        focus_b_in[1] = focus_b[1];
    end
    else begin
        focus_a_in[1] = focus_b[1];
        focus_b_in[1] = focus_a[1];
    end
    if(focus_a[2] >= focus_b[2]) begin
        focus_a_in[2] = focus_a[2];
        focus_b_in[2] = focus_b[2];
    end
    else begin
        focus_a_in[2] = focus_b[2];
        focus_b_in[2] = focus_a[2];
    end
end


assign sub_out[0] = focus_a_in[0]-focus_b_in[0];
assign sub_out[1] = focus_a_in[1]-focus_b_in[1];
assign sub_out[2] = focus_a_in[2]-focus_b_in[2];

always@(posedge clk)begin
    if(State == IDLE) begin
        temp_sub_focus_1[0] <= 0;
        temp_sub_focus_1[1] <= 0;
        temp_sub_focus_1[2] <= 0;
    end
    else if(State == CAL) begin
        temp_sub_focus_1[0] <= sub_out[0];
        temp_sub_focus_1[1] <= sub_out[1];
        temp_sub_focus_1[2] <= sub_out[2];
    end
end



always@(posedge clk)begin
    if(State == IDLE) begin
        focus_sum_6 <= 0;
    end
    else if(State == CAL) begin
        focus_sum_6 <= temp_sum_focus_6_1 + focus_sum_6;
    end
end

always@(posedge clk)begin
    if(State == IDLE) begin
        temp_sum_focus_6_1 <= 0;
    end
    else if(State == CAL) begin
        temp_sum_focus_6_1 <= (temp_sub_focus_1[0]+temp_sub_focus_1[1])+temp_sub_focus_1[2];
    end
end



always@(posedge clk)begin
    if(State == IDLE) begin
        focus_sum_4 <= 0;
    end
    else if(State == CAL) begin
        if(t_focus_cal>=6&&t_focus_cal<=11||t_focus_cal>=15&&t_focus_cal<=17||t_focus_cal>=20&&t_focus_cal<=22)  focus_sum_4 <= temp_sum_focus_4_1 + focus_sum_4;
    end
end

always@(posedge clk)begin
    if(State == IDLE) begin
        temp_sum_focus_4_1 <= 0;
    end
    else if(State == CAL) begin
        temp_sum_focus_4_1 <= temp_sub_focus_1[1]+temp_sub_focus_1[2];
    end
end

always@(posedge clk)begin
    if(State == IDLE) begin
        focus_sum_2 <= 0;
    end
    else if(State == CAL) begin
        if(t_focus_cal == 8||t_focus_cal == 9||t_focus_cal == 16||t_focus_cal == 21) focus_sum_2 <= temp_sum_focus_2_1 + focus_sum_2;
    end
end

always@(posedge clk)begin
    if(State == IDLE) begin
        temp_sum_focus_2_1 <= 0;
    end
    else if(State == CAL) begin
        temp_sum_focus_2_1 <= temp_sub_focus_1[2];
    end
end


//  div

reg [7:0] div_ans_of_2;
reg [8:0] div_ans_of_6,div_ans_of_4;
wire [21:0] mul;

// assign mul = focus_sum_6*8'd227;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        div_ans_of_2 <= 0;
    end
    else if(State == IDLE) begin
        div_ans_of_2 <= 0;
    end
    else if(t_focus_cal == 24) begin
        div_ans_of_2 <= focus_sum_2[9:2];
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        div_ans_of_4 <= 0;
    end
    else if(State == IDLE) begin
        div_ans_of_4 <= 0;
    end
    else if(t_focus_cal == 24) begin
        div_ans_of_4 <= focus_sum_4[12:4];
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        div_ans_of_6 <= 0;
    end
    else if(State == IDLE) begin
        div_ans_of_6 <= 0;
    end
    else if(t_focus_cal == 24) begin
        div_ans_of_6 <= focus_sum_6/36;
    end
end



always@(*) begin
    if(div_ans_of_2>= div_ans_of_4 && div_ans_of_2>=div_ans_of_6) index = 0;
    else if(div_ans_of_4>=div_ans_of_6)index = 1;
    else index = 2;
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0 ; i < 16; i++) begin
            focus_ans[i] <= 0;
        end
    end
    else if(t_focus_cal == 25) begin
        focus_ans[pic_no_in] <= index;
    end
end


//=========================================//










//=========================================//


// average of min max




CMP cmp0(.a(scaled_pixel_without_rgb[0]),.b(scaled_pixel_without_rgb[1]),.max(cmp_wire[0]),.min(cmp_wire[1]));
CMP cmp1(.a(scaled_pixel_without_rgb[2]),.b(scaled_pixel_without_rgb[3]),.max(cmp_wire[2]),.min(cmp_wire[3]));
CMP cmp2(.a(scaled_pixel_without_rgb[4]),.b(scaled_pixel_without_rgb[5]),.max(cmp_wire[4]),.min(cmp_wire[5]));
CMP cmp3(.a(scaled_pixel_without_rgb[6]),.b(scaled_pixel_without_rgb[7]),.max(cmp_wire[6]),.min(cmp_wire[7]));
CMP cmp4(.a(scaled_pixel_without_rgb[8]),.b(scaled_pixel_without_rgb[9]),.max(cmp_wire[8]),.min(cmp_wire[9]));
CMP cmp5(.a(scaled_pixel_without_rgb[10]),.b(scaled_pixel_without_rgb[11]),.max(cmp_wire[10]),.min(cmp_wire[11]));
CMP cmp6(.a(scaled_pixel_without_rgb[12]),.b(scaled_pixel_without_rgb[13]),.max(cmp_wire[12]),.min(cmp_wire[13]));
CMP cmp7(.a(scaled_pixel_without_rgb[14]),.b(scaled_pixel_without_rgb[15]),.max(cmp_wire[14]),.min(cmp_wire[15]));



CMP_max  cmp8(.a(cmp_wire_ff[0]),.b(cmp_wire_ff[2]),.max(cmp_wire[16]));
CMP_min  cmp9(.a(cmp_wire_ff[1]),.b(cmp_wire_ff[3]),.min(cmp_wire[17]));
CMP_max cmp10(.a(cmp_wire_ff[4]),.b(cmp_wire_ff[6]),.max(cmp_wire[18]));
CMP_min cmp11(.a(cmp_wire_ff[5]),.b(cmp_wire_ff[7]),.min(cmp_wire[19]));
CMP_max cmp12(.a(cmp_wire_ff[8]),.b(cmp_wire_ff[10]),.max(cmp_wire[20]));
CMP_min cmp13(.a(cmp_wire_ff[9]),.b(cmp_wire_ff[11]),.min(cmp_wire[21]));
CMP_max cmp14(.a(cmp_wire_ff[12]),.b(cmp_wire_ff[14]),.max(cmp_wire[22]));
CMP_min cmp15(.a(cmp_wire_ff[13]),.b(cmp_wire_ff[15]),.min(cmp_wire[23]));


CMP_max cmp16(.a(cmp_wire[16]),.b(cmp_wire[18]), .max(cmp_wire[24]));
CMP_min cmp17(.a(cmp_wire[17]),.b(cmp_wire[19]), .min(cmp_wire[25]));
CMP_max cmp18(.a(cmp_wire[20]),.b(cmp_wire[22]), .max(cmp_wire[26]));
CMP_min cmp19(.a(cmp_wire[21]),.b(cmp_wire[23]), .min(cmp_wire[27]));


CMP_max cmp20(.a(cmp_wire_ff[16]),.b(cmp_wire_ff[18]), .max(cmp_wire[28]));
CMP_min cmp21(.a(cmp_wire_ff[17]),.b(cmp_wire_ff[19]), .min(cmp_wire[29]));


assign cmp_wire[30] = (t == 2)? 8'd0:max_num;
assign cmp_wire[31] = (t == 2)? 8'd255:min_num;

CMP_max cmp22(.a(cmp_wire[28]),.b(cmp_wire[30]), .max(cmp_wire[32]));
CMP_min cmp23(.a(cmp_wire[29]),.b(cmp_wire[31]), .min(cmp_wire[33]));

always@(posedge clk) begin
    if(State == IDLE) begin
        for(i = 0; i < 20 ; i++) begin
            cmp_wire_ff[i] <= 0;
        end
    end
    else if(State == CAL) begin
        cmp_wire_ff[0] <= cmp_wire[0];
        cmp_wire_ff[1] <= cmp_wire[1];
        cmp_wire_ff[2] <= cmp_wire[2];
        cmp_wire_ff[3] <= cmp_wire[3];
        cmp_wire_ff[4] <= cmp_wire[4];
        cmp_wire_ff[5] <= cmp_wire[5];
        cmp_wire_ff[6] <= cmp_wire[6];
        cmp_wire_ff[7] <= cmp_wire[7];
        cmp_wire_ff[8] <= cmp_wire[8];
        cmp_wire_ff[9] <= cmp_wire[9];
        cmp_wire_ff[10] <= cmp_wire[10];
        cmp_wire_ff[11] <= cmp_wire[11];
        cmp_wire_ff[12] <= cmp_wire[12];
        cmp_wire_ff[13] <= cmp_wire[13];
        cmp_wire_ff[14] <= cmp_wire[14];
        cmp_wire_ff[15] <= cmp_wire[15];
        cmp_wire_ff[16] <= cmp_wire[24];
        cmp_wire_ff[17] <= cmp_wire[25];
        cmp_wire_ff[18] <= cmp_wire[26];
        cmp_wire_ff[19] <= cmp_wire[27];
    end
end


always@(posedge clk) begin
    if(State == IDLE) begin
        max_num <= 0;
    end
    else if(State == CAL) begin
        max_num <= cmp_wire[32];
    end
end
always@(posedge clk) begin
    if(State == IDLE) begin
        min_num <= 255;
    end
    else if(State == CAL) begin
        min_num <= cmp_wire[33];
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) max_sum <= 0;
    else if(State == IDLE) max_sum <= 0;
    else if(t==2||t_focus_cal == 28) max_sum <= max_sum + max_num;
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) min_sum <= 0;
    else if(State == IDLE) min_sum <= 0;
    else if(t==2||t_focus_cal == 28) min_sum <= min_sum + min_num;
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) max_div <= 0;
    else if(t_focus_cal == 29) max_div <= max_sum / 3;
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) min_div <= 0;
    else if(State == IDLE) min_div <= 0;
    else if(t_focus_cal == 29) min_div <= min_sum / 3;
end
always@(*) begin
    sum_minmax = min_div + max_div;
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0 ; i < 16; i++) begin
            average_res[i] <= 0;
        end
    end
    else if(t_focus_cal == 30) average_res[pic_no_in] <= sum_minmax[8:1];
end


// Your Design

endmodule

module CMP(a,b,max,min);
    input wire [7:0] a, b;
    output reg [7:0] max, min;

    always@(*) begin
        if(a>=b) begin
            max = a;
            min = b;
        end
        else begin
            max = b;
            min = a;
        end
    end
endmodule

module CMP_max(a,b,max);
    input wire [7:0] a, b;
    output reg [7:0] max;

    always@(*) begin
        if(a>=b) begin
            max = a;
        end
        else begin
            max = b;
        end
    end
endmodule

module CMP_min(a,b,min);
    input wire [7:0] a, b;
    output reg [7:0] min;

    always@(*) begin
        if(a>=b) begin
            min = b;
        end
        else begin
            min = a;
        end
    end
endmodule




module AXI_READ(
    clk, rst_n,
    begin_addr, read_num, addr_valid, data, data_valid,
    arid_s_inf, araddr_s_inf, arlen_s_inf, 
    arsize_s_inf, arburst_s_inf, arvalid_s_inf, 
    arready_s_inf, rid_s_inf, rdata_s_inf, rresp_s_inf, 
    rlast_s_inf, rvalid_s_inf, rready_s_inf
);
    input clk , rst_n;
    input [31:0] begin_addr;
    input [7:0] read_num;
    input addr_valid;
    output reg [127:0] data;
    output reg data_valid;

    // axi read address channel 
    // src master
    output  [3:0]   arid_s_inf;
    output reg [31:0]  araddr_s_inf;
    output reg [7:0]   arlen_s_inf;
    output  [2:0]   arsize_s_inf;
    output  [1:0]   arburst_s_inf;
    output    reg     arvalid_s_inf;
    // src slave
    input          arready_s_inf;
    // -----------------------------
  
    // axi read data channel 
    // slave
    input [3:0]    rid_s_inf;
    input [127:0]  rdata_s_inf;
    input [1:0]    rresp_s_inf;
    input          rlast_s_inf;
    input          rvalid_s_inf;
    // master
    output    reg     rready_s_inf;

//============= reg and wire ==============//
reg [7:0] num_in;
reg [31:0] addr_in;
//=========================================//

assign arid_s_inf = 4'b0000;
assign arsize_s_inf = (arvalid_s_inf)? 3'b100 : 3'b000;
assign arburst_s_inf = (arvalid_s_inf)? 2'b01 : 2'b00;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        addr_in <= 0;
        num_in <= 0;
    end
    else if(addr_valid) begin
        addr_in <= begin_addr;
        num_in <= read_num;
    end
end


always@(*) begin
    if(!rst_n) araddr_s_inf = 0;
    else if(arvalid_s_inf) araddr_s_inf = addr_in;
    else araddr_s_inf = 0;
end

always@(*) begin
    if(!rst_n) arlen_s_inf = 0;
    else if(arvalid_s_inf) arlen_s_inf = num_in;
    else arlen_s_inf = 0;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) arvalid_s_inf <= 0;
    else if(addr_valid) arvalid_s_inf <= 1;
    else if(arready_s_inf) arvalid_s_inf <= 0;
end
/////////  data  //////////

always@(*) begin
    if(!rst_n) data = 0;
    else if(rvalid_s_inf) data = rdata_s_inf;
    else data = 0;
end

always@(*) begin
    if(!rst_n) data_valid = 0;
    else data_valid = rvalid_s_inf;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) rready_s_inf <= 0;
    else if(addr_valid) rready_s_inf <= 1;
    else if(rlast_s_inf) rready_s_inf <= 0;
end

endmodule
module AXI_WRITE(
    clk, rst_n,
    begin_addr, write_num, addr_valid, data, data_valid,
    awid_s_inf, awaddr_s_inf, awsize_s_inf,
    awburst_s_inf, awlen_s_inf, awvalid_s_inf,
    awready_s_inf, wdata_s_inf, wlast_s_inf,
    wvalid_s_inf, wready_s_inf, bid_s_inf,
    bresp_s_inf, bvalid_s_inf, bready_s_inf
);
    input clk , rst_n;
    input [31:0] begin_addr;
    input [7:0] write_num;
    input addr_valid;
    input [127:0] data;
    input data_valid;
    // DRAM Signals
    // axi write address channel
    // src master
    output [3:0]  awid_s_inf;
    output reg [31:0] awaddr_s_inf;
    output [2:0]  awsize_s_inf;
    output [1:0]  awburst_s_inf;
    output reg [7:0]  awlen_s_inf;
    output   reg    awvalid_s_inf;
    // src slave;
    input         awready_s_inf;
    // ----------------------------;

    // axi write data channel;
    // src master;
    output reg [127:0] wdata_s_inf;
    output    reg      wlast_s_inf;
    output    reg     wvalid_s_inf;
    // src slave;
    input          wready_s_inf;

    // axi write response channel;
    // src slave;
    input [3:0]    bid_s_inf;
    input [1:0]    bresp_s_inf;
    input          bvalid_s_inf;
    // src master;
    output     reg    bready_s_inf;
    // -----------------------------
    //============= reg and wire ==============//
reg [7:0] t, num_in;
reg [31:0] addr_in;
reg [127:0] data_in;
//=========================================//

assign awid_s_inf = 4'b0000;
assign awsize_s_inf = (awvalid_s_inf)? 3'b100 : 3'b000;
assign awburst_s_inf = (awvalid_s_inf)? 2'b01 : 2'b00;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        addr_in <= 0;
        num_in <= 0;
    end
    else if(addr_valid) begin
        addr_in <= begin_addr;
        num_in <= write_num;
    end
end

always@(*) begin
    if(!rst_n) awaddr_s_inf = 0;
    else if(awvalid_s_inf) awaddr_s_inf = addr_in;
    else awaddr_s_inf = 0;
end

always@(*) begin
    if(!rst_n) awlen_s_inf = 0;
    else if(awvalid_s_inf) awlen_s_inf = num_in;
    else awlen_s_inf = 0;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) awvalid_s_inf <= 0;
    else if(addr_valid) awvalid_s_inf <= 1;
    else if(awready_s_inf) awvalid_s_inf <= 0;
end
/////////  data  //////////

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        t <= 0;
    end
    else if(wready_s_inf ) begin
        if(t == num_in) t <= 0;
        else t <= t + 1;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        data_in <= 0;
    end
    else if(data_valid) begin
        data_in <= data;
    end
end

always@(*) begin
    if(!rst_n) wdata_s_inf = 0;
    else if(wvalid_s_inf) wdata_s_inf = data_in;
    else wdata_s_inf = 0;
end

always@(*) begin
    if(!rst_n) wlast_s_inf = 0;
    else if(wvalid_s_inf&&t == num_in) wlast_s_inf = 1;
    else wlast_s_inf = 0;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) wvalid_s_inf <= 0;
    else if(data_valid) wvalid_s_inf <= 1;
    else wvalid_s_inf <= 0;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) bready_s_inf <= 0;
    else if(awready_s_inf) bready_s_inf <= 1;
    else if(bvalid_s_inf) bready_s_inf <= 0;
end

endmodule