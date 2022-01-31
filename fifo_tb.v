module tb;

logic clk=0,rst=1,wr=0,rd=0;//rdNBA=0,wrNBA=0;
  logic [7:0] din=0;//dinNBA=0;

logic  [7:0] dout;
logic  [3:0] wrptr,rdptr;
logic  housefull,nostock;

fifo f1 (clk,rst,wr,rd,wrptr,rdptr,din,dout,housefull,nostock);

always #5 clk = !clk;
initial #2 rst = 0;
  
initial begin
  $dumpfile("dump.vcd"); $dumpvars;
end

enum {EMPTY,PARTIAL,FULL} state_txt;
always @*
begin
	case(tb.f1.state)
		0 : state_txt = EMPTY;
		1 : state_txt = PARTIAL;
		2 : state_txt = FULL;
	endcase
end

initial begin
	#55;
	repeat(5)
	begin
		wr = 1; din = $random;
		#10; wr = 0;
		#50;
	end
	
	repeat(5)
	begin
		rd = 1; #10; rd = 0;
		#50;
	end
	
	$stop;
	
	repeat(5)
	begin
		rd = 1; #10; rd = 0;
		#50;
	end
	
	repeat(14)
	begin
		wr = 1; #10; wr = 0;
		#50;
	end
	
	$finish;
end
endmodule
