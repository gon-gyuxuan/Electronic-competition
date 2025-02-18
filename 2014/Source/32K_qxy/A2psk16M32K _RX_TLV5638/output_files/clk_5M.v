module clk_5M(clk,rst,clk_5M);
input clk,rst;
output clk_5M;

reg[31:0]cnt;
reg clk_5M;
always@(posedge clk or negedge rst)
begin
	if(!rst)
		begin
			cnt<=1'b0;
		end
	else if(cnt>=4)
		begin
			clk_5M<=~clk_5M;
			cnt<=1'b0;
		end 
	else  	
		begin
			cnt<=cnt+1'b1;
		end 
end 


endmodule 
