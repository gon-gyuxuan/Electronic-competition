module shiboqi (clk,rst_n,hsync_vga,vsync_vga,clk_out,red,green,blue,data_in,sw);
input clk,rst_n;
input[9:0] data_in;
input[7:0] sw;
output hsync_vga;
output vsync_vga;
output clk_out;
output[2:0] red,green,blue;

wire[9:0] data_out;
wire[7:0] sw_an;
wire valid;
wire[10:0] x_pos,y_pos,y_cnt;
wire cf;
wire[3:0] p1,p2,p3,p4,p5,p6,p7;
wire[3:0] f1,f2,f3,f4;

ads828 m1(
		 .clk(clk),
		 .rst_n(rst_n),
		 .data_in(data_in),
		 .data_out(data_out),
		 .clk_out(clk_out)
		 );
		 
vga1 m2  (
		 .clk(clk),
		 .rst_n(rst_n),
		 .valid(valid),
		 .hsync_vga(hsync_vga),
		 .vsync_vga(vsync_vga),
		 .x_pos(x_pos),
		 .y_pos(y_pos),
		 .y_cnt(y_cnt)
		  );

anjian m3(
		.clk(clk),
		.rst_n(rst_n),
		.sw(sw),
		.sw_an(sw_an)
		);

control m4(
		.clk(clk),
		.rst_n(rst_n),
		.x_pos(x_pos),
		.y_pos(y_pos),
		.y_cnt(y_cnt),
		.red(red),
		.blue(blue),
		.green(green),
	    .data_out(data_out),
        .sw_an(sw_an),
        .sw(sw),
        .valid(valid),
        .cf(cf),
        .f1(f1),
		.f2(f2),
		.f3(f3),
		.f4(f4),
		.p1(p1),
		.p2(p2),
		.p3(p3),
		.p4(p4),
		.p5(p5),
		.p6(p6),
		.p7(p7)
		);
pinlv m5(
		.clk(clk),
		.rst_n(rst_n),
		.cf(cf),
		.p1(p1),
		.p2(p2),
		.p3(p3),
		.p4(p4),
		.p5(p5),
		.p6(p6),
		.p7(p7)
		);
fuzhi m6(
		.clk(clk),
		.rst_n(rst_n),
		.data_out(data_out),
		.f1(f1),
		.f2(f2),
		.f3(f3),
		.f4(f4)
		);
endmodule 