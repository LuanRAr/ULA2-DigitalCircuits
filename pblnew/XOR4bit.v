
module XOR4bit(
    input  [3:0] A, B,     // Entradas de 4 bits
    output [3:0] Result    // Resultado XOR bit a bit
);

    // Operação XOR bit a bit
    xor xor0(Result[0], A[0], B[0]);
    xor xor1(Result[1], A[1], B[1]);
    xor xor2(Result[2], A[2], B[2]);
    xor xor3(Result[3], A[3], B[3]);

endmodule