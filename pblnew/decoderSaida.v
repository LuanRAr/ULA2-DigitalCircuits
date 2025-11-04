module decoderSaida(
    input [3:0] S,
    output [6:0] segments
);
    //Inversores
    wire S3_n, S2_n, S1_n, S0_n;
    not nS3(S3_n, S[3]);
    not nS2(S2_n, S[2]);
    not nS1(S1_n, S[1]);
    not nS0(S0_n, S[0]);

    //Segmento a
    wire a0, a1, a2, a3;
    and and_a0(a0, S3_n, S2_n, S1_n, S[0]);
    and and_a1(a1, S3_n, S[2], S1_n, S0_n);
    and and_a2(a2, S[3], S2_n, S[1], S[0]);
    and and_a3(a3, S[3], S[2], S1_n, S[0]);
    or or_a(segments[6], a0, a1, a2, a3);

    //Segmento b
    wire b0, b1, b2, b3;
	 and and_b0(b0, S3_n, S1_n, S[0]);
	 and and_b1(b1, S[2], S[1], S0_n);
	 and and_b2(b2, S[3], S[1], S[0]);
	 and and_b3(b3, S[3], S[2], S0_n);
	 or or_b(segments[5], b0, b1, b2, b3);

    //Segmento c
    wire c0, c1, c2, c3;
    and and_c0(c0, S3_n, S2_n, S1_n, S[0]);
    and and_c1(c1, S3_n, S2_n, S[1], S0_n);
    and and_c2(c2, S[3], S[2], S0_n);
	 and and_c3(c3, S[3], S[2], S[1]);
    or or_c(segments[4], c0, c1, c2, c3);

    //Segmento d
    wire d0, d1, d2, d3, d4;
    and and_d0(d0, S2_n, S1_n, S[0]);
    and and_d1(d1, S3_n, S[2], S1_n, S0_n);
    and and_d2(d2, S[2], S[1], S[0]);
	 and and_d3(d3, S[3], S2_n, S1_n, S[0]);
	 and and_d4(d4, S[3], S2_n, S[1], S0_n);
    or or_d(segments[3], d0, d1, d2, d3, d4);

    //Segmento e
    wire e0, e1, e2;
    and and_e0(e0, S3_n, S[1], S[0]);
    and and_e1(e1, S3_n, S[2], S1_n);
	 and and_e2(e2, S[3], S2_n, S1_n, S[0]);
    or or_e(segments[2], e0, e1, e2);

    //Segmento f
    wire f0, f1, f2;
    and and_f0(f0, S3_n, S2_n, S[1]);
    and and_f1(f1, S3_n, S[1], S[0]);
	 and and_f2(f2, S[3], S[2], S1_n, S[0]);
    or or_f(segments[1], f0, f1, f2);

    //Segmento g
    wire g0, g1, g2;
    and and_g0(g0, S3_n, S2_n, S1_n);
    and and_g1(g1, S3_n, S[2], S[1], S[0]);
    and and_g2(g2, S[3], S[2], S1_n, S0_n);
    or or_g(segments[0], g0, g1, g2);

endmodule
