module TMIP(
    // input signals
    clk,
    rst_n,
    in_valid, 
    in_valid2,
    
    image,
    template,
    image_size,
	action,
	
    // output signals
    out_valid,
    out_value
    );

input            clk, rst_n;
input            in_valid, in_valid2;

input      [7:0] image;
input      [7:0] template;
input      [1:0] image_size;
input      [2:0] action;

output reg       out_valid;
output reg       out_value;




//==================================================================
// parameter & integer
//==================================================================
parameter IDLE = 4'd0, 
          READ1 = 4'd1,
          READ2 = 4'd2,
          MAX_POOL = 4'd3,
          MEDIAN = 4'd4,
          CONV1 = 4'd5,
          CONV_OUT = 4'd6,
          IDLE1 = 4'd7;
integer k,l;
//==================================================================
// reg & wire
//==================================================================
reg [15:0] median_get_data_or_not;
reg [7:0] median_number [0:8];
reg [7:0] prev_median_result, median_result;

reg [3:0] median_i, median_j,median_read_i, median_read_j;


reg [2:0] State, nextState;
reg [15:0] mem0_w_data, mem1_w_data;
wire [15:0] mem0_r_data, mem1_r_data;
reg [8:0] mem0_addr;
reg [6:0] mem1_addr;
reg mem0_web, mem1_web; 
reg [7:0] queue [0:35];
reg [7:0] image_in [0:2];
reg [7:0] template_in [0:8];
reg [1:0] image_size_in;
reg [2:0] action_in;
reg put_data;
reg choose_mem ;
reg [7:0] pixel, next_pixel;
reg [1:0] channel, next_channel;
reg [2:0] RGB_count, next_RGB_count;
reg [8:0] t;
reg [2:0] current_action;
reg last_flag;
reg [8:0] t_last; 

reg [3:0] read_i,read_j, write_i, write_j;
wire [7:0] R, G, B;
reg [4:0] saved_action [0:6];
reg neg, flip, next_flip;
reg [7:0] pooling_number [0:3];
reg [7:0] pooling_result, prev_pooling_result; 
reg [8:0] do_pool_or_not;
reg [7:0] read_addr, write_addr;
reg [9:0] sum_of_rgb;
reg [17:0] product_temp;
reg [7:0] gray0, gray1, gray2;
reg [15:0] prev_gray0,prev_gray1,prev_gray2;

reg [1:0] im_size;
reg [7:0] convolution_number [0:8] ;
reg [3:0] convolution_i, convolution_j, read_convolution_i, read_convolution_j;
reg [4:0] conv_counter;
reg [4:0] out_counter;
reg [15:0] mul_res;
reg [19:0] conv_result, prev_conv_result;
reg [15:0] conv_get_data_or_not;
reg [7:0] conv_cal;
reg [2:0] ac_index;
reg [3:0] tem_index; 
reg [1:0] resi_img_size;
reg [3:0] action_num;
//==================================================================
//   module 
//==================================================================



SINGLE_PORT_51216 MEM0(
    .A0(mem0_addr[0]), .A1(mem0_addr[1]), .A2(mem0_addr[2]), .A3(mem0_addr[3]), 
    .A4(mem0_addr[4]), .A5(mem0_addr[5]), .A6(mem0_addr[6]), .A7(mem0_addr[7]), 
    .A8(mem0_addr[8]), 
    .DO0(mem0_r_data[0]), .DO1(mem0_r_data[1]), .DO2(mem0_r_data[2]), .DO3(mem0_r_data[3]), 
    .DO4(mem0_r_data[4]), .DO5(mem0_r_data[5]), .DO6(mem0_r_data[6]), .DO7(mem0_r_data[7]), 
    .DO8(mem0_r_data[8]), .DO9(mem0_r_data[9]), .DO10(mem0_r_data[10]), .DO11(mem0_r_data[11]), 
    .DO12(mem0_r_data[12]), .DO13(mem0_r_data[13]), .DO14(mem0_r_data[14]), .DO15(mem0_r_data[15]), 
    .DI0(mem0_w_data[0]), .DI1(mem0_w_data[1]), .DI2(mem0_w_data[2]), .DI3(mem0_w_data[3]), 
    .DI4(mem0_w_data[4]), .DI5(mem0_w_data[5]), .DI6(mem0_w_data[6]), .DI7(mem0_w_data[7]), 
    .DI8(mem0_w_data[8]), .DI9(mem0_w_data[9]), .DI10(mem0_w_data[10]), .DI11(mem0_w_data[11]), 
    .DI12(mem0_w_data[12]), .DI13(mem0_w_data[13]), .DI14(mem0_w_data[14]), .DI15(mem0_w_data[15]), 
    .CK(clk), .WEB(mem0_web), .OE(1'b1), .CS(1'b1)
);



SINGLE_PORT_12816 MEM1(
    .A0(mem1_addr[0]), .A1(mem1_addr[1]), .A2(mem1_addr[2]), .A3(mem1_addr[3]), 
    .A4(mem1_addr[4]), .A5(mem1_addr[5]), .A6(mem1_addr[6]), 
    .DO0(mem1_r_data[0]), .DO1(mem1_r_data[1]), .DO2(mem1_r_data[2]), .DO3(mem1_r_data[3]), 
    .DO4(mem1_r_data[4]), .DO5(mem1_r_data[5]), .DO6(mem1_r_data[6]), .DO7(mem1_r_data[7]), 
    .DO8(mem1_r_data[8]), .DO9(mem1_r_data[9]), .DO10(mem1_r_data[10]), .DO11(mem1_r_data[11]), 
    .DO12(mem1_r_data[12]), .DO13(mem1_r_data[13]), .DO14(mem1_r_data[14]), .DO15(mem1_r_data[15]), 
    .DI0(mem1_w_data[0]), .DI1(mem1_w_data[1]), .DI2(mem1_w_data[2]), .DI3(mem1_w_data[3]), 
    .DI4(mem1_w_data[4]), .DI5(mem1_w_data[5]), .DI6(mem1_w_data[6]), .DI7(mem1_w_data[7]), 
    .DI8(mem1_w_data[8]), .DI9(mem1_w_data[9]), .DI10(mem1_w_data[10]), .DI11(mem1_w_data[11]), 
    .DI12(mem1_w_data[12]), .DI13(mem1_w_data[13]), .DI14(mem1_w_data[14]), .DI15(mem1_w_data[15]), 
    .CK(clk), .WEB(mem1_web), .OE(1'b1), .CS(1'b1)
);


//==================================================================
// input & output
//==================================================================


always@(posedge clk) begin
    if(in_valid && State == IDLE) im_size <= image_size;
end


always@(posedge clk) begin
    if(in_valid && State == IDLE) image_size_in <= image_size;
    else if(State == MAX_POOL && !(image_size_in == 0)) begin
        if(last_flag) image_size_in <= image_size_in - 1;
    end
    else if(State == IDLE1) image_size_in <= im_size;
end

always@(posedge clk) begin
    if(in_valid && State == IDLE) resi_img_size <= image_size;
    else if(State == READ2 && action_in == 3) begin
        if(!(resi_img_size == 0)) resi_img_size <= resi_img_size - 1;
    end
    else if(State == IDLE1) resi_img_size <= im_size;
end

always@(posedge clk) begin
    if(tem_index < 9 && in_valid) template_in[tem_index] <= template;
end
always@(posedge clk) begin
    action_in <= action;
    if(in_valid) image_in[RGB_count] <= image;
end

always@(*) begin
    if(!rst_n) out_valid = 0;
    else if(State == CONV_OUT) out_valid =1;
    else out_valid =0;
end
always@(*) begin
    if(!rst_n) out_value = 0;
    else if(State == CONV_OUT) out_value = prev_conv_result[19-out_counter];
    else out_value = 0;
end
//==================================================================
// queue
//==================================================================




always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(k = 0 ; k <36; k++) begin
            queue[k] <= 0;
        end
    end
    else begin
        if(put_data) begin
            for(k = 0 ; k <34; k++) begin
                queue[k] <= queue[k+2];
            end
            if(choose_mem == 0) begin
                if(saved_action[current_action][4]) begin
                    queue[35] <= mem0_r_data[7:0];
                    queue[34] <= mem0_r_data[15:8];
                end
                else begin
                    queue[35] <= mem0_r_data[15:8];
                    queue[34] <= mem0_r_data[7:0];
                end
            end
            else begin
                if(saved_action[current_action][4]) begin
                    queue[35] <= mem1_r_data[7:0];
                    queue[34] <= mem1_r_data[15:8];
                end
                else begin
                    queue[35] <= mem1_r_data[15:8];
                    queue[34] <= mem1_r_data[7:0];
                end
            end
        end
    end
end

always@(*) begin
    case(State)
        IDLE: begin
            put_data = 0;
        end
        READ1 : begin
            put_data = 0;
        end
        IDLE1 : begin
            put_data = 0;
        end
        READ2 : begin
            put_data = 1;
        end
        MAX_POOL: begin
            put_data = 1;
        end
        MEDIAN: begin
            put_data =  median_get_data_or_not[0];
        end
        CONV1 : begin
            if(conv_counter == 8) put_data = 1;
            else if(image_size_in == 0 && t < 4) put_data = 1;
            else if(image_size_in == 1 && t < 6) put_data = 1;
            else if(image_size_in == 2 && t < 10) put_data = 1;
            else put_data = 0;
        end
        CONV_OUT: begin
            if(out_counter == 19) put_data = conv_get_data_or_not[0];
            else put_data = 0;
        end
    endcase
end




