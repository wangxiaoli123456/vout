`timescale 1ns/1ns;

module top();
bit clk_w;
bit clk_r;

always
#1 clk_w=~clk_w;

always
#2 clk_r=~clk_r;

fifo_if fifo_if();
FIFOAsync(fifo_if.fifo_duv_if);
fifo_tb(fifo_if.fifo_tb_if,clk_w,clk_r);

endmodule
