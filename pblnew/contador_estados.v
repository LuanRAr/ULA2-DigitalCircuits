
module contador_estados (
    input  wire clk_btn,   // clock da placa (CLOCK_50)
    input  wire rst_n_btn, // botão de reset ativo baixo (idle = 1, ao apertar -> 0)
    input  wire key_advance, // KEY[0] - avança estado quando pressionado
    output reg  [1:0] q    // q[1] = MSB, q[0] = LSB
);

    // sinais combinacionais (derivados do estado atual)
    wire q0, q1;
    assign q1 = q[1];
    assign q0 = q[0];

    // entradas T para cada flip-flop (combinacional)
    // T0 = ~(q1 & q0)  => toggle Q0 exceto no estado 11
    // T1 = q0          => toggle Q1 quando q0 = 1
    wire t0 = ~(q1 & q0);
    wire t1 = q0;

    // Detectar borda de descida do KEY[0] usando CLOCK_50
    reg key_advance_prev;
    wire key_advance_edge = key_advance_prev & ~key_advance; // borda de descida
    
    // Flip-flops tipo T: atualizanDO na borda de subida do CLOCK_50
    // reset assíncrono ativo baixo (rst_n_btn)
    always @(posedge clk_btn or negedge rst_n_btn) begin
        if (~rst_n_btn) begin
            q <= 2'b00; // reset para 00 quando reset pressionado (rst_n_btn = 0)
            key_advance_prev <= 1'b1;
        end else begin
            key_advance_prev <= key_advance;
            
            if (key_advance_edge) begin
                // característica T: Q <= Q ^ T (só quando KEY[0] é pressionado)
                q[0] <= q0 ^ t0;
                q[1] <= q1 ^ t1;
            end
        end
    end

endmodule