module binToHex(
    input [7:0] result,
    output [6:0] segmentsUn,
    output [6:0] segmentsDez,
	 output [6:0] segmentsCen
);
    wire [3:0] s0;   //decoder 0
    wire [3:0] s1;   //decoder 1
	 wire [3:0] s2;   //decoder 2

    //display das unidades
    buf u3(s0[3], result[3]);
    buf u2(s0[2], result[2]);
    buf u1(s0[1], result[1]);
    buf u0(s0[0], result[0]);

    //display das dezenas
    buf d3(s1[3], result[7]);
    buf d2(s1[2], result[6]);
    buf d1(s1[1], result[5]);
    buf d0(s1[0], result[4]);
	 
	 //display das centenas
	 buf c3(s2[3], 1'b0);
    buf c2(s2[2], 1'b0);
    buf c1(s2[1], 1'b0);
    buf c0(s2[0], 1'b0);

    decoderSaida dec0 (.S(s0), .segments(segmentsUn)); //unidades (bits 3–0)
    decoderSaida dec1 (.S(s1), .segments(segmentsDez)); //dezenas (bits 7–4)
	 decoderSaida dec2 (.S(s2), .segments(segmentsCen)); //centenas

endmodule