//==================================================================
// mem   input & output
//==================================================================


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) choose_mem <= 0;
    else if(State == IDLE1) choose_mem <= 0;
    else if(last_flag &&((State == MAX_POOL&&!(image_size_in == 0))||State == MEDIAN)) begin
        choose_mem <= choose_mem +1;
    end// if pooling or median done choose mem ++
end


always@(*) begin
    case(State)
        IDLE: begin
            mem0_addr = 0;
        end
        READ1 : begin
            case(RGB_count)
                0: mem0_addr = 128 + write_addr;
                1: mem0_addr = 256 + write_addr;
                2: mem0_addr = 384 + write_addr;
                default : mem0_addr = 128 + write_addr;
            endcase
        end
        IDLE1 : begin
            case(RGB_count)
                0: mem0_addr = 128 + write_addr;
                1: mem0_addr = 256 + write_addr;
                2: mem0_addr = 384 + write_addr;
                default : mem0_addr = 128 + write_addr;
            endcase
        end
        READ2 : begin
            case(RGB_count)
                0: mem0_addr = 128 + write_addr;
                1: mem0_addr = 256 + write_addr;
                2: mem0_addr = 384 + write_addr;
                default : mem0_addr = 128 + write_addr;
            endcase
        end
        MAX_POOL: begin
            if(current_action == 0) begin
                case(channel)
                    0: mem0_addr = 128 + read_addr;
                    1: mem0_addr = 256 + read_addr;
                    2: mem0_addr = 384 + read_addr;
                    default : mem0_addr = 128 + read_addr;
                endcase
            end
            else if(choose_mem == 0) begin
                mem0_addr = read_addr;
            end
            else begin
                mem0_addr = write_addr;
            end
        end
        MEDIAN: begin
            if(current_action == 0) begin
                case(channel)
                    0: mem0_addr = 128 + read_addr;
                    1: mem0_addr = 256 + read_addr;
                    2: mem0_addr = 384 + read_addr;
                    default : mem0_addr = 128 + read_addr;
                endcase
            end
            else if(choose_mem == 0) begin
                mem0_addr = read_addr;
            end
            else begin
                mem0_addr = write_addr;
            end
        end
        CONV1 : begin
            if(current_action == 0) begin
                case(channel)
                    0: mem0_addr = 128 + read_addr;
                    1: mem0_addr = 256 + read_addr;
                    2: mem0_addr = 384 + read_addr;
                    default : mem0_addr = 128 + read_addr;
                endcase
            end
            else if(choose_mem == 0) begin
                mem0_addr = read_addr;
            end
            else begin
                mem0_addr = write_addr;
            end
        end
        CONV_OUT: begin
            if(current_action == 0) begin
                case(channel)
                    0: mem0_addr = 128 + read_addr;
                    1: mem0_addr = 256 + read_addr;
                    2: mem0_addr = 384 + read_addr;
                    default : mem0_addr = 128 + read_addr;
                endcase
            end
            else if(choose_mem == 0) begin
                mem0_addr = read_addr;
            end
            else begin
                mem0_addr = write_addr;
            end
        end
    endcase
end

always@(*) begin
    case(State)
        IDLE: begin
            mem0_web = 1;
        end
        READ1 : begin
            if((!(t==0))&& t[0] == 0) mem0_web = 0;
            else mem0_web = 1;
        end
        IDLE1 : begin
            if(RGB_count == 1 || RGB_count == 2) mem0_web = 0;
            else mem0_web = 1;
        end
        READ2 : begin
            if(RGB_count == 1 || RGB_count == 2) mem0_web = 0;
            else mem0_web = 1;
        end
        MAX_POOL: begin
            if(choose_mem == 0) begin
                mem0_web = 1;
            end
            else begin
                if(do_pool_or_not[0]&&t[0]) mem0_web = 0;
                else mem0_web = 1;
            end
        end
        MEDIAN: begin
            if(choose_mem == 0) begin
                mem0_web = 1;
            end
            else begin
                if(median_j[0]) begin
                    if(image_size_in == 0 && t > 3 )mem0_web = 0;
                    else if(image_size_in == 1 && t > 5 )mem0_web = 0;
                    else if(image_size_in == 2 && t > 9 )mem0_web = 0;
                    else  mem0_web = 1;
                end
                else mem0_web = 1;
            end
        end
        CONV1 : begin
            mem0_web = 1;
        end
        CONV_OUT: begin
            mem0_web = 1;
        end
    endcase
end


always@(*) begin
    case(State)
        IDLE: begin
            mem0_w_data = 0;
        end
        READ1 : begin
            case(RGB_count)
                0: mem0_w_data = {gray0,prev_gray0[7:0]};
                1: mem0_w_data = prev_gray1;
                2: mem0_w_data = prev_gray2;
                default :  mem0_w_data = {gray0,prev_gray0[7:0]};
            endcase
        end
        IDLE1 : begin
            case(RGB_count)
                0: mem0_w_data = {gray0,prev_gray0[7:0]};
                1: mem0_w_data = prev_gray1;
                2: mem0_w_data = prev_gray2;
                default :  mem0_w_data = {gray0,prev_gray0[7:0]};
            endcase
        end
        READ2 : begin
            case(RGB_count)
                0: mem0_w_data = {gray0,prev_gray0[7:0]};
                1: mem0_w_data = prev_gray1;
                2: mem0_w_data = prev_gray2;
                default :  mem0_w_data = {gray0,prev_gray0[7:0]};
            endcase
        end
        MAX_POOL: begin
            mem0_w_data = {pooling_result, prev_pooling_result};
        end
        MEDIAN: begin
            mem0_w_data = {median_result, prev_median_result};
        end
        CONV1 : begin
            mem0_w_data = 0;
        end
        CONV_OUT: begin
            mem0_w_data = 0;
        end
    endcase
end

always@(*) begin
    case(State)
        IDLE: begin
            mem1_addr = 0;
        end
        READ1 : begin
            mem1_addr = 0;
        end
        IDLE1 : begin
            mem1_addr = 0;
        end
        READ2 : begin
            mem1_addr = 0;
        end
        MAX_POOL: begin
            if(choose_mem == 0) begin
                mem1_addr = write_addr;
            end
            else begin
                mem1_addr = read_addr;
            end
        end
        MEDIAN: begin
            if(choose_mem == 0) begin
                mem1_addr = write_addr;
            end
            else begin
                mem1_addr = read_addr;
            end
        end
        CONV1 : begin
            if(choose_mem == 0) begin
                mem1_addr = write_addr;
            end
            else begin
                mem1_addr = read_addr;
            end
        end
        CONV_OUT: begin
            if(choose_mem == 0) begin
                mem1_addr = write_addr;
            end
            else begin
                mem1_addr = read_addr;
            end
        end
    endcase
end

always@(*) begin
    case(State)
        IDLE: begin
            mem1_web = 1;
        end
        READ1 : begin
            mem1_web = 1;
        end
        IDLE1 : begin
            mem1_web = 1;
        end
        READ2 : begin
            mem1_web = 1;
        end
        MAX_POOL: begin
            if(choose_mem == 0) begin
                if(do_pool_or_not[0]&&t[0]) mem1_web = 0;
                else mem1_web = 1;
            end
            else begin
                mem1_web = 1;
            end
        end
        MEDIAN: begin
            if(choose_mem == 0) begin
                if(median_j[0]) begin
                    if(image_size_in == 0 && t > 3 )mem1_web = 0;
                    else if(image_size_in == 1 && t > 5 )mem1_web = 0;
                    else if(image_size_in == 2 && t > 9 )mem1_web = 0;
                    else  mem1_web = 1;
                end
                else mem1_web = 1;
            end
            else begin
                mem1_web = 1;
            end
        end
        CONV1 : begin
            mem1_web = 1;
        end
        CONV_OUT: begin
            mem1_web = 1;
        end
    endcase
end


always@(*) begin
    case(State)
        IDLE: begin
            mem1_w_data = 0;
        end
        READ1 : begin
            mem1_w_data = 0;
        end
        IDLE1 : begin
            mem1_w_data = 0;
        end
        READ2 : begin
            mem1_w_data = 0;
        end
        MAX_POOL: begin
            mem1_w_data = {pooling_result, prev_pooling_result};
        end
        MEDIAN: begin
            mem1_w_data = {median_result, prev_median_result};
        end
        CONV1 : begin
            mem1_w_data = 0;
        end
        CONV_OUT: begin
            mem1_w_data = 0;
        end
    endcase
end



