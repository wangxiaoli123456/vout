'timescale 1ns/100ps

'define PIXEL_PERIOD 8

module output_timing_tb();

reg pixel_clk=0;
reg rst_n=0;

wire hs,vs,de;
wire [7:0] datar_o,datag_o,datab_o;

reg output_timing_en,hpol_i;
reg [7:0] datar_i,datag_i,datab_i;
reg [7:0] vfp_i,vbp_i,hfp_i,hbp_i;
reg [3:0] vsw_i,hsw_i;
reg [15:0] v_active_i,h_active_i;

always #('PIXEL_PERIOD/2)
    pixel_clk = ~pixel_clk;

output_timing sync_gen(
   .hsync_o(hs),
   .vsync_o(vs),
   .de_o(de),
   .datar_o(datar_o),
   .datag_o(datag_o),
   .datab_o(datab_o),
   .clk(clk),
   .rst_n(rst_n),
   .sync_en(output_timing_en),
   .hpol_i(hpol_i),
   .datar_i(datar_i),
   .datag_i(datag_i),
   .datab_i(datab_i),
   .vactive_i(v_active_i),
   .hactive_i(h_active_i),
   .vfp_i(vfp_i),
   .vbp_i(vbp_i),
   .vsw_i(vsw_i),
   .hfp_i(hfp_i),
   .hbp_i(hbp_i),
   .hsw_i(hsw_i));

initial begin
clk=1'b0;
rst_n=1'b0;
output_timing_en=1'b1;
hpol_i=1'b0;
datar_i=8'hff;
datag_i=8'hee;
datab_i=8'h44;
vfp_i=8'd20;
hfp_i=8'd20;
vbp_i=8'd20;
hbp_i=8'd20;
vsw_i=4'd10;
hsw_i=4'd10;
v_active_i=16'd480;
h_active_i=16'd720;

#2 rst_n=1'b1;
#500000 $finish;
end

endmodule
