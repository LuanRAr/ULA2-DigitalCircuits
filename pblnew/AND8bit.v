// Módulo AND de 8 bits usando módulos de 4 bits
module AND8bit(
    input  [7:0] A, B,
    output [7:0] Result
);
    
    // AND dos 4 bits menos significativos
    AND4bit and_low(
        .A(A[3:0]),
        .B(B[3:0]),
        .Result(Result[3:0])
    );
    
    // AND dos 4 bits mais significativos
    AND4bit and_high(
        .A(A[7:4]),
        .B(B[7:4]),
        .Result(Result[7:4])
    );
    
endmodule