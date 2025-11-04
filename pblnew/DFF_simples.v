// Flip-flop D simples de 1 bit com enable
module DFF_simples(
    input  d,      // Entrada de dados
    input  clk,    // Clock (borda de subida)
    input  rst,    // Reset (ativo baixo)
    input  en,     // Enable (carrega quando en=1)
    output q       // Saída
);
    reg q_reg;
    
    always @(posedge clk or negedge rst) begin
        if (!rst)
            q_reg <= 1'b0;    // Reset: saída vai para 0
        else if (en)
            q_reg <= d;       // Enable: saída recebe entrada
    end
    
    assign q = q_reg;
endmodule