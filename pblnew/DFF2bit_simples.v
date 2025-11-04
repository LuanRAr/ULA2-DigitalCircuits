// Flip-flop D de 2 bits usando 2 flip-flops de 1 bit
module DFF2bit_simples(
    input  [1:0] D,      // Entrada de dados de 2 bits
    input        clk,    // Clock (borda de subida)
    input        rst,    // Reset (ativo baixo)
    input        en,     // Enable (carrega quando en=1)
    output [1:0] Q       // Saída de 2 bits
);
    
    // 2 flip-flops D individuais
    DFF_simples dff0(.d(D[0]), .clk(clk), .rst(rst), .en(en), .q(Q[0]));
    DFF_simples dff1(.d(D[1]), .clk(clk), .rst(rst), .en(en), .q(Q[1]));
    
endmodule

