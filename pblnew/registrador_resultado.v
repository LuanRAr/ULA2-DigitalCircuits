// registrador zeu
module registrador_resultado(
    input  [7:0] resultado,    // Resultado da operação (8 bits)
    input        overflow,     // Flag de overflow
    input        clk,          // Clock para carregar
    input        rst,          // Reset (ativo baixo)
    input        en,           // Enable (carrega quando en=1)
    output [8:0] Q             // Saída: {overflow, resultado[7:0]}
);

    reg [8:0] Q_reg;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            Q_reg <= 9'b000000000; // Reset: tudo zero
        end else if (en) begin
            Q_reg <= {overflow, resultado[7:0]};
        end
    end
    
    assign Q = Q_reg;

endmodule