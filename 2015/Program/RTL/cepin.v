module cepin(
			//system
			input 					clk		,// 系统时钟  
			input 					rst_n		,// 复位
			//other
			input 	 [1:0]		sw			,// 开关
			//ram signal 
			input  	[9:0]			data		,// ram的数据 
			input  	[10:0]		count		,// ram的写地址
			//vga signal 
			output 	[11:0]		a1			,// 幅值1 
			output 	[11:0]		a2			,// 幅值2
			output 	[19:0]		f1			,// 频率1
			output 	[19:0]		f2			 // 频率2
);


reg  [10:0] fp;//频率分辨率
always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		fp <= 1'b1;
	else 
		case(sw)
			2'b00: fp <= 1'b1;
			2'b01: fp <= 4'd10;
			2'b10: fp <= 7'd100;
			2'b11: fp <= 11'd1000;
		endcase
end 

reg 	[2:0]  	status;
reg 	[9:0]  	temp1, temp2, temp3;//寄存器
reg 	[9:0]  	an1,an2;

reg [1:0] flag;
//寻找峰值(两次)
reg [19:0] rf1,rf2;
always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n) begin 
		temp1 <= 1'b0;
		temp2 <= 1'b0;
		temp3 <= 1'b0;
		status <= 1'b0;
		flag <= 1'b0;
	   an1 <= 1'b0;
		an2 <= 1'b0;	
		rf1 <= 1'b0;
		rf2 <= 1'b0;
		end 
	else
		case(status)
		3'd0: if(count == 1'b1)
					status <= 3'd1;
				else begin 
					status <= 3'd0;
					temp1  <= 1'b0;
					temp2  <= 1'b0;
					temp3  <= 1'b0;
					flag <= 1'b0;
					an1 <= 1'b0;
					an2 <= 1'b0;	
					rf1 <= 1'b0;
					rf2 <= 1'b0;
				end 
					
		3'd1: if(temp2 > temp1 && temp2 > temp3 && temp2 - temp1 > 3'd5)begin 
						rf1     <= (count - 1'b1)*fp;
						flag   <= 1'b1;
						an1    <= temp2;
						status <= 3'd2;
						temp1  <= 1'b0;
				   	temp2  <= 1'b0;
					   temp3  <= 1'b0;
					end 
				else if(count < 10'd1023)begin 
					temp1 <= data;
					temp2 <= temp1;
					temp3 <= temp2; end 
				else begin 
				 	rf1 <= 1'b0;
					an1 <= 1'b0;
					status <= 3'd0; 
					flag   <= 1'b1;		end 
					
		3'd2: if(data < an1>>3'd4) begin 
					flag   <= 1'b0;
					status <= 3'd3; end 
				else if(count >= 11'd1024) begin 
					flag <= 1'b0;
					status <= 3'd0; end 
				else begin 
					status <= 3'd2;
					flag <= 1'b0; end 
					
		3'd3:if(temp2 > temp1 && temp2 > temp3 && temp2 - temp1 > 3'd5) begin 
						if(count >= 11'd1023) begin 
							rf2 <= 1'b0;
							flag <= 2'b10;
							an2 <= 1'b0;
							status <= 3'd0;
							end 
						else begin 
							rf2     <= (count - 1'b1)*fp;
							flag <= 2'b10;
							status <= 3'd4;
							an2    <= temp2;
							end 
						end 
						else begin 
							temp1 <= data;
							temp2 <= temp1;
							temp3 <= temp2; end 
		3'd4: if(count>= 11'd1024)begin 
					flag <= 1'b0;
					status <= 3'd0; end 
				else if(data <  an2>>3'd4) begin 
					flag <= 1'b0;
					status <= 3'd0; end 
				else begin 
					status <= 3'd4;
					flag <= 1'b0; end 
		endcase 
end

assign f1 = (flag == 1'b1) ?  rf1 : f1;
assign f2 = (flag == 2'b10) ? rf2 : f2;
//稳定幅值

wire is1  = (an1 > ra1 && an1 - ra1 >= 4'd3) || (ra1 > an1 && ra1 - an1 >=  4'd3);
 
wire is2  = (an2 > ra2 && an2 - ra2 >= 4'd3) || (ra2 > an2 && ra2 - an2 >=  4'd3);
 
reg [9:0] ra1,ra2;

always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		ra1 <= 1'b0;
	else if(flag == 1'b1 && is1)
		ra1 <= an1;
end 


always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		ra2 <= 1'b0;
	else if(flag == 2'd2 && is2)
		ra2 <= an2;
end 

 
wire [16:0] ta1 =  {ra1,7'b0} - {ra1,1'b0} - ra1;
wire [16:0] ta2 =  {ra2,7'b0} - {ra2,1'b0} - ra2;
assign a1 = ta1[16:5];
assign a2 = ta2[16:5];
endmodule 
