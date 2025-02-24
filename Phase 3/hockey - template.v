module hockey(

    input clk,
    input rst,
    
    input BTNA,
    input BTNB,
    
    input [1:0] DIRA,
    input [1:0] DIRB,
    
    input [2:0] YA,
    input [2:0] YB,
   
    output reg LEDA,
    output reg LEDB,
    output reg [4:0] LEDX,
    
    output reg [6:0] SSD7,
    output reg [6:0] SSD6,
    output reg [6:0] SSD5,
    output reg [6:0] SSD4, 
    output reg [6:0] SSD3,
    output reg [6:0] SSD2,
    output reg [6:0] SSD1,
    output reg [6:0] SSD0   

    );

    reg [2:0] X_COORD;
    reg [2:0] Y_COORD;

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
    //reg timer_amount;
    parameter [7:0] timer_amount = 100;

    // you may use additional always blocks or drive SSDs and LEDs in one always block
    // for state machine and memory elements 
    always @(posedge clk or posedge rst)
        begin
           if(rst) 
                begin
                    score_A <= 2'b00;
                    score_B <= 2'b00;
                    X_COORD <= 3'b000;
                    Y_COORD <= 3'b000;
                    Y_DIR <= 3'b000;
                    timer <= 0;
                    turn <= 1'b0;
                    current_state <= IDLE;
                end

            else
                begin
                    case(current_state)
                        IDLE: begin
                            if((BTNA == 1'b1) && (BTNB == 1'b0)) begin
                                turn <= 1'b0;
                                current_state <= DISP;
                            end 
                            else if((BTNA == 1'b0) && (BTNB == 1'b1)) begin
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

                            if(BTNA && (YA < 5)) begin

                                X_COORD <= 3'b000;
                                Y_COORD <= YA;
                                Y_DIR <= DIRA;

                                current_state <= SEND_B;
                            end

                            else begin
                                current_state <= HIT_A;
                            end
                        end
                        HIT_B: begin

                            if(BTNB && (YB < 5)) begin

                                X_COORD <= 3'b100;
                                Y_COORD <= YB;
                                Y_DIR <= DIRB;

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
                                    timer <= 0;
                                    if (Y_DIR == 2'b10)
                                        begin
                                            if (Y_COORD == 1'b0)
                                                begin
                                                    Y_DIR<= 2'b01;
                                                    Y_COORD <= Y_COORD + 1;
                                                end
                                            else
                                                begin
                                                    Y_COORD <= Y_COORD + 1;
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
                        end
                        RESP_A:
                            begin
                                if (timer < timer_amount)
                                    begin
                                        if (BTNA && (Y_COORD == YA))
                                            begin
                                                X_COORD <= 3'b001;
                                                timer <= 0;
                                                if (DIRB == 2'b00)
                                                    begin
                                                        Y_DIR <= DIRB;
                                                        current_state <= SEND_B;
                                                    end
                                                else if (DIRB == 2'b01)
                                                    begin
                                                        if (Y_COORD == 3'b100)
                                                            begin
                                                                Y_DIR <= 2'b10;
                                                                Y_COORD <= Y_COORD - 1;
                                                                current_state <= SEND_B;
                                                            end
                                                        else
                                                            begin
                                                                Y_DIR <= DIRA;
                                                                Y_COORD <= Y_COORD + 1;
                                                                current_state <= SEND_B;
                                                            end
                                                    end
                                                else if (DIRB == 2'b10)
                                                    begin
                                                        if (Y_COORD == 3'b000)
                                                            begin
                                                                Y_DIR <= 2'b01;
                                                                Y_COORD <= Y_COORD + 1;
                                                                current_state <= SEND_B;
                                                            end
                                                        else
                                                            begin
                                                                Y_DIR <= DIRA;
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
                                        if (BTNB && (Y_COORD == YB))
                                            begin
                                                X_COORD <= 3'b011;
                                                timer <= 0;
                                                if (DIRA == 2'b00)
                                                    begin
                                                        Y_DIR <= DIRA;
                                                        current_state <= SEND_A;
                                                    end
                                                else if (DIRA == 2'b01)
                                                    begin
                                                        if (Y_COORD == 3'b100)
                                                            begin
                                                                Y_DIR <= 2'b10;
                                                                Y_COORD <= Y_COORD - 1;
                                                                current_state <= SEND_A;
                                                            end
                                                        else if (Y_COORD != 3'b100)
                                                            begin
                                                                Y_DIR <= DIRB;
                                                                Y_COORD <= Y_COORD + 1;
                                                                current_state <= SEND_A;
                                                            end
                                                    end
                                                else if (DIRA == 2'b10)
                                                    begin
                                                        if (Y_COORD == 3'b000)
                                                            begin
                                                                Y_DIR <= 2'b01;
                                                                Y_COORD <= Y_COORD + 1;
                                                                current_state <= SEND_A;
                                                            end
                                                        else if (Y_COORD != 1'b0)
                                                            begin
                                                                Y_DIR <= DIRB;
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
                                if(timer > 200)
                                    begin
                                        timer <= 0;
                                    end
                                else
                                    begin
                                        timer <= timer+1;
                                    end
                            end


                    endcase
            end
        
        end
    // for SSDs
    always @ (*)
    
        begin        
            if (current_state == IDLE)
                begin 
                    SSD0 = 7'b1100000;
                    SSD1 = 7'b1111110;
                    SSD2 = 7'b0001000;
                    SSD3 = 7'b1111111;
                    SSD4 = 7'b1111111;
                    SSD5 = 7'b1111111;
                    SSD6 = 7'b1111111;
                    SSD7 = 7'b1111111;
                end
            else if (current_state == DISP)
                begin
                //SCORE DISPLAY
                case (score_A)
                    2'b00: SSD2 = 7'b0000001;
                    2'b01: SSD2 = 7'b1001111;
                    2'b10: SSD2 = 7'b0010010;
                    2'b11: SSD2 = 7'b0000110;
                    default:
                        SSD2 = 7'b1111111;
                endcase
    
                case (score_B)
                    2'b00: SSD0 = 7'b0000001;
                    2'b01: SSD0 = 7'b1001111;
                    2'b10: SSD0 = 7'b0010010;
                    2'b11: SSD0 = 7'b0000110;
                    default:
                        SSD0 = 7'b1111111;
                endcase
                end
            else if (current_state == HIT_A)
                begin 
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD3 = 7'b1111111;
                    case (YA)           
                        3'b000: SSD4 = 7'b0000001;
                        3'b001: SSD4 = 7'b1001111;
                        3'b010: SSD4 = 7'b0010010;
                        3'b011: SSD4 = 7'b0000110;
                        3'b100: SSD4 = 7'b1001100;
                        3'b101: SSD4 = 7'b1111110;
                        3'b110: SSD4 = 7'b1111110;
                        3'b111: SSD4 = 7'b1111110;
                        default:
                            SSD4 = 7'b1111111;
                    endcase
                    SSD5 = 7'b1111111;
                    SSD6 = 7'b1111111;
                    SSD7 = 7'b1111111;
                end
            else if (current_state == SEND_B)
                begin 
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD3 = 7'b1111111;
                    case (Y_COORD)           
                        3'b000: SSD4 = 7'b0000001;
                        3'b001: SSD4 = 7'b1001111;
                        3'b010: SSD4 = 7'b0010010;
                        3'b011: SSD4 = 7'b0000110;
                        3'b100: SSD4 = 7'b1001100;
                        3'b101: SSD4 = 7'b1111110;
                        3'b110: SSD4 = 7'b1111110;
                        3'b111: SSD4 = 7'b1111110;
                        default:
                            SSD4 = 7'b1111111;
                    endcase
                    SSD5 = 7'b1111111;
                    SSD6 = 7'b1111111;
                    SSD7 = 7'b1111111;
                end
            else if (current_state == RESP_B)
                begin 
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD3 = 7'b1111111;
                    case (Y_COORD)           
                        3'b000: SSD4 = 7'b0000001;
                        3'b001: SSD4 = 7'b1001111;
                        3'b010: SSD4 = 7'b0010010;
                        3'b011: SSD4 = 7'b0000110;
                        3'b100: SSD4 = 7'b1001100;
                        3'b101: SSD4 = 7'b1111110;
                        3'b110: SSD4 = 7'b1111110;
                        3'b111: SSD4 = 7'b1111110;
                        default:
                            SSD4 = 7'b1111111;
                    endcase
                    SSD5 = 7'b1111111;
                    SSD6 = 7'b1111111;
                    SSD7 = 7'b1111111;
                end
            else if (current_state == SEND_A)
                begin 
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD3 = 7'b1111111;
                    case (Y_COORD)           
                        3'b000: SSD4 = 7'b0000001;
                        3'b001: SSD4 = 7'b1001111;
                        3'b010: SSD4 = 7'b0010010;
                        3'b011: SSD4 = 7'b0000110;
                        3'b100: SSD4 = 7'b1001100;
                        3'b101: SSD4 = 7'b1111110;
                        3'b110: SSD4 = 7'b1111110;
                        3'b111: SSD4 = 7'b1111110;
                        default:
                            SSD4 = 7'b1111111;
                    endcase
                    SSD5 = 7'b1111111;
                    SSD6 = 7'b1111111;
                    SSD7 = 7'b1111111;
                end
             else if (current_state == RESP_A)
                begin 
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD3 = 7'b1111111;
                    case (Y_COORD)           
                        3'b000: SSD4 = 7'b0000001;
                        3'b001: SSD4 = 7'b1001111;
                        3'b010: SSD4 = 7'b0010010;
                        3'b011: SSD4 = 7'b0000110;
                        3'b100: SSD4 = 7'b1001100;
                        3'b101: SSD4 = 7'b1111110;
                        3'b110: SSD4 = 7'b1111110;
                        3'b111: SSD4 = 7'b1111110;
                        default:
                            SSD4 = 7'b1111111;
                    endcase
                    SSD5 = 7'b1111111;
                    SSD6 = 7'b1111111;
                    SSD7 = 7'b1111111;
                end
             else if (current_state == HIT_B)
             begin 
             SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD3 = 7'b1111111;
                    case (YB)           
                        3'b000: SSD4 = 7'b0000001;
                        3'b001: SSD4 = 7'b1001111;
                        3'b010: SSD4 = 7'b0010010;
                        3'b011: SSD4 = 7'b0000110;
                        3'b100: SSD4 = 7'b1001100;
                        3'b101: SSD4 = 7'b1111110;
                        3'b110: SSD4 = 7'b1111110;
                        3'b111: SSD4 = 7'b1111110;
                        default:
                            SSD4 = 7'b1111111;
                    endcase
                    SSD5 = 7'b1111111;
                    SSD6 = 7'b1111111;
                    SSD7 = 7'b1111111;
             end
             
             else if(current_state == GOAL_A)
             begin 
                 //SCORE DISPLAY
                 SSD4 = 7'b1111111;
                 SSD1 = 7'b1111110;
                case (score_A)
                    2'b00: SSD2 = 7'b0000001;
                    2'b01: SSD2 = 7'b1001111;
                    2'b10: SSD2 = 7'b0010010;
                    2'b11: SSD2 = 7'b0000110;
                    default:
                        SSD2 = 7'b1111111;
                endcase
                
                case (score_B)
                    2'b00: SSD0 = 7'b0000001;
                    2'b01: SSD0 = 7'b1001111;
                    2'b10: SSD0 = 7'b0010010;
                    2'b11: SSD0 = 7'b0000110;
                    default:
                        SSD0 = 7'b1111111;
                endcase
             end
             
             else if (current_state == GOAL_B)
             begin
                 //SCORE DISPLAY
                 SSD4 = 7'b1111111;
                 SSD1 = 7'b1111110;
                case (score_A)
                    2'b00: SSD2 = 7'b0000001;
                    2'b01: SSD2 = 7'b1001111;
                    2'b10: SSD2 = 7'b0010010;
                    2'b11: SSD2 = 7'b0000110;
                    default:
                        SSD2 = 7'b1111111;
                endcase
                
                case (score_B)
                    2'b00: SSD0 = 7'b0000001;
                    2'b01: SSD0 = 7'b1001111;
                    2'b10: SSD0 = 7'b0010010;
                    2'b11: SSD0 = 7'b0000110;
                    default:
                        SSD0 = 7'b1111111;
                endcase
             end
             
             else if (current_state == END_GAME)
             begin
                if (score_A == 3)
                    begin
                        SSD4 = 7'b0001000;
                    end
                else
                    begin
                        SSD4 = 7'b1100000;
                    end
                
                case (score_A)
                    2'b00: SSD2 = 7'b0000001;
                    2'b01: SSD2 = 7'b1001111;
                    2'b10: SSD2 = 7'b0010010;
                    2'b11: SSD2 = 7'b0000110;
                    default:
                        SSD2 = 7'b1111111;
                endcase
                
                case (score_B)
                    2'b00: SSD0 = 7'b0000001;
                    2'b01: SSD0 = 7'b1001111;
                    2'b10: SSD0 = 7'b0010010;
                    2'b11: SSD0 = 7'b0000110;
                    default:
                        SSD0 = 7'b1111111;
                endcase
             end
             
       
    end

    //for LEDs
    always @ (*)
        begin
        
            if(current_state == IDLE)
                begin            
                    LEDA = 1'b1;
                    LEDB = 1'b1; 
                    LEDX = 5'b00000;
                end
            else if (current_state == DISP)
            begin 
                LEDA = 1'b0;
                LEDB = 1'b0; 
                LEDX = 5'b11111;
            end
            else if (current_state == GOAL_A)
                begin
                    LEDX = 5'b11111;
                    LEDA = 1'b0;
                    LEDB = 1'b0;
                end
            else if (current_state == GOAL_B)
                begin
                    LEDX = 5'b11111;
                    LEDA = 1'b0;
                    LEDB = 1'b0;
                end
                
            else if (current_state == HIT_A )
                begin
                    LEDX = 5'b00000;
                    LEDA = 1'b1;
                    LEDB = 1'b0;
                end
                
            else if (current_state == RESP_A)
                begin
                    LEDA = 1'b1;
                    LEDB = 1'b0;
                    LEDX = 5'b10000;
                end

            else if (current_state == HIT_B)
                begin
                    LEDX = 5'b00000;
                    LEDA = 1'b0;
                    LEDB = 1'b1;
                end  
            else if (current_state == RESP_B)
                begin
                    LEDA = 1'b0;
                    LEDB = 1'b1;
                    LEDX = 5'b00001;
                end           
             
            else if (current_state == SEND_A || current_state == SEND_B)
                begin 
                    LEDA = 1'b0;
                    LEDB = 1'b0;
                    case (X_COORD)
                        3'b000: LEDX = 5'b10000;
                        3'b001: LEDX = 5'b01000;
                        3'b010: LEDX = 5'b00100;
                        3'b011: LEDX = 5'b00010;
                        3'b100: LEDX = 5'b00001;
                        default:
                            LEDX = 5'b00000;
                    endcase
                end
                
            else if (current_state == END_GAME)
            begin 
                if (timer < 100)
                    begin
                        LEDX = 5'b10101; 
                    end
                else
                    begin
                       LEDX = 5'b01010;
                    end
            
            end
       end
endmodule
