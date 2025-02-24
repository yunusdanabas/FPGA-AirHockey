module hockey_tb();


parameter HP = 5;       // Half period of our clock signal
parameter FP = (2*HP);  // Full period of our clock signal
parameter FFP = (3*FP);

reg clk, rst, BTN_A, BTN_B;
reg [1:0] DIR_A;
reg [1:0] DIR_B;
reg [2:0] Y_in_A;
reg [2:0] Y_in_B;

wire [2:0] X_COORD, Y_COORD;

// Our design-under-test is the DigiHockey module
hockey dut(clk, rst, BTN_A, BTN_B, DIR_A, DIR_B, Y_in_A, Y_in_B, X_COORD,Y_COORD);

// This always statement automatically cycles between clock high and clock low in HP (Half Period) time. Makes writing test-benches easier.
always #HP clk = ~clk;

initial begin
	$dumpfile("hockey.vcd"); 
	$dumpvars(0, hockey_tb); // Dump signals for tracing
    $display("Simulation started.");

    clk = 0; 
    rst = 0;
    BTN_A = 0;
	BTN_B = 0;
	DIR_A = 0;
	DIR_B = 0;
    Y_in_A = 0;
    Y_in_B = 0;
    
	#FP;
	rst=1;
	#FP;
	rst=0;

	// First Hit A - Starts
	
	BTN_A = 1;
	#FP;
	BTN_A = 0;

	#FP;
	Y_in_A = 1;
	DIR_A = 1;
	BTN_A = 1;
	#FP;
	BTN_A = 0;
	#FFP;

	// B couldnt Hit A:1 - B:0
	
	Y_in_B = 2;
	DIR_B = 0;
	BTN_B = 1;
	#FP;
	BTN_B = 0;
	#FFP;

	// Second Hit - B Starts
	
	Y_in_B = 2;
	DIR_B = 0;
	BTN_B = 1;
	#FP;
	BTN_B = 0;
	
	#FFP;
	Y_in_A = 1;
	DIR_A = 2;
	BTN_A = 1;
	#FP;
	BTN_A = 0;
	#FFP;
	
	// A couldnt Hit A:1 - B:1
	// Third hit - A starts 
	
	Y_in_A = 4;
	DIR_A = 2;
	BTN_A = 1;
	#FP;
	BTN_A = 0;
	#FFP;
	
	
	Y_in_B = 3;
	DIR_B = 0;
	BTN_B = 1;
	#FP;
	BTN_B = 0;
	#FFP;
	
	// B couldnt Hit A:2 - B:1
	// Fourth Hit - B Starts
	
	Y_in_B = 1;
	DIR_B = 2;
	BTN_B = 1;
	#FP;
	BTN_B = 0;
	#FFP;
	
	
	Y_in_A = 3;
	DIR_A = 0;
	BTN_A = 1;
	#FP;
	BTN_A = 0;
	#FFP;
	
	
	Y_in_B = 3;
	DIR_B = 1;
	BTN_B = 1;
	#FP;
	BTN_B = 0;
	#FFP;
	
	
	Y_in_A = 1;
	DIR_A = 2;
	BTN_A = 1;
	#FP;
	BTN_A = 0;
	#FFP;
	
	
	Y_in_B = 2;
	DIR_B = 0;
	BTN_B = 1;
	#FP;
	BTN_B = 0;
	#FFP;
	#FFP;
	#FFP;
	#FFP;

	
	
	rst = 1;
	#FP
	rst= 0;
	$display("Simulation finished.");
	$finish();
end



endmodule