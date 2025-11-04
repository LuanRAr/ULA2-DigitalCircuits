// MUX para seleção do primeiro operando
// sel = 0: usa A (primeira operação)
// sel = 1: usa resultado_anterior (operações subsequentes)
module mux_operando(
    input  [7:0] A,                    // Entrada A (primeira operação)
    input  [7:0] resultado_anterior,  // Resultado anterior (operações subsequentes)
    input        sel,                 // Seleção (0=A, 1=resultado_anterior)
    output [7:0] out                  // Primeiro operando selecionado
);

    assign out = sel ? resultado_anterior : A;

endmodule