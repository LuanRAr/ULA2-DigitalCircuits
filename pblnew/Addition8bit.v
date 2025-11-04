// Somador completo de 8 bits usando módulos de 4 bits
module Addition8bit(
    input  [7:0] A, B,
    input        Cin,
    output [7:0] Sum,
    output       Cout
);
    wire C4; // carry entre os módulos de 4 bits
    
    // Primeiros 4 bits (bits 0-3)
    Addition4bit low_bits(
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .Sum(Sum[3:0]),
        .Cout(C4)
    );
    
    // Últimos 4 bits (bits 4-7)
    Addition4bit high_bits(
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C4),
        .Sum(Sum[7:4]),
        .Cout(Cout)
    );
endmodule