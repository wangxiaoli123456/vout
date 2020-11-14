module output_timing#(
  parameter HFP_WIDTH=8,
  parameter HSW_WIDTH=4,
  parameter HBP_WIDTH=8,
  parameter HACTIVE_WIDTH=16,
  parameter DATA_WIDTH=8,
  parameter VFP_WIDTH=8,
  parameter VSW_WIDTH=4,
  parameter VBP_WIDTH=8,
  parameter VACTIVE_WIDTH=16

)(
  input                       clk,
  input                       rst_n,
  input                       output_timing_en,
  input                       hpol_i,
  input [HFP_WIDTH-1:0]       hfp_i,
  input [HSW_WIDTH-1:0]       hsw_i,
  input [HBP_WIDTH-1:0]       hbp_i,
  input [HACTIVE_WIDTH-1:0]   hactive_i,
  input [VFP_WIDTH-1:0]       vfp_i,
  input [VSW_WIDTH-1:0]       vsw_i,
  input [VBP_WIDTH-1:0]       vbp_i,
  input [VACTIVE_WIDTH-1:0]   vactive_i,
  input [DATA_WIDTH-1:0]      datar_i,
  input [DATA_WIDTH-1:0]      datag_i,
  input [DATA_WIDTH-1:0]      datab_i,

  output [DATA_WIDTH-1:0]     datar_o,
  output [DATA_WIDTH-1:0]     datag_o,
  output [DATA_WIDTH-1:0]     datab_o,
  output                      hsync_o,
  output                      vsync_o,
  output                      de_o
);


reg  [HACTIVE_WIDTH:0]  h_cnt_r;
reg                     hsync_r;
reg                     deync_r;

wire [HACTIVE_WIDTH:0]  htt_c;
wire [HFP_WIDTH:0]      hsw_end_c;
wire [HFP_WIDTH:0]      hbp_end_c;
wire [HFP_WIDTH:0]      hfp_end_c;

assign hfp_end_c =  hfp_i;
assign hsw_end_c = hfp_end_c + hsw_i;
assign hbp_end_c = hsw_end_c + hbp_i;
assign htt_c =  hbp_end_c + hactive_i ;

//h_cnt
always @(posedge clk)begin
  if(!rst_n)
      h_cnt_r <= {(HACTIVE_WIDTH+1){1'b0}}+1'b1;
  else if(output_timing_en)
      h_cnt_r <= (h_cnt_r<htt_c)?(h_cnt_r+1'b1):{(HACTIVE_WIDTH+1){1'b0}}+1'b1;
  else
      h_cnt_r <= {(HACTIVE_WIDTH+1){1'b0}}+1'b1;
end

//h_sync
always @(posedge clk)begin
  if(!rst_n)
    hsync_r <= 1'b0;
  else if(output_timing_en & h_cnt_r < hfp_end_c)
      hsync_r <=1'b0;
  else if(output_timing_en & h_cnt_r < hsw_end_c)
      hsync_r <= 1'b1;
  else
      hsync_r <= 1'b0;
end

//deync
always @(posedge clk)begin
  if(!rst_n)
    deync_r <= 1'b0;
  else if(output_timing_en & h_cnt_r < hbp_end_c )
    deync_r <= 1'b0;
  else if(output_timing_en & h_cnt_r < htt_c)
    deync_r <= 1'b1;
  else
    deync_r <= 1'b0;
end

assign hsync_o = hsync_r;
assign de_o=deync_r;

reg  [VACTIVE_WIDTH:0]  v_cnt_r;
reg                     vsync_r;
wire                    v_en;

wire [VACTIVE_WIDTH:0]  vtt_c;
wire [VFP_WIDTH:0]      vsw_end_c;
wire [VFP_WIDTH:0]      vbp_end_c;
wire [VFP_WIDTH:0]      vfp_end_c;

assign v_en =( h_cnt_r == htt_c -1'b1) ? 1'b1:1'b0;

assign vfp_end_c = vfp_i;
assign vsw_end_c = vfp_end_c + vsw_i;
assign vbp_end_c = vsw_end_c + vbp_i;
assign vtt_c =  vbp_end_c + vactive_i ;

always @ (posedge clk) begin
  if(!rst_n) begin
    v_cnt_r <= {(VACTIVE_WIDTH+1){1'b0}}+1'b1;
    end
  else if(v_cnt_r < vtt_c)
      v_cnt_r <=v_en?(v_cnt_r+1'b1):v_cnt_r;
  else
      v_cnt_r <={(VACTIVE_WIDTH+1) {1'b0}}+1'b1;
  end

always @(posedge clk) begin
  if(!rst_n)
    vsync_r <= 1'b0;
  else if(v_cnt_r < vfp_end_c+1'b1)
    vsync_r <= 1'b0;
  else if(v_cnt_r < vsw_end_c+1'b1)
    vsync_r <= 1'b1;
  else if(v_cnt_r < vbp_end_c+1'b1)
    vsync_r <= 1'b0;
  else if(v_cnt_r < vtt_c+1'b1)
    vsync_r <= 1'b1;
  else
    vsync_r <= 1'b0;
end

assign vsync_o=vsync_r;

reg[DATA_WIDTH-1:0] datar_r;
reg[DATA_WIDTH-1:0] datag_r;
reg[DATA_WIDTH-1:0] datab_r;

assign datar_o=datar_r;
assign datag_o=datag_r;
assign datab_o=datab_r;

always @ (posedge clk) begin
  if(!rst_n) begin 
    datar_r <={ DATA_WIDTH{1'b0}};
    datag_r <={ DATA_WIDTH{1'b0}};
    datab_r <={ DATA_WIDTH{1'b0}};
    end
  else begin
    datar_r <= datar_i;
    datag_r <= datag_i;
    datab_r <= datab_i;
    end
end

endmodule
