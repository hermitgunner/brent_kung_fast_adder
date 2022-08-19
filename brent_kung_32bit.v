`include "brent_kung.v"

module brent_kung32(
	input [31:0] a,b,
	input cin,
	output [31:0] sum,
	output cout
);

	wire cout_int;

	brent_kung bk0 (a[15:0],b[15:0],cin,sum[15:0],cout_int);
	brent_kung bk1 (a[31:16],b[31:16],cout_int,sum[31:16],cout);


endmodule