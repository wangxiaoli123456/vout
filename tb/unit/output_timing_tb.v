'timescale 1ns/100ps

'define PIXEL_PERIOD 8

module output_timing_tb();

reg pixel_clk=0;
reg rst_n=0;

always #('PIXEL_PERIOD/2)
    pixel_clk = ~pixel_clk;

output_timing sync_gen(
    .clk(pixel_clk),
    .rst_n(rst_n),
);

endmodule
