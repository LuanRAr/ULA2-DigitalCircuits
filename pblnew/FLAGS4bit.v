// Módulo para detecção de flags da uLa completa
module FLAGS4bit(
    input  [3:0] Result,   // Resultado da operação
    input        Cout,     // Carry out da operação
    input        Error,    // Flag de erro (divisão por zero, etc.)
    input  [2:0] Op,       // Código da operação (para detectar overflow)
    input  [3:0] A, B,     // Operandos originais (para detectar overflow)
    output       Overflow, // Flag de overflow
    output       Zero,     // Flag de zero
    output       CarryOut, // Flag de carry out
    output       Err       // Flag de erro
);

    // Flag Zero: resultado é zero
    wire n0, n1, n2, n3;
    not not0(n0, Result[0]);
    not not1(n1, Result[1]);
    not not2(n2, Result[2]);
    not not3(n3, Result[3]);
    
    and zero_flag(Zero, n0, n1, n2, n3);

    // Flag Carry Out: passa o carry out diretamente

    buf carry_buf(CarryOut, Cout);

    // Flag Error: passa o erro diretamente
    buf error_buf(Err, Error);

    // Flag Overflow: detecta overflow em operações aritméticas
    // Overflow ocorre quando:
    // - Soma: A[3] = B[3] mas Result[3] ≠ A[3]
    // - Subtração: A[3] ≠ B[3] mas Result[3] ≠ A[3]
    
    // Para soma (op = 000)
    wire sel_soma;
    wire n_op0, n_op1, n_op2;
    not not_op0(n_op0, Op[0]);
    not not_op1(n_op1, Op[1]);
    not not_op2(n_op2, Op[2]);
    and sel_soma_and(sel_soma, n_op2, n_op1, n_op0);
    
    // Para subtração (op = 001)
    wire sel_sub;
    and sel_sub_and(sel_sub, n_op2, n_op1, Op[0]);
    
    // Overflow na soma: A[3] = B[3] ≠ Result[3]
    wire A_eq_B, A_ne_result;
    xnor A_eq_B_xnor(A_eq_B, A[3], B[3]);
    xor A_ne_result_xor(A_ne_result, A[3], Result[3]);
    wire ov_soma;
    and ov_soma_and(ov_soma, A_eq_B, A_ne_result, sel_soma);
    
    // Overflow na subtração: A[3] ≠ B[3] ≠ Result[3]
    wire A_ne_B;
    xor A_ne_B_xor(A_ne_B, A[3], B[3]);
    wire ov_sub;
    and ov_sub_and(ov_sub, A_ne_B, A_ne_result, sel_sub);
    
    // Overflow final
    or overflow_or(Overflow, ov_soma, ov_sub);

endmodule