always@(*) begin
    if(State == MEDIAN) begin 
        case(median_read_i)
            0: read_addr = median_read_j;
            1: read_addr = 8 + median_read_j;
            2: read_addr = 16 + median_read_j;
            3: read_addr = 24 + median_read_j;
            4: read_addr = 32 + median_read_j;
            5: read_addr = 40 + median_read_j;
            6: read_addr = 48 + median_read_j;
            7: read_addr = 56 + median_read_j;
            8: read_addr = 64 + median_read_j;
            9: read_addr = 72 + median_read_j;
            10: read_addr = 80 + median_read_j;
            11: read_addr = 88 + median_read_j;
            12: read_addr = 96 + median_read_j;
            13: read_addr = 104 + median_read_j;
            14: read_addr = 112 + median_read_j;
            default: read_addr = 120 + median_read_j;
        endcase
    end
    else if(State == CONV1||State == CONV_OUT) begin
        case(read_convolution_i)
            0: read_addr = read_convolution_j;
            1: read_addr = 8 + read_convolution_j;
            2: read_addr = 16 + read_convolution_j;
            3: read_addr = 24 + read_convolution_j;
            4: read_addr = 32 + read_convolution_j;
            5: read_addr = 40 + read_convolution_j;
            6: read_addr = 48 + read_convolution_j;
            7: read_addr = 56 + read_convolution_j;
            8: read_addr = 64 + read_convolution_j;
            9: read_addr = 72 + read_convolution_j;
            10: read_addr = 80 + read_convolution_j;
            11: read_addr = 88 + read_convolution_j;
            12: read_addr = 96 + read_convolution_j;
            13: read_addr = 104 + read_convolution_j;
            14: read_addr = 112 + read_convolution_j;
            default: read_addr = 120 + read_convolution_j;
        endcase
    end
    else begin
        case(read_i)
            0: read_addr = read_j;
            1: read_addr = 8 + read_j;
            2: read_addr = 16 + read_j;
            3: read_addr = 24 + read_j;
            4: read_addr = 32 + read_j;
            5: read_addr = 40 + read_j;
            6: read_addr = 48 + read_j;
            7: read_addr = 56 + read_j;
            8: read_addr = 64 + read_j;
            9: read_addr = 72 + read_j;
            10: read_addr = 80 + read_j;
            11: read_addr = 88 + read_j;
            12: read_addr = 96 + read_j;
            13: read_addr = 104 + read_j;
            14: read_addr = 112 + read_j;
            default: read_addr = 120 + read_j;
        endcase
    end
    
end

always@(*) begin
    
        case(write_i)
            0: write_addr = write_j;
            1: write_addr = 8 + write_j;
            2: write_addr = 16 + write_j;
            3: write_addr = 24 + write_j;
            4: write_addr = 32 + write_j;
            5: write_addr = 40 + write_j;
            6: write_addr = 48 + write_j;
            7: write_addr = 56 + write_j;
            8: write_addr = 64 + write_j;
            9: write_addr = 72 + write_j;
            10: write_addr = 80 + write_j;
            11: write_addr = 88 + write_j;
            12: write_addr = 96 + write_j;
            13: write_addr = 104 + write_j;
            14: write_addr = 112 + write_j;
            default: write_addr = 120 + write_j;
        endcase
    
end
//==================================================================
// Counter
//==================================================================


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) action_num <= 0;
    else if(State == CONV_OUT && last_flag)begin
        if(action_num == 7) action_num <= 0;
        else action_num <= action_num +1;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) read_i <= 0;
    else if(State == IDLE||State == IDLE1) read_i <= 0;
    else if(last_flag) begin
        read_i <= 0;
    end
    else if(State == MAX_POOL)begin
        if(saved_action[current_action][4]&&read_j == 0) read_i <= read_i + 1;
        else if(!saved_action[current_action][4]) begin
            if(image_size_in == 0 && read_j == 1)  read_i <= read_i + 1;
            else if(image_size_in == 1 && read_j == 3) read_i <= read_i + 1;
            else if(image_size_in == 2 && read_j == 7) read_i <= read_i + 1;
        end
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) read_j <= 0;
    else if(State == IDLE||State == IDLE1) read_j <= 0;
    else if(State == READ2) begin
        if(saved_action[current_action][4]) begin
            if(image_size_in == 0)  read_j <= 1;
            else if(image_size_in == 1 ) read_j <= 3;
            else if(image_size_in == 2 ) read_j <= 7;
        end
    end
    else if(State == MAX_POOL)begin
        if(last_flag&&next_flip) begin
            if(image_size_in == 0)  read_j <= 1;
            else if(image_size_in == 1 ) read_j <= 1;
            else if(image_size_in == 2 ) read_j <= 3;
        end
        else if(last_flag) read_j <= 0;
        else if(saved_action[current_action][4]) begin
            if(read_j == 0) begin
                if(image_size_in == 0)  read_j <= 1;
                else if(image_size_in == 1 ) read_j <= 3;
                else if(image_size_in == 2 ) read_j <= 7;
            end
            else read_j <= read_j -1;
        end
        else begin
            if(image_size_in == 0 && read_j == 1)  read_j <= 0;
            else if(image_size_in == 1 && read_j == 3) read_j <= 0;
            else if(image_size_in == 2 && read_j == 7) read_j <= 0;
            else read_j <= read_j + 1;
        end
    end
    else begin
        if(last_flag&&next_flip) begin
            if(image_size_in == 0)  read_j <= 1;
            else if(image_size_in == 1 ) read_j <= 3;
            else if(image_size_in == 2 ) read_j <= 7;
        end
        else if(last_flag) read_j <= 0;
        else if(saved_action[current_action][4]) begin
            if(read_j == 0) begin
                if(image_size_in == 0)  read_j <= 1;
                else if(image_size_in == 1 ) read_j <= 3;
                else if(image_size_in == 2 ) read_j <= 7;
            end
            else read_j <= read_j -1;
        end
        else begin
            if(image_size_in == 0 && read_j == 1)  read_j <= 0;
            else if(image_size_in == 1 && read_j == 3) read_j <= 0;
            else if(image_size_in == 2 && read_j == 7) read_j <= 0;
            else read_j <= read_j + 1;
        end
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) write_i <= 0;
    else if(State == READ1 && !mem0_web && RGB_count == 2) begin
        if(image_size_in == 0 && write_j == 1) write_i <= write_i + 1;
        else if(image_size_in == 1 && write_j == 3) write_i <= write_i + 1;
        else if(image_size_in == 2 && write_j == 7) write_i <= write_i + 1;
    end
    else if(State == READ2) begin
        write_i <= 0;
    end
    else if(State == MAX_POOL)begin
        if(last_flag) begin
            write_i <= 0;
        end
        else if(do_pool_or_not[0] && t[0]) begin
            if(image_size_in == 1 && write_j == 1) write_i <= write_i + 1;
            else if(image_size_in == 2 && write_j == 3) write_i <= write_i + 1;
        end 
    end
    else if(State == MEDIAN)begin
        if(last_flag) begin
            write_i <= 0;
        end
        else if(median_j[0]) begin
            if(image_size_in == 0 && write_j == 1) write_i <= write_i + 1;
            else if(image_size_in == 1 && write_j == 3) write_i <= write_i + 1;
            else if(image_size_in == 2 && write_j == 7) write_i <= write_i + 1;
        end 
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) write_j <= 0;
    else if(State == READ2) begin
        write_j <= 0;
    end
    else if(State == READ1 && !mem0_web && RGB_count == 2) begin
        if(image_size_in == 0 && write_j == 1) write_j <= 0;
        else if(image_size_in == 1 && write_j == 3) write_j <= 0;
        else if(image_size_in == 2 && write_j == 7) write_j <= 0;
        else write_j <= write_j +1;
    end
    else if(State == MAX_POOL)begin
        if(do_pool_or_not[0] && t[0] ) begin
            if(image_size_in == 1 && write_j == 1) write_j <= 0;
            else if(image_size_in == 2 && write_j == 3) write_j <= 0;
            else write_j <= write_j +1;
        end 
    end
    else if(State == MEDIAN)begin
        if(median_j[0]) begin
            if(image_size_in == 0 && write_j == 1) write_j <= 0;
            else if(image_size_in == 1 && write_j == 3) write_j <= 0;
            else if(image_size_in == 2 && write_j == 7) write_j <= 0;
            else write_j <= write_j +1;
        end 
    end

end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) t_last <= 0;
    else if(State == READ2)begin
        if(saved_action[current_action][2:0] == 3) begin
            if(image_size_in == 1) t_last <= 33;
            else if(image_size_in == 2) t_last <= 129; 
            else t_last <= 0;
        end
        else if(saved_action[current_action][2:0] == 6) begin
            if(image_size_in == 1) t_last <= 69;
            else if(image_size_in == 2) t_last <= 265; 
            else t_last <= 19;
        end
        else begin
            if(image_size_in == 1) t_last <= 14;
            else if(image_size_in == 2) t_last <= 18; 
            else t_last <= 12;
        end
    end
    else if((State == MEDIAN)&&last_flag)begin
        if(saved_action[current_action+1][2:0] == 3) begin
            if(image_size_in == 1) t_last <= 33;
            else if(image_size_in == 2) t_last <= 129; 
            else t_last <= 0;
        end
        else if(saved_action[current_action+1][2:0] == 6) begin
            if(image_size_in == 1) t_last <= 69;
            else if(image_size_in == 2) t_last <= 265; 
            else t_last <= 19;
        end
        else if(saved_action[current_action+1][2:0] == 7) begin
            if(image_size_in == 1) t_last <= 14;
            else if(image_size_in == 2) t_last <= 18; 
            else t_last <= 12;
        end
    end
    else if((State == MAX_POOL)&&last_flag)begin
        if(saved_action[current_action+1][2:0] == 3) begin
            if(image_size_in == 1) t_last <= 0;
            else if(image_size_in == 2) t_last <= 33; 
            else t_last <= 0;
        end
        else if(saved_action[current_action+1][2:0] == 6) begin
            if(image_size_in == 1) t_last <= 19;
            else if(image_size_in == 2) t_last <= 69; 
            else t_last <= 19;
        end
        else if(saved_action[current_action+1][2:0] == 7) begin
            if(image_size_in == 1) t_last <= 12;
            else if(image_size_in == 2) t_last <= 14; 
            else t_last <= 12;
        end
    end
end


