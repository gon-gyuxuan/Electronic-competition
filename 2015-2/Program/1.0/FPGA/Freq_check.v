/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/6/21
* Function:				通过等精度测频法，测量频率。并将所测的频率传到Uart发送模块
* 
* ==================================================================*/

module Freq_check(
	
	input wire 			clk,	
	input	wire			rst_n,
	input wire 			One_Signal_in,
	input wire  		Two_Signal_in,
	
	output reg	[31:0] One_TestSignal_num,		//A路信号在闸门时间内的个数
	output reg  [31:0] Two_TestSignal_num,		//B路信号在闸门时间内的个数
	output reg  [31:0] StandSignal_num			//标准信号在闸门时间内的个数

);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================




//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 预设闸门模块 ****************************/
	//由标准时钟产生预置闸门1hz
	reg [31:0] Standcount;
	reg 		  pre_gate;
	reg        gate_buf;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		Standcount <= 32'd0;
	else if(Standcount == 32'd24_999_999) begin 
		gate_buf <= ~gate_buf;
		pre_gate <= gate_buf;
		Standcount 	<= 1'd0;
	end 
	else begin 
		Standcount <= Standcount + 1'd1;
	end 

	
	
	/************************* 计数 模块 ****************************/
	reg gate_out;
	reg [31:0] TestCount;
	reg [31:0] r_StandSignal_num;
	reg [31:0] r_One_TestSignal_num;
	reg [31:0] r_Two_TestSignal_num;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		gate_out <= 1'b0;
	else begin 
		if(pre_gate == 1'b1 && gate_out == 1'b0) begin 
			gate_out <= 1'b1;
		end 
		else if(pre_gate == 1'b1 && gate_out == 1'b1) begin 
			TestCount <= TestCount + 16'b1;
			r_StandSignal_num <= TestCount;		//标准信号在闸门时间内的计数
		end
		else if(pre_gate == 1'b0 && gate_out == 1'b1) begin 
			gate_out <= 1'b0;
			StandSignal_num <= r_StandSignal_num;
		end
		else 
			TestCount <= 16'b0;
	end

	/************************* A路信号计数模块 ****************************/
	reg 		  flag1_a,flag2_a;
	reg [31:0] One_Signal_in_num;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		flag1_a <= 1'b0;
		flag2_a <= 1'b0;
	end 
	else begin   //对输入信号进行计数
			flag1_a <= One_Signal_in;
			flag2_a <= flag1_a;	
	end 	
	
	assign nedege_a = ~flag2_a & flag1_a;	//提取输入信号的下降沿
	
	//测量输入信号的个数
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		One_Signal_in_num <= 16'd0;
	end
	else if(pre_gate) begin 
		if(nedege_a) begin 
			One_Signal_in_num <= One_Signal_in_num + 1'b1;
			r_One_TestSignal_num <= One_Signal_in_num;
		end 
	end
	else begin	
		One_Signal_in_num <= 32'd0;
		One_TestSignal_num <= r_One_TestSignal_num;		//标准信号在闸门时间内的计数
	end 
	
	
	/************************* B路信号计数模块 ****************************/
	reg 		  flag1_b,flag2_b;
	reg [31:0] Two_Signal_in_num;

	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		flag1_b <= 1'b0;
		flag2_b <= 1'b0;
	end 
	else begin   //对输入信号进行计数
			flag1_b <= Two_Signal_in;
			flag2_b <= flag1_b;	
	end 	
	
	assign nedege_b = ~flag2_b & flag1_b;	//提取输入信号的下降沿
	
	//测量输入信号的个数
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		Two_Signal_in_num <= 16'd0;
	end
	else if(pre_gate) begin 
		if(nedege_b) begin 
			Two_Signal_in_num <= Two_Signal_in_num + 1'b1;
			r_Two_TestSignal_num <= Two_Signal_in_num;
		end 
	end
	else begin	
		Two_Signal_in_num <= 32'd0;
		Two_TestSignal_num <= r_Two_TestSignal_num;		//标准信号在闸门时间内的计数
	end 
		


endmodule
