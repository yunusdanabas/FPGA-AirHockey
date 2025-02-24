module hockey(

    input clk,
    input rst,
    
    input BTN_A,
    input BTN_B,
    
    input [1:0] DIR_A,
    input [1:0] DIR_B,
    
    input [2:0] Y_in_A,
    input [2:0] Y_in_B,
   
    /*output reg LEDA,
    output reg LEDB,
    output reg [4:0] LEDX,
    
    output reg [6:0] SSD7,
    output reg [6:0] SSD6,
    output reg [6:0] SSD5,
    output reg [6:0] SSD4, 
    output reg [6:0] SSD3,
    output reg [6:0] SSD2,
    output reg [6:0] SSD1,
    output reg [6:0] SSD0   */

    output reg [2:0] X_COORD,
	output reg [2:0] Y_COORD

    );    

    reg [1:0] Y_DIR;
    
    reg [3:0] current_state; 

    parameter IDLE = 0, DISP = 1;
    parameter HIT_A = 2, HIT_B = 3; 
    parameter SEND_A = 4, SEND_B = 5;
    parameter RESP_A = 6, RESP_B = 7;
    parameter GOAL_A = 8, GOAL_B = 9;
    parameter END_GAME = 10;

    reg [1:0] score_A;
    reg [1:0] score_B;

    reg turn;

    reg [7:0] timer;
    reg timer_amount;
    
    always @(posedge clk or posedge rst)
    begin

        if(rst) begin
            X_COORD <= 3'b000;
            Y_COORD <= 3'b000;
            Y_DIR <= 3'b000;
            timer <= 7'b0000000;
            timer_amount <= 200;
            turn <= 1'b0;
            score_A <= 2'b00;
            score_B <= 2'b00;

            current_state <= IDLE;
        end

        else
            begin
                case(current_state)

                IDLE: begin
                    if((BTN_A == 1'b1) && (BTN_B == 1'b0)) begin
                        turn <= 1'b0;
                        current_state <= DISP;
                    end 
                    else if((BTN_A == 1'b0) && (BTN_B == 1'b1)) begin
                        turn <= 1'b1;
                        current_state <= DISP;
                    end 
                    else begin
                        current_state <= IDLE;
                    end                    
                end

                DISP: begin

                    if (turn == 0) begin // Hit A

                        if (timer == timer_amount) begin

                            current_state <= HIT_A;
                            timer <= 0;
                        end

                        else begin
                            timer <= timer + 1;
                            current_state <= DISP;
                        end                        
                    end

                    else if (turn == 1) begin
                        
                        if (timer == timer_amount) begin
                            current_state <= HIT_B;
                            timer <= 0;
                        end

                        else begin
                            timer <= timer + 1;
                            current_state <= DISP;
                        end                        
                    end

                    end

                HIT_A: begin

                    if(BTN_A && (Y_in_A < 5)) begin

                        X_COORD <= 3'b000;
                        Y_COORD <= Y_in_A;
                        Y_DIR <= DIR_A;

                        current_state <= SEND_B;
                    end

                    else begin
                        current_state <= HIT_A;
                    end
                end

                HIT_B: begin

                    if(BTN_B && (Y_in_B < 5)) begin

                        X_COORD <= 3'b100;
                        Y_COORD <= Y_in_B;
                        Y_DIR <= DIR_B;

                        current_state <= SEND_A;
                    end

                    else begin
                        current_state <= HIT_B;
                    end
                end

                SEND_A: begin
                    if (timer < timer_amount) 
                        begin
                            timer <= timer + 1;
                            current_state <= SEND_A;
                        end
                    else if (timer == timer_amount)
                        begin
                            timer <= 1'b0;
                            if (Y_DIR == 2'b10)
                                begin
                                    if (Y_COORD == 1'b0)
                                        begin
                                            Y_DIR<= 2'b01;
                                            Y_COORD <= Y_COORD + 1;
                                        end
                                    else
                                        begin
                                            Y_COORD <= Y_COORD - 1;
                                        end
                                end
                            else if (Y_DIR == 2'b01)
                                begin
                                    if (Y_COORD == 3'b100)
                                        begin
                                            Y_DIR <= 2'b10;
                                            Y_COORD <= Y_COORD - 1;
                                        end
                                    else 
                                        begin
                                            Y_COORD <= Y_COORD + 1;
                                        end
                                end
                            else if (Y_DIR == 2'b00)
                                begin

                                end
                        end

                        if (X_COORD > 1)
                            begin
                                X_COORD <= X_COORD - 1;
                                current_state <= SEND_A;
                            end
                        else
                            begin
                                X_COORD <= 3'b000;
                                current_state <= RESP_A;
                            end
                    end

                SEND_B: begin
                    if (timer < timer_amount) 
                        begin
                            timer <= timer + 1;
                            current_state <= SEND_B;
                        end
                    else if (timer == timer_amount)
                        begin
                            timer <= 0;
                            if (Y_DIR == 2'b10)
                                begin
                                    if (Y_COORD == 3'b000)
                                        begin
                                            Y_DIR<= 2'b01;
                                            Y_COORD <= Y_COORD + 1;
                
                                        end
                                    else
                                        begin
                                            Y_COORD <= Y_COORD - 1;
                                        end
                                end
                            else if (Y_DIR == 2'b01)
                                begin
                                    if (Y_COORD == 3'b100)
                                        begin
                                            Y_DIR <= 2'b10;
                                            Y_COORD <= Y_COORD - 1;
                                        end
                                    else 
                                        begin
                                            Y_COORD <= Y_COORD + 1;
                                        end
                                end
                            else if (Y_DIR == 2'b00)
                                begin
                
                                end
                        end
                
                    if (X_COORD < 3)
                        begin
                            X_COORD <= X_COORD + 1;
                            current_state <= SEND_B;
                        end
                    else
                        begin
                            X_COORD <= 3'b100;
                            current_state <= RESP_B;
                        end
                end

                RESP_A:
                    begin
                        if (timer < timer_amount)
                            begin
                                if (BTN_A && (Y_COORD == Y_in_A))
                                    begin
                                        X_COORD <= 3'b001;
                                        timer <= 0;
                                        if (DIR_B == 2'b00)
                                            begin
                                                Y_DIR <= DIR_B;
                                                current_state <= SEND_B;
                                            end
                                        else if (DIR_B == 2'b01)
                                            begin
                                                if (Y_COORD == 3'b100)
                                                    begin
                                                        Y_DIR <= 2'b10;
                                                        Y_COORD <= Y_COORD - 1;
                                                        current_state <= SEND_B;
                                                    end
                                                else
                                                    begin
                                                        Y_DIR <= DIR_A;
                                                        Y_COORD <= Y_COORD + 1;
                                                        current_state <= SEND_B;
                                                    end
                                            end
                                        else if (DIR_B == 2'b10)
                                            begin
                                                if (Y_COORD == 3'b000)
                                                    begin
                                                        Y_DIR <= 2'b01;
                                                        Y_COORD <= Y_COORD + 1;
                                                        current_state <= SEND_B;
                                                    end
                                                else
                                                    begin
                                                        Y_DIR <= DIR_A;
                                                        Y_COORD <= Y_COORD - 1;
                                                        current_state <= SEND_B;
                                                    end
                                            end
                                    end
                                else 
                                    begin
                                        timer <= timer + 1;
                                        current_state <= RESP_A;
                                    end
                            end
                        else if (timer == timer_amount)
                            begin
                                timer <= 0;
                                score_B <= score_B + 1;
                                current_state <= GOAL_B;
                            end
                    end

                GOAL_B:
                    begin
                        if (timer < timer_amount)
                            begin
                                timer <= timer + 1;
                                current_state <= GOAL_B;
                            end
                        else if (timer == timer_amount)
                            begin
                                timer <= 0;
                                if (score_B == 2'b11)
                                    begin
                                        turn <= 1'b1;
                                        current_state <= END_GAME;
                                    end
                                else if (score_B != 2'b11)
                                    begin
                                        current_state <= HIT_A;
                                    end
                            end
                    end

                GOAL_A:
                    begin
                        if (timer < timer_amount)
                            begin
                                timer <= timer + 1;
                                current_state <= GOAL_A;
                            end
                        else if (timer == timer_amount)
                            begin
                                timer <= 0;
                                if (score_A == 2'b11)
                                    begin
                                        turn <= 1'b0;
                                        current_state <= END_GAME;
                                    end
                                else if (score_A != 2'b11)
                                    begin
                                        current_state <= HIT_B;
                                    end
                            end
                    end

                RESP_B:
                    begin
                        if (timer < timer_amount)
                            begin
                                if (BTN_B && (Y_COORD == Y_in_B))
                                    begin
                                        X_COORD <= 3'b011;
                                        timer <= 0;
                                        if (DIR_A == 2'b00)
                                            begin
                                                Y_DIR <= DIR_A;
                                                current_state <= SEND_A;
                                            end
                                        else if (DIR_A == 2'b01)
                                            begin
                                                if (Y_COORD == 3'b100)
                                                    begin
                                                        Y_DIR <= 2'b10;
                                                        Y_COORD <= Y_COORD - 1;
                                                        current_state <= SEND_A;
                                                    end
                                                else if (Y_COORD != 3'b100)
                                                    begin
                                                        Y_DIR <= DIR_B;
                                                        Y_COORD <= Y_COORD + 1;
                                                        current_state <= SEND_A;
                                                    end
                                            end
                                        else if (DIR_A == 2'b10)
                                            begin
                                                if (Y_COORD == 3'b000)
                                                    begin
                                                        Y_DIR <= 2'b01;
                                                        Y_COORD <= Y_COORD + 1;
                                                        current_state <= SEND_A;
                                                    end
                                                else if (Y_COORD != 1'b0)
                                                    begin
                                                        Y_DIR <= DIR_B;
                                                        Y_COORD <= Y_COORD - 1;
                                                        current_state <= SEND_A;
                                                    end
                                            end
                                    end
                                else 
                                    begin
                                        timer <= timer + 1;
                                        current_state <= RESP_B;
                                    end
                            end
                        else if (timer == timer_amount)
                            begin
                                timer <= 0;
                                score_A <= score_A + 1;
                                current_state <= GOAL_A;
                            end
                    end

                END_GAME: 
                    begin
                        current_state <= END_GAME;
                    end


            endcase
        end
	end
endmodule
