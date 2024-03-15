module top;
parameter mem_asize = 20;
parameter io_asize = 16;
bit CLK = '0;
bit MNMX = '1;
bit TEST = '1;
bit RESET = '0;
bit READY = '1;
bit NMI = '0;
bit INTR = '0;
bit HOLD = '0;

wire logic [7:0] AD;
logic [19:8] A;
logic HLDA;
logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;


logic [19:0] ADDRESS;
wire [7:0]  Data;

wire CS_MEM1, CS_MEM2, CS_IO1, CS_IO2;

Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);
  
// memory 


MEMORY #(mem_asize) MEM_DUT_1(CLK, RESET, ADDRESS,CS_MEM1,ALE,RD,WR,Data); 
MEMORY #(mem_asize) MEM_DUT_2(CLK, RESET,ADDRESS,CS_MEM2,ALE,RD,WR,Data);
MEMORY #(io_asize) IO_DUT_1(CLK,RESET, ADDRESS,CS_IO1,ALE,RD,WR,Data);
MEMORY #(io_asize) IO_DUT_2(CLK,RESET, ADDRESS,CS_IO2,ALE,RD,WR,Data);


// CHIP SELECT
assign CS_MEM1 = ~IOM & ~ADDRESS[19];   
assign CS_MEM2 = ~IOM & ADDRESS[19];    
assign CS_IO1 = ~&({IOM, DTR, SSO}) ? ADDRESS[15:4]== 12'hFF0 : '0;
assign CS_IO2 = ~&({IOM, DTR, SSO}) ? ADDRESS[15:9]== 8'h0E : '0;


// 8282 Latch to latch bus ADDRESS
always_latch
begin
if (ALE)
    ADDRESS <= {A, AD};
end

// 8286 transceiver
assign Data =  (DTR & ~DEN) ? AD   : 'z;
assign AD   = (~DTR & ~DEN) ? Data : 'z;


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
