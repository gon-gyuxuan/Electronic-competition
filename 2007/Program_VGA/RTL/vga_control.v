/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/
* Function:				VGA控制部分
* 
* ==================================================================*/

module vga_control(
	
	input wire 				clk,	
	input	wire				rst_n,
	
	input wire [1:0]		key_state1,
	input wire [1:0] 		key_state2,
	input wire [7:0]		vga_data,
	
	input wire [9:0]		ad_level,	//触发电平
	input wire [31:0]     freq,				//频率
	input wire [9:0]		fuzhi,
	
	input wire [9:0] 		hx,		//vga的行坐标和列坐标
	input wire [9:0] 		vy,
	output wire [23:0] 	RGB

);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	parameter F1 = 104857;
	
	

//====================================================================
// ************************* Main Code *************************
//====================================================================

	/**************************************** 背景显示 ************************************************/ 	
	//定义坐标轴显示的位置以及颜色
	wire vgalive;
	
	assign vgalive = (vy >= 10'd200 && vy <= 10'd456) && (hx <= 10'd300 && hx >= 10'd100);
	
	
	//显示虚线的坐标轴
	wire z1 = vgalive && (hx%7'd20 == 1'b0 || hx == 1'b1) && vy%2'd3 == 1'b0;
	wire z2 = vgalive && ((vy - 7'd200)%7'd32 == 1'b0) && hx%2'd3 == 1'b0;
	
	
	/**************************************** 显示地址 ************************************************/
	//“数字示波器”显示地址
	wire tile_area1 = (vy >= 10'd10 && vy <= 10'd73) && (hx >= 10'd240   &&  hx <= 10'd303);//数
	wire tile_area2 = (vy >= 10'd10 && vy <= 10'd73) && (hx >= 10'd304   &&  hx <= 10'd367);//字
	wire tile_area3 = (vy >= 10'd10 && vy <= 10'd73) && (hx >= 10'd368   &&  hx <= 10'd431);//示
	wire tile_area4 = (vy >= 10'd10 && vy <= 10'd73) && (hx >= 10'd432   &&  hx <= 10'd495);//波
	wire tile_area5 = (vy >= 10'd10 && vy <= 10'd73) && (hx >= 10'd496   &&  hx <= 10'd559);//器
	
	//“垂直灵敏度”显示地址
	wire vertical_sensitivity_area1  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd350  &&  hx <= 10'd382 );
	wire vertical_sensitivity_area2  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd382  &&  hx <= 10'd414);//冒号
	wire vertical_sensitivity_area3  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd414  &&  hx <= 10'd446);//25 000 000
	wire vertical_sensitivity_area4  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd446  &&  hx <= 10'd478);
	wire vertical_sensitivity_area5  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd478  &&  hx <= 10'd510);
	
	
	//“扫描速度”显示地址
	wire scan_speed_area1  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd350   &&  hx <= 10'd382 );
	wire scan_speed_area2  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd382   &&  hx <= 10'd414);//冒号
	wire scan_speed_area3  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd414   &&  hx <= 10'd446);//25 000 000
	wire scan_speed_area4  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd446   &&  hx <= 10'd478);
	
	//“触发电平”显示地址
	wire trigger_level_area1  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd350  &&  hx <= 10'd382 );
	wire trigger_level_area2  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd382  &&  hx <= 10'd414);//冒号
	wire trigger_level_area3  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd414  &&  hx <= 10'd446);//25 000 000
	wire trigger_level_area4  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd446  &&  hx <= 10'd478);
	

	//“频率”显示地址
	wire r_freq_area1  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd382  &&  hx <= 10'd414);//25 000 000
	wire r_freq_area2  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd414  &&  hx <= 10'd446);
	
	//“幅值”显示地址
	wire level_area1  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd382  &&  hx <= 10'd414);//25 000 000
	wire level_area2  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd414  &&  hx <= 10'd446);
	
	//“幅值”数字显示地址
	wire a2_1_1  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd558  &&  hx <= 10'd574); // 
	wire a2_1_2  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd574  &&  hx <= 10'd590);//
	wire a2_1_3  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd590  &&  hx <= 10'd606);
	wire a2_1_4  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd606  &&  hx <= 10'd622);
	wire a2_1_5  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd622  &&  hx <= 10'd638);
	wire a2_1_6  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd638  &&  hx <= 10'd654);
	wire a2_1_7  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd654  &&  hx <= 10'd670);
	wire a2_1_8  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd670  &&  hx <= 10'd686);//
	
	//“幅值”单位显示
	wire symbol3  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd702  &&  hx <= 10'd718);// m
	wire symbol4  =  (vy >= 10'd400 && vy <= 10'd431) && (hx >= 10'd718  &&  hx <= 10'd734);// v
	
	//“频率”数字显示地址
	wire f2_1_1  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd558  &&  hx <= 10'd574); // 
	wire f2_1_2  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd574  &&  hx <= 10'd590);//
	wire f2_1_3  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd590  &&  hx <= 10'd606);
	wire f2_1_4  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd606  &&  hx <= 10'd622);
	wire f2_1_5  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd622  &&  hx <= 10'd638);
	wire f2_1_6  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd638  &&  hx <= 10'd654);
	wire f2_1_7  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd654  &&  hx <= 10'd670);
	wire f2_1_8  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd670  &&  hx <= 10'd686);//
	
	//“频率”单位显示
	wire symbol1  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd702  &&  hx <= 10'd718);// h
	wire symbol2  =  (vy >= 10'd350 && vy <= 10'd381) && (hx >= 10'd718  &&  hx <= 10'd730);// z
	
	//“垂直灵敏度”档位显示  0.1mV/divmuns
	wire symbol_area1  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd542  &&  hx <= 10'd558);// 0
	wire symbol_area2  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd558  &&  hx <= 10'd574);// .
	wire symbol_area3  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd574  &&  hx <= 10'd590);///1
	wire symbol_area4  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd590  &&  hx <= 10'd606);// m
	wire symbol_area5  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd606  &&  hx <= 10'd622);// v
	
	wire symbol_area6  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd622  &&  hx <= 10'd638);// /
	wire symbol_area7  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd638  &&  hx <= 10'd654);// d
	wire symbol_area8  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd654  &&  hx <= 10'd670);// i
	wire symbol_area9  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd670  &&  hx <= 10'd686);// v
	
	//“扫描速度”档位显示
	wire r_symbol_area9 =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd542  && hx <= 10'd558);// 1
	wire symbol_area10  =  (vy >= 10'd250 && vy <= 10'd281)&& (hx >= 10'd558  &&  hx <= 10'd574);// 0
	wire symbol_area11  =  (vy >= 10'd250 && vy <= 10'd281)&& (hx >= 10'd574  &&  hx <= 10'd590);// 0
	wire symbol_area12  =  (vy >= 10'd250 && vy <= 10'd281)&& (hx >= 10'd590  &&  hx <= 10'd606);// n
	wire symbol_area13  =  (vy >= 10'd250 && vy <= 10'd281)&& (hx >= 10'd606  &&  hx <= 10'd622);// s
	
	wire symbol_area14  =  (vy >= 10'd250 && vy <= 10'd281)&& (hx >= 10'd622  &&  hx <= 10'd638);// /
	wire symbol_area15  =  (vy >= 10'd250 && vy <= 10'd281)&& (hx >= 10'd638  &&  hx <= 10'd654);// d
	wire symbol_area16  =  (vy >= 10'd250 && vy <= 10'd281)&& (hx >= 10'd654  &&  hx <= 10'd670);// i
	wire symbol_area17  =  (vy >= 10'd250 && vy <= 10'd281)&& (hx >= 10'd670  &&  hx <= 10'd686);// v
	
	
	//触发电平数据显示
	wire f1_1_1  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd558  &&  hx <= 10'd574); // 
	wire f1_1_2  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd574  &&  hx <= 10'd590);//
	wire f1_1_3  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd590  &&  hx <= 10'd606);
	wire f1_1_4  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd606  &&  hx <= 10'd622);
	wire f1_1_5  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd622  &&  hx <= 10'd638);
	wire f1_1_6  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd638  &&  hx <= 10'd654);
	wire f1_1_7  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd654  &&  hx <= 10'd670);
	wire f1_1_8  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd670  &&  hx <= 10'd686);//
	
	//“触发电平幅值”单位显示
	wire symbol5  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd702  &&  hx <= 10'd718);// m
	wire symbol6  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd718  &&  hx <= 10'd734);// v
	
	
	/**************************************** ROM访问地址 ************************************************/
	wire  [3:0] f1_1,f1_2,f1_3,f1_4,f1_5,f1_6,f1_7,f1_8;
	wire  [3:0] f2_1,f2_2,f2_3,f2_4,f2_5,f2_6,f2_7,f2_8;
	wire  [3:0] p1_1,p1_2,p1_3,p1_4,p1_5,p1_6,p1_7,p1_8;
	wire  [3:0] a2_1,a2_2,a2_3,a2_4,a2_5,a2_6,a2_7,a2_8;
	
	//触发电平的数据
	assign f1_1 = 1'b0;
	assign f1_2 = ad_level/1_000_000;
	assign f1_3 = ad_level/100_000%10;
	assign f1_4 = ad_level/10_000%10;
	assign f1_5 = ad_level/1000%10;
	assign f1_6 = ad_level/100%10;
	assign f1_7 = ad_level/10%10;
	assign f1_8 = ad_level%10;

	
	//测量的频率
	assign f2_1 = 1'b0;
	assign f2_2 = freq/1_000_000;
	assign f2_3 = freq/100_000%10;
	assign f2_4 = freq/10_000%10;
	assign f2_5 = freq/1000%10;
	assign f2_6 = freq/100%10;
	assign f2_7 = freq/10%10;
	assign f2_8 = freq%10;

	//测量的幅值
	assign a2_1 = 1'b0;
	assign a2_2 = fuzhi/1_000_000;
	assign a2_3 = fuzhi/100_000%10;
	assign a2_4 = fuzhi/10_000%10;
	assign a2_5 = fuzhi/1000%10;
	assign a2_6 = fuzhi/100%10;
	assign a2_7 = fuzhi/10%10;
	assign a2_8 = fuzhi%10;
	
	
	reg [9:0] add;
	reg [9:0] add2;
	reg [9:0] add3;
	reg [9:0] add4;
	reg [9:0] add5;
	reg [9:0] add6;
	reg [9:0] add7;
	
	always @(posedge clk or negedge rst_n)
	begin 
		if(!rst_n) begin 
			add <= 1'b0;
			add2 <= 1'b0;
			add3 <= 1'b0;
			add4 <= 1'b0;
			add5 <= 1'b0;
		end 
		//标题显示地址
		else if(tile_area1)
			add2 <= vy - 10'd10;
		else if(tile_area2)
			add2 <= vy - 10'd10 + 10'd65;
		else if(tile_area3)      
			add2 <= vy - 10'd10 + 10'd129;	
		else if(tile_area4)      
			add2 <= vy - 10'd10 + 10'd193;	
		else if(tile_area5)      
			add2 <= vy - 10'd10 + 10'd257;	

			
		//“垂直灵敏度”显示地址   
		else if(vertical_sensitivity_area1)
			add3 <= vy - 10'd200;            
		else if(vertical_sensitivity_area2)
			add3 <= vy - 10'd200 + 10'd31;   
		else if(vertical_sensitivity_area3)
			add3 <= vy - 10'd200 + 10'd63;	
		else if(vertical_sensitivity_area4)
			add3 <= vy - 10'd200 + 10'd95;	
		else if(vertical_sensitivity_area5)
			add3 <= vy - 10'd200 + 10'd127;	
	
		
		
		//“扫描速度”的显示位置
		else if(scan_speed_area1)
			add4 <= vy - 10'd250; 
		else if(scan_speed_area2)
			add4 <= vy - 10'd250 + 10'd31; 
		else if(scan_speed_area3)                       
			add4 <= vy - 10'd250 + 10'd63; 
		else if(scan_speed_area4)                       
			add4 <= vy - 10'd250 + 10'd95; 

			
		//触发电平的显示位置
		else if(trigger_level_area1)   
			add5 <= vy - 10'd300; 
		else if(trigger_level_area2)
			add5 <= vy - 10'd300 + 10'd31; 
		else if(trigger_level_area3)
			add5 <= vy - 10'd300 + 10'd63;
		else if(trigger_level_area4)
			add5 <= vy - 10'd300 + 10'd95; 
			
		//“触发电平幅值”显示
		else if(symbol5)
			add7 <= vy - 10'd300 + 10'd95; 
		else if(symbol6)
			add7 <= vy - 10'd300 + 10'd127; 
		
		
		//“频率”显示
		else if(r_freq_area1)
			add6 <= vy - 10'd350; 
		else if(r_freq_area2)
			add6 <= vy - 10'd350 + 10'd31; 
			
		//“幅值”显示
		else if(level_area1)
			add6 <= vy - 10'd400 + 10'd64; 
		else if(level_area2)
			add6 <= vy - 10'd400 + 10'd96; 

		//“频率”单位显示
		else if(symbol1)
			add7 <= vy - 10'd350 + 10'd416; 
		else if(symbol2)
			add7 <= vy - 10'd350 + 10'd448;
		
		//“幅值”单位显示
		else if(symbol3)
			add7 <= vy - 10'd400 + 10'd95; 
		else if(symbol4)
			add7 <= vy - 10'd400 + 10'd127;
			
		
		//垂直灵敏度的档位显示
		else if(symbol_area1 && key_state1 == 2'b00) 				 //0
			add7 <= vy - 10'd200; 
		else if(symbol_area2 && key_state1 == 2'b00) 				//.
			add7 <= vy - 10'd200 + 10'd31;
		else if(symbol_area3 && key_state1 == 2'b00)					//1
			add7 <= vy - 10'd200 + 10'd63;
		else if(symbol_area1 && key_state1 == 2'b01)					//2
			add <=  vy - 10'd200 + {4'd2,5'b0}; 	
		else if(symbol_area1 && key_state1 == 2'b10)					//1
			add <=  vy - 10'd200 + {4'd1,5'b0}; 
		
		else if(symbol_area4 && key_state1 == 2'b01)					//m
			add7 <= vy - 10'd200 + 10'd95;
		else if(symbol_area5)					//v
			add7 <= vy - 10'd200 + 10'd127;
		else if(symbol_area6)					///
			add7 <= vy - 10'd200 + 10'd159;	
		else if(symbol_area7)					//d
			add7 <= vy - 10'd200 + 10'd191;	
		else if(symbol_area8)					//i
			add7 <= vy - 10'd200 + 10'd223;
		else if(symbol_area9)					//v
			add7 <= vy - 10'd200 + 10'd255;
			
		//扫描速度档位显示	
		else if(r_symbol_area9 && key_state2 == 2'b00)					//2
			add <= vy - 10'd250 + {4'd2,5'b0};
		
		else if(r_symbol_area9 && key_state2 == 2'b01 )					//2
			add <= vy - 10'd250 + {4'd2,5'b0};
		else if(r_symbol_area9 && key_state2 == 2'b10 )					//1
			add <= vy - 10'd250 + {4'd1,5'b0};
		else if(symbol_area10 && key_state2 == 2'b00 )					//0
			add <= vy - 10'd250 + {4'd0,5'b0};	
		else if(symbol_area10 && key_state2 == 2'b10 )					//0
			add <= vy - 10'd250 + {4'd0,5'b0};
		else if(symbol_area11 && key_state2 == 2'b10 )					//0
			add <= vy - 10'd250 + {4'd0,5'b0};	
	
		else if(symbol_area12 && key_state2 == 2'b00)					//m
			add7 <= vy - 10'd250 + 10'd287;
		else if(symbol_area12 && key_state2 == 2'b01)					//u
			add7 <= vy - 10'd250 + 10'd319;	
		else if(symbol_area12 && key_state2 == 2'b10)					//n
			add7 <= vy - 10'd250 + 10'd351;

		else if(symbol_area13)
			add7 <= vy - 10'd250 + 10'd383;// s 	
			
		else if(symbol_area14)					///
			add7 <= vy - 10'd250 + 10'd159;	
		else if(symbol_area15)					//d
			add7 <= vy - 10'd250 + 10'd191;	
		else if(symbol_area16)					//i
			add7 <= vy - 10'd250 + 10'd223;
		else if(symbol_area17)						//v
			add7 <= vy - 10'd250 + 10'd255;
			
		//触发电平数据显示
		
		else if(f1_1_1)
			add <= vy - 10'd300 + {f1_1,5'b0}; 
		else if(f1_1_2)                       
			add <= vy - 10'd300 + {f1_2,5'b0}; 
		else if(f1_1_3)                       
			add <= vy - 10'd300 + {f1_3,5'b0}; 
		else if(f1_1_4)                       
			add <= vy - 10'd300 + {f1_4,5'b0}; 
		else if(f1_1_5)                       
			add <= vy - 10'd300 + {f1_5,5'b0}; 
		else if(f1_1_6)                       
			add <= vy - 10'd300 + {f1_6,5'b0};
		else if(f1_1_7)
			add <= vy - 10'd300 + {f1_7,5'b0};
		else if(f1_1_8)
			add <= vy - 10'd300 + {f1_8,5'b0}; 	
			
		
			
		//“频率”数字显示
		else if(f2_1_1)
			add <= vy - 10'd350 + {f2_1,5'b0}; 
		else if(f2_1_2)                       
			add <= vy - 10'd350 + {f2_2,5'b0}; 
		else if(f2_1_3)                       
			add <= vy - 10'd350 + {f2_3,5'b0}; 
		else if(f2_1_4)                       
			add <= vy - 10'd350 + {f2_4,5'b0}; 
		else if(f2_1_5)                       
			add <= vy - 10'd350 + {f2_5,5'b0}; 
		else if(f2_1_6)                       
			add <= vy - 10'd350 + {f2_6,5'b0};
		else if(f2_1_7)
			add <= vy - 10'd350 + {f2_7,5'b0};
		else if(f2_1_8)
			add <= vy - 10'd350 + {f2_8,5'b0}; 	
			
			
		//“幅值”数字显示
		else if(a2_1_1)
			add <= vy - 10'd400 + {a2_1,5'b0}; 
		else if(a2_1_2)                       
			add <= vy - 10'd400 + {a2_2,5'b0}; 
		else if(a2_1_3)                       
			add <= vy - 10'd400 + {a2_3,5'b0}; 
		else if(a2_1_4)                       
			add <= vy - 10'd400 + {a2_4,5'b0}; 
		else if(a2_1_5)                       
			add <= vy - 10'd400 + {a2_5,5'b0}; 
		else if(a2_1_6)                       
			add <= vy - 10'd400 + {a2_6,5'b0};
		else if(a2_1_7)
			add <= vy - 10'd400 + {a2_7,5'b0};
		else if(a2_1_8)
			add <= vy - 10'd400 + {a2_8,5'b0};
			
	end 
	/**************************************** 波形RAM ************************************************/
	
	
	
	
	
	/**************************************** ROM ************************************************/
	wire [15:0] q;
	wire [61:0] q2;
	wire [61:0] q3,q4,q5,q6,q7;
	wire [7:0]  qt;
	

	
	rom_title U5(				//数字示波器
		.address		(add2),
		.clock		(clk),
		.q				(q2)
	);
	
	rom_chuizhi U6(				//垂直灵敏度
		.address		(add3),
		.clock		(clk),
		.q				(q3)
	);
	
	rom_scan U7(				//扫描速度
		.address		(add4),
		.clock		(clk),
		.q				(q4)
	);
	
	rom_trigger U8(				//触发电平
		.address		(add5),
		.clock		(clk),
		.q				(q5)
	);
	
	rom_freq   U9(		//“频率 + 幅值”
		.address		(add6),
		.clock		(clk),
		.q				(q6)
	);
	
	rom_number U10(				//数字
		.address		(add),
		.clock		(clk),
		.q				(q)
	);
	
	rom_symbol U11(				//符号显示
		.address		(add7),
		.clock		(clk),
		.q				(q7)
	);
	

	
	
	
	/**************************************** 颜色分配 ************************************************/
	reg [7:0] r,g,b;
	
	always @(posedge clk or negedge rst_n)
	begin 
		if(!rst_n) begin 
			r <= 8'h0;
			g <= 8'h0;
			b <= 8'h0;
		end 
		
		//波形分配
		else if( vgalive && vga_data == 10'd455 - vy)
			begin r <= 8'hFF; g <= 8'hd7;    b <= 8'h00; end 
		
		
		
		//“数字示波器”分配
		else if(tile_area1 && q2[10'd303 - hx])        
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
		else if(tile_area2 && q2[10'd367 - hx])      
			begin r <= 8'hdc;  g <= 8'hdc;	 b <= 8'hdc; end     
		else if(tile_area3 && q2[10'd431 - hx])      
			begin r <= 8'hdc;  g <= 8'hdc;	 b <= 8'hdc; end     
		else if(tile_area4 && q2[10'd495 - hx])       
			begin r <= 8'hdc;  g <= 8'hdc;	 b <= 8'hdc; end      
		else if(tile_area5 && q2[10'd559 - hx])
			begin r <= 8'hdc;  g <= 8'hdc;	 b <= 8'hdc; end
 
		//“垂直灵敏度”分配
		else if(vertical_sensitivity_area1 && q3[10'd382 - hx])    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end                     
		else if(vertical_sensitivity_area2 && q3[10'd414 - hx])           
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end                   
		else if(vertical_sensitivity_area3 && q3[10'd446 - hx])           
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end                 
		else if(vertical_sensitivity_area4 && q3[10'd478 - hx])    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		else if(vertical_sensitivity_area5 && q3[10'd510 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end	
			
			
		//“垂直灵敏度”档位分配
		else if(symbol_area1 && q7[10'd558 - hx] && key_state1 == 2'b00)        		//0      
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end      
		else if(symbol_area2 && q7[10'd574 - hx] && key_state1 == 2'b00)         		//.     
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end      
		else if(symbol_area3 && q7[10'd590 - hx] && key_state1 == 2'b00)         		//1     
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		else if(symbol_area1 && q[10'd558 - hx]  && key_state1 == 2'b01)         		//2    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		else if(symbol_area1 && q[10'd558 - hx]  && key_state1 == 2'b10)         		//1    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		
		else if(symbol_area4 && q7[10'd606 - hx] && key_state1 == 2'b01)           	//m   
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end	    
		
		
		else if(symbol_area5 && q7[10'd622 - hx])           	//v   
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end	
			
		else if(symbol_area6 && q7[10'd638 - hx])				//  /
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end	
		else if(symbol_area7 && q7[10'd654 - hx])				//d
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end	
		else if(symbol_area8 && q7[10'd670 - hx])				//i
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		else if(symbol_area9 && q7[10'd686 - hx])				//v
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end		
		
		
		//“扫描速度”分配
		else if(scan_speed_area1 && q4[10'd382 - hx])				
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end              
		else if(scan_speed_area2 && q4[10'd414 - hx])				
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end              
		else if(scan_speed_area3 && q4[10'd446 - hx])           
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
		else if(scan_speed_area4 && q4[10'd478 - hx])           
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   

		//“扫描速度”档位分配	
		else if(r_symbol_area9 && q[10'd558 - hx] && key_state2 == 2'b00)				//2
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		else if(symbol_area10 && q[10'd574 - hx] && key_state2 ==2'b00)				//0
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
			
		else if(r_symbol_area9 && q[10'd558 - hx] && key_state2 == 2'b01)				//2
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		
		else if(r_symbol_area9 && q[10'd558 - hx] && key_state2 == 2'b10)				//1
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		else if(symbol_area10 && q[10'd574 - hx] && key_state2 == 2'b10)				//0
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		else if(symbol_area11 && q[10'd590 - hx] && key_state2 == 2'b10)				//0
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
			
	   else if(symbol_area12 && q7[10'd606 - hx] && key_state2 == 2'b00)			//m
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		else if(symbol_area12 && q7[10'd606 - hx] && key_state2 == 2'b01)			//u
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		else if(symbol_area12 && q7[10'd606 - hx] && key_state2 == 2'b10)			//n
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end	
			
		else if(symbol_area13 && q7[10'd622 - hx])			//s
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
			
		else if(symbol_area14 && q7[10'd638 - hx])				//  /
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end	
		else if(symbol_area15 && q7[10'd654 - hx])				//d
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end	
		else if(symbol_area16 && q7[10'd670 - hx])				//i
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		else if(symbol_area17 && q7[10'd686 - hx])				//v
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
			
			
		
		//“触发电平”分配
		else if(trigger_level_area1 && q5[10'd382 - hx])   
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end            
		else if(trigger_level_area2 && q5[10'd414 - hx])    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end            
		else if(trigger_level_area3 && q5[10'd446 - hx])   
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end         
		else if(trigger_level_area4 && q5[10'd478 - hx])    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
	
		//“触发电平”数据分配
		else if(f1_1_1 && q[10'd574 - hx])				      
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(f1_1_2 && q[10'd590 - hx])                 
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(f1_1_3 && q[10'd606 - hx])                 
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(f1_1_4 && q[10'd622 - hx])                 
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(f1_1_5 && q[10'd638 - hx])            
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
		else if(f1_1_6 && q[10'd654 - hx])                    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
		else if(f1_1_7 && q[10'd670 - hx])                    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
		else if(f1_1_8 && q[10'd686- hx])                     
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
		
		//“触发电平”单位分配
		else if(symbol5 && q7[10'd718 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
		else if(symbol6 && q7[10'd734 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		
		
		//“频率”分配
		else if(r_freq_area1 && q6[10'd414 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
		else if(r_freq_area2 && q6[10'd446 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
			
		//“幅值”分配
		else if(level_area1 && q6[10'd414 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
		else if(level_area2 && q6[10'd446 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
	
		//“幅值”单位分配
		else if(symbol3 && q7[10'd718 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
		else if(symbol4 && q7[10'd734 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
		
		//“频率”单位分配
		else if(symbol1 && q7[10'd718 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
		else if(symbol2 && q7[10'd734 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
		
		
		//“频率”数据分配
		else if(f2_1_1 && q[10'd574 - hx])				      
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(f2_1_2 && q[10'd590 - hx])                 
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(f2_1_3 && q[10'd606 - hx])                 
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(f2_1_4 && q[10'd622 - hx])                 
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(f2_1_5 && q[10'd638 - hx])            
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
		else if(f2_1_6 && q[10'd654 - hx])                    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
		else if(f2_1_7 && q[10'd670 - hx])                    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
		else if(f2_1_8 && q[10'd686- hx])                     
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 

		//“幅值”数据分配
		else if(a2_1_1 && q[10'd574 - hx])				      
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(a2_1_2 && q[10'd590 - hx])                 
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(a2_1_3 && q[10'd606 - hx])                 
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(a2_1_4 && q[10'd622 - hx])                 
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
		else if(a2_1_5 && q[10'd638 - hx])            
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
		else if(a2_1_6 && q[10'd654 - hx])                    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
		else if(a2_1_7 && q[10'd670 - hx])                    
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
		else if(a2_1_8 && q[10'd686- hx])                     
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
	                                                        
		 
			
			
		else if(z1 || z2)
			begin r <= 8'hDE;  g <= 8'hDE;   b <= 8'hDE;   end 
		else 
			begin r <= 8'h0;  g <= 8'h0;   b <= 8'h0;   end 
		

	end 
	
	assign  RGB = {r,g,b};
	
	



endmodule

