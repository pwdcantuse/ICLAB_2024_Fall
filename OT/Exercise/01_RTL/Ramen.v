module Ramen(
    // Input Registers
    input clk, 
    input rst_n, 
    input in_valid,
    input selling,
    input portion, 
    input [1:0] ramen_type,

    // Output Signals
    output reg out_valid_order,
    output reg success,

    output reg out_valid_tot,
    output reg [27:0] sold_num,
    output reg [14:0] total_gain
);


//==============================================//
//             Parameter and Integer            //
//==============================================//

// ramen_type
parameter TONKOTSU = 0;
parameter TONKOTSU_SOY = 1;
parameter MISO = 2;
parameter MISO_SOY = 3;

// initial ingredient
parameter NOODLE_INIT = 12000;
parameter BROTH_INIT = 41000;
parameter TONKOTSU_SOUP_INIT =  9000;
parameter MISO_INIT = 1000;
parameter SOY_SAUSE_INIT = 1500;

parameter IDLE = 3'd0;
parameter READ = 3'd1;
parameter CAL = 3'd2;
parameter DONE1  = 3'd3;
parameter IDLE2 = 3'd4;
parameter DONE2 = 3'd5;
//==============================================//
//                 reg declaration              //
//==============================================// 


reg [1:0] ramen_type_in;
reg portion_in;


reg [2:0] t;

reg [2:0] State, nextState;
reg [16:0] noodle_init, broth_init, tonkotsu_soup_init, miso_init, soy_sause_init;
reg can_sell, can_sell_reg;
reg [14:0] sell_gain, sell_gain_reg;
reg [16:0] need_noodle, need_broth, need_tonkotsu, need_miso, need_soy_sause;
reg [16:0] next_noodle, next_broth, next_tonkotsu, next_miso, next_soy_sause;
reg [6:0] sold_tonkosu_num, sold_tonkosu_soy_num, sold_miso_num, sold_miso_soy_num; 
//==============================================//
//                    Design                    //
//==============================================//
//////////// output ////////////////
always@(*) begin
    if(!rst_n) out_valid_order = 0;
    else if(State == DONE1) out_valid_order = 1;
    else out_valid_order = 0;
end

always@(*) begin
    if(!rst_n) success = 0;
    else if(State == DONE1) success = can_sell_reg;
    else success = 0;
end



always@(*) begin
    if(!rst_n) out_valid_tot = 0;
    else if(State == DONE2) out_valid_tot = 1;
    else out_valid_tot = 0;
end

always@(*) begin
    if(!rst_n) sold_num = 0;
    else if(State == DONE2) sold_num = {sold_tonkosu_num, sold_tonkosu_soy_num, sold_miso_num, sold_miso_soy_num};
    else sold_num = 0;
end

always@(*) begin
    if(!rst_n) total_gain = 0;
    else if(State == DONE2) total_gain = sell_gain_reg;
    else total_gain = 0;
end
/////////////////////////////////////

////////// State ///////////
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) State <= IDLE;
    else begin
        State <= nextState;
    end
end
always@(posedge clk) begin
    if(in_valid) begin
        if(State == IDLE || State == IDLE2) ramen_type_in <= ramen_type;
    end
end
always@(posedge clk) begin
    if(in_valid) begin
        if(State == READ) portion_in <= portion;
    end
end

always@(*) begin
    case(State)
        IDLE: begin
            if(in_valid) nextState = READ;
            else nextState = State;
        end
        READ: begin
            nextState = CAL;
        end
        CAL: begin
            nextState = DONE1;
        end
        DONE1: begin
            if(selling) nextState = IDLE2;
            else nextState = DONE2;
        end
        IDLE2: begin
            if(in_valid) nextState = READ;
            else nextState = State;
        end
        DONE2: begin
            nextState = IDLE;
        end
        default: begin
            nextState = IDLE;
        end

    endcase
end

////////////////////////////




