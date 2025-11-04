// Somador completo de 4 bits usando 1-bit modules
module Addition4bit(
    input  [3:0] A, B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire C1, C2, C3; // fios internos para ligar os carries entre os 1-bit

    // bit 0
    Rot2Ckt1 bit0(.S(Sum[0]), .Cout(C1), .A(A[0]), .B(B[0]), .Cin(Cin));
    // bit 1
    Rot2Ckt1 bit1(.S(Sum[1]), .Cout(C2), .A(A[1]), .B(B[1]), .Cin(C1));
    // bit 2
    Rot2Ckt1 bit2(.S(Sum[2]), .Cout(C3), .A(A[2]), .B(B[2]), .Cin(C2));
    // bit 3
    Rot2Ckt1 bit3(.S(Sum[3]), .Cout(Cout), .A(A[3]), .B(B[3]), .Cin(C3));
endmodule