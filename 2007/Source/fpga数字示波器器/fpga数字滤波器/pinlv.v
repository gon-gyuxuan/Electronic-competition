//**Ƶ�ʼ���**********************Ƶ�ʼ���***********
module pinlv(clk,rst_n,cf,p1,p2,p3,p4,p5,p6,p7);
input clk,rst_n;
input cf;
output[3:0] p1,p2,p3,p4,p5,p6,p7;
//***********************************
reg[25:0] cnt;
reg[23:0] pinlv_r,n;
reg div;//0.5hz
always@(posedge clk)
begin
	if(cnt==49_999_999)
	begin
		div<=~div;
		cnt<=1'b0;
	end
	else
		cnt<=cnt+1'b1;
end
always@(posedge cf)
begin
	if(div) 	
		n <= n+1'b1;
	else
		n<=1'b0;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) 	pinlv_r<=1'b0;
	else if(cnt==26'd49_999_999 && div)
		pinlv_r<=n;
	else 
		pinlv_r<=pinlv_r;
end
//********************************8
reg[27:0] temp;
integer i;
reg[23:0] pinlv;
reg[3:0] p1_r,p2_r,p3_r,p4_r,p5_r,p6_r,p7_r;
always@(posedge clk)
begin
	pinlv=pinlv_r;
	temp = 0;
	for(i = 0;i < 23;i = i + 1)
	begin
		 temp = {temp[26:0],pinlv[23]}; 
		 if(temp[3:0] > 4'd4) 
			temp[3:0] = temp[3:0]+4'd3;
         if(temp[7:4] > 4'd4) 
            temp[7:4] = temp[7:4]+4'd3;
         if(temp[11:8] > 4'd4) 
            temp[11:8] = temp[11:8]+4'd3;
         if(temp[15:12] > 4'd4) 
            temp[15:12] = temp[15:12]+4'd3;
         if(temp[19:16] > 4'd4) 
            temp[19:16] = temp[19:16]+4'd3;
         if(temp[23:20] > 4'd4) 
            temp[23:20] = temp[23:20]+4'd3;
         if(temp[27:24] > 4'd4) 
            temp[27:24] = temp[27:24]+4'd3;
		 pinlv=pinlv<<1;  
          {p1_r,p2_r,p3_r,p4_r,p5_r,p6_r,p7_r}={temp[26:0],pinlv[0]};
      end
end

assign p1=p1_r;
assign p2=p2_r;
assign p3=p3_r;
assign p4=p4_r;
assign p5=p5_r;
assign p6=p6_r;
assign p7=p7_r;

/*reg[3:0] p4_r_1;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		p4_r_1<=1'b0;
	else if(pinlv_r_1<8'd180)
	  p4_r_1<=p4_r;
	else
		p4_r_1<=p4_r+1'b1;
end*/
		
endmodule
