module Program(input clk, INF.Program_inf inf);
import usertype::*;

STATE State, nextState;

Action act_ff;
Warn_Msg warn_ff;
Formula_Type formula_ff;
Mode mode_ff;
logic [11:0] index_ff [0:3] ;
Date date_ff;
Data_No data_no_ff;
Data_Dir data_dram;
logic [11:0] threshold;
Index [3:0] a;
logic [3:0] cmp_result;
logic  [12:0] extension_a [0:3];
logic  [12:0] extension_b [0:3];
logic [12:0] sub_res [0:3];
logic [12:0] sub_res_ff [0:3];
logic [11:0] min_max_temp_res [0:7];
logic [11:0] min_max_temp_res_ff [0:3];
logic [11:0] sort_ff [0:3];
logic [13:0] formula_res;
logic [13:0] formula_res_ff;
logic [11:0] formula_ans;
logic [11:0] formula_ans_ff;
logic [63:0] write_back_data ;
// input and output //

always_ff@(posedge clk) begin
     if(inf.sel_action_valid) act_ff <= inf.D.d_act[0];
end
always_ff@(posedge clk) begin
     if(inf.formula_valid) formula_ff <= inf.D.d_formula[0];
end
always_ff@(posedge clk) begin
     if(inf.mode_valid) mode_ff <= inf.D.d_mode[0];
end
always_ff@(posedge clk) begin
     case(formula_ff)
        Formula_A,Formula_C : threshold <= (mode_ff == Insensitive) ? 12'd2047 : (mode_ff == Normal) ? 12'd1023 : 12'd511 ;
        Formula_B,Formula_F,Formula_G,Formula_H : threshold <= (mode_ff == Insensitive) ? 12'd800 : (mode_ff == Normal) ? 12'd400 : 12'd200 ;
        Formula_D,Formula_E : threshold <= (mode_ff == Insensitive) ? 12'd3 : (mode_ff == Normal) ? 12'd2 : 12'd1 ;
     endcase
end
always_ff@(posedge clk) begin
     if(inf.date_valid) begin
        date_ff.M <= inf.D.d_date[0].M;
        date_ff.D <= inf.D.d_date[0].D;
     end
end
always_ff@(posedge clk) begin
     if(inf.data_no_valid) data_no_ff <= inf.D.d_data_no[0];
end
always_ff@(posedge clk) begin
     if(inf.index_valid&&State==READ_A) index_ff[0] <= inf.D.d_index[0];
end
always_ff@(posedge clk) begin
     if(inf.index_valid&&State==READ_B) index_ff[1] <= inf.D.d_index[0];
end
always_ff@(posedge clk) begin
     if(inf.index_valid&&State==READ_C) index_ff[2] <= inf.D.d_index[0];
end
always_ff@(posedge clk) begin
     if(inf.index_valid&&State==READ_D) index_ff[3] <= inf.D.d_index[0];
end

