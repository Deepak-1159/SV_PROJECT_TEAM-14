module FSM(clock,reset,ALE,rdb,wrb,IOM,OEb,WR_RDb);
//parameter IOM = '0;
input logic clock,reset,ALE,rdb,wrb,IOM;

output logic OEb,WR_RDb;


typedef enum logic [5:0]{INITIAL = 6'b000001,START = 6'b000010,P_READ = 6'b000100,P_WRITE = 6'b001000,TRISTATE= 6'b010000,WAITING = 6'b100000} state;


state PS,NS;

//PRESENT STATE LOGIC

always@(posedge clock)
	begin
		if(reset)
			PS <= INITIAL;
		else
			PS <= NS;
	end


always_comb
	begin
		NS = PS;
		case(PS)

		INITIAL :begin
					if(ALE)
						NS = START;

				end

		START : begin
					if(rdb && !wrb)
						NS = P_WRITE;
					else if(!rdb && wrb)
						NS=P_READ;
				end

		P_WRITE : NS = WAITING;

		P_READ : NS = TRISTATE;

		TRISTATE : NS = INITIAL;

		WAITING : NS = INITIAL;

		endcase
	end


//OUTPUT LOGIC

assign OEb    = (PS == TRISTATE)?'1:'0;
assign WR_RDb = (PS == P_WRITE)?'1:'0;


endmodule
