// Flip-flop D de 3 bits usando 3 flip-flops de 1 bit
module DFF3bit_simples(
    input  [2:0] D,      // Entrada de dados de 3 bits
    input        clk,    // Clock (borda de subida)
    input        rst,    // Reset (ativo baixo)
    input        en,     // Enable (carrega quando en=1)
    output [2:0] Q       // Saída de 3 bits
);
    
    // 3 flip-flops D individuais
    DFF_simples dff0(.d(D[0]), .clk(clk), .rst(rst), .en(en), .q(Q[0]));
    DFF_simples dff1(.d(D[1]), .clk(clk), .rst(rst), .en(en), .q(Q[1]));
    DFF_simples dff2(.d(D[2]), .clk(clk), .rst(rst), .en(en), .q(Q[2]));
    
endmodule

