module MEMORY(Intel8088Pins P_if,input [19:0] ADDRESS,[7:0]Data,input CS);
parameter SIZE=20;
logic write, OE, load;

FSM FSM_MEM_IO(.clock(P_if.CLK),.reset(P_if.RESET), .CS(CS), .ALE(P_if.ALE), .rdb(P_if.RD), .wrb(P_if.WR), .OEb(OE), .WR_RDb(write), .load(load));

reg [7:0] mem [2**SIZE-1:0];
reg [SIZE-1:0] Addr_Reg;
 
always_ff @(posedge P_if.CLK) begin
    if(load)    
        Addr_Reg<= ADDRESS;
    if(write)
        mem[Addr_Reg]<= Data;
end
 
 
assign Data = (OE & ~write)?mem[Addr_Reg] : 8'bzzzzzzzz;

initial $readmemh("mem.txt",mem);


endmodule
