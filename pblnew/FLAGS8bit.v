// OVERFLOW = resultado não cabe em 8 bits (precisa de 9+ bits)
//   - SOMA: carry out = 1 (ex: 200 + 100 = 300)
//   - SUBTRAÇÃO: borrow = 1 (ex: 2 - 4 = -2, pegou emprestado)
//   - MULTIPLICAÇÃO: resultado > 255 (ex: 20 × 20 = 400)
//
module FLAGS8bit(
    input  [7:0] Result,     // Resultado da operação (8 bits)
    input        Cout,       // Carry out da soma
    input        Borrow,     // Borrow da subtração
    input        MultOvf,    // Overflow da multiplicação
    input        DivError,   // Erro de divisão (div por zero)
    input  [2:0] Op,         // Código da operação
    output       Overflow,   // Flag de overflow - não cabe em 8 bits
    output       Zero,       // Flag de zero - resultado = 0
    output       Negative,   // Flag de negativo - Result[7] = 1
    output       Error       // Flag de erro - divisão por zero
);

    // ========================================
    // 1. Flag ZERO (Z): resultado é zero
    // Acende quando todos os 8 bits = 0
    // ========================================
    wire n0, n1, n2, n3, n4, n5, n6, n7;
    not not0(n0, Result[0]);
    not not1(n1, Result[1]);
    not not2(n2, Result[2]);
    not not3(n3, Result[3]);
    not not4(n4, Result[4]);
    not not5(n5, Result[5]);
    not not6(n6, Result[6]);
    not not7(n7, Result[7]);
    
    // AND de todos os bits negados
    wire and_low, and_high;
    and and_low_4(and_low, n0, n1, n2, n3);
    and and_high_4(and_high, n4, n5, n6, n7);
    and zero_flag(Zero, and_low, and_high);

    // ========================================
    // 2. Flag NEGATIVE (N): número negativo
    // Acende quando Result[7] = 1
    // Exemplo: 2 - 4 = -2 → 11111110 → Negative = 1
    // ========================================
    buf negative_buf(Negative, Result[7]);

    // ========================================
    // 3. Flag ERROR (E): divisão por zero
    // Passa o sinal de erro diretamente
    // ========================================
    buf error_buf(Error, DivError);

    // ========================================
    // 4. Flag OVERFLOW: resultado não cabe em 8 bits
    // Acende em 3 situações:
    //   a) SOMA (op=000): Cout = 1
    //   b) SUBTRAÇÃO (op=001): Borrow = 1
    //   c) MULTIPLICAÇÃO (op=101): MultOvf = 1
    // ========================================
    
    // Decodifica operação SOMA (op = 000)
    wire n_op0, n_op1, n_op2;
    not not_op0(n_op0, Op[0]);
    not not_op1(n_op1, Op[1]);
    not not_op2(n_op2, Op[2]);
    wire is_soma;
    and is_soma_and(is_soma, n_op2, n_op1, n_op0);
    
    // Decodifica operação SUBTRAÇÃO (op = 001)
    wire is_sub;
    and is_sub_and(is_sub, n_op2, n_op1, Op[0]);
    
    // Decodifica operação MULTIPLICAÇÃO (op = 101)
    wire is_mult;
    and is_mult_and(is_mult, Op[2], n_op1, Op[0]);
    
    // Overflow na SOMA: Cout = 1
    wire ovf_soma;
    and ovf_soma_and(ovf_soma, is_soma, Cout);
    
    // Overflow na SUBTRAÇÃO: Borrow = 1
    wire ovf_sub;
    and ovf_sub_and(ovf_sub, is_sub, Borrow);
    
    // Overflow na MULTIPLICAÇÃO: MultOvf = 1
    wire ovf_mult;
    and ovf_mult_and(ovf_mult, is_mult, MultOvf);
    
    // Overflow final: OR de todas as condições
    wire ovf_temp;
    or ovf_or1(ovf_temp, ovf_soma, ovf_sub);
    or ovf_or2(Overflow, ovf_temp, ovf_mult);

endmodule

