module  FIFOAsync #(parameter WIDTH =4,
                    parameter DEEP =16,
                    parameter ADRESS_WIDTH=4)
                   (fifo_if.fifo_duv_if fifo_duv);

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
always @(posedge fifo_duv.clk_w) begin
  if(!fifo_duv.rst_n)
    memory[adress_w] <= {(WIDTH){1'b0}};

  else if(fifo_duv.en_w && !fifo_duv.full) 
    memory[adress_w]<= fifo_duv.data_w;
    
  else
    memory[adress_w]<=memory[adress_w];
    
end

//read
always @(posedge fifo_duv.clk_r) begin
  if(!fifo_duv.rst_n)
    fifo_duv.data_r<={(WIDTH){1'b0}};

  else if(fifo_duv.en_r && !fifo_duv.empty)
    fifo_duv.data_r <= memory[adress_r];

  else 
    fifo_duv.data_r <= {(WIDTH){1'b0}};
end

//write adress
always @(posedge fifo_duv.clk_w) begin
  if(!fifo_duv.rst_n)
    adress_w_e <= {(ADRESS_WIDTH){1'b0}};

  else if(fifo_duv.en_w && !fifo_duv.full)
    adress_w_e <= adress_w_e + 1'b1;

  else 
    adress_w_e <= adress_w_e;
end

//read adress
always @(posedge fifo_duv.clk_r) begin
  if(!fifo_duv.rst_n)
    adress_r_e <= {(ADRESS_WIDTH){1'b0}};

  else if(fifo_duv.en_r && !fifo_duv.empty)
    adress_r_e <= adress_r_e + 1'b1;

  else
    adress_r_e <= adress_r_e;
end

//d 
always @(posedge fifo_duv.clk_r)begin
  adress_w_d1 <= adress_w_g;
  adress_w_d2 <= adress_w_d1;
end

always @(posedge fifo_duv.clk_w) begin
  adress_r_d1 <= adress_r_g;
  adress_r_d2 <= adress_r_d1;
end

//gray
assign adress_r_g=(adress_r_e >> 1)^adress_r_e;
assign adress_w_g=(adress_w_e>> 1)^adress_w_e;

//full&&empty
assign fifo_duv.full =
adress_w_g=={~adress_r_d2[ADRESS_WIDTH:ADRESS_WIDTH-1],adress_r_d2[ADRESS_WIDTH-2:0]};
assign fifo_duv.empty= adress_r_g==adress_w_d2;

//assign fifo_duv.full =
//adress_w_g=={~adress_r_g[ADRESS_WIDTH:ADRESS_WIDTH-1],adress_r_g[ADRESS_WIDTH-2:0]};
//assign fifo_duv.empty= adress_r_g==adress_w_g;
  
endmodule

