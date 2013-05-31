/* 
The eight binary switches are used to take value into the eight bits 
of the registers in the meory module. The toggle switches are used to 
reset, execute, insert, respectively.
*/

module main	(	input clk,
			input s1, s2, s3,
			input b1, b2, b3, b4, b5, b6, b7, b8,
 			output wire [6:0] led,
			output wire d1, d2, d3, d4);

//General initialisations
reg [127:0] chk;				//For taking the input of the toggle switches
reg [7:0] state;				//To denote state of FSM
reg [7:0] ret_state;				//Return state
reg [7:0] disp;					//Whatever the register contains, the display module displays it
reg [7:0] count;				//Very imp.
wire [7:0] binary_input;

//Memory module initialisations
reg [5:0] sys_adrs;
reg [5:0] prgm_adrs;
reg sys_mode;
reg prgm_mode;
reg sys_erase;
reg prgm_erase;
reg [7:0] sys_data;
reg [7:0] prgm_data;
wire [7:0] sys_out;
wire [7:0] prgm_out;

//Control registers
reg [5:0] pc;


//wire assigns
assign binary_input[0] = b8;
assign binary_input[1] = b7;
assign binary_input[2] = b6;
assign binary_input[3] = b5;
assign binary_input[4] = b4;
assign binary_input[5] = b3;
assign binary_input[6] = b2;
assign binary_input[7] = b1;


initial begin
/*Some initialisations*/
state = 0;
disp = 0;
sys_mode = 0;
prgm_mode = 0;
sys_erase = 0;
prgm_erase = 0;
pc = 0;
end


sys_mem m1(.adrs(sys_adrs), .erase(sys_erase), .mode(sys_mode), .data(sys_data), .out(sys_out), .clk(clk));
prgm_mem m2(.adrs(prgm_adrs), .erase(prgm_erase), .mode(prgm_mode), .data(prgm_data), .out(prgm_out), .clk(clk));
display disp1(.inp(disp), .clk(clk), .led(led), .d1(d1), .d2(d2), .d3(d3), .d4(d4));


always @(posedge clk)					
begin
	//To help get the inputs of the toggle switches
	chk <= chk<<1;				//Corressponds to the input switch 3
	chk[0] <= s3;
end

always @(posedge clk)
begin
	if (s1==1)	begin
		prgm_erase = 1;
		state = 0;
		disp = 0;
		prgm_mode = 0;
		sys_mode = 0;
		pc = 0;
	end

	case(state)
	0: begin
		prgm_erase = 0;
		if (chk==1)	begin
			count = 0;
			state = 6;
		end
		if (s2 == 1)	begin
			count = 0;
			pc = 0;
			state = 1;
		end
	end

	1: begin				//Execute state

	end
	2: begin				//Program Read state
		
	end
	3: begin				//Program Write state
		prgm_mode = 1;
		if (count==5)	begin
			prgm_mode = 0;
			count = 0;
			state = ret_state;
		end
	end
	4: begin				//System Read state
	
	end
	5: begin				//System Write state
		sys_mode = 1;
		if (count==5)	begin
			sys_mode = 0;
			count = 0;
			state = ret_state;
		end
	end

	6: begin				//Program input state
		prgm_data = binary_input;
		prgm_adrs = pc;
		pc = pc+1;
		ret_state = 0;
		count = 0;
		state = 3;
	end

	
	


	endcase
	
	count = count+1;
end

endmodule