always@(*) begin
    case(State)
        IDLE: begin
            last_flag = 0;
        end
        READ1 : begin
            last_flag = 0;
        end
        IDLE1 : begin
            last_flag = 0;
        end
        READ2 : begin
            last_flag = 0;
        end
        MAX_POOL: begin
            if(t == t_last) last_flag = 1;
            else last_flag = 0;
        end
        MEDIAN: begin
            if(t == t_last) last_flag = 1;
            else last_flag = 0;
        end
        CONV1 : begin
            if(t == t_last) last_flag = 1;
            else last_flag = 0;
        end
        CONV_OUT: begin
            if(image_size_in == 0 && t == 15 && out_counter == 19) last_flag = 1;
            else if(image_size_in == 1 && t == 63 && out_counter == 19) last_flag = 1;
            else if(image_size_in == 2 && t == 255 && out_counter == 19) last_flag = 1;
            else last_flag = 0;
        end
    endcase
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ac_index <= 0;
    end
    else if(State == READ2) begin
        if(action_in == 7) ac_index <= 0;
        else if((action_in == 3&& !(resi_img_size==0)) || action_in == 6) ac_index <= ac_index +1;
    end
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        current_action <= 0;
    end
    else if(State == READ2) begin
        current_action <= 0;
    end
    else if(last_flag && (State == MAX_POOL || State == MEDIAN))begin
        current_action <= current_action +1;
        // when the action done , current_action ++;
    end
end



always@(posedge clk or negedge rst_n) begin
    if(!rst_n) tem_index <= 0;
    else if(in_valid && tem_index < 9) tem_index <= tem_index +1;
    else if(State == IDLE) tem_index <= 0;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) t <= 0;
    else if(State == IDLE) t <= 0;
    else if(!(State == nextState)) t <= 0;
    else if(last_flag) t <= 0;
    else if(State == READ1 && RGB_count == 2) t <= t+1;
    else if(State == CONV_OUT && out_counter == 19) t<=t+1; 
    else if(!(State == READ1 || State == CONV_OUT))  t <= t+1;
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pixel <= 0;
        channel <= 0;
        RGB_count <= 0;
    end
    else begin
        pixel <= next_pixel;
        channel <= next_channel;
        RGB_count <= next_RGB_count;
    end
end

always@(*) begin
    case(State)
        IDLE: begin
            next_pixel = pixel;
        end
        READ1 : begin
            if(channel == 2) next_pixel = pixel+1;
            else next_pixel = pixel;
        end
        IDLE1 : begin
            if(channel == 2) next_pixel = 0;
            else next_pixel = pixel;
        end
        READ2 : begin
            next_pixel = pixel;
        end
        CONV_OUT: begin
            if(last_flag && action_num == 7) next_pixel = 0;
            else next_pixel = pixel;
        end
        default: begin
            next_pixel = pixel;
        end
    endcase
end

always@(*) begin
    case(State)
        IDLE: begin
            next_channel = channel; 
        end
        READ1 : begin
            if(RGB_count == 2 && t[0] == 1) next_channel = channel +1;
            else if(channel == 2) next_channel = 0;
            else if(channel == 0) next_channel = channel;
            else next_channel = channel +1; 
        end
        IDLE1 : begin
            next_channel = channel +1;
        end
        READ2 : begin
            case(action_in)
                0 : next_channel = 0;
                1 : next_channel = 1;
                2 : next_channel = 2;
                default : next_channel = channel; // determine which grayscale trans be used
            endcase
        end
        CONV_OUT: begin
            if(last_flag && action_num == 7) next_channel = 0;
            else next_channel = channel;
        end
        default: next_channel = channel;
    endcase
end

always@(*) begin
    case(State)
        IDLE: begin
            if(in_valid) next_RGB_count = RGB_count +1; 
            else next_RGB_count = RGB_count;
        end
        READ1 : begin
            if(RGB_count == 2) next_RGB_count = 0;
            else next_RGB_count = RGB_count +1;
        end
        IDLE1 : begin
            if(RGB_count == 3) next_RGB_count = RGB_count;
            else next_RGB_count = RGB_count +1;
        end
        READ2 : begin
            if(RGB_count == 2||RGB_count == 1) next_RGB_count = RGB_count +1;
            else next_RGB_count = RGB_count;
        end
        CONV_OUT: begin
            if(last_flag && action_num == 7) next_RGB_count = 0;
            else next_RGB_count = RGB_count;
        end
        default: begin
            next_RGB_count = RGB_count;
        end
    endcase
end
//==================================================================
// State
//==================================================================
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) State <= IDLE;
    else State <= nextState;
end

