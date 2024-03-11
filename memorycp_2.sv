
module MEMORY(CLK, ADDRESS, DATA, load, write, OE);  

parameter SIZE=20;
input [SIZE-1:0] ADDRESS;
input write, OE, load, CLK;
inout [7:0] DATA;

reg [7:0] mem [2**SIZE-1:0];
reg [SIZE-1:0] Addr_Reg;

always @(posedge CLK) begin
    if(load) 
        Addr_Reg<=ADDRESS;
    if(write)
        mem[Addr_Reg]<=DATA;
end

 
assign DATA = (OE & ~write)?mem[ADDRESS] : 8'bzzzzzzzz;

initial $readmemh("mem.txt",mem);

initial begin
       	#10;
 	for (int i=0;i<20;i++)
	begin
		$display("The memory values = %h",mem[i]);
	end

	end




endmodule
