module top;
parameter mem_asize = 20;
parameter io_asize = 16;

bit CLK='0;
bit RESET='0;

logic [19:0] ADDRESS;
wire [7:0] Data;

Intel8088Pins P_if(.CLK(CLK),.RESET(RESET));

Intel8088 P(.i(P_if.Processor));

wire CS_MEM1, CS_MEM2, CS_IO1, CS_IO2;
 

// memory 
MEMORY #(mem_asize) MEM_DUT_1(.P_if(P_if.Peripheral),.CS(CS_MEM1),.ADDRESS(ADDRESS),.Data(Data)); 
MEMORY #(mem_asize) MEM_DUT_2(.P_if(P_if.Peripheral),.CS(CS_MEM2),.ADDRESS(ADDRESS),.Data(Data));
MEMORY #(io_asize) IO_DUT_1(.P_if(P_if.Peripheral),.CS(CS_IO1),.ADDRESS(ADDRESS),.Data(Data));
MEMORY #(io_asize) IO_DUT_2(.P_if(P_if.Peripheral),.CS(CS_IO2),.ADDRESS(ADDRESS),.Data(Data));


assign CS_MEM1 = ~P_if.IOM & ~ADDRESS[19];   
assign CS_MEM2 = ~P_if.IOM & ADDRESS[19];    
assign CS_IO1 = ~&({P_if.IOM,P_if.DTR,P_if.SSO}) ? ADDRESS[15:4]== 12'hFF0 : '0;
assign CS_IO2 = ~&({P_if.IOM,P_if.DTR,P_if.SSO}) ? ADDRESS[15:9]== 8'h0E : '0;

always_latch
begin
if (P_if.ALE)
    ADDRESS <= {P_if.A,P_if.AD};
end

// 8286 transceiver
assign Data =  (P_if.DTR & ~P_if.DEN) ? P_if.AD   : 'z;
assign P_if.AD   = (~P_if.DTR & ~P_if.DEN) ? Data : 'z;
 

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

