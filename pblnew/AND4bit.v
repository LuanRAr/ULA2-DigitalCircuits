// Módulo para operação AND bit a bit de 4 bits
// 100% COMBINACIONAL - apenas portas lógicas
module AND4bit(
    input  [3:0] A, B,     // Entradas de 4 bits
    output [3:0] Result    // Resultado AND bit a bit
);

    // Operação AND bit a bit
    and and0(Result[0], A[0], B[0]);
    and and1(Result[1], A[1], B[1]);
    and and2(Result[2], A[2], B[2]);
    and and3(Result[3], A[3], B[3]);

endmodule