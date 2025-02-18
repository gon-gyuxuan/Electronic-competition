module rs232_rx
(
clk_16M,//10M
rst,
data_i,//250KHZ
data_o,
done
);

input clk_16M,rst;
input data_i;
output[15:0]data_o;
output done;
//output[2:0]state;
reg f1,f2;
always@(posedge clk_16M or negedge rst)
begin
	if(!rst)
		begin
			f1<=1'b0;
			f2<=1'b0;
		end
	else
		begin
			f1<=data_i;
			f2<=f1;
		end
end
wire data_up=(f1&&(!f2));//上升沿
wire data_done=((!f1)&&f2);//下降沿


reg[2:0]state;
reg [15:0]data_o;
reg [31:0]num1;//
reg [31:0]num2;
reg done;
reg [19:0]data_code;
always@(posedge clk_16M or negedge rst)
begin
	if(!rst)
		begin
			state<=1'b0;
			data_o<=1'b0;
			done<=1'b0;
		end
	else 
		begin
			case(state)
				3'd0:
					begin
						data_o<=data_o;
						done<=1'b0;
						if(data_up)
							state<=3'd1;
						else
							state<=3'd0;
					end
				3'd1://判断是否为空闲时间
					begin
						if(data_done)
							begin
								num1<=1'b0;
								if(num1>32'd135)//空闲时间大于九个码元
									state<=3'd2;
								else
									state<=3'd0;
							end
						else
							num1<=num1+1'b1;
					end
				3'd2://
					begin
						num2<=num2+1'b1;
						case(num2)
							9'd6:			data_code[0]<=data_i;//起始位
							9'd22:		data_code[1]<=data_i;//起始位
							
							9'd38:		data_code[2]<=data_i;
							9'd54:		data_code[3]<=data_i;
							9'd70:		data_code[4]<=data_i;
							9'd86:		data_code[5]<=data_i;
							9'd102:     data_code[6]<=data_i;
							9'd118:     data_code[7]<=data_i;
							9'd134:     data_code[8]<=data_i;
							9'd150:		data_code[9]<=data_i;
							
							9'd166:     data_code[10]<=data_i;//区分AB
							9'd182:     data_code[11]<=data_i;//区分AB
							
							9'd198:     data_code[12]<=data_i;
							9'd214:     data_code[13]<=data_i;
							9'd230:		data_code[14]<=data_i;
							9'd246:     data_code[15]<=data_i;
							9'd262:     data_code[16]<=data_i;
							9'd278:     data_code[17]<=data_i;
							9'd294:		data_code[18]<=data_i;
							9'd310:     
										begin 
											data_code[19]<=data_i;
											state<=3'd3;
											num2<=1'b0;
										end
							default:
									begin 
										state<=3'd2;
										data_code<=data_code;
									end 		
						endcase
					end
				3'd3:
					begin
						state<=3'd0;
						done<=1'b1;
						data_o[7:0]<=8'hff-data_code[9:2];
						data_o[15:8]<=8'hff-data_code[19:12];
					end
				endcase	
		end
		
end
endmodule