always@(*) begin
    case(State)
        IDLE: begin
            if(in_valid) nextState = READ1;
            else nextState = State;
        end
        READ1 : begin
            if(in_valid) nextState = State;
            else nextState = IDLE1;
        end
        IDLE1 : begin
            if(in_valid2) nextState = READ2;
            else nextState = State;
        end
        READ2 : begin
            if(in_valid2) nextState = State;
            else begin
                if(saved_action[current_action][2:0] == 3'd3) nextState = MAX_POOL;
                else if(saved_action[current_action][2:0] == 3'd6) nextState = MEDIAN;
                else nextState = CONV1;
            end
        end
        MAX_POOL: begin
            if(!last_flag) nextState = State;
            else begin
                if(saved_action[current_action+1][2:0] == 3'd3) nextState = MAX_POOL;
                else if(saved_action[current_action+1][2:0] == 3'd6) nextState = MEDIAN;
                else nextState = CONV1;
            end
        end
        MEDIAN: begin
            if(!last_flag) nextState = State;
            else begin
                if(saved_action[current_action+1][2:0] == 3'd3) nextState = MAX_POOL;
                else if(saved_action[current_action+1][2:0] == 3'd6) nextState = MEDIAN;
                else nextState = CONV1;
            end
        end
        CONV1 : begin
            if(!last_flag) nextState = State;
            else begin
                nextState = CONV_OUT;
            end
        end
        CONV_OUT: begin
            // if(image_size_in == 0 && t == 15 && out_counter == 19) nextState = IDLE;
            // else if(image_size_in == 1 && t == 63 && out_counter == 19) nextState = IDLE;
            // else if(image_size_in == 2 && t == 255 && out_counter == 19) nextState = IDLE;
            // else nextState = State;
            if(!last_flag) nextState = State;
            else begin
                if(action_num == 7) nextState = IDLE;
                else nextState = IDLE1;
            end
        end
    endcase
end

//==================================================================
// design
//==================================================================


////////////  read and write grayscale //////////////


assign R = image_in[0];
assign G = image_in[1];
assign B = image_in[2];



always@ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        prev_gray0 <= 0;
        prev_gray1 <= 0;
        prev_gray2 <= 0;
    end
    else begin
        if(RGB_count == 0 && t[0] == 1) begin
            prev_gray0[7:0] <= gray0;
            prev_gray1[7:0] <= gray1;
            prev_gray2[7:0] <= gray2;
        end 
        if(RGB_count == 0 && t[0] == 0) begin
            prev_gray0[15:8] <= gray0;
            prev_gray1[15:8] <= gray1;
            prev_gray2[15:8] <= gray2;
        end 
    end
end



always@(*) begin
    if(R>G && R>B) gray0 = R;
    else if(G>B) gray0 = G;
    else gray0 = B;
end

always@(*) begin
    sum_of_rgb = R+G+B;
    sum_of_rgb = (sum_of_rgb > 510) ? sum_of_rgb -1 : sum_of_rgb;
    product_temp = sum_of_rgb * 8'd171;
    gray1 = product_temp[16:9];
end

always@(*) begin
    gray2 = {2'd0, R[7:2]}+{1'b0, G[7:1]}+{2'd0, B[7:2]};
end

////////////// save action /////////////////





always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        next_flip <= 0;
    end
    else if(!(saved_action[current_action][2:0]==7)) next_flip <= saved_action[current_action+1][4];
    
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        neg <= 0;
    end
    else if(State == READ2 && action_in == 4) neg <= neg +1;
    else if(State == READ2 && (action_in == 3&& !(resi_img_size==0)) || action_in == 6 || action_in == 7) neg <= 0;
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        flip <= 0;
    end
    else if(State == READ2 && action_in == 5) flip <= flip +1;
    else if(State == READ2 && (action_in == 3&& !(resi_img_size==0)) || action_in == 6 || action_in == 7) flip <= 0;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(k = 0; k < 7; k++) saved_action[k] <= 0;
    end
    else if(State == CONV_OUT && last_flag) for(k = 0; k < 7; k++) saved_action[k] <= 0;
    else if(State == READ2) begin
        if((action_in == 3&& !(resi_img_size==0)) || action_in == 6 || action_in == 7) saved_action[ac_index] <= {flip, neg , action_in};
    end
    else if(State == IDLE) begin
        for(k = 0; k < 7; k++) saved_action[k] <= 0;
    end
end

////////////////// max pooling //////////////////



max_pooling mx0(pooling_number[0], pooling_number[1], pooling_number[2], pooling_number[3], pooling_result);

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) do_pool_or_not <= 0;
    else if(State == MAX_POOL) begin
        if(t == 0) do_pool_or_not <= 0;
        else if(image_size_in == 1 && t[2:0] == 3'b100) do_pool_or_not <= 9'b000011110;
        else if(image_size_in == 2 && t[3:0] == 4'b1000) do_pool_or_not <= 9'b111111110;
        else do_pool_or_not <= do_pool_or_not >> 1;
    end
    else do_pool_or_not <= 0 ;
end

always@(posedge clk) begin
    prev_pooling_result <= pooling_result;
end

always@(*) begin
    if(saved_action[current_action][3] == 1) begin
        pooling_number[0] = ~queue[35];
        pooling_number[1] = ~queue[34];
        if(image_size_in == 1) begin
            pooling_number[2] = ~queue[26];
            pooling_number[3] = ~queue[27];
        end
        else begin
            pooling_number[2] = ~queue[18];
            pooling_number[3] = ~queue[19];
        end
    end
    else begin
        pooling_number[0] = queue[35];
        pooling_number[1] = queue[34];
        if(image_size_in == 1) begin
            pooling_number[2] = queue[26];
            pooling_number[3] = queue[27];
        end
        else begin
            pooling_number[2] = queue[18];
            pooling_number[3] = queue[19];
        end
    end
    
end





//////////////////  median  //////////////////////



always@(posedge clk) begin
    prev_median_result <= median_result;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) median_read_i <= 0;
    else if(State == IDLE ||State == IDLE1) median_read_i <= 0;
    else if(last_flag) median_read_i <= 0;
    else if(State == MEDIAN) begin
        if(image_size_in == 0) begin
            if(saved_action[current_action][4]) begin
                if(t<3&&median_read_j == 0) median_read_i <= median_read_i + 1;
                else if(t[0]==0&&median_read_j == 0) begin
                    median_read_i <= median_read_i + 1;
                end
            end
            else begin
                if(t<3&&median_read_j == 1) median_read_i <= median_read_i + 1;
                else if(t[0]==0&&median_read_j == 1) begin
                    median_read_i <= median_read_i + 1;
                end
            end
        end
        else if(image_size_in == 1) begin
            if(saved_action[current_action][4]) begin
                if(t<5&&median_read_j == 0) median_read_i <= median_read_i + 1;
                else if(t[0]==0&&median_read_j == 0) begin
                    median_read_i <= median_read_i + 1;
                end
            end
            else begin
                if(t<5&&median_read_j == 3) median_read_i <= median_read_i + 1;
                else if(t[0]==0&&median_read_j == 3) begin
                    median_read_i <= median_read_i + 1;
                end
            end
        end
        else if(image_size_in == 2) begin
            if(saved_action[current_action][4]) begin
                if(t<9&&median_read_j == 0) median_read_i <= median_read_i + 1;
                else if(t[0]==0&&median_read_j == 0) begin
                    median_read_i <= median_read_i + 1;
                end
            end
            else begin
                if(t<9&&median_read_j == 7) median_read_i <= median_read_i + 1;
                else if(t[0]==0&&median_read_j == 7) begin
                    median_read_i <= median_read_i + 1;
                end
            end
        end
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) median_read_j <= 0;
    else if(State == IDLE||State == IDLE1) median_read_j <= 0;
    else if(State == READ2) begin
        if(saved_action[current_action][4]) begin
            if(image_size_in == 0)  median_read_j <= 1;
            else if(image_size_in == 1 ) median_read_j <= 3;
            else if(image_size_in == 2 ) median_read_j <= 7;
        end
        else median_read_j <= 0;
    end
    else if(last_flag&&next_flip&&State == MEDIAN) begin
        if(image_size_in == 0)  median_read_j <= 1;
        else if(image_size_in == 1 ) median_read_j <= 3;
        else if(image_size_in == 2 ) median_read_j <= 7;
    end
    else if(last_flag&&next_flip&&State == MAX_POOL) begin
        if(image_size_in == 0)  median_read_j <= 1;
        else if(image_size_in == 1 ) median_read_j <= 1;
        else if(image_size_in == 2 ) median_read_j <= 3;
    end
    else if(last_flag) median_read_j <= 0;
    else if(State == MEDIAN) begin
        if(image_size_in == 0) begin
            if(saved_action[current_action][4]) begin
                if(t<3) begin
                    if(median_read_j == 0) begin
                        median_read_j <= 1;
                    end
                    else begin
                        median_read_j <= median_read_j - 1;
                    end 
                end
                else if(t[0]==0) begin
                    if(median_read_j == 0) begin
                        median_read_j <= 1;
                    end
                    else begin
                        median_read_j <= median_read_j - 1;
                    end 
                end
            end
            else begin
                if(t<3) begin
                    if(median_read_j == 1) begin
                        median_read_j <= 0;
                    end
                    else begin
                        median_read_j <= median_read_j + 1;
                    end 
                end
                else if(t[0]==0) begin
                    if(median_read_j == 1) begin
                        median_read_j <= 0;
                    end
                    else begin
                        median_read_j <= median_read_j + 1;
                    end 
                end
            end
        end
        else if(image_size_in == 1) begin
            if(saved_action[current_action][4]) begin
                if(t<5) begin
                    if(median_read_j == 0) begin
                        median_read_j <= 3;
                    end
                    else begin
                        median_read_j <= median_read_j - 1;
                    end 
                end
                else if(t[0]==0) begin
                    if(median_read_j == 0) begin
                        median_read_j <= 3;
                    end
                    else begin
                        median_read_j <= median_read_j - 1;
                    end 
                end
            end
            else begin
                if(t<5) begin
                    if(median_read_j == 3) begin
                        median_read_j <= 0;
                    end
                    else begin
                        median_read_j <= median_read_j + 1;
                    end 
                end
                else if(t[0]==0) begin
                    if(median_read_j == 3) begin
                        median_read_j <= 0;
                    end
                    else begin
                        median_read_j <= median_read_j + 1;
                    end 
                end
            end
        end
        else if(image_size_in == 2) begin
            if(saved_action[current_action][4]) begin
                if(t<9) begin
                    if(median_read_j == 0) begin
                        median_read_j <= 7;
                    end
                    else begin
                        median_read_j <= median_read_j - 1;
                    end 
                end
                else if(t[0]==0) begin
                    if(median_read_j == 0) begin
                        median_read_j <= 7;
                    end
                    else begin
                        median_read_j <= median_read_j - 1;
                    end 
                end
            end
            else begin
                if(t<9) begin
                    if(median_read_j == 7) begin
                        median_read_j <= 0;
                    end
                    else begin
                        median_read_j <= median_read_j + 1;
                    end 
                end
                else if(t[0]==0) begin
                    if(median_read_j == 7) begin
                        median_read_j <= 0;
                    end
                    else begin
                        median_read_j <= median_read_j + 1;
                    end 
                end
            end
        end
    end
end




always@(posedge clk or negedge rst_n) begin
    if(!rst_n) median_i <= 0;
    else if(State == IDLE || State == IDLE1) begin
        median_i <= 0;
    end
    else if(State == MEDIAN) begin
        if(image_size_in == 0) begin
            if(t<4) median_i <= 0;
            else if(median_j == 3) median_i <= median_i + 1;
        end
        else if(image_size_in == 1) begin
            if(t<6) median_i <= 0;
            else if(median_j == 7) median_i <= median_i + 1;
        end
        else if(image_size_in == 2) begin
            if(t<10) median_i <= 0;
            else if(median_j == 15) median_i <= median_i + 1;
        end
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) median_j <= 0;
    else if(State == IDLE || State == IDLE1) begin
        median_j <= 0;
    end
    else if(State == MEDIAN) begin
        if(image_size_in == 0) begin
            if(t<4) median_j <= 0;
            else if(median_j == 3) median_j <= 0;
            else median_j <= median_j + 1;
        end
        else if(image_size_in == 1) begin
            if(t<6) median_j <= 0;
            else if(median_j == 7) median_j <= 0;
            else median_j <= median_j + 1;
        end
        else if(image_size_in == 2) begin
            if(t<10) median_j <= 0;
            else if(median_j == 15) median_j <= 0;
            else median_j <= median_j + 1;
        end
    end
end


always@ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        median_get_data_or_not <= 0;
    end
    else if(State == IDLE||State == IDLE1) median_get_data_or_not <= 0;
    else if(State == MEDIAN) begin
        if(t == 0) median_get_data_or_not <= 16'hffff;
        else begin
            if(image_size_in == 0 && t == 2) median_get_data_or_not <= 16'h3333;
            else if(image_size_in == 1 && t == 4) median_get_data_or_not <= 16'b0010101100101011;
            else if(image_size_in == 2 && t == 8) median_get_data_or_not <= 16'b0010101010101011;
            // else if(image_size_in == 0 && t == 14) median_get_data_or_not <= 16'd0;
            // else if(image_size_in == 1 && t == 60) median_get_data_or_not <= 16'd0;
            // else if(image_size_in == 2 && t == 248) median_get_data_or_not <= 16'd0;
            else median_get_data_or_not <= {median_get_data_or_not[0], median_get_data_or_not[15:1]};
        end
    end
end

always@(*) begin
    if(image_size_in == 0) begin
        if(median_j[0]) begin
            median_number[0] = queue[24];
            median_number[1] = queue[25];
            median_number[2] = queue[26];
            median_number[3] = queue[28];
            median_number[4] = queue[29];
            median_number[5] = queue[30];
            median_number[6] = queue[32];
            median_number[7] = queue[33];
            median_number[8] = queue[34];
        end
        else begin
            median_number[0] = queue[25];
            median_number[1] = queue[26];
            median_number[2] = queue[27];
            median_number[3] = queue[29];
            median_number[4] = queue[30];
            median_number[5] = queue[31];
            median_number[6] = queue[33];
            median_number[7] = queue[34];
            median_number[8] = queue[35];
        end    
    end
    else if(image_size_in == 1) begin
        if(median_j[0]) begin
            median_number[0] = queue[16];
            median_number[1] = queue[17];
            median_number[2] = queue[18];
            median_number[3] = queue[24];
            median_number[4] = queue[25];
            median_number[5] = queue[26];
            median_number[6] = queue[32];
            median_number[7] = queue[33];
            median_number[8] = queue[34];
        end
        else begin
            median_number[0] = queue[17];
            median_number[1] = queue[18];
            median_number[2] = queue[19];
            median_number[3] = queue[25];
            median_number[4] = queue[26];
            median_number[5] = queue[27];
            median_number[6] = queue[33];
            median_number[7] = queue[34];
            median_number[8] = queue[35];
        end
    end
    else begin
        if(median_j[0]) begin
            median_number[0] = queue[0];
            median_number[1] = queue[1];
            median_number[2] = queue[2];
            median_number[3] = queue[16];
            median_number[4] = queue[17];
            median_number[5] = queue[18];
            median_number[6] = queue[32];
            median_number[7] = queue[33];
            median_number[8] = queue[34];
        end
        else begin
            median_number[0] = queue[1];
            median_number[1] = queue[2];
            median_number[2] = queue[3];
            median_number[3] = queue[17];
            median_number[4] = queue[18];
            median_number[5] = queue[19];
            median_number[6] = queue[33];
            median_number[7] = queue[34];
            median_number[8] = queue[35];
        end
    end

    if(median_i == 0) begin
        if(median_j == 0) begin
            median_number[0] = median_number[4];
            median_number[1] = median_number[4];
            median_number[3] = median_number[4];
            median_number[2] = median_number[5];
            median_number[6] = median_number[7];
        end
        else if (image_size_in == 0 && median_j == 3) begin
            median_number[0] = queue[30];//
            median_number[1] = queue[31];//
            median_number[2] = queue[31];//
            median_number[3] = queue[30];
            median_number[4] = queue[31];
            median_number[5] = queue[31];//
            median_number[6] = queue[34];
            median_number[7] = queue[35];
            median_number[8] = queue[35];//
        end
        else if (image_size_in == 1 && median_j == 7) begin
            median_number[0] = queue[26];//
            median_number[1] = queue[27];//
            median_number[2] = queue[27];//
            median_number[3] = queue[26];
            median_number[4] = queue[27];
            median_number[5] = queue[27];//
            median_number[6] = queue[34];
            median_number[7] = queue[35];
            median_number[8] = queue[35];//
        end
        else if (image_size_in == 2 && median_j == 15) begin
            median_number[0] = queue[18];//
            median_number[1] = queue[19];//
            median_number[2] = queue[19];//
            median_number[3] = queue[18];
            median_number[4] = queue[19];
            median_number[5] = queue[19];//
            median_number[6] = queue[34];
            median_number[7] = queue[35];
            median_number[8] = queue[35];//
        end
        else begin
            median_number[0] = median_number[3];
            median_number[1] = median_number[4];
            median_number[2] = median_number[5];
        end
    end
    else if(image_size_in == 0 && median_i == 3) begin
        
        if(median_j == 0) begin
            median_number[0] = median_number[1];
            median_number[3] = median_number[4];
            median_number[6] = median_number[4];
            median_number[7] = median_number[4];
            median_number[8] = median_number[5];
        end
        else if (image_size_in == 0 && median_j == 3) begin
            median_number[0] = queue[26];
            median_number[1] = queue[27];
            median_number[2] = queue[27];
            median_number[3] = queue[30];
            median_number[4] = queue[31];
            median_number[5] = queue[31];
            median_number[6] = queue[30];
            median_number[7] = queue[31];
            median_number[8] = queue[31];
        end
        else begin
            median_number[6] = median_number[3];
            median_number[7] = median_number[4];
            median_number[8] = median_number[5];
        end
    end
    else if(image_size_in == 1 && median_i == 7) begin
        if(median_j == 0) begin
            median_number[0] = median_number[1];
            median_number[3] = median_number[4];
            median_number[6] = median_number[4];
            median_number[7] = median_number[4];
            median_number[8] = median_number[5];
        end
        else if (image_size_in == 1 && median_j == 7) begin
            median_number[0] = queue[18];
            median_number[1] = queue[19];
            median_number[2] = queue[19];//
            median_number[3] = queue[26];
            median_number[4] = queue[27];
            median_number[5] = queue[27];//
            median_number[6] = queue[26];//
            median_number[7] = queue[27];//
            median_number[8] = queue[27];//
        end
        else begin
            median_number[6] = median_number[3];
            median_number[7] = median_number[4];
            median_number[8] = median_number[5];
        end
    end
    else if(image_size_in == 2 && median_i == 15) begin
        if(median_j == 0) begin
            median_number[0] = median_number[1];
            median_number[3] = median_number[4];
            median_number[6] = median_number[4];
            median_number[7] = median_number[4];
            median_number[8] = median_number[5];
        end
        else if (image_size_in == 2 && median_j == 15) begin
            median_number[0] = queue[2];
            median_number[1] = queue[3];
            median_number[2] = queue[3];
            median_number[3] = queue[18];
            median_number[4] = queue[19];
            median_number[5] = queue[19];
            median_number[6] = queue[18];
            median_number[7] = queue[19];
            median_number[8] = queue[19];
        end
        else begin
            median_number[6] = median_number[3];
            median_number[7] = median_number[4];
            median_number[8] = median_number[5];
        end
    end
    else begin
        if(median_j == 0) begin
            median_number[0] = median_number[1];
            median_number[3] = median_number[4];
            median_number[6] = median_number[7];
        end
        else if (image_size_in == 0 && median_j == 3) begin
            median_number[0] = queue[26];
            median_number[1] = queue[27];
            median_number[2] = queue[27];//
            median_number[3] = queue[30];
            median_number[4] = queue[31];
            median_number[5] = queue[31];//
            median_number[6] = queue[34];
            median_number[7] = queue[35];
            median_number[8] = queue[35];//
        end
        else if (image_size_in == 1 && median_j == 7) begin
            median_number[0] = queue[18];
            median_number[1] = queue[19];
            median_number[2] = queue[19];//
            median_number[3] = queue[26];
            median_number[4] = queue[27];
            median_number[5] = queue[27];//
            median_number[6] = queue[34];
            median_number[7] = queue[35];
            median_number[8] = queue[35];//
        end
        else if (image_size_in == 2 && median_j == 15) begin
            median_number[0] = queue[2];
            median_number[1] = queue[3];
            median_number[2] = queue[3];//
            median_number[3] = queue[18];
            median_number[4] = queue[19];
            median_number[5] = queue[19];//
            median_number[6] = queue[34];
            median_number[7] = queue[35];
            median_number[8] = queue[35];//
        end
    end

    if(saved_action[current_action][3] == 1) begin
        median_number[0] = ~median_number[0];
        median_number[1] = ~median_number[1];
        median_number[2] = ~median_number[2];
        median_number[3] = ~median_number[3];
        median_number[4] = ~median_number[4];
        median_number[5] = ~median_number[5];
        median_number[6] = ~median_number[6];
        median_number[7] = ~median_number[7];
        median_number[8] = ~median_number[8];
    end
end
median (.a(median_number[0]),.b(median_number[1]),.c(median_number[2]),.d(median_number[3]),.e(median_number[4]),.f(median_number[5]),.g(median_number[6]),.h(median_number[7]),.i(median_number[8]), .result(median_result));



//////////////////// convolution //////////////////




always@(posedge clk or negedge rst_n) begin
    if(!rst_n) read_convolution_i <= 0;
    else if(State == IDLE||State == IDLE1) read_convolution_i <= 0;
    else if(State == CONV1) begin
         if(image_size_in == 0) begin
            if(saved_action[current_action][4]) begin
                if((t<3 || conv_counter == 8)&&read_convolution_j == 0) read_convolution_i <= read_convolution_i + 1;
                else if((t<3 || conv_counter == 8)&&read_convolution_j == 0) begin
                    read_convolution_i <= read_convolution_i + 1;
                end
            end
            else begin
                if((t<3 || conv_counter == 8)&&read_convolution_j == 1) read_convolution_i <= read_convolution_i + 1;
                else if((t<3 || conv_counter == 8)&&read_convolution_j == 1) begin
                    read_convolution_i <= read_convolution_i + 1;
                end
            end
        end
        else if(image_size_in == 1) begin
            if(saved_action[current_action][4]) begin
                if((t<5 || conv_counter == 8)&&read_convolution_j == 0) read_convolution_i <= read_convolution_i + 1;
                else if((t<5 || conv_counter == 8)&&read_convolution_j == 0) begin
                    read_convolution_i <= read_convolution_i + 1;
                end
            end
            else begin
                if((t<5 || conv_counter == 8)&&read_convolution_j == 3) read_convolution_i <= read_convolution_i + 1;
                else if((t<5 || conv_counter == 8)&&read_convolution_j == 3) begin
                    read_convolution_i <= read_convolution_i + 1;
                end
            end
        end
        else if(image_size_in == 2) begin
            if(saved_action[current_action][4]) begin
                if((t<9 || conv_counter == 8)&&read_convolution_j == 0) read_convolution_i <= read_convolution_i + 1;
                else if((t<9 || conv_counter == 8)&&read_convolution_j == 0) begin
                    read_convolution_i <= read_convolution_i + 1;
                end
            end
            else begin
                if((t<9 || conv_counter == 8)&&read_convolution_j == 7) read_convolution_i <= read_convolution_i + 1;
                else if((t<9 || conv_counter == 8)&&read_convolution_j == 7) begin
                    read_convolution_i <= read_convolution_i + 1;
                end
            end
        end
    end
    else if(State == CONV_OUT && put_data) begin
        if(image_size_in == 0) begin
            if(saved_action[current_action][4]) begin
                if(read_convolution_j == 0) read_convolution_i <= read_convolution_i + 1;
            end
            else begin
                if(read_convolution_j == 1) read_convolution_i <= read_convolution_i + 1;
            end
        end
        else if(image_size_in == 1) begin
            if(saved_action[current_action][4]) begin
                if(read_convolution_j == 0) read_convolution_i <= read_convolution_i + 1;
            end
            else begin
                if(read_convolution_j == 3) read_convolution_i <= read_convolution_i + 1;
            end
        end
        else if(image_size_in == 2) begin
            if(saved_action[current_action][4]) begin
                if(read_convolution_j == 0) read_convolution_i <= read_convolution_i + 1;
            end
            else begin
                if(read_convolution_j == 7) read_convolution_i <= read_convolution_i + 1;
            end
        end
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) read_convolution_j <= 0;
    else if(State == READ2) begin
        if(flip) begin
            if(image_size_in == 0)  read_convolution_j <= 1;
            else if(image_size_in == 1 ) read_convolution_j <= 3;
            else if(image_size_in == 2 ) read_convolution_j <= 7;
        end
        else read_convolution_j <= 0;
    end
    else if(last_flag&&next_flip&& State == MAX_POOL ) begin
        if(image_size_in == 0)  read_convolution_j <= 1;
        else if(image_size_in == 1 ) read_convolution_j <= 1;
        else if(image_size_in == 2 ) read_convolution_j <= 3;
    end
    else if(last_flag&&next_flip&& !(State == CONV1) ) begin
        if(image_size_in == 0)  read_convolution_j <= 1;
        else if(image_size_in == 1 ) read_convolution_j <= 3;
        else if(image_size_in == 2 ) read_convolution_j <= 7;
    end
    else if(last_flag && !(State == CONV1) ) begin
        read_convolution_j <= 0;
    end
    else if(State == CONV1) begin
        if(image_size_in == 0) begin
            if(saved_action[current_action][4]) begin
                if(t<3) begin
                    if(read_convolution_j == 0) begin
                        read_convolution_j <= 1;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j - 1;
                    end 
                end
                else if(conv_counter == 8) begin
                    if(read_convolution_j == 0) begin
                        read_convolution_j <= 1;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j - 1;
                    end 
                end
                
            end
            else begin
                if(t<3) begin
                    if(read_convolution_j == 1) begin
                        read_convolution_j <= 0;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j + 1;
                    end 
                end
                else if(conv_counter == 8) begin
                    if(read_convolution_j == 1) begin
                        read_convolution_j <= 0;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j + 1;
                    end 
                end
            end
        end
        else if(image_size_in == 1) begin
            if(saved_action[current_action][4]) begin
                if(t<5) begin
                    if(read_convolution_j == 0) begin
                        read_convolution_j <= 3;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j - 1;
                    end 
                end
                else if(conv_counter == 8) begin
                    if(read_convolution_j == 0) begin
                        read_convolution_j <= 3;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j - 1;
                    end
                end
                
            end
            else begin
                if(t<5) begin
                    if(read_convolution_j == 3) begin
                        read_convolution_j <= 0;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j + 1;
                    end 
                end
                else if(conv_counter == 8) begin
                    if(read_convolution_j == 3) begin
                        read_convolution_j <= 0;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j + 1;
                    end 
                end
            end
        end
        else if(image_size_in == 2) begin
            if(saved_action[current_action][4]) begin
                if(t<9) begin
                    if(read_convolution_j == 0) begin
                        read_convolution_j <= 7;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j - 1;
                    end 
                end
                else if(conv_counter == 8) begin
                    if(read_convolution_j == 0) begin
                        read_convolution_j <= 7;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j - 1;
                    end 
                end
            end
            else begin
                if(t<9) begin
                    if(read_convolution_j == 7) begin
                        read_convolution_j <= 0;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j + 1;
                    end 
                end
                else if(conv_counter == 8) begin
                    if(read_convolution_j == 7) begin
                        read_convolution_j <= 0;
                    end
                    else begin
                        read_convolution_j <= read_convolution_j + 1;
                    end 
                end
            end
        end
    end
    else if(State == CONV_OUT) begin
        if(out_counter == 19 && put_data) begin
            if(image_size_in == 0) begin
                if(saved_action[current_action][4]) begin
                        if(read_convolution_j == 0) begin
                            read_convolution_j <= 1;
                        end
                        else begin
                            read_convolution_j <= read_convolution_j - 1;
                        end 
                end
                else begin
                        if(read_convolution_j == 1) begin
                            read_convolution_j <= 0;
                        end
                        else begin
                            read_convolution_j <= read_convolution_j + 1;
                        end 
                end
            end
            else if(image_size_in == 1) begin
                if(saved_action[current_action][4]) begin
                        if(read_convolution_j == 0) begin
                            read_convolution_j <= 3;
                        end
                        else begin
                            read_convolution_j <= read_convolution_j - 1;
                        end 
                end
                else begin
                        if(read_convolution_j == 3) begin
                            read_convolution_j <= 0;
                        end
                        else begin
                            read_convolution_j <= read_convolution_j + 1;
                        end 
                end
            end
            else if(image_size_in == 2) begin
                if(saved_action[current_action][4]) begin
                        if(read_convolution_j == 0) begin
                            read_convolution_j <= 7;
                        end
                        else begin
                            read_convolution_j <= read_convolution_j - 1;
                        end 
                end
                else begin
                        if(read_convolution_j == 7) begin
                            read_convolution_j <= 0;
                        end
                        else begin
                            read_convolution_j <= read_convolution_j + 1;
                        end 
                end
            end
        end
    end
end
















always@(posedge clk or negedge rst_n) begin
    if(!rst_n) conv_counter <= 0;
    else if(State == IDLE||State == IDLE1) begin
        conv_counter <= 0;
    end
    else if(State == CONV1) begin
        if(conv_counter == 8) conv_counter <= 0;
        else if(image_size_in == 0 && t > 3) conv_counter <= conv_counter + 1;
        else if(image_size_in == 1 && t > 5) conv_counter <= conv_counter + 1;
        else if(image_size_in == 2 && t > 9) conv_counter <= conv_counter + 1;
    end
    else if(State == CONV_OUT) begin
        if(out_counter == 19) conv_counter <= 0;
        else if(conv_counter == 9) conv_counter <= conv_counter;
        else conv_counter <= conv_counter + 1;
    end
end



always@(posedge clk or negedge rst_n) begin
    if(!rst_n) conv_result <= 0;
    else if(State == IDLE || State == IDLE1) begin
        conv_result <= 0;
    end
    else if(State == CONV1) begin
        if(conv_counter == 8) conv_result <= 0;
        else if(image_size_in == 0 && t > 3) conv_result <= conv_result + mul_res;
        else if(image_size_in == 1 && t > 5) conv_result <= conv_result + mul_res;
        else if(image_size_in == 2 && t > 9) conv_result <= conv_result + mul_res;
    end
    else if(State == CONV_OUT) begin
        if(out_counter == 19) conv_result <= 0;
        else if(conv_counter < 9) conv_result <= conv_result + mul_res;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) prev_conv_result <= 0;
    else if(State == IDLE || State == IDLE1) begin
        prev_conv_result <= 0;
    end
    else if(State == CONV1) begin
        if(conv_counter == 8) prev_conv_result <= conv_result + mul_res;
    end
    else if(State == CONV_OUT) begin
        if(out_counter == 19) prev_conv_result <= conv_result;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) out_counter <= 0;
    else if(State == IDLE || State == IDLE1) begin
        out_counter <= 0;
    end
    else if(State == CONV_OUT) begin
        if(out_counter == 19) out_counter <= 0;
        else out_counter <= out_counter  + 1; 
    end
end




always@(posedge clk or negedge rst_n) begin
    if(!rst_n) convolution_i <= 0;
    
    else if(State == CONV1) begin
        convolution_i <= 0;
    end
    else if(State == CONV_OUT && out_counter == 19) begin
        if(image_size_in == 0) begin
            if(convolution_j == 3) convolution_i <= convolution_i + 1;
        end
        else if(image_size_in == 1) begin
            if(convolution_j == 7) convolution_i <= convolution_i + 1;
        end
        else if(image_size_in == 2) begin
            if(convolution_j == 15) convolution_i <= convolution_i + 1;
        end
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) convolution_j <= 0;
    else if(State == IDLE || State == IDLE1) begin
        convolution_j <= 0;
    end
    else if(State == CONV1) begin
        if(image_size_in == 0 && t == 12) convolution_j <= 1;
        else if(image_size_in == 1 && t == 14) convolution_j <= 1;
        else if(image_size_in == 2 && t == 18) convolution_j <= 1;
    end
    else if(State == CONV_OUT && out_counter == 19) begin
        if(image_size_in == 0) begin
            if(convolution_j == 3) convolution_j <= 0;
            else convolution_j <= convolution_j + 1;
        end
        else if(image_size_in == 1) begin
            if(convolution_j == 7) convolution_j <= 0;
            else convolution_j <= convolution_j + 1;
        end
        else if(image_size_in == 2) begin
            if(convolution_j == 15) convolution_j <= 0;
            else convolution_j <= convolution_j + 1;
        end
    end
end




always@ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        conv_get_data_or_not <= 0;
    end
    else if(State == IDLE || State == IDLE1) begin
        conv_get_data_or_not <= 0;
    end
    else if(State == CONV1) begin
        if(image_size_in == 0 && t == 12) conv_get_data_or_not <= 16'hcccc;
        else if(image_size_in == 1 && t == 14) conv_get_data_or_not <= 16'b1100101011001010;
        else if(image_size_in == 2 && t == 18) conv_get_data_or_not <= 16'b1100101010101010;
    end
    else if(State == CONV_OUT && out_counter == 19) begin
        conv_get_data_or_not <= {conv_get_data_or_not[0],conv_get_data_or_not[15:1]};
    end
end



always@(*) begin
    if(image_size_in == 0) begin
        if(convolution_j[0]) begin
            convolution_number[0] = queue[24];
            convolution_number[1] = queue[25];
            convolution_number[2] = queue[26];
            convolution_number[3] = queue[28];
            convolution_number[4] = queue[29];
            convolution_number[5] = queue[30];
            convolution_number[6] = queue[32];
            convolution_number[7] = queue[33];
            convolution_number[8] = queue[34];
        end
        else begin
            convolution_number[0] = queue[25];
            convolution_number[1] = queue[26];
            convolution_number[2] = queue[27];
            convolution_number[3] = queue[29];
            convolution_number[4] = queue[30];
            convolution_number[5] = queue[31];
            convolution_number[6] = queue[33];
            convolution_number[7] = queue[34];
            convolution_number[8] = queue[35];
        end    
    end
    else if(image_size_in == 1) begin
        if(convolution_j[0]) begin
            convolution_number[0] = queue[16];
            convolution_number[1] = queue[17];
            convolution_number[2] = queue[18];
            convolution_number[3] = queue[24];
            convolution_number[4] = queue[25];
            convolution_number[5] = queue[26];
            convolution_number[6] = queue[32];
            convolution_number[7] = queue[33];
            convolution_number[8] = queue[34];
        end
        else begin
            convolution_number[0] = queue[17];
            convolution_number[1] = queue[18];
            convolution_number[2] = queue[19];
            convolution_number[3] = queue[25];
            convolution_number[4] = queue[26];
            convolution_number[5] = queue[27];
            convolution_number[6] = queue[33];
            convolution_number[7] = queue[34];
            convolution_number[8] = queue[35];
        end
    end
    else begin
        if(convolution_j[0]) begin
            convolution_number[0] = queue[0];
            convolution_number[1] = queue[1];
            convolution_number[2] = queue[2];
            convolution_number[3] = queue[16];
            convolution_number[4] = queue[17];
            convolution_number[5] = queue[18];
            convolution_number[6] = queue[32];
            convolution_number[7] = queue[33];
            convolution_number[8] = queue[34];
        end
        else begin
            convolution_number[0] = queue[1];
            convolution_number[1] = queue[2];
            convolution_number[2] = queue[3];
            convolution_number[3] = queue[17];
            convolution_number[4] = queue[18];
            convolution_number[5] = queue[19];
            convolution_number[6] = queue[33];
            convolution_number[7] = queue[34];
            convolution_number[8] = queue[35];
        end
    end

    if(convolution_i == 0) begin
        if(convolution_j == 0) begin
            convolution_number[0] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[1] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[2] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else if (image_size_in == 0 && convolution_j == 3) begin
            convolution_number[0] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[1] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[2] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = queue[30];
            convolution_number[4] = queue[31];
            convolution_number[5] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = queue[34];
            convolution_number[7] = queue[35];
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else if (image_size_in == 1 && convolution_j == 7) begin
            convolution_number[0] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[1] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[2] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = queue[26];
            convolution_number[4] = queue[27];
            convolution_number[5] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = queue[34];
            convolution_number[7] = queue[35];
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else if (image_size_in == 2 && convolution_j == 15) begin
            convolution_number[0] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[1] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[2] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = queue[18];
            convolution_number[4] = queue[19];
            convolution_number[5] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = queue[34];
            convolution_number[7] = queue[35];
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else begin
            convolution_number[0] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[1] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[2] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
    end
    else if(image_size_in == 0 && convolution_i == 3) begin
        
        if(convolution_j == 0) begin
            convolution_number[0] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[7] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else if (image_size_in == 0 && convolution_j == 3) begin
            convolution_number[0] = queue[26];
            convolution_number[1] = queue[27];
            convolution_number[2] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = queue[30];
            convolution_number[4] = queue[31];
            convolution_number[5] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[7] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else begin
            convolution_number[6] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[7] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
    end
    else if(image_size_in == 1 && convolution_i == 7) begin
        if(convolution_j == 0) begin
            convolution_number[0] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[7] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else if (image_size_in == 1 && convolution_j == 7) begin
            convolution_number[0] = queue[18];
            convolution_number[1] = queue[19];
            convolution_number[2] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = queue[26];
            convolution_number[4] = queue[27];
            convolution_number[5] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[7] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else begin
            convolution_number[6] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[7] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
    end
    else if(image_size_in == 2 && convolution_i == 15) begin
        if(convolution_j == 0) begin
            convolution_number[0] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[7] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else if (image_size_in == 2 && convolution_j == 15) begin
            convolution_number[0] = queue[2];
            convolution_number[1] = queue[3];
            convolution_number[2] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = queue[18];
            convolution_number[4] = queue[19];
            convolution_number[5] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[7] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else begin
            convolution_number[6] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[7] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
    end
    else begin
        if(convolution_j == 0) begin
            convolution_number[0] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else if (image_size_in == 0 && convolution_j == 3) begin
            convolution_number[0] = queue[26];
            convolution_number[1] = queue[27];
            convolution_number[2] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = queue[30];
            convolution_number[4] = queue[31];
            convolution_number[5] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = queue[34];
            convolution_number[7] = queue[35];
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else if (image_size_in == 1 && convolution_j == 7) begin
            convolution_number[0] = queue[18];
            convolution_number[1] = queue[19];
            convolution_number[2] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = queue[26];
            convolution_number[4] = queue[27];
            convolution_number[5] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = queue[34];
            convolution_number[7] = queue[35];
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
        else if (image_size_in == 2 && convolution_j == 15) begin
            convolution_number[0] = queue[2];
            convolution_number[1] = queue[3];
            convolution_number[2] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[3] = queue[18];
            convolution_number[4] = queue[19];
            convolution_number[5] = (saved_action[current_action][3]) ? 8'hff: 0;
            convolution_number[6] = queue[34];
            convolution_number[7] = queue[35];
            convolution_number[8] = (saved_action[current_action][3]) ? 8'hff: 0;
        end
    end

    if(saved_action[current_action][3] == 1) begin
        convolution_number[0] = ~convolution_number[0];
        convolution_number[1] = ~convolution_number[1];
        convolution_number[2] = ~convolution_number[2];
        convolution_number[3] = ~convolution_number[3];
        convolution_number[4] = ~convolution_number[4];
        convolution_number[5] = ~convolution_number[5];
        convolution_number[6] = ~convolution_number[6];
        convolution_number[7] = ~convolution_number[7];
        convolution_number[8] = ~convolution_number[8];
    end
end

always@(*)begin
    conv_cal = convolution_number[conv_counter];
    mul_res = conv_cal * template_in[conv_counter];
end





//////////////////////////////////////////////////


  
endmodule

module max_pooling(a, b, c, d, result);
    input [7:0] a,b,c,d;
    output reg [7:0] result;
    always@(*) begin
        if(a>b&&a>c&&a>d) begin
            result = a;
        end
        else if(b>c && b>d) begin
            result = b;
        end
        else if(c>d) begin
            result = c;
        end
        else begin
            result = d;
        end 
    end
    
endmodule

module median(a,b,c,d,e,f,g,h,i, result);
    input [7:0] a, b, c, d, e, f, g, h, i;
    output [7:0] result;
    wire [7:0] w1, w2, w3, w4, w5, w6, w7, w8, w9, w10,
    w11, w12, w13, w14, w15, w16, w17, w18, w19, w20,
    w21, w22, w23, w24, w25, w26, w27, w28, w29, w30,
    w31, w32, w33, w34, w35, w36, w37, w38, w39, w40,
    w41, w42;

    compare_and_swap comp0(.a(b),.b(c),.min(w1),.max(w2));
    compare_and_swap comp1(.a(e),.b(f),.min(w3),.max(w4));
    compare_and_swap comp2(.a(h),.b(i),.min(w5),.max(w6));
    compare_and_swap comp3(.a(a),.b(w1),.min(w7),.max(w8));
    compare_and_swap comp4(.a(d),.b(w3),.min(w9),.max(w10));
    compare_and_swap comp5(.a(g),.b(w5),.min(w11),.max(w12));
    compare_and_swap comp6(.a(w8),.b(w2),.min(w13),.max(w14));
    compare_and_swap comp7(.a(w10),.b(w4),.min(w15),.max(w16));
    compare_and_swap comp8(.a(w12),.b(w6),.min(w17),.max(w18));
    compare_and_swap comp9(.a(w9),.b(w11),.min(w19),.max(w20));
    compare_and_swap comp10(.a(w15),.b(w17),.min(w21),.max(w22));
    compare_and_swap comp11(.a(w16),.b(w18),.min(w23),.max(w24));
    compare_and_swap comp12(.a(w7),.b(w19),.min(w25),.max(w26));
    compare_and_swap comp13(.a(w13),.b(w21),.min(w27),.max(w28));
    compare_and_swap comp14(.a(w14),.b(w23),.min(w29),.max(w30));
    compare_and_swap comp15(.a(w26),.b(w20),.min(w31),.max(w32));
    compare_and_swap comp16(.a(w28),.b(w22),.min(w33),.max(w34));
    compare_and_swap comp17(.a(w30),.b(w24),.min(w35),.max(w36));
    compare_and_swap comp18(.a(w29),.b(w32),.min(w37),.max(w38));
    compare_and_swap comp19(.a(w37),.b(w33),.min(w39),.max(w40));
    compare_and_swap comp20(.a(w40),.b(w38),.min(w41),.max(w42));

    assign result = w41;

endmodule

module compare_and_swap(input wire [7:0] a, b, output wire [7:0] min, max);
    assign {max, min} = (a > b) ? {a, b} : {b, a};
endmodule