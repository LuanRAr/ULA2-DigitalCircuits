// Módulo OR de 8 bits usando módulos de 4 bits
module OR8bit(
    input  [7:0] A, B,
    output [7:0] Result
);
    
    // OR dos 4 bits menos significativos
    OR4bit or_low(
        .A(A[3:0]),
        .B(B[3:0]),
        .Result(Result[3:0])
    );
    
    // OR dos 4 bits mais significativos
    OR4bit or_high(
        .A(A[7:4]),
        .B(B[7:4]),
        .Result(Result[7:4])
    );
    
endmodule