always@(*) begin
    case(ramen_type_in)
        TONKOTSU: begin
            if(portion_in == 0) begin
                need_noodle = 100;
                need_broth = 300;
                need_tonkotsu = 150;
                need_soy_sause = 0;
                need_miso = 0;
                
            end
            else begin
                need_noodle = 150;
                need_broth = 500;
                need_tonkotsu = 200;
                need_soy_sause = 0;
                need_miso = 0;
            end 
        end
        TONKOTSU_SOY: begin
            if(portion_in == 0) begin
                need_noodle = 100;
                need_broth = 300;
                need_tonkotsu = 100;
                need_soy_sause = 30;
                need_miso = 0;
            end
            else begin
                need_noodle = 150;
                need_broth = 500;
                need_tonkotsu = 150;
                need_soy_sause = 50;
                need_miso = 0;
            end
        end
        MISO: begin
            if(portion_in == 0) begin
                need_noodle = 100;
                need_broth = 400;
                need_tonkotsu = 0;
                need_soy_sause = 0;
                need_miso = 30;
                
            end
            else begin
                need_noodle = 150;
                need_broth = 650;
                need_tonkotsu = 0;
                need_soy_sause = 0;
                need_miso = 50;
            end
        end
        MISO_SOY: begin
            if(portion_in == 0) begin
                need_noodle = 100;
                need_broth = 300;
                need_tonkotsu = 70;
                need_soy_sause = 15;
                need_miso = 15;
                
            end
            else begin
                need_noodle = 150;
                need_broth = 500;
                need_tonkotsu = 100;
                need_soy_sause = 25;
                need_miso = 25;
            end
        end
    endcase
end

always@(*) begin
    can_sell = (noodle_init >= need_noodle) && (broth_init >= need_broth) && (tonkotsu_soup_init >= need_tonkotsu) && (miso_init >= need_miso)  && (soy_sause_init >= need_soy_sause);
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        can_sell_reg <= 0;
    end
    else if(State == CAL && can_sell) begin
        can_sell_reg <= can_sell;
    end
    else if(State == DONE1 || State == DONE2) begin
        can_sell_reg <= 0;
    end
end
always@(*) begin
    next_noodle = noodle_init - need_noodle;
    next_broth = broth_init - need_broth;
    next_tonkotsu = tonkotsu_soup_init - need_tonkotsu;
    next_miso = miso_init - need_miso;
    next_soy_sause = soy_sause_init - need_soy_sause;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        noodle_init <= NOODLE_INIT;
        broth_init <= BROTH_INIT;
        tonkotsu_soup_init <= TONKOTSU_SOUP_INIT;
        miso_init <= MISO_INIT;
        soy_sause_init <= SOY_SAUSE_INIT;
    end
    else if(State == CAL && can_sell) begin
        noodle_init <= next_noodle;
        broth_init <= next_broth;
        tonkotsu_soup_init <= next_tonkotsu;
        miso_init <= next_miso;
        soy_sause_init <= next_soy_sause;
    end
    else if(State == DONE2) begin
        noodle_init <= NOODLE_INIT;
        broth_init <= BROTH_INIT;
        tonkotsu_soup_init <= TONKOTSU_SOUP_INIT;
        miso_init <= MISO_INIT;
        soy_sause_init <= SOY_SAUSE_INIT;
    end
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sold_tonkosu_num <= 0;
        sold_tonkosu_soy_num <= 0;
        sold_miso_num <= 0;
        sold_miso_soy_num <= 0;
    end
    else if(State == CAL && can_sell) begin
        if(ramen_type_in == TONKOTSU) sold_tonkosu_num <= sold_tonkosu_num +1;
        if(ramen_type_in == TONKOTSU_SOY) sold_tonkosu_soy_num <= sold_tonkosu_soy_num +1;
        if(ramen_type_in == MISO) sold_miso_num <= sold_miso_num +1;
        if(ramen_type_in == MISO_SOY) sold_miso_soy_num <= sold_miso_soy_num +1;
    end
    else if(State == DONE2) begin
        sold_tonkosu_num <= 0;
        sold_tonkosu_soy_num <= 0;
        sold_miso_num <= 0;
        sold_miso_soy_num <= 0;
    end
end

always@(*) begin
    sell_gain = sold_tonkosu_num*200 + sold_tonkosu_soy_num* 250 + sold_miso_num*200 + sold_miso_soy_num*250;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sell_gain_reg <= 0;
    end
    else if(State == DONE1) begin
        sell_gain_reg <= sell_gain;
    end
    else if(State == DONE2) begin
        sell_gain_reg <= 0;
    end
end
endmodule
