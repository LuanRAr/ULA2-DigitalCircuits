
module OR4bit(
    input  [3:0] A, B,     // Entradas de 4 bits
    output [3:0] Result    // Resultado OR bit a bit
);

    // Operação OR bit a bit
    or or0(Result[0], A[0], B[0]);
    or or1(Result[1], A[1], B[1]);
    or or2(Result[2], A[2], B[2]);
    or or3(Result[3], A[3], B[3]);

endmodule