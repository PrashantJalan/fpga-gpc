/* 
The eight binary switches are used to take value into the eight bits 
of the registers in the meory module. The toggle switches are used to 
reset, execute, insert, respectively.
*/

module main	(	input clk,
			input s1, s2, s3, s4,
			input b1, b2, b3, b4, b5, b6, b7, b8,
 			output wire [6:0] led,
			output wire d1, d2, d3, d4,
			output wire [7:0] s_led);

//General initialisations
reg [127:0] chk2, chk3, chk4;			//For taking the input of the toggle switches
reg [7:0] state;				//To denote state of FSM
reg [7:0] ret_state;				//Return state
reg [7:0] oper_state;				//Operation state
reg [7:0] disp;					//Whatever the register contains, the display module displays it
reg [7:0] count;				//Very imp.
wire [7:0] binary_input;
wire [3:0] opcode;
wire [5:0] r0,r1,r2,r3;
wire [5:0] ra,rb;
wire [7:0] val;
reg busy, pc_disp;				//For the display module

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

//Add substract module initialisations
reg addsub;
reg [7:0] op1;
reg [7:0] op2;
wire [7:0] out_addsub;

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
assign opcode = prgm_out[7:4];
assign r0 = 0;
assign r1 = 1;
assign r2 = 2;
assign r3 = 3;
assign ra = prgm_out[3:2];
assign rb = prgm_out[1:0];
assign val = prgm_out[1:0];


initial begin
/*Some initialisations*/
state = 0;
disp = 0;
sys_mode = 0;
prgm_mode = 0;
sys_erase = 0;
prgm_erase = 0;
pc = 0;
busy = 0;
pc_disp = 0;
addsub = 0;
end


sys_mem m1(.adrs(sys_adrs), .erase(sys_erase), .mode(sys_mode), .data(sys_data), .out(sys_out), .clk(clk));
prgm_mem m2(.adrs(prgm_adrs), .erase(prgm_erase), .mode(prgm_mode), .data(prgm_data), .out(prgm_out), .clk(clk));
add_sub as1(.clk(clk), .oper(addsub), .a(op1), .b(op2), .out(out_addsub));
display disp1(.inp(disp), .clk(clk), .busy(busy), .pc_disp(pc_disp), .led(led), .d1(d1), .d2(d2), .d3(d3), .d4(d4), .s_led(s_led));


always @(posedge clk)					
begin
	//To help get the inputs of the toggle switches
	chk4 <= chk4<<1;				//Corressponds to the input switch 3
	chk4[0] <= s4;
	chk3 <= chk3<<1;				//Corressponds to the input switch 3
	chk3[0] <= s3;
	chk2 <= chk2<<1;				//Corressponds to the input switch 3
	chk2[0] <= s2;
end

always @(posedge clk)
begin
	if (s1==1)	begin
		prgm_erase = 1;
		state = 0;
		disp = 0;
		busy = 0;
		pc_disp = 0;
		prgm_mode = 0;
		sys_mode = 0;
		pc = 0;
	end

	case(state)
	0: begin
		if (chk3==1)	begin			//Insert
			prgm_erase = 0;
			disp = pc;
			busy = 0;
			pc_disp = 1;
			count = 0;
			state = 5;
		end
		if (chk2==1)	begin			//Execute
			prgm_erase = 0;
			busy = 1;
			pc_disp = 0;
			disp = 0;
			count = 0;
			pc = 0;
			state = 1;
		end
		if (chk4==1)	begin			//Forward
			prgm_erase = 0;
			disp = pc;
			busy = 0;
			pc_disp = 1;
			pc = pc+1;
		end
	end

	1: begin				//Execute state
		prgm_adrs = pc;
		ret_state = 6;
		pc = pc+1;
		count = 0;
		state = 2;
	end
	2: begin				//Read state
		if (count==2)	begin
			count = 0;
			state = ret_state;
		end
	end
	3: begin				//Program Write state
		prgm_mode = 1;
		if (count==3)	begin
			prgm_mode = 0;
			count = 0;
			state = ret_state;
		end
	end
	4: begin				//System Write state
		sys_mode = 1;
		if (count==3)	begin
			sys_mode = 0;
			count = 0;
			state = ret_state;
		end
	end

	5: begin				//Program input state
		prgm_data = binary_input;
		prgm_adrs = pc;
		pc = pc+1;
		ret_state = 0;
		count = 0;
		state = 3;
	end
	
	6: begin				//Checking the opcode state
		if (opcode==0)	begin
			if (prgm_out==0)	begin	//No operation
				count = 0;
				state = 1;
			end
			if (prgm_out==1)	begin	//Input
				sys_data = binary_input;
				sys_adrs = r0;
				ret_state = 1;
				count = 0;
				state = 4;
			end
			if (prgm_out==2)	begin	//Output
				sys_adrs = r0;
				ret_state = 11;
				count = 0;
				state = 2;	
			end
			if (prgm_out==3)	begin	//Sleep
				count = 0;
				state = 1;
			end
			if (prgm_out==15)	begin	//Halt
				count = 0;
				pc = 0;
				state = 0;
			end
									
		end
		if (opcode==1)	begin		//add ra + rb	
			addsub = 0;
			count = 0;
			oper_state = 10;
			state = 7;
		end
	end
	7: begin					//Reads ra and rb to store in op1 and op2
		sys_adrs = ra;
		ret_state = 8;
		count = 0;
		state = 2;
	end
	8: begin
		op1 = sys_out;
		sys_adrs = rb;
		ret_state = 9;
		count = 0;
		state = 2;
	end
	9: begin
		op2 = sys_out;
		count = 0;
		state = oper_state;
	end
	10: begin					//Sum ra + rb
		sys_data = out_addsub;
		sys_adrs = r0;
		ret_state = 1;
		count = 0;
		state = 4;	
	end
	11: begin
		disp = sys_out;
		count = 0;
		state = 1;
	end

	endcase
	
	count = count+1;
end

endmodule
