module main(
    input [7:0] bin,
    input [1:0] sel,     // 00 binToOct, 01 binToHex, 10 binToDec
    output [6:0] segmentsUn,
    output [6:0] segmentsDez,
	 output [6:0] segmentsCen
);

    wire [6:0] C_oct, D_oct, U_oct, C_hex, D_hex, U_hex, C_dec, D_dec, U_dec;

    binToOct convOct(.result(bin), .segmentsUn(U_oct), .segmentsDez(D_oct), .segmentsCen(C_oct));
    binToHex convHex(.result(bin), .segmentsUn(U_hex), .segmentsDez(D_hex), .segmentsCen(C_hex));
    binToBcd convBcd(.S(bin), .segmentsUn(U_dec), .segmentsDez(D_dec), .segmentsCen(C_dec));

	//centena
	 wire [3:0] C_mux;	
    mux4to1 muxC0(C_oct[0], C_hex[0], C_dec[0], 1'b1, sel, segmentsCen[0]);
    mux4to1 muxC1(C_oct[1], C_hex[1], C_dec[1], 1'b1, sel, segmentsCen[1]);
    mux4to1 muxC2(C_oct[2], C_hex[2], C_dec[2], 1'b1, sel, segmentsCen[2]);
    mux4to1 muxC3(C_oct[3], C_hex[3], C_dec[3], 1'b1, sel, segmentsCen[3]);
	 mux4to1 muxC4(C_oct[4], C_hex[4], C_dec[4], 1'b1, sel, segmentsCen[4]);
	 mux4to1 muxC5(C_oct[5], C_hex[5], C_dec[5], 1'b1, sel, segmentsCen[5]);
	 mux4to1 muxC6(C_oct[6], C_hex[6], C_dec[6], 1'b1, sel, segmentsCen[6]);


    //Dezena
    wire [3:0] D_mux;
    mux4to1 muxD0(D_oct[0], D_hex[0], D_dec[0], 1'b1, sel, segmentsDez[0]);
    mux4to1 muxD1(D_oct[1], D_hex[1], D_dec[1], 1'b1, sel, segmentsDez[1]);
    mux4to1 muxD2(D_oct[2], D_hex[2], D_dec[2], 1'b1, sel, segmentsDez[2]);
    mux4to1 muxD3(D_oct[3], D_hex[3], D_dec[3], 1'b1, sel, segmentsDez[3]);
	 mux4to1 muxD4(D_oct[4], D_hex[4], D_dec[4], 1'b1, sel, segmentsDez[4]);
	 mux4to1 muxD5(D_oct[5], D_hex[5], D_dec[5], 1'b1, sel, segmentsDez[5]);
	 mux4to1 muxD6(D_oct[6], D_hex[6], D_dec[6], 1'b1, sel, segmentsDez[6]);


    //unidade
    wire [3:0] U_mux;
    mux4to1 muxU0(U_oct[0], U_hex[0], U_dec[0], 1'b1, sel, segmentsUn[0]);
    mux4to1 muxU1(U_oct[1], U_hex[1], U_dec[1], 1'b1, sel, segmentsUn[1]);
    mux4to1 muxU2(U_oct[2], U_hex[2], U_dec[2], 1'b1, sel, segmentsUn[2]);
    mux4to1 muxU3(U_oct[3], U_hex[3], U_dec[3], 1'b1, sel, segmentsUn[3]);
	 mux4to1 muxU4(U_oct[4], U_hex[4], U_dec[4], 1'b1, sel, segmentsUn[4]);
	 mux4to1 muxU5(U_oct[5], U_hex[5], U_dec[5], 1'b1, sel, segmentsUn[5]);
	 mux4to1 muxU6(U_oct[6], U_hex[6], U_dec[6], 1'b1, sel, segmentsUn[6]);

endmodule