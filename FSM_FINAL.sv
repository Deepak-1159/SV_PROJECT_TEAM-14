module FSM(clock, reset, CS, ALE, rdb, wrb, OEb, WR_RDb, load);

input logic clock, reset, CS, ALE, rdb, wrb;

output logic OEb, WR_RDb, load;

typedef enum logic [4:0]{INITIAL = 5'b00001,START = 5'b00010,READ = 5'b00100,WRITE = 5'b01000,TRISTATE= 5'b10000} state;

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
                    if(ALE && CS)
                        NS = START;

                end

        START : begin
                    if(!wrb)
                        NS = WRITE;
                    else if(!rdb)
                        NS=READ;
                end

        WRITE : NS = TRISTATE;

        READ : NS = TRISTATE;

        TRISTATE : NS = INITIAL;
	default: NS = PS;

        endcase
end


//OUTPUT LOGIC
always_comb
begin
{OEb, WR_RDb, load}='0;
unique case(PS)

    START :   load='1;

    READ  :   OEb = '1;

    WRITE :   WR_RDb = '1;

    default : {OEb, WR_RDb, load}='0;
endcase

end

endmodule
