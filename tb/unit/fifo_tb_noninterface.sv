`timescale 1ns/1ns;

program fifo_tb(output rst_n_w,
                output rst_n_r,
                output clk_w,
                output clk_r,
                output en_w,
                output en_r,
                output data_w,
                input  full,
                input  empty,
                input  data_r,
                input clk_w_i,
                input clk_r_i);
reg rst_n_w;
       reg rst_n_r;
       reg en_w;
       reg en_r;
       reg[7:0] data_w;
       reg[7:0] data_r;



       //write
       assign clk_w=clk_w_i;
       initial begin
       rst_n_w=1'b0;
       rst_n_r=1'b0;
       en_w=1'b1;
       data_w=8'hff;
#10 rst_n_w=1'b1;
       rst_n_r=1'b1;
#2 data_w=8'b00;
#4 data_w=8'haa;
#30 en_w=1'b0;
       end

       //read
       assign clk_r=clk_r_i;
initial begin
  en_r=1'b0;
#40 en_r=1'b1;
#40 en_r=1'b0;
end

endprogram
