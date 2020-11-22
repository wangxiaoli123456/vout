`timescale 1ns/1ns;

program fifo_tb(fifo_if.fifo_tb_if tb_if,input clk_w_i,input clk_r_i);

//write
assign tb_if.clk_w=clk_w_i;
initial begin
  tb_if.rst_n=1'b0;
  tb_if.en_w=1'b1;
  tb_if.data_w=8'hff;
#10 tb_if.rst_n=1'b1;
#2 tb_if.data_w=8'b00;
#4 tb_if.data_w=8'haa;
#30 tb_if.en_w=1'b0;
end

//read
assign tb_if.clk_r=clk_r_i;
initial begin
  tb_if.en_r=1'b0;
#40 tb_if.en_r=1'b1;
#40 tb_if.en_r=1'b0;
end

endprogram
