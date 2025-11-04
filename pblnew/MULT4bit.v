// Módulo para multiplicação de 4 bits
// 100% COMBINACIONAL - apenas portas lógicas
// ESTRUTURA BÁSICA - LÓGICA SERÁ IMPLEMENTADA POSTERIORMENTE
module MULT4bit(
    input  [3:0] A, B,     // Entradas de 4 bits
    output [3:0] Result,   // Resultado da multiplicação (4 bits - apenas os menos significativos)
    output       Overflow  // Flag de overflow
);

    // Implementação da multiplicação usando algoritmo de multiplicação binária
    // A × B = Result (4 bits - apenas os menos significativos)
    
    // Produtos parciais (cada bit de A multiplicado por cada bit de B)
    wire p00, p01, p02, p03;  // A[0] × B[0,1,2,3]
    wire p10, p11, p12, p13;  // A[1] × B[0,1,2,3]
    wire p20, p21, p22, p23;  // A[2] × B[0,1,2,3]
    wire p30, p31, p32, p33;  // A[3] × B[0,1,2,3]
    
    // Produtos parciais usando portas AND
    and and00(p00, A[0], B[0]);
    and and01(p01, A[0], B[1]);
    and and02(p02, A[0], B[2]);
    and and03(p03, A[0], B[3]);
    
    and and10(p10, A[1], B[0]);
    and and11(p11, A[1], B[1]);
    and and12(p12, A[1], B[2]);
    and and13(p13, A[1], B[3]);
    
    and and20(p20, A[2], B[0]);
    and and21(p21, A[2], B[1]);
    and and22(p22, A[2], B[2]);
    and and23(p23, A[2], B[3]);
    
    and and30(p30, A[3], B[0]);
    and and31(p31, A[3], B[1]);
    and and32(p32, A[3], B[2]);
    and and33(p33, A[3], B[3]);
    
    // Somadores para calcular o resultado (apenas 4 bits)
    // Result[0] = p00
    buf res0(Result[0], p00);
    
    // Result[1] = p01 + p10 (soma simples)
    wire sum1_carry;
    wire sum1_result;
    // Meio somador para p01 + p10
    xor sum1_xor(sum1_result, p01, p10);
    and sum1_and(sum1_carry, p01, p10);
    buf res1(Result[1], sum1_result);
    
    // Result[2] = p02 + p11 + p20 + sum1_carry
    wire sum2_temp1, sum2_temp2, sum2_carry1, sum2_carry2;
    // Primeiro: p02 + p11
    xor sum2_xor1(sum2_temp1, p02, p11);
    and sum2_and1(sum2_carry1, p02, p11);
    // Segundo: sum2_temp1 + p20
    xor sum2_xor2(sum2_temp2, sum2_temp1, p20);
    and sum2_and2(sum2_carry2, sum2_temp1, p20);
    // Terceiro: sum2_temp2 + sum1_carry
    wire sum2_final, sum2_carry3;
    xor sum2_xor3(sum2_final, sum2_temp2, sum1_carry);
    and sum2_and3(sum2_carry3, sum2_temp2, sum1_carry);
    buf res2(Result[2], sum2_final);
    
    // Result[3] = p03 + p12 + p21 + p30 + sum2_carry1 + sum2_carry2 + sum2_carry3
    wire sum3_temp1, sum3_temp2, sum3_temp3, sum3_temp4, sum3_temp5, sum3_temp6;
    wire sum3_carry1, sum3_carry2, sum3_carry3, sum3_carry4, sum3_carry5, sum3_carry6;
    // Primeiro: p03 + p12
    xor sum3_xor1(sum3_temp1, p03, p12);
    and sum3_and1(sum3_carry1, p03, p12);
    // Segundo: sum3_temp1 + p21
    xor sum3_xor2(sum3_temp2, sum3_temp1, p21);
    and sum3_and2(sum3_carry2, sum3_temp1, p21);
    // Terceiro: sum3_temp2 + p30
    xor sum3_xor3(sum3_temp3, sum3_temp2, p30);
    and sum3_and3(sum3_carry3, sum3_temp2, p30);
    // Quarto: sum3_temp3 + sum2_carry1
    xor sum3_xor4(sum3_temp4, sum3_temp3, sum2_carry1);
    and sum3_and4(sum3_carry4, sum3_temp3, sum2_carry1);
    // Quinto: sum3_temp4 + sum2_carry2
    xor sum3_xor5(sum3_temp5, sum3_temp4, sum2_carry2);
    and sum3_and5(sum3_carry5, sum3_temp4, sum2_carry2);
    // Sexto: sum3_temp5 + sum2_carry3
    xor sum3_xor6(sum3_temp6, sum3_temp5, sum2_carry3);
    and sum3_and6(sum3_carry6, sum3_temp5, sum2_carry3);
    buf res3(Result[3], sum3_temp6);
    
    // Overflow: quando o resultado excede 15 (4 bits)
    // Calculamos o bit 4 (bit mais significativo) para detectar overflow
    // Bit 4 = p13 + p22 + p31 + sum3_carry1 + sum3_carry2 + sum3_carry3 + sum3_carry4 + sum3_carry5 + sum3_carry6
    wire sum4_temp1, sum4_temp2, sum4_temp3, sum4_temp4, sum4_temp5, sum4_temp6;
    wire sum4_carry1, sum4_carry2, sum4_carry3, sum4_carry4, sum4_carry5, sum4_carry6;
    
    // Primeiro: p13 + p22
    xor sum4_xor1(sum4_temp1, p13, p22);
    and sum4_and1(sum4_carry1, p13, p22);
    // Segundo: sum4_temp1 + p31
    xor sum4_xor2(sum4_temp2, sum4_temp1, p31);
    and sum4_and2(sum4_carry2, sum4_temp1, p31);
    // Terceiro: sum4_temp2 + sum3_carry1
    xor sum4_xor3(sum4_temp3, sum4_temp2, sum3_carry1);
    and sum4_and3(sum4_carry3, sum4_temp2, sum3_carry1);
    // Quarto: sum4_temp3 + sum3_carry2
    xor sum4_xor4(sum4_temp4, sum4_temp3, sum3_carry2);
    and sum4_and4(sum4_carry4, sum4_temp3, sum3_carry2);
    // Quinto: sum4_temp4 + sum3_carry3
    xor sum4_xor5(sum4_temp5, sum4_temp4, sum3_carry3);
    and sum4_and5(sum4_carry5, sum4_temp4, sum3_carry3);
    // Sexto: sum4_temp5 + sum3_carry4
    xor sum4_xor6(sum4_temp6, sum4_temp5, sum3_carry4);
    and sum4_and6(sum4_carry6, sum4_temp5, sum3_carry4);
    
    // Overflow se bit 4 (sum4_temp6) for 1 OU se houver carry além do bit 4
    // Ou qualquer carry dos somadores de sum3_carry5, sum3_carry6, ou carries de sum4
    wire ov_temp1, ov_temp2, ov_temp3, ov_temp4, ov_temp5;
    or ov_or1(ov_temp1, sum4_temp6, sum3_carry5);
    or ov_or2(ov_temp2, sum3_carry6, sum4_carry1);
    or ov_or3(ov_temp3, sum4_carry2, sum4_carry3);
    or ov_or4(ov_temp4, sum4_carry4, sum4_carry5);
    or ov_or5(ov_temp5, sum4_carry6, ov_temp1);
    wire ov_temp6, ov_temp7;
    or ov_or6(ov_temp6, ov_temp2, ov_temp3);
    or ov_or7(ov_temp7, ov_temp4, ov_temp5);
    or ov_or8(Overflow, ov_temp6, ov_temp7);

endmodule
