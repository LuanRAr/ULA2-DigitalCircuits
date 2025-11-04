// Flip-flop D de 8 bits para registrar entrada A,ETC
module DFF8bit(
    input  [7:0] D,      // Entrada de dados de 8 bits
    input        clk,    // Clock (borda de subida)
    input        rst,    // Reset (ativo baixo)
    output [7:0] Q       // Saída registrada
);
    // Flip-flops D individuais para cada bit
    dff dff0(.d(D[0]), .clk(clk), .rst(rst), .q(Q[0]));
    dff dff1(.d(D[1]), .clk(clk), .rst(rst), .q(Q[1]));
    dff dff2(.d(D[2]), .clk(clk), .rst(rst), .q(Q[2]));
    dff dff3(.d(D[3]), .clk(clk), .rst(rst), .q(Q[3]));
    dff dff4(.d(D[4]), .clk(clk), .rst(rst), .q(Q[4]));
    dff dff5(.d(D[5]), .clk(clk), .rst(rst), .q(Q[5]));
    dff dff6(.d(D[6]), .clk(clk), .rst(rst), .q(Q[6]));
    dff dff7(.d(D[7]), .clk(clk), .rst(rst), .q(Q[7]));
endmodule

// Flip-flop D básico
module dff(
    input  d,    // Entrada de dados
    input  clk,  // Clock
    input  rst,  // Reset (ativo baixo)
    output q     // Saída
);
    reg q_reg;
    
    always @(posedge clk or negedge rst) begin
        if (!rst)
            q_reg <= 1'b0;
        else
            q_reg <= d;
    end
    
    assign q = q_reg;
endmodule