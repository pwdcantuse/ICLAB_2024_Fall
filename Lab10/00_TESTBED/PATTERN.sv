
// `include "../00_TESTBED/pseudo_DRAM.sv"
`include "Usertype.sv"

program automatic PATTERN(input clk, INF.PATTERN inf);
import usertype::*;
//================================================================
// parameters & integer
//================================================================
parameter DRAM_p_r = "../00_TESTBED/DRAM/dram.dat";
parameter MAX_CYCLE=1000;
parameter PAT_NUM=5402;
parameter SEED=5500;
integer total_lat, lat;
integer i, i_pat;
//================================================================
// wire & registers 
//================================================================
logic [7:0] golden_DRAM [((65536+8*256)-1):(65536+0)];  // 32 box


logic complete_golden;
Warn_Msg warn_golden;

Action action_in;
Formula_Type formula_in;
Mode mode_in;
Data_No no_in;
Data_Dir data_dir_in;
Index inList[4] ;
Index absList[4]  ;
Index dramList[0:3] ;
Index Max;
Index Min;
logic signed[12:0] update_data [0:3];
logic signed[12:0] org_data [0:3];
logic signed[12:0] var_data [0:3];
integer act_type ;
integer formula_type ;
integer mode_type ;
//================================================================
// class random
//================================================================

/**
 * Class representing a random action.
 */
class random_act;
    randc Action act_id;
    function new (int SEED);
        this.srandom(SEED);
    endfunction
    constraint range{
        act_id inside{Index_Check, Update, Check_Valid_Date};
    }
endclass

class random_formula_type;
    randc Formula_Type formula_id;
    function new (int SEED);
        this.srandom(SEED);
    endfunction
    constraint range{
        formula_id inside{ Formula_A ,Formula_B,Formula_C ,Formula_D , Formula_E ,Formula_F, Formula_G ,Formula_H};
    }
endclass
class random_mode;
    randc Mode mode_id;
    function new (int SEED);
        this.srandom(SEED);
    endfunction
    constraint range{
        mode_id inside{ Insensitive ,Normal ,Sensitive };
    }
endclass


class random_date;
    rand Month month_rand;
    rand Day day_rand;
    function new (int SEED);
        this.srandom(SEED);
    endfunction
    constraint month_rand_range{
        month_rand inside{ [1:12] };
    }
    constraint day_rand_range{
        (month_rand == 1) -> day_rand inside{ [1:31] };
        (month_rand == 2) -> day_rand inside{ [1:28] };
        (month_rand == 3) -> day_rand inside{ [1:31] };
        (month_rand == 4) -> day_rand inside{ [1:30] };
        (month_rand == 5) -> day_rand inside{ [1:31] };
        (month_rand == 6) -> day_rand inside{ [1:30] };
        (month_rand == 7) -> day_rand inside{ [1:31] };
        (month_rand == 8) -> day_rand inside{ [1:31] };
        (month_rand == 9) -> day_rand inside{ [1:30] };
        (month_rand == 10) -> day_rand inside{ [1:31] };
        (month_rand == 11) -> day_rand inside{ [1:30] };
        (month_rand == 12) -> day_rand inside{ [1:31] };
    }
endclass

class random_no;
    rand Data_No no_rand;
    function new (int SEED);
        this.srandom(SEED);
    endfunction
    constraint range{
        no_rand inside{ [0:255] };
    }
endclass

class random_index;
    randc Index index_rand;
    function new (int SEED);
        this.srandom(SEED);
    endfunction
    constraint range{
        index_rand inside{ [0:4095] };
    }
endclass


random_act act_rand = new(SEED);
random_formula_type formula_rand = new(SEED);
random_mode mode_rand = new(SEED);
random_date date_rand = new(SEED);
random_no no_rand = new(SEED);
random_index index_rand = new(SEED);

//================================================================
// initial
//================================================================







initial 
begin
    $readmemh(DRAM_p_r, golden_DRAM);
    reset_task;
    act_type = 0;
    formula_type = 0;
    mode_type = 0;
    for (i_pat=0;i_pat<PAT_NUM;i_pat++) 
	begin
        if(i_pat<1000)  begin
            act_type = 0;
            if(i_pat<150) begin
                formula_type = 0;
                mode_type = 0;
            end
            else if(i_pat<300) begin
                formula_type = 0;
                mode_type = 1;
            end
            else if(i_pat<450) begin
                formula_type = 0;
                mode_type = 2;
            end
            else if(i_pat<600) begin
                formula_type = 1;
                mode_type = 0;
            end
            else if(i_pat<750) begin
                formula_type = 1;
                mode_type = 1;
            end
            else if(i_pat<900) begin
                formula_type = 1;
                mode_type = 2;
            end
            else begin //100
                formula_type = 2;
                mode_type = 0;
            end
            
        end
        else if(i_pat>=1000 && i_pat < 1600) begin
            if(i_pat<1100) begin
                if(i_pat%2 == 0) begin
                    act_type = 1;
                end
                else begin
                    act_type = 0;
                end
                formula_type = 2;
                mode_type = 0;
            end
            else if(i_pat<1400) begin
                if(i_pat%2 == 0) begin
                    act_type = 1;
                end
                else begin
                    act_type = 0;
                end
                formula_type = 2;
                mode_type = 1;
            end
            else begin // 100
                if(i_pat%2 == 0) begin
                    act_type = 1;
                end
                else begin
                    act_type = 0;
                end
                formula_type = 2;
                mode_type = 2;
            end
        end
        else if(i_pat>=1600 && i_pat < 2600) begin
            if(i_pat<1650) begin
                act_type = 0;
                formula_type = 2;
                mode_type = 2;
            end
            else if(i_pat<1800) begin
                act_type = 0;
                formula_type = 3;
                mode_type = 0;
            end
            else if(i_pat<1950) begin
                act_type = 0;
                formula_type = 3;
                mode_type = 1;
            end
            else if(i_pat<2100) begin
                act_type = 0;
                formula_type = 3;
                mode_type = 2;
            end
            else if(i_pat<2250) begin
                act_type = 0;
                formula_type = 4;
                mode_type = 0;
            end
            else if(i_pat<2400) begin
                act_type = 0;
                formula_type = 4;
                mode_type = 1;
            end
            else if(i_pat<2550) begin
                act_type = 0;
                formula_type = 4;
                mode_type = 2;
            end
            else  begin //50
                act_type = 0;
                formula_type = 5;
                mode_type = 0;
            end
        end
        else if(i_pat>=2600 && i_pat < 3200) begin
            if(i_pat<2800) begin
                if(i_pat%2 == 0) begin
                    act_type = 2;
                end
                else begin
                    act_type = 0;
                end
                formula_type = 5;
                mode_type = 0;
            end
            else if(i_pat<3100) begin
                if(i_pat%2 == 0) begin
                    act_type = 2;
                end
                else begin
                    act_type = 0;
                end
                formula_type = 5;
                mode_type = 1;
            end
            else begin // 50
                if(i_pat%2 == 0) begin
                    act_type = 2;
                end
                else begin
                    act_type = 0;
                end
                formula_type = 5;
                mode_type = 2;
            end
        end
        else if(i_pat>=3200 && i_pat < 4200) begin
            if(i_pat<3300) begin
                act_type = 0;
                formula_type = 5;
                mode_type = 2;
            end
            else if(i_pat<3450) begin
                act_type = 0;
                formula_type = 6;
                mode_type = 0;
            end
            else if(i_pat<3600) begin
                act_type = 0;
                formula_type = 6;
                mode_type = 1;
            end
            else if(i_pat<3750) begin
                act_type = 0;
                formula_type = 6;
                mode_type = 2;
            end
            else if(i_pat<3900) begin
                act_type = 0;
                formula_type = 7;
                mode_type = 0;
            end
            else if(i_pat<4050) begin
                act_type = 0;
                formula_type = 7;
                mode_type = 1;
            end
            else  begin 
                act_type = 0;
                formula_type = 7;
                mode_type = 2;
            end
        end
        else if(i_pat>=4200 && i_pat < 4500) begin
            act_type = 2;
        end
        else if(i_pat>=4500 && i_pat < 5102) begin
            if(i_pat%2 == 0) begin
                act_type = 2;
            end
            else begin
                act_type = 1;
            end
        end
        else if(i_pat>=5102 && i_pat < 5402) begin
            act_type = 1;
        end
        else begin
            act_type = 4;
            formula_type = 8;
            mode_type = 3;
        end

        input_task;
        wait_out_valid_task;
        exe_task;
        check_ans_task; 
        total_lat += lat;
		//$display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32m latency: %3d  Formula NO.%4d  Action.%4d  Warn: %d \033[m", i_pat, lat,formula_in,action_in, warn_golden);
    end
    YOU_PASS_task;
end

task reset_task;
    begin
        inf.rst_n            = 1;
        inf.sel_action_valid = 0;
        inf.formula_valid       = 0;
        inf.mode_valid       = 0;
        inf.date_valid       = 0;
        inf.data_no_valid     = 0;
        inf.index_valid    = 0;
        inf.D                =72'dx;
        total_lat            = 0;

        #0.5;  inf.rst_n = 0; 
        #2; inf.rst_n = 1;
    end
endtask

task input_task;
    begin
        @(negedge clk);
        inf.sel_action_valid = 1;
        if(act_type == 0) begin
            inf.D.d_act[0] = Index_Check;
        end
        else if(act_type == 1) begin
            inf.D.d_act[0] = Update;
        end
        else if(act_type == 2) begin
            inf.D.d_act[0] = Check_Valid_Date;
        end
        else begin
            i= act_rand.randomize();
            inf.D.d_act[0] = act_rand.act_id;
        end
        action_in = inf.D.d_act[0];
        @(negedge clk);
        inf.D                =72'dx;
        inf.sel_action_valid = 0;
        if(action_in === Index_Check) begin
            inf.formula_valid = 1;
            case(formula_type)
                0: inf.D.d_formula[0] = Formula_A;
                1: inf.D.d_formula[0] = Formula_B;
                2: inf.D.d_formula[0] = Formula_C;
                3: inf.D.d_formula[0] = Formula_D;
                4: inf.D.d_formula[0] = Formula_E;
                5: inf.D.d_formula[0] = Formula_F;
                6: inf.D.d_formula[0] = Formula_G;
                7: inf.D.d_formula[0] = Formula_H;
                default: begin
                    i= formula_rand.randomize();
                    inf.D.d_formula[0] = formula_rand.formula_id;
                end
            endcase
            formula_in = inf.D.d_formula[0];
            @(negedge clk);
            inf.D                =72'dx;
            inf.formula_valid = 0;
            inf.mode_valid = 1;
            case(mode_type)
                0: inf.D.d_mode[0] = Insensitive;
                1: inf.D.d_mode[0] = Normal  ;
                2: inf.D.d_mode[0] = Sensitive ;
                default: begin
                    i= mode_rand.randomize();
                    inf.D.d_mode[0] = mode_rand.mode_id;
                end
            endcase
            mode_in = inf.D.d_mode[0];
            @(negedge clk);
            inf.D                =72'dx;
            inf.mode_valid = 0;
            inf.date_valid = 1;
            if(i_pat<50) begin
                inf.D.d_date[0].M =  4'd8;
                inf.D.d_date[0].D = 5'd1;
            end
            else if(i_pat==3750) begin
                inf.D.d_date[0].M =  4'd9;
                inf.D.d_date[0].D = 5'd2;
            end
            else if(i_pat<4200) begin
                inf.D.d_date[0].M =  4'd9;
                inf.D.d_date[0].D = 5'd18;
            end
            else begin
                i= date_rand.randomize();
                inf.D.d_date[0].M = date_rand.month_rand;
                inf.D.d_date[0].D = date_rand.day_rand;
            end
            data_dir_in.M = inf.D.d_date[0].M;
            data_dir_in.D = inf.D.d_date[0].D;
            @(negedge clk);
            inf.D                =72'dx;
            inf.date_valid = 0;
            inf.data_no_valid = 1;
            if(i_pat<50) begin
                inf.D.d_data_no[0] = 8'hb8;
            end
            else if(i_pat==3750) begin
                inf.D.d_data_no[0] = 8'h00;
            end
            else if(i_pat<4200) begin
                inf.D.d_data_no[0] = 8'h9c;
            end
            else begin
                i= no_rand.randomize();
                inf.D.d_data_no[0] = no_rand.no_rand;
            end
            no_in = inf.D.d_data_no[0];
            @(negedge clk);
            inf.D                =72'dx;
            inf.data_no_valid = 0;
            inf.index_valid = 1;
            if(i_pat<50) begin
                inf.D.d_index[0] = 12'hc27;
            end
            else if(i_pat==3750) begin
                inf.D.d_index[0] = 12'h993;
            end
            else if(i_pat<4200) begin
                inf.D.d_index[0] = 12'h000;
            end
            else begin
                i= index_rand.randomize();
                inf.D.d_index[0] = index_rand.index_rand;
            end
            
            data_dir_in.Index_A = inf.D.d_index[0];
            @(negedge clk);
            inf.D                =72'dx;
            inf.index_valid = 0;
            inf.index_valid = 1;
            if(i_pat<50) begin
                inf.D.d_index[0] = 12'hbe5;
            end
            else if(i_pat==3750) begin
                inf.D.d_index[0] = 12'h039;
            end
            else if(i_pat<4200) begin
                inf.D.d_index[0] = 12'h000;
            end
            else begin
                i= index_rand.randomize();
                inf.D.d_index[0] = index_rand.index_rand;
            end
            data_dir_in.Index_B = inf.D.d_index[0];
            @(negedge clk);
            inf.D                =72'dx;
            inf.index_valid = 0;
            inf.index_valid = 1;
            if(i_pat<50) begin
                inf.D.d_index[0] = 12'hb82;
            end
            else if(i_pat==3750) begin
                inf.D.d_index[0] = 12'hd02;
            end
            else if(i_pat<4200) begin
                inf.D.d_index[0] = 12'h000;
            end
            else begin
                i= index_rand.randomize();
                inf.D.d_index[0] = index_rand.index_rand;
            end
            data_dir_in.Index_C = inf.D.d_index[0];
            @(negedge clk);
            inf.D                =72'dx;
            inf.index_valid = 0;
            inf.index_valid = 1;
            if(i_pat<50) begin
                inf.D.d_index[0] = 12'hb61;
            end
            else if(i_pat==3750) begin
                inf.D.d_index[0] = 12'h6df;
            end
            else if(i_pat<4200) begin
                inf.D.d_index[0] = 12'h000;
            end
            else begin
                i= index_rand.randomize();
                inf.D.d_index[0] = index_rand.index_rand;
            end
            data_dir_in.Index_D = inf.D.d_index[0];
            @(negedge clk);
            inf.D = 72'dx;
            inf.D                =72'dx;
            inf.index_valid = 0;
        end
        else if(action_in === Update) begin
            inf.date_valid = 1;
            i= date_rand.randomize();
            inf.D.d_date[0].M = date_rand.month_rand;
            inf.D.d_date[0].D = date_rand.day_rand;
            data_dir_in.M = inf.D.d_date[0].M;
            data_dir_in.D = inf.D.d_date[0].D;
            @(negedge clk);
            inf.D = 72'dx;
            inf.date_valid = 0;
            inf.data_no_valid = 1;
            if(i_pat<4200) begin
                inf.D.d_data_no[0] = 8'hab;
            end
            else begin
                i= no_rand.randomize();
                inf.D.d_data_no[0] = no_rand.no_rand;
            end
            no_in = inf.D.d_data_no[0];
            @(negedge clk);
            inf.D = 72'dx;
            inf.data_no_valid = 0;
            inf.index_valid = 1;
            i= index_rand.randomize();
            inf.D.d_index[0] = index_rand.index_rand;
            data_dir_in.Index_A = inf.D.d_index[0];
            @(negedge clk);
            inf.D = 72'dx;
            inf.index_valid = 0;
            inf.index_valid = 1;
            i= index_rand.randomize();
            inf.D.d_index[0] = index_rand.index_rand;
            data_dir_in.Index_B = inf.D.d_index[0];
            @(negedge clk);
            inf.D = 72'dx;
            inf.index_valid = 0;
            inf.index_valid = 1;
            i= index_rand.randomize();
            inf.D.d_index[0] = index_rand.index_rand;
            data_dir_in.Index_C = inf.D.d_index[0];
            @(negedge clk);
            inf.D = 72'dx;
            inf.index_valid = 0;
            inf.index_valid = 1;
            i= index_rand.randomize();
            inf.D.d_index[0] = index_rand.index_rand;
            data_dir_in.Index_D = inf.D.d_index[0];
            @(negedge clk);
            inf.D = 72'dx;
            inf.index_valid = 0;
        end
        else if(action_in === Check_Valid_Date) begin
            inf.date_valid = 1;
            i= date_rand.randomize();
            inf.D.d_date[0].M = date_rand.month_rand;
            inf.D.d_date[0].D = date_rand.day_rand;
            data_dir_in.M = inf.D.d_date[0].M;
            data_dir_in.D = inf.D.d_date[0].D;
            @(negedge clk);
            inf.D = 72'dx;
            inf.date_valid = 0;
            inf.data_no_valid = 1;
            i= no_rand.randomize();
            inf.D.d_data_no[0] = no_rand.no_rand;
            no_in = inf.D.d_data_no[0];
            @(negedge clk);
            inf.D = 72'dx;
            inf.data_no_valid = 0;
            
            
        end
        
    end
endtask

task wait_out_valid_task;
    begin
        lat = 0;
    while(inf.out_valid !== 1) 
        begin
            lat += 1;
            @(negedge clk);
        end
    end
endtask


task exe_task;
    begin
        if(action_in == Index_Check) begin
            Index_Check_task;
        end
        else if(action_in == Update) begin
            Update_task;
        end
        else if(action_in == Check_Valid_Date) begin
            Check_Valid_Date_task;
        end
    end
endtask


task Index_Check_task;
    begin
        Data_Dir data_dram;
        logic [63:0] dram_in = {golden_DRAM[(65536+8*no_in)+7],golden_DRAM[(65536+8*no_in)+6],golden_DRAM[(65536+8*no_in)+5],golden_DRAM[(65536+8*no_in)+4],golden_DRAM[(65536+8*no_in)+3],golden_DRAM[(65536+8*no_in)+2],
        golden_DRAM[(65536+8*no_in)+1],golden_DRAM[(65536+8*no_in)]};
        logic [13:0] sum_formula;
        logic [13:0] result = 0;
        logic [11:0] threshold;
        Index G_A;
        Index G_B;
        Index G_C;
        Index G_D;

        data_dram.Index_A = dram_in[63:52];
        data_dram.Index_B = dram_in[51:40];
        data_dram.M = dram_in[39:32];
        data_dram.Index_C = dram_in[31:20];
        data_dram.Index_D = dram_in[19:8];
        data_dram.D = dram_in[7:0];

        

        G_A = (data_dram.Index_A>data_dir_in.Index_A) ? (data_dram.Index_A-data_dir_in.Index_A):(data_dir_in.Index_A-data_dram.Index_A);
        G_B = (data_dram.Index_B>data_dir_in.Index_B) ? (data_dram.Index_B-data_dir_in.Index_B):(data_dir_in.Index_B-data_dram.Index_B);
        G_C = (data_dram.Index_C>data_dir_in.Index_C) ? (data_dram.Index_C-data_dir_in.Index_C):(data_dir_in.Index_C-data_dram.Index_C);
        G_D = (data_dram.Index_D>data_dir_in.Index_D) ? (data_dram.Index_D-data_dir_in.Index_D):(data_dir_in.Index_D-data_dram.Index_D);


        
        dramList[0] = data_dram.Index_A;
        dramList[1] = data_dram.Index_B;
        dramList[2] = data_dram.Index_C;
        dramList[3] = data_dram.Index_D;
        
        inList[0] = data_dir_in.Index_A;
        inList[1] = data_dir_in.Index_B;
        inList[2] = data_dir_in.Index_C;
        inList[3] = data_dir_in.Index_D;
        
        absList[0] = G_A;
        absList[1] = G_B;
        absList[2] = G_C;
        absList[3] = G_D;

        Max = (dramList[0] >= dramList[1] && dramList[0] >= dramList[2] && dramList[0] >= dramList[3]) ? dramList[0] :
            (dramList[1] >= dramList[0] && dramList[1] >= dramList[2] && dramList[1] >= dramList[3]) ? dramList[1] :
            (dramList[2] >= dramList[0] && dramList[2] >= dramList[1] && dramList[2] >= dramList[3]) ? dramList[2] :
            dramList[3];

        Min = (dramList[0] <= dramList[1] && dramList[0] <= dramList[2] && dramList[0] <= dramList[3]) ? dramList[0] :
            (dramList[1] <= dramList[0] && dramList[1] <= dramList[2] && dramList[1] <= dramList[3]) ? dramList[1] :
            (dramList[2] <= dramList[0] && dramList[2] <= dramList[1] && dramList[2] <= dramList[3]) ? dramList[2] :
            dramList[3];

        
        case(formula_in)
            Formula_A: begin
                result = (dramList[0]+dramList[1]+dramList[2]+dramList[3])/4;
            end
            Formula_B: begin
                result = Max - Min;
            end
            Formula_C: begin
                result = Min;
            end
            Formula_D: begin
                integer k;
                for(k = 0; k < 4; k++)
                    if(dramList[k]>=2047) result++;
            end
            Formula_E: begin
                integer k;
                for(k = 0; k < 4; k++)
                    if(dramList[k]>=inList[k]) result++;
            end
            Formula_F: begin
                absList.sort();
                result = (absList[0] + absList[1] + absList[2])/3;
            end
            Formula_G: begin
                absList.sort();
                result = absList[0]/2 + absList[1]/4 + absList[2]/4;
            end
            Formula_H: begin
                result = (absList[0]+absList[1]+absList[2]+absList[3])/4;
            end
        endcase

        case(formula_in)
            Formula_A,Formula_C : threshold = (mode_in == Insensitive) ? 12'd2047 : (mode_in == Normal) ? 12'd1023 : 12'd511 ;
            Formula_B,Formula_F,Formula_G,Formula_H : threshold = (mode_in == Insensitive) ? 12'd800 : (mode_in == Normal) ? 12'd400 : 12'd200 ;
            Formula_D,Formula_E : threshold = (mode_in == Insensitive) ? 12'd3 : (mode_in == Normal) ? 12'd2 : 12'd1 ;
        endcase

        if(data_dram.M>data_dir_in.M||(data_dram.M==data_dir_in.M&&data_dram.D>data_dir_in.D)) warn_golden = Date_Warn;
        else if(result>=threshold)warn_golden = Risk_Warn;
        else warn_golden = No_Warn;

        complete_golden = (warn_golden == No_Warn)? 1:0;
    end
endtask

task Update_task;
    begin
        Data_Dir data_dram;
        logic [63:0] dram_in = {golden_DRAM[(65536+8*no_in)+7],golden_DRAM[(65536+8*no_in)+6],golden_DRAM[(65536+8*no_in)+5],golden_DRAM[(65536+8*no_in)+4],golden_DRAM[(65536+8*no_in)+3],golden_DRAM[(65536+8*no_in)+2],
        golden_DRAM[(65536+8*no_in)+1],golden_DRAM[(65536+8*no_in)]};
        logic [63:0] write_data;

        data_dram.Index_A = dram_in[63:52];
        data_dram.Index_B = dram_in[51:40];
        data_dram.M = dram_in[39:32];
        data_dram.Index_C = dram_in[31:20];
        data_dram.Index_D = dram_in[19:8];
        data_dram.D = dram_in[7:0];

        

        org_data[0] = {2'd0,data_dram.Index_A};
        org_data[1] = {2'd0,data_dram.Index_B};
        org_data[2] = {2'd0,data_dram.Index_C};
        org_data[3] = {2'd0,data_dram.Index_D};
        var_data[0] = $signed(data_dir_in.Index_A);
        var_data[1] = $signed(data_dir_in.Index_B);
        var_data[2] = $signed(data_dir_in.Index_C);
        var_data[3] = $signed(data_dir_in.Index_D);

        update_data[0] = org_data[0] + var_data[0];
        update_data[1] = org_data[1] + var_data[1];
        update_data[2] = org_data[2] + var_data[2];
        update_data[3] = org_data[3] + var_data[3];

        write_data[63:52] = (update_data[0]<0 && var_data[0]<0) ? 0: (update_data[0]<0) ?  4095 : update_data[0][11:0];
        write_data[51:40] = (update_data[1]<0 && var_data[1]<0) ? 0: (update_data[1]<0) ?  4095 : update_data[1][11:0];
        write_data[39:32] = data_dir_in.M;
        write_data[31:20] = (update_data[2]<0 && var_data[2]<0) ? 0: (update_data[2]<0) ? 4095 : update_data[2][11:0];
        write_data[19:8] = (update_data[3]<0 && var_data[3]<0) ? 0: (update_data[3]<0) ? 4095 : update_data[3][11:0];
        write_data[7:0] = data_dir_in.D;

        {golden_DRAM[(65536+8*no_in)+7],golden_DRAM[(65536+8*no_in)+6],golden_DRAM[(65536+8*no_in)+5],golden_DRAM[(65536+8*no_in)+4],golden_DRAM[(65536+8*no_in)+3],golden_DRAM[(65536+8*no_in)+2],
        golden_DRAM[(65536+8*no_in)+1],golden_DRAM[(65536+8*no_in)]} = write_data;
        
        if(update_data[0]<0|| update_data[1]<0||update_data[2]<0||update_data[3]<0) warn_golden = Data_Warn;
        else warn_golden = No_Warn;

        complete_golden = (warn_golden == No_Warn)? 1:0;
    end
endtask

task Check_Valid_Date_task;
    begin
        Data_Dir data_dram;
        logic [63:0] dram_in = {golden_DRAM[(65536+8*no_in)+7],golden_DRAM[(65536+8*no_in)+6],golden_DRAM[(65536+8*no_in)+5],golden_DRAM[(65536+8*no_in)+4],golden_DRAM[(65536+8*no_in)+3],golden_DRAM[(65536+8*no_in)+2],
        golden_DRAM[(65536+8*no_in)+1],golden_DRAM[(65536+8*no_in)]};
        data_dram.Index_A = dram_in[63:52];
        data_dram.Index_B = dram_in[51:40];
        data_dram.M = dram_in[39:32];
        data_dram.Index_C = dram_in[31:20];
        data_dram.Index_D = dram_in[19:8];
        data_dram.D = dram_in[7:0];

        if(data_dram.M>data_dir_in.M||(data_dram.M==data_dir_in.M&&data_dram.D>data_dir_in.D)) warn_golden = Date_Warn;
        else warn_golden = No_Warn;

        complete_golden = (warn_golden == No_Warn)? 1:0;
    end
endtask

task check_ans_task;
    begin
        if(inf.warn_msg!==warn_golden || inf.complete !== complete_golden) begin
            $display("                                                              Wrong Answer                                                                 ");
            
            $finish;
        end
    end
endtask

task YOU_PASS_task;
    begin
        $display("                                                             Congratulations                                                                ");
        $finish;
    end
endtask

endprogram
