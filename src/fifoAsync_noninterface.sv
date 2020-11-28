module  FIFOAsync #(parameter WIDTH =8,
                    parameter DEEP =16,
                    parameter ADRESS_WIDTH=4)
                   (output full,
                    output empty,
                    output data_r,
                    input rst_n_w,
                    input rst_n_r,
                    input clk_w,
                    input clk_r,
                    input en_w,
                    input en_r,
                    input data_w);
reg[WIDTH-1:0] data_r;
reg[WIDTH-1:0] data_w;

//memory width * deep
reg[WIDTH -1:0] memory[DEEP-1:0];

//actual adress
reg[ADRESS_WIDTH-1:0] adress_r;
reg[ADRESS_WIDTH-1:0] adress_w;

//gray adress
reg[ADRESS_WIDTH:0] adress_r_g;
reg[ADRESS_WIDTH:0] adress_w_g;

//expand adress
reg[ADRESS_WIDTH:0] adress_r_e;
reg[ADRESS_WIDTH:0] adress_w_e;

//D adress
reg[ADRESS_WIDTH:0] adress_r_d1;
reg[ADRESS_WIDTH:0] adress_r_d2;
reg[ADRESS_WIDTH:0] adress_w_d1;
reg[ADRESS_WIDTH:0] adress_w_d2;

assign adress_r=adress_r_e[ADRESS_WIDTH-1:0];
assign adress_w=adress_w_e[ADRESS_WIDTH-1:0];

//write                   
always @(posedge clk_w) begin
  if(!rst_n_w)
    memory[adress_w] <= {(WIDTH){1'b0}};

  else if(en_w && !full) 
    memory[adress_w]<= data_w;
    
  else
    memory[adress_w]<=memory[adress_w];
    
end

//read
always @(posedge clk_r) begin
  if(!rst_n_r)
    data_r<={(WIDTH){1'b0}};

  else if(en_r && !empty)
    data_r <= memory[adress_r];

  else 
    data_r <= {(WIDTH){1'b0}};
end

//write adress
always @(posedge clk_w) begin
  if(!rst_n_w)
    adress_w_e <= {(ADRESS_WIDTH){1'b0}};

  else if(en_w && !full)
    adress_w_e <= adress_w_e + 1'b1;

  else 
    adress_w_e <= adress_w_e;
end

//read adress
always @(posedge clk_r) begin
  if(!rst_n_r)
    adress_r_e <= {(ADRESS_WIDTH){1'b0}};

  else if(en_r && !empty)
    adress_r_e <= adress_r_e + 1'b1;

  else
    adress_r_e <= adress_r_e;
end

//d 
always @(posedge clk_r)begin
  adress_w_d1 <= adress_w_g;
  adress_w_d2 <= adress_w_d1;
end

always @(posedge clk_w) begin
  adress_r_d1 <= adress_r_g;
  adress_r_d2 <= adress_r_d1;
end

//gray
assign adress_r_g=(adress_r_e >> 1)^adress_r_e;
assign adress_w_g=(adress_w_e>> 1)^adress_w_e;

//full&&empty
assign full =
adress_w_g=={~adress_r_d2[ADRESS_WIDTH:ADRESS_WIDTH-1],adress_r_d2[ADRESS_WIDTH-2:0]};
assign empty= adress_r_g==adress_w_d2;

//assign full =
//adress_w_g=={~adress_r_g[ADRESS_WIDTH:ADRESS_WIDTH-1],adress_r_g[ADRESS_WIDTH-2:0]};
//assign empty= adress_r_g==adress_w_g;
  
endmodule

