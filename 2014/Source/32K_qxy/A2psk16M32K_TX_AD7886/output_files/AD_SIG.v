module AD_SIG(clk_1M,rst,clk_AD,ad_up);
input clk_1M,rst;
input clk_AD;
output ad_up;

reg H2L_F1;
reg H2L_F2;
/*
H2L_F1，H2L_F2，是针对检测电平由高变低
H2L_Fx 是为了检测由高变低的电平，所以初始化为逻辑1。
*/
always@(posedge clk_1M or negedge rst)
begin
	if(!rst) 
		begin
			H2L_F1 <= 1'b1;
			H2L_F2 <= 1'b1;
		end
	else 
		begin
			H2L_F1 <= clk_AD;
			H2L_F2 <= H2L_F1;
		end
end

wire ad_up =H2L_F1 & (~H2L_F2);//上升沿
endmodule 