//MUX DE 8 ENTRADAS - USANDO O MUX DE 4 
module MUX8x8(
    input  [7:0] in0,  // Entrada 0: SOMA (op=000)
    input  [7:0] in1,  // Entrada 1: SUBTRAÇÃO (op=001)
    input  [7:0] in2,  // Entrada 2: OR (op=010)
    input  [7:0] in3,  // Entrada 3: AND (op=011)
    input  [7:0] in4,  // Entrada 4: XOR (op=100)
    input  [7:0] in5,  // Entrada 5: MULTIPLICAÇÃO (op=101)
    input  [7:0] in6,  // Entrada 6: DIVISÃO (op=110)
    input  [7:0] in7,  // Entrada 7: NOT (op=111)
    input  [2:0] sel,  // Sinal de seleção da operação (3 bits)
    output [7:0] out   // Resultado final selecionado (8 bits)
);

    // MUX para os 4 bits menos significativos
    MUX8x4 mux_low(
        .in0(in0[3:0]),   // SOMA[3:0]
        .in1(in1[3:0]),   // SUBTRAÇÃO[3:0]
        .in2(in2[3:0]),   // OR[3:0]
        .in3(in3[3:0]),   // AND[3:0]
        .in4(in4[3:0]),   // XOR[3:0]
        .in5(in5[3:0]),   // MULTIPLICAÇÃO[3:0]
        .in6(in6[3:0]),   // DIVISÃO[3:0]
        .in7(in7[3:0]),   // NOT[3:0]
        .sel(sel),
        .out(out[3:0])
    );
    
    // MUX para os 4 bits mais significativos
    MUX8x4 mux_high(
        .in0(in0[7:4]),   // SOMA[7:4]
        .in1(in1[7:4]),   // SUBTRAÇÃO[7:4]
        .in2(in2[7:4]),   // OR[7:4]
        .in3(in3[7:4]),   // AND[7:4]
        .in4(in4[7:4]),   // XOR[7:4]
        .in5(in5[7:4]),   // MULTIPLICAÇÃO[7:4]
        .in6(in6[7:4]),   // DIVISÃO[7:4]
        .in7(in7[7:4]),   // NOT[7:4]
        .sel(sel),
        .out(out[7:4])
    );

endmodule