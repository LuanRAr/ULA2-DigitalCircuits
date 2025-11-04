// Módulo para atualizar LEDs baseado no estado atual
// Mostra o que foi registrado até o momento -- IGNORAR - NAO TO UTILIZANDO MAIS FOI SO UNS TESTES
module atualizador_leds(
    input  [1:0]  state,           // Estado atual
    input  [7:0]  A_registered,    // A registrado
    input  [7:0]  B_registered,    // B registrado
    input  [2:0]  OP_registered,   // OP registrado
    input  [7:0]  result,          // Resultado atual
    output [9:0]  LEDR             // 10 LEDs
);

    // LEDs de estado (sempre ativos)
    assign LEDR[0] = (state == 2'b00);  // Estado 00
    assign LEDR[1] = (state == 2'b01);  // Estado 01
    assign LEDR[2] = (state == 2'b10);  // Estado 10
    assign LEDR[3] = (state == 2'b11);  // Estado 11
    
    // LEDs de dados (baseados no estado atual)
    // Estado 00: Não exibe nada (LEDR[9:4] = 0)
    // Estado 01: Exibe A registrado
    // Estado 10: Exibe B registrado  
    // Estado 11: Exibe resultado
    
    wire [5:0] dados_leds;
    
    assign dados_leds = (state == 2'b00) ? 6'b000000 :  // Estado 00: não exibe nada
                       (state == 2'b01) ? {A_registered[3:0], A_registered[5:4]} :  // Estado 01: exibe A (6 bits)
                       (state == 2'b10) ? {B_registered[3:0], B_registered[5:4]} :  // Estado 10: exibe B (6 bits)
                       {result[3:0], result[5:4]};  // Estado 11: exibe resultado (6 bits)
    
    assign LEDR[9:4] = dados_leds;

endmodule