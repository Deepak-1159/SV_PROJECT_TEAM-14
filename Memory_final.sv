module MEMORY(clock, reset, ADDRESS,CS,ALE,rdb,wrb,DATA);  

parameter SIZE=20;
input [SIZE-1:0] ADDRESS;
inout [7:0] DATA;
input logic clock,reset,CS,ALE,rdb,wrb;

logic write, OE, load;

FSM FSM_MEM_IO(clock, reset, CS, ALE, rdb, wrb, OE, write, load);

reg [7:0] mem [2**SIZE-1:0];
reg [SIZE-1:0] Addr_Reg;
 
always_ff @(posedge clock) begin
    if(load) 
        Addr_Reg<=ADDRESS;
    if(write)
        mem[Addr_Reg]<=DATA;
end
 
 
assign DATA = (OE & ~write)?mem[Addr_Reg] : 8'bzzzzzzzz;

initial $readmemh("mem.txt",mem);


endmodule
