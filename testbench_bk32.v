`include "brent_kung_32bit.v"

module testbench;

	reg [31:0] a,b;
	reg cin;
	wire [31:0] out;
	wire cout;

	brent_kung32 test (a,b,cin,out, cout);
	
		integer i,j,err_flag;
	initial begin 
		
		cin = 0;

		$dumpfile("test.vcd");
		$dumpvars(0, testbench);

		#10 a = 1024; b = 1023;
		#10 $display ("a = %d, b = %d , a*b = %d , out = %d\n", a,b,i*j,out);
		for(i = 0; i < 2**15; i = i + 1)

			for (j = 0; j < 2**15; j = j + 1)
			begin
				 a = i; 
				 b = j;
				#10 $display ("a = %d, b = %d , a+b = %d , out = %d & cout = %d\n", a,b,i+j,out,cout);
				if (!(i+j)==out) begin
					$display("ERROR");
					$stop;
				end	
			end
	end
endmodule