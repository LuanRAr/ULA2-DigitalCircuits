// Módulo para conversão de binário para display de 7 segmentos
module display7seg(
    input  [3:0] bin,        // Entrada binária de 4 bits (0-15)
    output [6:0] seg         // Saída para 7 segmentos (a,b,c,d,e,f,g)
);

    // Inversões dos bits de entrada
    wire n3, n2, n1, n0;
    not inv3(n3, bin[3]);
    not inv2(n2, bin[2]);
    not inv1(n1, bin[1]);
    not inv0(n0, bin[0]);
    
    // Decodificação para cada dígito
    wire dig0, dig1, dig2, dig3, dig4, dig5, dig6, dig7, dig8, dig9;
    wire digA, digB, digC, digD, digE, digF;
    
    // Dígito 0: 0000
    and and_dig0(dig0, n3, n2, n1, n0);
    
    // Dígito 1: 0001
    and and_dig1(dig1, n3, n2, n1, bin[0]);
    
    // Dígito 2: 0010
    and and_dig2(dig2, n3, n2, bin[1], n0);
    
    // Dígito 3: 0011
    and and_dig3(dig3, n3, n2, bin[1], bin[0]);
    
    // Dígito 4: 0100
    and and_dig4(dig4, n3, bin[2], n1, n0);
    
    // Dígito 5: 0101
    and and_dig5(dig5, n3, bin[2], n1, bin[0]);
    
    // Dígito 6: 0110
    and and_dig6(dig6, n3, bin[2], bin[1], n0);
    
    // Dígito 7: 0111
    and and_dig7(dig7, n3, bin[2], bin[1], bin[0]);
    
    // Dígito 8: 1000
    and and_dig8(dig8, bin[3], n2, n1, n0);
    
    // Dígito 9: 1001
    and and_dig9(dig9, bin[3], n2, n1, bin[0]);
    
    // Dígito A (10): 1010
    and and_digA(digA, bin[3], n2, bin[1], n0);
    
    // Dígito b (11): 1011
    and and_digB(digB, bin[3], n2, bin[1], bin[0]);
    
    // Dígito C (12): 1100
    and and_digC(digC, bin[3], bin[2], n1, n0);
    
    // Dígito d (13): 1101
    and and_digD(digD, bin[3], bin[2], n1, bin[0]);
    
    // Dígito E (14): 1110
    and and_digE(digE, bin[3], bin[2], bin[1], n0);
    
    // Dígito F (15): 1111
	 
	 
    and and_digF(digF, bin[3], bin[2], bin[1], bin[0]);
    
    // Padrões dos segmentos para ânodo comum (ativo baixo)
    // Formato: {g, f, e, d, c, b, a}
    
    // Segmento a (bit 0) - acende para: 0,2,3,5,6,7,8,9,A,C,E,F
    //or seg_a(seg[0], dig0, dig2, dig3, dig5, dig6, dig7, dig8, dig9, digA, digC, digE, digF);
	 or seg_a(seg[0], dig1, dig4, digB, digD);
    
    // Segmento b (bit 1) - acende para: 0,1,2,3,4,7,8,9,A,D
    //or seg_b(seg[1], dig0, dig1, dig2, dig3, dig4, dig7, dig8, dig9, digA, digD);
	 or seg_b(seg[1], dig5, dig6, digB, digC, digE,digF);
    
    // Segmento c (bit 2) - acende para: 0,1,3,4,5,6,7,8,9,A,B,D
    //or seg_c(seg[2], dig0, dig1, dig3, dig4, dig5, dig6, dig7, dig8, dig9, digA, digB, digD);
	 or seg_c(seg[2], dig2, digC, digE, digF);
    
    // Segmento d (bit 3) - acende para: 0,2,3,5,6,8,9,B,C,D,E
    //or seg_d(seg[3], dig0, dig2, dig3, dig5, dig6, dig8, dig9, digB, digC, digD, digE);
	 or seg_d(seg[3], dig1, dig4, dig7, digA, digF);
    
    // Segmento e (bit 4) - acende para: 0,2,6,8,A,B,C,D,E,F
    //or seg_e(seg[4], dig0, dig2, dig6, dig8, digA, digB, digC, digD, digE, digF);
	 or seg_e(seg[4], dig1, dig3, dig4, dig5, dig7, dig9);
    
    // Segmento f (bit 5) - acende para: 0,4,5,6,8,9,A,B,C,E,F
    //or seg_f(seg[5], dig0, dig4, dig5, dig6, dig8, dig9, digA, digB, digC, digE, digF);
	 or seg_f(seg[5], dig1, dig2, dig3, dig7);
    
    // Segmento g (bit 6) - acende para: 2,3,4,5,6,8,9,A,B,D,E,F
    //or seg_g(seg[6], dig2, dig3, dig4, dig5, dig6, dig8, dig9, digA, digB, digD, digE, digF);
	 or seg_g(seg[6], dig0, dig1, digC,dig7);

endmodule