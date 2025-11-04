// Módulo XOR de 8 bits usando módulos de 4 bits
module XOR8bit(
    input  [7:0] A, B,
    output [7:0] Result
);
    
    // XOR dos 4 bits menos significativos
    XOR4bit xor_low(
        .A(A[3:0]),
        .B(B[3:0]),
        .Result(Result[3:0])
    );
    
    // XOR dos 4 bits mais significativos
    XOR4bit xor_high(
        .A(A[7:4]),
        .B(B[7:4]),
        .Result(Result[7:4])
    );
    
endmodule