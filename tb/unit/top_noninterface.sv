`timescale 1ns/1ns;

module top();
bit clk_w_i;
bit clk_r_i;
logic rst_n_w;
logic rst_n_r;
logic clk_w;
logic clk_r;
logic en_w;
logic en_r;
logic[7:0] data_w;
logic  full;
logic  empty;
logic[7:0]  data_r;
                

always
#1 clk_w_i=~clk_w_i;

always
#2 clk_r_i=~clk_r_i;

//fifo_if fifo_if();
FIFOAsync(
    .full(full),
    .empty(empty),
    .data_r(data_r),
    .rst_n_w(rst_n_w),
    .rst_n_r(rst_n_r),
    .clk_w(clk_w),
    .clk_r(clk_r),
    .en_w(en_w),
    .en_r(en_r),
    .data_w(data_w));
fifo_tb(
    .clk_w(clk_w),
    .clk_r(clk_r),
    .full(full),
    .empty(empty),
    .data_r(data_r),
    .rst_n_w(rst_n_w),
    .rst_n_r(rst_n_r),
    .clk_w_i(clk_w_i),
    .clk_r_i(clk_r_i),
    .en_w(en_w),
    .en_r(en_r),
    .data_w(data_w));
endmodule
