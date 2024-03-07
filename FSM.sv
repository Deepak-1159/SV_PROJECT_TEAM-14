module FSM(clock,reset,ALE,rdb,wrb,OEb,WR_RDb);
parameter IOM = '0;
input logic clock,reset,ALE,rdb,wrb;

output logic OEb,WR_RDb;


typedef enum logic [4:0]{INITIAL = 5'b00001,START = 5'b00010,P_READ = 5'b00100,P_WRITE = 5'b01000,TRISTATE= 5'b10000} state;


state PS,NS;

//PRESENT STATE LOGIC

always_ff @(posedge clock)
	begin
		if(reset)
			PS <= INITIAL;
		else
			PS <= NS;
	end


always_comb
	begin
		NS = PS;
		unique case(PS)

		INITIAL :begin
				if(ALE)
					NS = START;
			  end

		START : begin
				if(!wrb)
					NS = P_WRITE;
				else if(!rdb)
					NS=P_READ;
			end

		P_WRITE : NS = TRISTATE;

		P_READ : NS = TRISTATE;

		TRISTATE : NS = INITIAL;

		endcase
	end


//OUTPUT LOGIC
/*
assign OEb    = (PS == P_READ)?'0:'1;
assign WR_RDb = (PS == P_WRITE)?'1:'0;
*/
always_comb 
	begin
		{OEb,WR_RDb} ='0;
		case (PS) 
			P_READ : OEb = '1;
			P_WRITE : WR_RDb = '1;
		endcase
	end
endmodule
