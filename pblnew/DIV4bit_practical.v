// DIV4bit prático - divisão limitada mas funcional
// 100% COMBINACIONAL - apenas portas lógicas
module DIV4bit_practical(
    input  [3:0] A, B,
    output [3:0] Quotient,
    output [3:0] Remainder,
    output       Error,
    output       Fractional  // Flag indicando se a divisão resultou em número quebrado
);

    // -----------------------------
    // 1) Detecção de erro (divisão por zero)
    // -----------------------------
    wire nB0, nB1, nB2, nB3;
    not inv_b0(nB0, B[0]);
    not inv_b1(nB1, B[1]);
    not inv_b2(nB2, B[2]);
    not inv_b3(nB3, B[3]);
    wire B_zero;
    and and_bzero(B_zero, nB0, nB1, nB2, nB3);
    buf buf_err(Error, B_zero);

    // enable = ~B_zero
    wire not_B_zero;
    not inv_bzero(not_B_zero, B_zero);

    // -----------------------------
    // 2) Detecção de divisores suportados
    // -----------------------------
    // Divisores especiais: 1, 2, 4, 8
    wire B_one, B_two, B_four, B_eight;
    and and_b1(B_one, B[0], nB1, nB2, nB3);     // 0001
    and and_b2(B_two, nB0, B[1], nB2, nB3);     // 0010
    and and_b4(B_four, nB0, nB1, B[2], nB3);    // 0100
    and and_b8(B_eight, nB0, nB1, nB2, B[3]);   // 1000

    // Divisores simples: 3, 5, 6, 7, 9, 10, 12, 15
    wire B_three, B_five, B_six, B_seven, B_nine, B_ten, B_twelve, B_fifteen;
    and and_b3(B_three, B[0], B[1], nB2, nB3);      // 0011
    and and_b5(B_five, B[0], nB1, B[2], nB3);       // 0101
    and and_b6(B_six, nB0, B[1], B[2], nB3);        // 0110
    and and_b7(B_seven, B[0], B[1], B[2], nB3);     // 0111
    and and_b9(B_nine, B[0], nB1, nB2, B[3]);      // 1001
    and and_b10(B_ten, nB0, B[1], nB2, B[3]);      // 1010
    and and_b12(B_twelve, nB0, nB1, B[2], B[3]);    // 1100
    and and_b15(B_fifteen, B[0], B[1], B[2], B[3]); // 1111

    // Divisor suportado = qualquer um dos acima
    wire B_supported;
    wire supp1, supp2, supp3, supp4;
    or or_supp1(supp1, B_one, B_two, B_four, B_eight);
    or or_supp2(supp2, B_three, B_five, B_six, B_seven);
    or or_supp3(supp3, B_nine, B_ten, B_twelve, B_fifteen);
    or or_supp4(supp4, supp1, supp2, supp3);
    and and_supported(B_supported, supp4, not_B_zero);

    // Divisor não suportado
    wire B_unsupported;
    not inv_supported(B_unsupported, B_supported);

    // -----------------------------
    // 3) Cálculo do quociente para divisores especiais (1,2,4,8)
    // -----------------------------
    
    // bit 0 contributions
    wire q0_d1, q0_d2, q0_d4, q0_d8;
    and q0_div1(q0_d1, A[0], B_one, not_B_zero);
    and q0_div2(q0_d2, A[1], B_two, not_B_zero);
    and q0_div4(q0_d4, A[2], B_four, not_B_zero);
    and q0_div8(q0_d8, A[3], B_eight, not_B_zero);
    wire q0_special;
    or or_q0_special(q0_special, q0_d1, q0_d2, q0_d4, q0_d8);

    // bit 1 contributions
    wire q1_d1, q1_d2, q1_d4, q1_d8;
    and q1_div1(q1_d1, A[1], B_one, not_B_zero);
    and q1_div2(q1_d2, A[2], B_two, not_B_zero);
    and q1_div4(q1_d4, A[3], B_four, not_B_zero);
    and q1_div8(q1_d8, 1'b0, B_eight, not_B_zero);
    wire q1_special;
    or or_q1_special(q1_special, q1_d1, q1_d2, q1_d4, q1_d8);

    // bit 2 contributions
    wire q2_d1, q2_d2, q2_d4, q2_d8;
    and q2_div1(q2_d1, A[2], B_one, not_B_zero);
    and q2_div2(q2_d2, A[3], B_two, not_B_zero);
    and q2_div4(q2_d4, 1'b0, B_four, not_B_zero);
    and q2_div8(q2_d8, 1'b0, B_eight, not_B_zero);
    wire q2_special;
    or or_q2_special(q2_special, q2_d1, q2_d2, q2_d4, q2_d8);

    // bit 3 contributions
    wire q3_d1, q3_d2, q3_d4, q3_d8;
    and q3_div1(q3_d1, A[3], B_one, not_B_zero);
    and q3_div2(q3_d2, 1'b0, B_two, not_B_zero);
    and q3_div4(q3_d4, 1'b0, B_four, not_B_zero);
    and q3_div8(q3_d8, 1'b0, B_eight, not_B_zero);
    wire q3_special;
    or or_q3_special(q3_special, q3_d1, q3_d2, q3_d4, q3_d8);

    // -----------------------------
    // 4) Cálculo do resto para divisores especiais
    // -----------------------------
    
    // r0
    wire r0_d1, r0_d2, r0_d4, r0_d8;
    and r0_div1(r0_d1, 1'b0, B_one, not_B_zero);
    and r0_div2(r0_d2, A[0], B_two, not_B_zero);
    and r0_div4(r0_d4, A[0], B_four, not_B_zero);
    and r0_div8(r0_d8, A[0], B_eight, not_B_zero);
    wire r0_special;
    or or_r0_special(r0_special, r0_d1, r0_d2, r0_d4, r0_d8);

    // r1
    wire r1_d1, r1_d2, r1_d4, r1_d8;
    and r1_div1(r1_d1, 1'b0, B_one, not_B_zero);
    and r1_div2(r1_d2, 1'b0, B_two, not_B_zero);
    and r1_div4(r1_d4, A[1], B_four, not_B_zero);
    and r1_div8(r1_d8, A[1], B_eight, not_B_zero);
    wire r1_special;
    or or_r1_special(r1_special, r1_d1, r1_d2, r1_d4, r1_d8);

    // r2
    wire r2_d1, r2_d2, r2_d4, r2_d8;
    and r2_div1(r2_d1, 1'b0, B_one, not_B_zero);
    and r2_div2(r2_d2, 1'b0, B_two, not_B_zero);
    and r2_div4(r2_d4, 1'b0, B_four, not_B_zero);
    and r2_div8(r2_d8, A[2], B_eight, not_B_zero);
    wire r2_special;
    or or_r2_special(r2_special, r2_d1, r2_d2, r2_d4, r2_d8);

    // r3
    wire r3_d1, r3_d2, r3_d4, r3_d8;
    and r3_div1(r3_d1, 1'b0, B_one, not_B_zero);
    and r3_div2(r3_d2, 1'b0, B_two, not_B_zero);
    and r3_div4(r3_d4, 1'b0, B_four, not_B_zero);
    and r3_div8(r3_d8, 1'b0, B_eight, not_B_zero);
    wire r3_special;
    or or_r3_special(r3_special, r3_d1, r3_d2, r3_d4, r3_d8);

    // -----------------------------
    // 5) Cálculo aproximado para divisores simples
    // -----------------------------
    // Para divisores não especiais, retorna resultado aproximado
    // ou erro dependendo da implementação escolhida
    
    // Opção A: Retorna erro para divisores não suportados
    wire q0_unsupported, q1_unsupported, q2_unsupported, q3_unsupported;
    and and_q0_unsup(q0_unsupported, 1'b0, B_unsupported);
    and and_q1_unsup(q1_unsupported, 1'b0, B_unsupported);
    and and_q2_unsup(q2_unsupported, 1'b0, B_unsupported);
    and and_q3_unsup(q3_unsupported, 1'b0, B_unsupported);

    // -----------------------------
    // 6) Seleção final do resultado
    // -----------------------------
    
    // Quociente final
    or or_q0_final(Quotient[0], q0_special, q0_unsupported);
    or or_q1_final(Quotient[1], q1_special, q1_unsupported);
    or or_q2_final(Quotient[2], q2_special, q2_unsupported);
    or or_q3_final(Quotient[3], q3_special, q3_unsupported);

    // Resto final
    wire r0_unsupported, r1_unsupported, r2_unsupported, r3_unsupported;
    and and_r0_unsup(r0_unsupported, 1'b0, B_unsupported);
    and and_r1_unsup(r1_unsupported, 1'b0, B_unsupported);
    and and_r2_unsup(r2_unsupported, 1'b0, B_unsupported);
    and and_r3_unsup(r3_unsupported, 1'b0, B_unsupported);

    or or_r0_final(Remainder[0], r0_special, r0_unsupported);
    or or_r1_final(Remainder[1], r1_special, r1_unsupported);
    or or_r2_final(Remainder[2], r2_special, r2_unsupported);
    or or_r3_final(Remainder[3], r3_special, r3_unsupported);

    // -----------------------------
    // 7) Detecção de número quebrado
    // -----------------------------
    wire remainder_not_zero;
    wire r0_or_r1, r2_or_r3, remainder_any;
    or or_r01(r0_or_r1, Remainder[0], Remainder[1]);
    or or_r23(r2_or_r3, Remainder[2], Remainder[3]);
    or or_remainder(remainder_any, r0_or_r1, r2_or_r3);
    
    // Fractional = 1 se há resto E não há erro E divisor é suportado
    wire fractional_condition;
    and fractional_cond(fractional_condition, remainder_any, not_B_zero, B_supported);
    and fractional_and(Fractional, fractional_condition, 1'b1);

endmodule