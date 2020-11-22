interface fifo_if();
logic rst_n;
logic clk_w;
logic clk_r;
logic en_w;
logic en_r;
logic[7:0] data_w;
logic[7:0] data_r;
logic full;
logic empty;

modport fifo_duv_if(output full,
                    output empty,
                    output data_r,
                    input rst_n,
                    input clk_w,
                    input clk_r,
                    input en_w,
                    input en_r,
                    input data_w);

modport fifo_tb_if(output rst_n,
                   output clk_w,
                   output clk_r,
                   output en_w,
                   output en_r,
                   output data_w,
                   input  full,
                   input  empty,
                   input  data_r);
endinterface
