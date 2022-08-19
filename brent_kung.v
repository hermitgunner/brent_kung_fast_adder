module brent_kung(
	input [15:0] A,B,
	input cin,
	output [15:0] Add_Out,
	output Cout
);



	wire [15:0]p0i,g0i;
	wire [7:0] p1i,g1i;
	wire [3:0] p2i,g2i;
	wire [1:0] p3i,g3i;
	wire 	   p4i,g4i;

	assign p0i = A ^ B;
	assign g0i = A & B;


	// level 1
	genvar i;
	generate
	for(i = 0; i < 8; i = i+1)
		begin : lev1 
			a_plus_bc l1 (g0i[2*i+1],g0i[2*i],p0i[2*i+1],g1i[i]);
			anda l1a (p1i[i],p0i[2*i+1],p0i[2*i]);
		end
	endgenerate
	
	// level 2
	genvar j;
	generate
	for(j = 0; j < 4; j = j+1)
		begin : lev2
			a_plus_bc l2 (g1i[2*j+1],g1i[2*j],p1i[2*j+1],g2i[j]);
			anda l2a (p2i[j],p1i[2*j+1],p1i[2*j]);
		end
	endgenerate
	
	// level 3
	genvar k;
	generate
	for(k = 0; k < 2; k = k+1)
		begin : lev3
			a_plus_bc l3 (g2i[2*k+1],g2i[2*k],p2i[2*k+1],g3i[k]);
			anda l3a (p3i[k],p2i[2*k+1],p2i[2*k]);
		end
	endgenerate
		
	a_plus_bc l4 (g3i[1],g3i[0],p3i[1],g4i);
	and l4a (p4i,p3i[1],p3i[0]);


	wire [16:1] carry;
	// Iter 0	
			   // can we make this '0' as carryin from ports?
	a_plus_bc carry16( g4i , p4i  ,cin,carry[16]);
	a_plus_bc carry8 (g3i[0],p3i[0],cin,carry[8]);
	a_plus_bc carry4 (g2i[0],p2i[0],cin,carry[4]);
	a_plus_bc carry2 (g1i[0],p1i[0],cin,carry[2]);
	a_plus_bc carry1 (g0i[0],p0i[0],cin,carry[1]);

	// Iter 1
	a_plus_bc carry3 (g0i[2],p0i[2],carry[2],carry[3]);
	a_plus_bc carry5 (g0i[4],p0i[4],carry[4],carry[5]);
	a_plus_bc carry6 (g1i[2],p1i[2],carry[4],carry[6]);
	a_plus_bc carry9 (g0i[8],p0i[8],carry[8],carry[9]);
		//a_plus_bc carry12 (g2i[1],p2i[1],carry[8],carry[12]);
		a_plus_bc carry12 (g2i[2],p2i[2],carry[8],carry[12]);
	
	// Iter 2
	a_plus_bc carry7 (g0i[6],p0i[6],carry[6],carry[7]);
	a_plus_bc carry10 (g0i[9],p0i[9],carry[9],carry[10]);
	a_plus_bc carry13 (g0i[12],p0i[12],carry[12],carry[13]);
	a_plus_bc carry14 (g1i[6],p1i[6],carry[12],carry[14]);
	
	// Iter 3
	a_plus_bc carry11 (g0i[10],p0i[10],carry[10],carry[11]);
	a_plus_bc carry15 (g0i[14],p0i[14],carry[14],carry[15]);

	assign Add_Out = p0i ^ {carry[15:1] , cin}; 
	assign Cout = carry[16];


endmodule

module anda (
	output andO,
	input a,b
	);
	
	assign andO = a & b;

endmodule


module a_plus_bc (
	input a,b,c,
	output g
	);

	assign g = a | (b&c);

endmodule