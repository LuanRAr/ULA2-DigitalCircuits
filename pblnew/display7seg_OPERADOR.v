// Módulo para conversão de binário para display de 7 segmentos
module display7seg_OPERADOR(
  input [2:0] bin,    // Entrada binária de 4 bits (0-15)
  output [6:0] seg     // Saída para 7 segmentos (a,b,c,d,e,f,g)
);

  // Inversões dos bits de entrada
  wire n2, n1, n0;
  not inv2(n2, bin[2]);
  not inv1(n1, bin[1]);
  not inv0(n0, bin[0]);
  

  // Decodificação para cada dígito
  wire dig_soma, dig_sub, dig_or, dig_and, dig_xor, dig_mult, dig_div, dig_nusado, dig8, dig9;
  wire digA, digB, digC, digD, digE, digF;
  
  // Dígito soma: 000
  and and_dig(dig_soma, n2, n1, n0);
  
  // Dígito sub: 001
  and and_dig_sub(dig_sub, n2, n1, bin[0]);
  
  // Dígito OR: 010
  and and_dig_or(dig_or, n2, bin[1], n0);
  
  // Dígito AND: 011
  and and_dig_and(dig_and, n2, bin[1], bin[0]);
  
  // Dígito XOR: 100
  and and_dig_xor(dig_xor, bin[2], n1, n0);
  
  // Dígito MULT: 101
  and and_dig_mult(dig_mult, bin[2], n1, bin[0]);
  
  // Dígito DIV: 110
  and and_dig_div(dig_div, bin[2], bin[1], n0);
  
  // Dígito N USADO: 111
  and and_dig_nusado(dig_nusado, bin[2], bin[1], bin[0]);
  
  
  
  // Padrões dos segmentos para ânodo comum (ativo baixo)
  // Formato: {g, f, e, d, c, b, a}
  
  // Segmento a (bit 0) - acende para: 0,2,3,5,6,7,8,9,A,C,E,F
  //or seg_a(seg[0], dig_soma, dig_or, dig_and, dig_mult, dig_div, dig_nusado, dig8, dig9, digA, digC, digE, digF);
	 or seg_a(seg[0], dig_sub,dig_or,dig_mult,dig_nusado);
  
  // Segmento b (bit 1) - acende para: 0,1,2,3,4,7,8,9,A,D
  //or seg_b(seg[1], dig_soma, dig_sub, dig_or, dig_and, dig_xor, dig_nusado, dig8, dig9, digA, digD);
	 or seg_b(seg[1], dig_soma,dig_sub,dig_or,dig_xor,dig_mult);
  
  // Segmento c (bit 2) - acende para: 0,1,3,4,5,6,7,8,9,A,B,D
  //or seg_c(seg[2], dig_soma, dig_sub, dig_and, dig_xor, dig_mult, dig_div, dig_nusado, dig8, dig9, digA, digB, digD);
	 or seg_c(seg[2], dig_sub,dig_mult);
  
  // Segmento d (bit 3) - acende para: 0,2,3,5,6,8,9,B,C,D,E
  //or seg_d(seg[3], dig_soma, dig_or, dig_and, dig_mult, dig_div, dig8, dig9, digB, digC, digD, digE);
	 or seg_d(seg[3], dig_sub,dig_and ,dig_nusado,dig_mult);
  
  // Segmento e (bit 4) - acende para: 0,2,6,8,A,B,C,D,E,F
  //or seg_e(seg[4], dig_soma, dig_or, dig_div, dig8, digA, digB, digC, digD, digE, digF);
	 or seg_e(seg[4], dig_soma,dig_sub,dig_nusado);
  
  // Segmento f (bit 5) - acende para: 0,4,5,6,8,9,A,B,C,E,F
  //or seg_f(seg[5], dig_soma, dig_xor, dig_mult, dig_div, dig8, dig9, digA, digB, digC, digE, digF);
	 or seg_f(seg[5], dig_sub,dig_or,dig_xor,dig_nusado );
  
  // Segmento g (bit 6) - acende para: 2,3,4,5,6,8,9,A,B,D,E,F
  //or seg_g(seg[6], dig_or, dig_and, dig_xor, dig_mult, dig_div, dig8, dig9, digA, digB, digD, digE, digF);
	 or seg_g(seg[6],dig_nusado );

endmodule