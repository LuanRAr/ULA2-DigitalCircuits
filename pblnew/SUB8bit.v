// Módulo de subtração de 8 bits (A - B)
module SUB8bit(
    input  [7:0] A, B,
    output [7:0] Result,
    output       Borrow
);
    
    // Para subtração: A - B = A + (~B + 1)
    wire [7:0] notB;
    wire [7:0] sub_result;
    
    // Inverte B bit a bit
    not not0(notB[0], B[0]);
    not not1(notB[1], B[1]);
    not not2(notB[2], B[2]);
    not not3(notB[3], B[3]);
    not not4(notB[4], B[4]);
    not not5(notB[5], B[5]);
    not not6(notB[6], B[6]);
    not not7(notB[7], B[7]);
    
    // Soma A + (~B + 1)
    Addition8bit sub_adder(
        .A(A),
        .B(notB),
        .Cin(1'b1),        // +1 para complemento de 2
        .Sum(sub_result),
        .Cout(Borrow)
    );
    
    assign Result = sub_result;
    
endmodule