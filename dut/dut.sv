module apb_slave(input logic  pclk , 
    input logic   rst_n, 
    input logic [3:0]  paddr, 
    input logic  psel, 
    input logic  penable, 
    input logic  pwrite, 
    input logic [31:0]  pwdata,
   output logic  pready ,
   output logic [31:0] prdata);
  
   logic [31:0] mem [0:256]; 
  logic [1:0] apb_st;
  const logic [1:0] SETUP=0;
  const logic [1:0] W_ENABLE=1;
  const logic [1:0] R_ENABLE=2;
  
  always @(posedge pclk or negedge rst_n) begin
  if (rst_n==0) begin
  apb_st <=0;
  prdata <=0;
  for(int i=0;i<256;i++) mem[i]=i;
  end
  else begin
  case (apb_st)
  SETUP: begin
   prdata <= 0;
   pready <=0;
   if (psel && !penable) begin
       if (pwrite) begin
           apb_st <= W_ENABLE;
       end
       else begin
           apb_st <= R_ENABLE;
       end
   end
  end
  W_ENABLE: begin
   if (psel && penable && pwrite) begin
       mem[paddr] <= pwdata;
       pready =1;
   end
       apb_st <= SETUP;
   end
  R_ENABLE: begin
   if (psel && penable && !pwrite)begin
   // @(posedge pclk)
       prdata = mem[paddr];
       pready <=1;
   end         
   apb_st <= SETUP;
  end
  endcase
  end
  end
  endmodule