always_comb inf.out_valid = (State == DONE) ? 1:0;
always_comb inf.warn_msg = (State == DONE) ? warn_ff : No_Warn;
always_comb inf.complete = (State == DONE && warn_ff == 2'd0) ? 1:0;

/////////////////////



//State//

always_ff@(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        State <= IDLE;
    end    
    else begin
        State  <=  nextState;
    end
end

always_comb begin
    case(State)
        IDLE:begin
            if(inf.sel_action_valid) nextState = READ;
            else nextState = State;
        end
        READ:begin
            if(inf.formula_valid) nextState = READ_mode;
            else if(inf.date_valid) nextState = READ_no;
            else nextState = State;
        end
        READ_mode:begin
            if(inf.mode_valid) nextState = READ_date;
            else nextState = State;
        end
        READ_date:begin
            if(inf.date_valid) nextState = READ_no;
            else nextState = State;
        end
        READ_no:begin
            if(inf.data_no_valid) begin
                if(act_ff==Check_Valid_Date) nextState = PASS_ADDR_R;
                else nextState = READ_A;
            end
            else nextState = State;
        end
        READ_A:begin
            if(inf.index_valid) nextState = READ_B;
            else nextState = State;
        end
        READ_B:begin
            if(inf.index_valid) nextState = READ_C;
            else nextState = State;
        end
        READ_C:begin
            if(inf.index_valid) nextState = READ_D;
            else nextState = State;
        end
        READ_D:begin
            if(inf.index_valid) nextState = PASS_ADDR_R;
            else nextState = State;
        end
        PASS_ADDR_R:begin
            if(inf.AR_READY) nextState = WAIT_R;
            else nextState = State;
        end
        WAIT_R:begin
            if(inf.R_VALID ) begin
                if(act_ff == Update) nextState = SUB_0;
                else nextState = CHECK_DATE;
            end
            else nextState = State;
        end
        CHECK_DATE:begin
            if(act_ff == Update||(act_ff == Index_Check && ((date_ff.M>data_dram.M)||(date_ff.M==data_dram.M && date_ff.D>=data_dram.D)))) nextState = SUB_0;
            else nextState = DONE;
        end
        SUB_0:begin
            nextState = SUB_1;
        end
        SUB_1:begin
            nextState = SUB;
        end
        SUB:begin
            if(act_ff == Update) nextState = WARN;
            else nextState = MAX_MIN;
        end
        MAX_MIN:begin
            nextState = MAX_MIN_1;
        end
        MAX_MIN_1:begin
            nextState = CAL;
        end
        CAL:begin
            nextState = CAL_1;
        end
        CAL_1:begin
            nextState = WARN;
        end
        WARN:begin
            if(act_ff == Update) nextState = PASS_ADDR_W;
            else nextState = DONE;
        end
        PASS_ADDR_W:begin
            if(inf.AW_READY) nextState = WAIT_W;
            else nextState = State;
        end
        WAIT_W:begin
            if(inf.W_READY) nextState = WAIT_BRES;
            else nextState = State;
        end
        WAIT_BRES:begin
            if(inf.B_VALID) nextState = DONE;
            else nextState = State;
        end
        DONE:begin
            nextState = IDLE;
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end



////////

/// FUN ///
 


always_comb begin
    if(act_ff == Update) begin
        a[0] =  index_ff[0];
        a[1] =  index_ff[1];
        a[2] =  index_ff[2];
        a[3] =  index_ff[3];
    end
    else begin
        case(formula_ff)
            Formula_A,Formula_B,Formula_C: begin
                a[0] = 12'd0;
                a[1] = 12'd0;
                a[2] = 12'd0;
                a[3] = 12'd0;
            end
            Formula_D: begin
                a[0] = 12'd2047;
                a[1] = 12'd2047;
                a[2] = 12'd2047;
                a[3] = 12'd2047;
            end
            default: begin
                a[0] =  index_ff[0];
                a[1] =  index_ff[1];
                a[2] =  index_ff[2];
                a[3] =  index_ff[3];
            end
        endcase
    end
end

always_comb cmp_result[0] <= (data_dram.Index_A>=a[0]);
always_comb cmp_result[1] <= (data_dram.Index_B>=a[1]);
always_comb cmp_result[2] <= (data_dram.Index_C>=a[2]);
always_comb cmp_result[3] <= (data_dram.Index_D>=a[3]);

always_ff @(posedge clk) extension_a[0] <= (act_ff == Update || cmp_result[0]) ? {1'b0, data_dram.Index_A} : {1'b0, index_ff[0]} ;
always_ff @(posedge clk) extension_a[1] <= (act_ff == Update || cmp_result[1]) ? {1'b0, data_dram.Index_B} : {1'b0, index_ff[1]} ;
always_ff @(posedge clk) extension_a[2] <= (act_ff == Update || cmp_result[2]) ? {1'b0, data_dram.Index_C} : {1'b0, index_ff[2]} ;
always_ff @(posedge clk) extension_a[3] <= (act_ff == Update || cmp_result[3]) ? {1'b0, data_dram.Index_D} : {1'b0, index_ff[3]} ;

always_ff @(posedge clk) extension_b[0] <= (act_ff == Update) ? {a[0][11], a[0]} : (cmp_result[0]) ? {1'b0, a[0]} :  {1'b0, data_dram.Index_A};
always_ff @(posedge clk) extension_b[1] <= (act_ff == Update) ? {a[1][11], a[1]} : (cmp_result[1]) ? {1'b0, a[1]} :  {1'b0, data_dram.Index_B};
always_ff @(posedge clk) extension_b[2] <= (act_ff == Update) ? {a[2][11], a[2]} : (cmp_result[2]) ? {1'b0, a[2]} :  {1'b0, data_dram.Index_C};
always_ff @(posedge clk) extension_b[3] <= (act_ff == Update) ? {a[3][11], a[3]} : (cmp_result[3]) ? {1'b0, a[3]} :  {1'b0, data_dram.Index_D};

always_comb begin
    if(act_ff == Update) 
        sub_res[0] = extension_a[0]+extension_b[0];
    else 
        sub_res[0] = extension_a[0]-extension_b[0];
end
always_comb begin
    if(act_ff == Update) 
        sub_res[1] = extension_a[1]+extension_b[1];
    else 
        sub_res[1] = extension_a[1]-extension_b[1];
end
always_comb begin
    if(act_ff == Update) 
        sub_res[2] = extension_a[2]+extension_b[2];
    else 
        sub_res[2] = extension_a[2]-extension_b[2];
end
always_comb begin
    if(act_ff == Update) 
        sub_res[3] = extension_a[3]+extension_b[3];
    else 
        sub_res[3] = extension_a[3]-extension_b[3];
end

always_ff @(posedge clk) begin
    sub_res_ff[0] <= sub_res[0];
    sub_res_ff[1] <= sub_res[1];
    sub_res_ff[2] <= sub_res[2];
    sub_res_ff[3] <= sub_res[3];
end

/// min_max //


minmax mm0(sub_res_ff[0][11:0], sub_res_ff[1][11:0], min_max_temp_res[0], min_max_temp_res[1]);
minmax mm1(sub_res_ff[2][11:0], sub_res_ff[3][11:0], min_max_temp_res[2], min_max_temp_res[3]);
always_ff @(posedge clk) begin
    min_max_temp_res_ff[0] <= min_max_temp_res[0];
    min_max_temp_res_ff[1] <= min_max_temp_res[1];
    min_max_temp_res_ff[2] <= min_max_temp_res[2];
    min_max_temp_res_ff[3] <= min_max_temp_res[3];
end
minmax mm2(min_max_temp_res_ff[0], min_max_temp_res_ff[2], min_max_temp_res[4], min_max_temp_res[5]);
minmax mm3(min_max_temp_res_ff[1], min_max_temp_res_ff[3], min_max_temp_res[6], min_max_temp_res[7]);




always_ff @(posedge clk) begin
    sort_ff[0] <= min_max_temp_res[4][11:0];
    sort_ff[1] <= min_max_temp_res[5][11:0];
    sort_ff[2] <= min_max_temp_res[6][11:0];
    sort_ff[3] <= min_max_temp_res[7][11:0];
end


//// formula ////



always_comb begin
    case(formula_ff)
        Formula_A,Formula_H: begin
            formula_res = (sort_ff[0] + sort_ff[1] +sort_ff[2] + sort_ff[3]);
        end
        Formula_B: begin
            formula_res = sort_ff[3] - sort_ff[0];
        end
        Formula_C: begin
            formula_res = sort_ff[0];
        end
        Formula_D, Formula_E: begin
            formula_res = cmp_result[0] + cmp_result[1] +cmp_result[2] + cmp_result[3];
        end
        Formula_F: begin
            formula_res = (sort_ff[0] + sort_ff[1] +sort_ff[2] + 12'd0);
        end
        Formula_G: begin
            formula_res = sort_ff[0][11:1] + sort_ff[1][11:2] +sort_ff[2][11:2]+ 12'd0;
        end
    endcase
end

always_ff @(posedge clk) begin
    if(State == CAL) formula_res_ff <= formula_res;
end



always_comb begin
    case(formula_ff)
        Formula_A,Formula_H: begin
            formula_ans = formula_res_ff >> 2;
        end
        Formula_F: begin
            formula_ans = formula_res_ff/3;
        end
        default: begin
            formula_ans = formula_res_ff;
        end
    endcase
end

always_ff @(posedge clk) begin
    if(State == CAL_1) formula_ans_ff <= formula_ans;
end

///// Warn  /////

always_ff@(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        warn_ff <= No_Warn;
    end
    else if(State == CHECK_DATE) begin
        if(((date_ff.M>data_dram.M)||(date_ff.M==data_dram.M && date_ff.D>=data_dram.D))) warn_ff <= No_Warn;
        else warn_ff <= Date_Warn;
    end
    else if(State == WARN) begin
        if(act_ff == Update && (sub_res_ff[0][12] || sub_res_ff[1][12] || sub_res_ff[2][12] || sub_res_ff[3][12])) warn_ff <= Data_Warn;
        else if(act_ff == Index_Check && formula_ans_ff >= threshold) warn_ff <=Risk_Warn;
        else warn_ff <= No_Warn;
    end
end




//////////


///////////////  AXI LITE /////////////////




always_comb inf.AR_VALID = (State == PASS_ADDR_R)? 1:0;
always_comb inf.AR_ADDR = (State == PASS_ADDR_R)? {6'b100000 ,data_no_ff, 3'd0}:17'd0;
always_comb inf.R_READY = (State == WAIT_R)? 1:0;
always_comb inf.AW_VALID = (State == PASS_ADDR_W)? 1:0;
always_comb inf.AW_ADDR = (State == PASS_ADDR_W)? {6'b100000,data_no_ff, 3'd0}:17'd0;
always_comb inf.W_VALID = (State == WAIT_W)? 1:0;
always_comb inf.W_DATA = (State == WAIT_W)? write_back_data:0;
always_comb inf.B_READY = (State == WAIT_W||State == WAIT_BRES)? 1:0;


always_ff @(posedge clk) begin
    if(inf.R_VALID) begin
        data_dram.Index_A <= inf.R_DATA[63:52];
        data_dram.Index_B <= inf.R_DATA[51:40];
        data_dram.M <= inf.R_DATA[39:32];
        data_dram.Index_C <= inf.R_DATA[31:20];
        data_dram.Index_D <= inf.R_DATA[19:8];
        data_dram.D <= inf.R_DATA[7:0];
    end
end

always_ff @(posedge clk) begin
    if(State == PASS_ADDR_W) begin
        write_back_data[63:52] <= (sub_res_ff[0][12]&&index_ff[0][11]) ? 0 : (sub_res_ff[0][12]) ? 4095: sub_res_ff[0][11:0];
        write_back_data[51:40] <= (sub_res_ff[1][12]&&index_ff[1][11]) ? 0 : (sub_res_ff[1][12]) ? 4095: sub_res_ff[1][11:0];
        write_back_data[39:32] <= date_ff.M;
        write_back_data[31:20] <= (sub_res_ff[2][12]&&index_ff[2][11]) ? 0 : (sub_res_ff[2][12]) ? 4095: sub_res_ff[2][11:0];
        write_back_data[19:8] <= (sub_res_ff[3][12]&&index_ff[3][11]) ? 0 : (sub_res_ff[3][12]) ? 4095: sub_res_ff[3][11:0];
        write_back_data[7:0] <= date_ff.D;
    end
end


////////////////////////////////////////////
endmodule

module minmax(a, b, min, max);
    input logic [11:0] a, b;
    output logic [11:0] min, max;

    always_comb min = (a>=b) ? b:a;
    always_comb max = (a>=b) ? a:b;

endmodule