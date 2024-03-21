interface Intel8088Pins(input logic CLK,RESET);

logic MNMX ='1;
logic TEST ='1;  

logic READY ='1;
logic NMI ='0;
logic INTR = '0;
logic HOLD ='0;

logic HLDA;
tri [7:0] AD;
tri [19:8] A;

logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;

logic [19:0] ADDRESS;
wire [7:0] Data;

modport Processor(input CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, output A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN,inout AD);

modport Peripheral(input CLK,RESET,ALE,RD,WR,ADDRESS,inout Data); 




endinterface