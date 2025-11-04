// Debounce simples com 3 flip-flops em cascta
module debounce(
    input clk,
    input btn_in,
    output btn_out
);
    reg ff1, ff2, ff3;
    
    always @(posedge clk) begin
        ff1 <= btn_in;
        ff2 <= ff1;
        ff3 <= ff2;
    end
    
    assign btn_out = ff3;
endmodule
