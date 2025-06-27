module traffic_light (
	input clk,
	input reset_n,
	input Ta, Tb,

	output reg [2:0] La,
	output reg [2:0] Lb
);

	reg [4:0]  counter_sec;
	reg        counter_reset;
	
	localparam S0 = 0; //La green, Lb red
	localparam S1 = 1; //La yellow, Lb red
	localparam S2 = 2; //La red, Lb green
	localparam S3 = 3; //La red, Lb yellow
	localparam GREEN = 3'b101;
	localparam YELLOW = 3'b001;
	localparam RED = 3'b011;
	
	reg [1:0] current_state;
	reg [1:0] next_state;

	
//----------------counter--------------------
	
	always @(posedge clk, negedge reset_n)
	begin 
		if (~reset_n)
			counter_sec <= 4;
		else
		begin
			if (counter_reset)
				counter_sec <= 4;
			else
				counter_sec <= counter_sec - 1;
		end
	end
	
	
//-----------------register------------------
	
	always @(posedge clk, negedge reset_n)
	begin 
		if (~reset_n)
			current_state <= S0;
		else 
			current_state <= next_state;
	end
	
	
//--------- current_state -> next_state ----------
	
	always @*
	begin 
		case (current_state)
			S0:
				if(~Ta)
					next_state = S1;
				else
					next_state = S0;
			S1:
				if(counter_sec == 0)
					next_state = S2;
				else
					next_state = S1;
			S2:
				if(~Tb)
					next_state = S3;
				else
					next_state = S2;
			S3:
				if(counter_sec == 0)
					next_state = S0;
				else
					next_state = S3;
			default: next_state = S0;
		endcase
	end
	

//---------- current_state -> output ---------------

	always @*
	begin
		case (current_state)
			S0:
			begin
				{La, Lb} = {GREEN, RED};
				if (~Ta)
					counter_reset = 1;
				
			end
			S1:
			begin 
				{La, Lb} = {YELLOW, RED};
				if (counter_sec == 0)
					counter_reset = 1;
				else
					counter_reset = 0;
				
			end
			S2:
			begin
				{La, Lb} = {RED, GREEN};
				if (~Tb)
					counter_reset = 1;
				
			end
			S3:
			begin
				{La, Lb} = {RED, YELLOW};
				if (counter_sec == 0)
					counter_reset = 1;
				else
					counter_reset = 0;
				
			end
			default:
				{La, Lb} = 0;
		endcase
	end

endmodule
	
	
	
