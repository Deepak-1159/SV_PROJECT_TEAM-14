module top;
parameter mem_asize = 20;
parameter io_asize = 16;

bit CLK='0;
bit RESET='0;



Intel8088Pins P_if(.CLK(CLK),.RESET(RESET));

Intel8088 P(P_if.Processor); 

wire CS_MEM1, CS_MEM2, CS_IO1, CS_IO2;
 
  
// memory 
MEMORY #(mem_asize) MEM_DUT_1(.P_if(P_if.Peripheral),.CS(CS_MEM1)); 
MEMORY #(mem_asize) MEM_DUT_2(.P_if(P_if.Peripheral),.CS(CS_MEM2));
MEMORY #(io_asize) IO_DUT_1(.P_if(P_if.Peripheral),.CS(CS_IO1));
MEMORY #(io_asize) IO_DUT_2(.P_if(P_if.Peripheral),.CS(CS_IO2));

assign CS_MEM1 = 1'b1 & ~P_if.ADDRESS[19];   
assign CS_MEM2 = 1'b1 & P_if.ADDRESS[19];
assign CS_IO1 = ~&({1'b1,P_if.DTR,P_if.SSO}) ? P_if.ADDRESS[15:4]== 12'hFF0 : '0;
assign CS_IO2 = ~&({1'b1,P_if.DTR,P_if.SSO}) ? P_if.ADDRESS[15:9]== 8'h0E : '0;

always_latch
begin
if (P_if.ALE)
    P_if.ADDRESS <= {P_if.A,P_if.AD};
end

// 8286 transceiver
assign P_if.Data =  (P_if.DTR & ~P_if.DEN) ? P_if.AD   : 'z;
assign P_if.AD   = (~P_if.DTR & ~P_if.DEN) ? P_if.Data : 'z;
 

always #50 CLK = ~CLK;

initial
begin
$dumpfile("dump.vcd"); $dumpvars;

repeat (2) @(posedge CLK);
RESET = '1;
repeat (5) @(posedge CLK);
RESET = '0;

repeat(10000) @(posedge CLK);
$finish();
end

endmodule

