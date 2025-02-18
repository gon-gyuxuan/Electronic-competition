/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/6/22
* Function:				测量被测时钟的占空比，并将测得的信息传送到Uart发送端
* 
* ==================================================================*/

module Duty_Cycle(
	
	input wire 		clk,	
	input	wire		rst_n,
	
	input wire 		One_Signal_in,  //A路信号输入
	input wire		Two_Signal_in,   //B路信号输入
			
	output reg [31:0] Single_Time_interval_a,  //A路信号1000个波峰时间总长
	output wire [31:0] Whole_Time_interval_a,   //A路信号周期总长
	output reg [31:0] Single_Time_interval_b,  //b路信号1000个波峰的时间总长
	output wire [31:0] Whole_Time_interval_b    //b路信号1000个周期总长
);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================



//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 上升沿&下降沿检测 ****************************/
	//采集A路信号的上升沿与下降沿
	reg One_flag1;
	reg One_flag2;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		One_flag1 <= 1'b0;
		One_flag2 <= 1'b0;
	end 
	else begin 
		One_flag1 <= One_Signal_in;
		One_flag2 <= One_flag1;
	end 
	
	assign One_Rising_edge = (~One_flag1) & One_flag2;
	assign One_falling_edge = One_flag1 & (~One_flag2);
	
	
	//采集B路信号的上升沿与下降沿
	reg Two_flag1;
	reg Two_flag2;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		Two_flag1 <= 1'b0;
		Two_flag2 <= 1'b0;
	end 
	else begin 
		Two_flag1 <= Two_Signal_in;
		Two_flag2 <= Two_flag1;
	end 
	
	assign Two_Rising_edge = (~Two_flag1) & Two_flag2;
	assign Two_falling_edge = Two_flag1 & (~Two_flag2);
	
	
	
	/************************* 计数器1 ****************************/
	//计算A路信号的波峰时间总长
	
	reg [9:0] SignalCount_a ;	//计算上升沿的个数，到达1000个上升沿停止
	reg [31:0] Numcount_a;		//上升沿开始计数，下降沿停止计数
	reg [31:0] r_Single_TimePeriod_a;	//计算1000个混合信号的周期总长
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		SignalCount_a <= 10'd0;
		r_Single_TimePeriod_a  <= 32'd0;
		Numcount_a		<= 32'd0;
	end 
	else begin  
		if(One_Rising_edge) begin 
			SignalCount_a <= SignalCount_a + 1'b1;
			if(SignalCount_a == 10'd1000) begin 
				SignalCount_a <= 10'd0;
				Single_Time_interval_a <= r_Single_TimePeriod_a;
				r_Single_TimePeriod_a <= 10'd0;
			end 
		end 
		else if(One_Signal_in) begin 
			Numcount_a <= Numcount_a + 1'b1;
			if(One_falling_edge) begin 
				r_Single_TimePeriod_a <= r_Single_TimePeriod_a + Numcount_a;
				Numcount_a <= 32'd0;
			end 
		end 
	end 
	
	
	//计算A路信号的周期长度
	
	reg [9:0] count_TimePeriod_a;
	reg [31:0] count_wait_TimePeriod_a;
	reg [31:0] TimePeriod_a;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		TimePeriod_a <= 32'd0;
	else if(One_Rising_edge) begin 
		count_TimePeriod_a <= count_TimePeriod_a + 32'd1;
		if(count_TimePeriod_a == 10'd1000) begin
			TimePeriod_a <= count_wait_TimePeriod_a;
			count_TimePeriod_a <= 10'd1;
			count_wait_TimePeriod_a <= 32'd0;
		end 
	end 
	else begin 
		if(count_TimePeriod_a)
			count_wait_TimePeriod_a <= count_wait_TimePeriod_a + 32'd1;
		end 

	assign Whole_Time_interval_a = TimePeriod_a;		//A路信号周期总长
	
	
	/************************* 计数器2 ****************************/
	//计算B路信号的波峰时间总长
	
	reg [9:0] SignalCount_b ;	//计算上升沿的个数，到达1000个上升沿停止
	reg [31:0] Numcount_b;		//上升沿开始计数，下降沿停止计数
	reg [31:0] r_Single_TimePeriod_b;	//计算1000个混合信号的周期总长
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		SignalCount_b <= 10'd0;
		r_Single_TimePeriod_b  <= 32'd0;
		Numcount_b		<= 32'd0;
	end 
	else begin  
		if(Two_Rising_edge) begin 
			SignalCount_b <= SignalCount_b + 1'b1;
			if(SignalCount_b == 10'd1000) begin 
				SignalCount_b <= 10'd0;
				Single_Time_interval_b <= r_Single_TimePeriod_b;
				r_Single_TimePeriod_b <= 10'd0;
			end 
		end 
		else if(Two_Signal_in) begin 
			Numcount_b <= Numcount_b + 1'b1;
			if(Two_falling_edge) begin 
				r_Single_TimePeriod_b <= r_Single_TimePeriod_b + Numcount_b;
				Numcount_b <= 32'd0;
			end 
		end 
	end 
	
	
	//计算B路信号的周期长度
	
	reg [9:0] count_TimePeriod_b;
	reg [31:0] count_wait_TimePeriod_b;
	reg [31:0] TimePeriod_b;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		TimePeriod_b <= 32'd0;
	else if(Two_Rising_edge) begin 
		count_TimePeriod_b <= count_TimePeriod_b + 32'd1;
		if(count_TimePeriod_b == 10'd1000) begin
			TimePeriod_b <= count_wait_TimePeriod_b;
			count_TimePeriod_b <= 10'd1;
			count_wait_TimePeriod_b <= 32'd0;
		end 
	end 
	else begin 
		if(count_TimePeriod_b)
			count_wait_TimePeriod_b <= count_wait_TimePeriod_b + 32'd1;
		end 

	assign Whole_Time_interval_b = TimePeriod_b;		//A路信号周期总长

endmodule

