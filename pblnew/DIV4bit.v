// DIV4bit - estrutural corrigido (sem múltiplos drivers)
module DIV4bit(
    input  [3:0] A, B,
    output [3:0] Quotient,
    output [3:0] Remainder,
    output       Error
);

    // detecta B == 0
    wire nB0, nB1, nB2, nB3;
    not inv_b0(nB0, B[0]);
    not inv_b1(nB1, B[1]);
    not inv_b2(nB2, B[2]);
    not inv_b3(nB3, B[3]);
    wire B_zero;
    and and_bzero(B_zero, nB0, nB1, nB2, nB3);
    buf buf_err(Error, B_zero);

    // enable = ~B_zero (para bloquear operações quando divisor = 0)
    wire not_B_zero;
    not inv_bzero(not_B_zero, B_zero);

    // detectores simples de divisores 1,2,4,8
    wire B_one, B_two, B_four, B_eight;
    and and_b1(B_one, B[0], nB1, nB2, nB3);     // 0001
    and and_b2(B_two, nB0, B[1], nB2, nB3);     // 0010
    and and_b4(B_four, nB0, nB1, B[2], nB3);    // 0100
    and and_b8(B_eight, nB0, nB1, nB2, B[3]);   // 1000

    // other_div = quando B não é 0 nem 1,2,4,8
    wire not_B_one, not_B_two, not_B_four, not_B_eight;
    not inv_not_b1(not_B_one, B_one);
    not inv_not_b2(not_B_two, B_two);
    not inv_not_b4(not_B_four, B_four);
    not inv_not_b8(not_B_eight, B_eight);
    wire other_div;
    and and_other(other_div, not_B_one, not_B_two, not_B_four, not_B_eight, not_B_zero);

    // --- Criar sinais intermediários para cada contribuição do quociente ---
    // bit 0 contributions
    wire q0_d1, q0_d2, q0_d4, q0_d8, q0_dother;
    and q0_div1(q0_d1, A[0], B_one, not_B_zero);      // A when B==1
    and q0_div2(q0_d2, A[1], B_two, not_B_zero);      // A>>1 when B==2
    and q0_div4(q0_d4, A[2], B_four, not_B_zero);     // A>>2 when B==4
    and q0_div8(q0_d8, A[3], B_eight, not_B_zero);    // A>>3 when B==8
    and q0_divother(q0_dother, 1'b0, other_div);      // 0 for other_div (simplificado)

    or or_q0(Quotient[0], q0_d1, q0_d2, q0_d4, q0_d8, q0_dother);

    // bit 1 contributions
    wire q1_d1, q1_d2, q1_d4, q1_d8, q1_dother;
    and q1_div1(q1_d1, A[1], B_one, not_B_zero);
    and q1_div2(q1_d2, A[2], B_two, not_B_zero);
    and q1_div4(q1_d4, A[3], B_four, not_B_zero);
    and q1_div8(q1_d8, 1'b0, B_eight, not_B_zero);
    and q1_divother(q1_dother, 1'b0, other_div);
    or or_q1(Quotient[1], q1_d1, q1_d2, q1_d4, q1_d8, q1_dother);

    // bit 2 contributions
    wire q2_d1, q2_d2, q2_d4, q2_d8, q2_dother;
    and q2_div1(q2_d1, A[2], B_one, not_B_zero);
    and q2_div2(q2_d2, A[3], B_two, not_B_zero);
    and q2_div4(q2_d4, 1'b0, B_four, not_B_zero);
    and q2_div8(q2_d8, 1'b0, B_eight, not_B_zero);
    and q2_divother(q2_dother, 1'b0, other_div);
    or or_q2(Quotient[2], q2_d1, q2_d2, q2_d4, q2_d8, q2_dother);

    // bit 3 contributions
    wire q3_d1, q3_d2, q3_d4, q3_d8, q3_dother;
    and q3_div1(q3_d1, A[3], B_one, not_B_zero);
    and q3_div2(q3_d2, 1'b0, B_two, not_B_zero);
    and q3_div4(q3_d4, 1'b0, B_four, not_B_zero);
    and q3_div8(q3_d8, 1'b0, B_eight, not_B_zero);
    and q3_divother(q3_dother, 1'b0, other_div);
    or or_q3(Quotient[3], q3_d1, q3_d2, q3_d4, q3_d8, q3_dother);

    // --- Remainder: mesmos princípios (contribuições) ---
    // r0
    wire r0_d1, r0_d2, r0_d4, r0_d8, r0_dother;
    and r0_div1(r0_d1, 1'b0, B_one, not_B_zero);  // remainder 0 if B==1
    and r0_div2(r0_d2, A[0], B_two, not_B_zero);
    and r0_div4(r0_d4, A[0], B_four, not_B_zero);
    and r0_div8(r0_d8, A[0], B_eight, not_B_zero);
    and r0_divother(r0_dother, A[0], other_div);
    or or_r0(Remainder[0], r0_d1, r0_d2, r0_d4, r0_d8, r0_dother);

    // r1
    wire r1_d1, r1_d2, r1_d4, r1_d8, r1_dother;
    and r1_div1(r1_d1, 1'b0, B_one, not_B_zero);
    and r1_div2(r1_d2, 1'b0, B_two, not_B_zero);
    and r1_div4(r1_d4, A[1], B_four, not_B_zero);
    and r1_div8(r1_d8, A[1], B_eight, not_B_zero);
    and r1_divother(r1_dother, A[1], other_div);
    or or_r1(Remainder[1], r1_d1, r1_d2, r1_d4, r1_d8, r1_dother);

    // r2
    wire r2_d1, r2_d2, r2_d4, r2_d8, r2_dother;
    and r2_div1(r2_d1, 1'b0, B_one, not_B_zero);
    and r2_div2(r2_d2, 1'b0, B_two, not_B_zero);
    and r2_div4(r2_d4, 1'b0, B_four, not_B_zero);
    and r2_div8(r2_d8, A[2], B_eight, not_B_zero);
    and r2_divother(r2_dother, A[2], other_div);
    or or_r2(Remainder[2], r2_d1, r2_d2, r2_d4, r2_d8, r2_dother);

    // r3
    wire r3_d1, r3_d2, r3_d4, r3_d8, r3_dother;
    and r3_div1(r3_d1, 1'b0, B_one, not_B_zero);
    and r3_div2(r3_d2, 1'b0, B_two, not_B_zero);
    and r3_div4(r3_d4, 1'b0, B_four, not_B_zero);
    and r3_div8(r3_d8, 1'b0, B_eight, not_B_zero);
    and r3_divother(r3_dother, A[3], other_div);
    or or_r3(Remainder[3], r3_d1, r3_d2, r3_d4, r3_d8, r3_dother);

endmodule