`timescale 1s/1ms

module traffic_light_tb();
	reg clk;
	reg reset_n;
	reg Ta;
	reg Tb;

	wire [2:0]La;
	wire [2:0]Lb;

	traffic_light uut(
		.clk(clk),
		.reset_n(reset_n),
		.Ta(Ta),
		.Tb(Tb),
		.La(La),
		.Lb(Lb)
	);

	always
	begin
		#0.5 clk = ~clk;
	end
	
	initial begin
		clk = 1; 
		reset_n = 0;
		Ta = 1;
		Tb = 1;
		#1;
		reset_n = 1;
		#4;
		Ta = 0;
		#10;
		Tb = 0; Ta = 1;
		#10;
		Ta = 0; Tb = 1;
		#2
		reset_n = 0;
		#5;
		reset_n = 1;
		#1;
	end
endmodule
