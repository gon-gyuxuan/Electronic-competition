`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:31:01 07/23/2012 
// Design Name: 
// Module Name:    tlv_5638 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module tlv_5638(clk_50,rst,
					data,ab,
					cs_n,dout,sclk,
					done);
	input clk_50,rst;
	input [11:0]data;
	input ab;		// 1 ʱдA, 0 ʱдB
	
	output cs_n,dout,sclk;
	reg cs_n,dout,sclk;
	
	output reg done;
	
	reg [4:0]timer;
	always @(posedge clk_50)
		if(rst)
			timer <= 1'b0;
		else if(timer < 24)
			timer <= timer + 1'b1;
		else begin
			timer <= 1'b0;
			sclk <= ~sclk;
		end
		
/////
	wire ab_edge;
	reg n;
	always @(posedge sclk)
		n <= ab;
	
	assign ab_edge = n ^ ab;
	
	reg [1:0]state;
	//reg [1:0]n_s;
	parameter	set0 = 2'd0,
					ready = 2'd1,
					write = 2'd2;
	reg [4:0]cnt;
	reg [15:0]dat_o;
	//reg []
	always @(posedge sclk)
		if(rst || ab_edge)
		begin
			state <= set0;
			cnt <= 5'd16;
			cs_n <= 1'b1;
		end
		else begin
			case(state)
			set0	:	begin
							dat_o <= 16'hD002;		//set reference voltage to 2.048v
							//dat_o <= 16'hD000;		//set regerence voltage to external
							cnt <= 5'd16;
							//cs_n <= 1'b0;
							state <= write;
						end

			ready	:	begin
							dat_o[15:12] <= ab ? 4'd12 : 4'd4;
							dat_o[11:0] <= data;
							cnt <= 5'd16;
							done <= 1'b0;
							state <= write;
							//cs_n <= 1'b0;
						end
			
			write	:	begin
							cs_n <= 1'b0;
							dout <= dat_o[15];
							dat_o <= dat_o << 1'b1;
							cnt <= cnt - 1'b1;
							if(cnt == 1'b0)
							begin
								cs_n <= 1'b1;
								done <= 1'b1;
								state <= ready;
							end
						end
			default	:	state <= set0;
			endcase
		end

endmodule
