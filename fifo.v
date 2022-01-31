module fifo(clk,rst,wr,rd,wrptr,rdptr,din,dout,housefull,nostock);
input clk,rst,wr,rd;
input [7:0] din;

output reg [7:0] dout;
output reg [3:0] wrptr,rdptr;
output wire housefull,nostock;

wire [3:0] wrptrplus1,rdptrplus1;
parameter EMPTY=0,PARTIAL=1,FULL=2;
reg [1:0] state;
integer i;

reg [7:0] Box [1:10];

always @ (posedge clk or posedge rst)
begin
	if(rst)
		for(i=1;i<=10;i=i+1) Box[i] <= 0;
    else
		case(state)
			EMPTY,PARTIAL : Box[wrptr] <= wr ? din : Box[wrptr];
		endcase	
end

always @ (posedge clk or posedge rst)
begin
	if(rst) dout <= 0;
    else
		case(state)
			PARTIAL,FULL : dout <= rd ? Box[rdptr] : dout;
		endcase	
end

always @ (posedge clk or posedge rst)
begin
	if(rst) state <= EMPTY;
    else
		case(state)
			EMPTY : state <= wr ? PARTIAL : EMPTY;
			PARTIAL : if(wr && wrptrplus1 == rdptr) state <= FULL;
					  else if(rd && rdptrplus1 == rdptr) state <= EMPTY;
					  else state <= PARTIAL;
			FULL : state <= rd ? PARTIAL : FULL;
		endcase	
end

assign housefull = (state == FULL);
assign nostock = (state == EMPTY);

always @ (posedge clk or posedge rst)
begin
	if(rst) rdptr <= 1;
    else
		case(state)
			EMPTY : rdptr <= rdptr;
			PARTIAL,FULL : rdptr <= rd ? rdptrplus1 : rdptr;
		endcase	
end

assign wrptrplus1 = (wrptr == 10) ? 1 : wrptr+1;
assign rdptrplus1 = (rdptr == 10) ? 1 : rdptr+1;

always @ (posedge clk or posedge rst)
begin
	if(rst) wrptr <= 1;
    else
		case(state)
			EMPTY,PARTIAL : wrptr <= wr ? wrptrplus1 : wrptr;
			FULL : wrptr <= wrptr;
		endcase	
end

endmodule
