// COMECEI A ULA8BITS - FALTA PASSAR MULT E DIV PARA 8 BITS - ALERT
module ULA8bit_PRINCIPAL(
    input  CLOCK_50,      // Clock da placa
    input  [7:0]  SW,    // 8 switches para dados (A, B) e OP[7:5]
    input  [1:0]  KEY,   // KEY[0]=avança estado, KEY[1]=reset
	 input  [1:0]  Exib, //2 sinais de entradas dos 2 switchs mais a direita da placa > para tornar a selecao de exibicao mais facil
    output [8:0] LEDR,  // LEDR[7:0]=resultado, LEDR[8]=overflow, LEDR[9]=zero, LEDR[10]=negative, LEDR[11]=error
    
	 
	 // OUTPUT DOS DISPLAYS - LUAN FEZ
	 output [6:0]  HEX0,   // Display unidade,
    output [6:0]  HEX1,   // Display dezena,
    output [6:0]  HEX2,    // Display centena
	 output [6:0] seg_display_operador // display do sinal de operacao
    

);

    // Sinais de controle
    wire [1:0] state;           // Estado atual (2 bits)
    wire [7:0] A_registered;    // A registrado (só no estado 00)
    wire [7:0] B_registered;    // B registrado (só no estado 01)
    wire [2:0] OP_registered;   // OP registrado (só no estado 10)
    wire [1:0] sel_exibicao_registered; // SELETOR DE EXIBICAO REGISTRADO - LUAN

    wire [7:0] resultado_anterior; // Resultado anterior (8 bits)
    wire [8:0] resultado_completo; // {overflow, resultado[7:0]}
    wire [7:0] primeiro_operando;  // A ou resultado_anterior
    wire [7:0] segundo_operando;  // B registrado
    wire [7:0] result;           // Resultado da operação (8 bits)
    
    
    // Flags calculadas (combinacionais)
    wire       overflow_calc;    // Flag de overflow calculada
    wire       zero_calc;        // Flag de zero calculada
    wire       negative_calc;    // Flag de negativo calculada
    wire       error_calc;       // Flag de erro calculada
    
    // Flags registradas (só mudam no estado 11)
    wire       overflow_reg;     // Flag de overflow registrada
    wire       zero_reg;         // Flag de zero registrada
    wire       negative_reg;     // Flag de negativo registrada
    wire       error_reg;        // Flag de erro registrada
    
    
    // OP vem dos 3 bits mais significativos de SW
    wire [2:0] OP = SW[7:5];
    // SELETOR DE EXIBICAO VEM DOS 2 BITS SEGUINTES (SW[4:3])
    wire [1:0] exibicao = Exib;
    
    // Debounce simples com flip-flops em cascata
    wire key_advance_debounced, reset_debounced;

    debounce debounce_advance (
        .clk(CLOCK_50),
        .btn_in(KEY[0]),
        .btn_out(key_advance_debounced)
    );
    
    debounce debounce_reset (
        .clk(CLOCK_50),
        .btn_in(KEY[1]),
        .btn_out(reset_debounced)
    );
    
    // Contador de estados
    contador_estados contador(
        .clk_btn(CLOCK_50),       // Clock da placa
        .rst_n_btn(reset_debounced), // Reset ativo baixo
        .key_advance(key_advance_debounced), // KEY[0] para avançar estado
        .q(state)
    );
    
    // Detectar transições de estado (para enable_resultado pulsar apenas 1 vez)
    reg [1:0] state_prev;
    always @(posedge CLOCK_50 or negedge reset_debounced) begin
        if (!reset_debounced)
            state_prev <= 2'b11;  // Valor inicial diferente de 00
        else
            state_prev <= state;
    end
    
    // Sinais de enable para carregar registros (baseados no estado)
    wire enable_A = (state == 2'b00) & (resultado_anterior == 8'b00000000);
    wire enable_B = (state == 2'b01);
    wire enable_OP = (state == 2'b10);
    // enable_resultado PULSA APENAS 1 VEZ quando ENTRA no estado 11!
    wire enable_resultado = (state == 2'b11) & (state_prev != 2'b11);
    
    // Registro de A (só carrega no estado 00 quando resultado_anterior é zero)
    DFF8bit_simples registro_A(
        .D(SW),
        .clk(CLOCK_50),
        .rst(reset_debounced),
        .en(enable_A),
        .Q(A_registered)
    );
    
    // Registro de B (só carrega no estado 01)
    DFF8bit_simples registro_B(
        .D(SW),
        .clk(CLOCK_50),
        .rst(reset_debounced),
        .en(enable_B),
        .Q(B_registered)
    );
    
        // Registro de OP (só carrega no estado 10)
    DFF3bit_simples registro_OP(
        .D(OP),
        .clk(CLOCK_50),
        .rst(reset_debounced),
        .en(enable_OP),
        .Q(OP_registered)
    );
    
    // Registro de sel_exibicao (só carrega no estado 10) - 2 bits
    DFF2bit_simples registro_sel_exibicao(
        .D(exibicao),
        .clk(CLOCK_50),
        .rst(reset_debounced),
        .en(enable_OP),
        .Q(sel_exibicao_registered)
    );


    
    // Registro de resultado (carrega no estado 11)
    registrador_resultado reg_resultado(
        .resultado(result),
        .overflow(overflow_calc),
        .clk(CLOCK_50),
        .rst(reset_debounced),
        .en(enable_resultado),
        .Q(resultado_completo)
    );
	 //DFF8bit_simples reg_resultado(
        //.D(result),
        //.clk(load_resultado),
        //.rst(KEY[1]),
        //.Q(resultado_completo)
    //);
    
    // Extrair resultado anterior (8 bits)
    assign resultado_anterior = resultado_completo[7:0];
    
    // MUX para seleção do primeiro operando
    // Primeira operação: usa A (sel = 0)
    // Operações seguintes: usa resultado_anterior (sel = 1)
    wire sel_primeiro = (resultado_anterior != 8'b00000000);
    mux_operando mux_op(
        .A(A_registered),
        .resultado_anterior(resultado_anterior),
        .sel(sel_primeiro),
        .out(primeiro_operando)
    );
    
    // Segundo operando (B registrado)
    assign segundo_operando = B_registered;
    
    // -----------------------------
    // 1) SOMA (op = 000)
    // -----------------------------
    wire [7:0] sum;
    wire sum_cout;
    Addition8bit somador(
        .A(primeiro_operando),
        .B(segundo_operando),
        .Cin(1'b0),  // Cin fixo em 0
        .Sum(sum),
        .Cout(sum_cout)
    );
    
    // -----------------------------
    // 2) SUBTRAÇÃO (op = 001)
    // -----------------------------
    wire [7:0] sub;
    wire sub_cout;
    SUB8bit subtrator(
        .A(primeiro_operando),
        .B(segundo_operando),
        .Result(sub),
        .Borrow(sub_cout)
    );
    
    // -----------------------------
    // 3) OR (op = 010)
    // -----------------------------
    wire [7:0] or_result;
    OR8bit or_module(
        .A(primeiro_operando),
        .B(segundo_operando),
        .Result(or_result)
    );
    
    // -----------------------------
    // 4) AND (op = 011)
    // -----------------------------
    wire [7:0] and_result;
    AND8bit and_module(
        .A(primeiro_operando),
        .B(segundo_operando),
        .Result(and_result)
    );
    
    // -----------------------------
    // 5) XOR (op = 100)
    // -----------------------------
    wire [7:0] xor_result;
    XOR8bit xor_module(
        .A(primeiro_operando),
        .B(segundo_operando),
        .Result(xor_result)
    );
    
    // -----------------------------
    // 6) MULTIPLICAÇÃO (op = 101)
    // -----------------------------
    wire [7:0] mult_result;
    wire mult_overflow;
    MULT8bit mult_module(
        .A(primeiro_operando),
        .B(segundo_operando),
        .Result(mult_result),
        .Overflow(mult_overflow)
    );
    
    // -----------------------------
    // 7) DIVISÃO (op = 110)
    // -----------------------------
    wire [7:0] div_quotient, div_remainder;
    wire div_error, div_fractional;
    DIV8bit div_module(
        .A(primeiro_operando),
        .B(segundo_operando),
        .Quotient(div_quotient),
        .Remainder(div_remainder),
        .Error(div_error),
        .Fractional(div_fractional)
    );
    
    // -----------------------------
    // 8) NOT (op = 111)
    // -----------------------------
    wire [7:0] not_result;
    NOT8bit not_module(
        .A(primeiro_operando),
        .Result(not_result)
    );
    
    // -----------------------------
    // 9) Seleção do resultado final com MUX
    // -----------------------------
    MUX8x8 result_mux(
        .in0(sum),           // op = 000 → SOMA
        .in1(sub),           // op = 001 → SUBTRAÇÃO
        .in2(or_result),     // op = 010 → OR
        .in3(and_result),    // op = 011 → AND
        .in4(xor_result),    // op = 100 → XOR
        .in5(mult_result),   // op = 101 → MULTIPLICAÇÃO
        .in6(div_quotient),  // op = 110 → DIVISÃO (quociente)
        .in7(not_result),    // op = 111 → NOT
        .sel(OP_registered), // Sinal de seleção da operação registrado
        .out(result)         // Resultado final
    );
    
    // -----------------------------
    // 10) Detecção de FLAGS (Overflow, Zero, Negative, Error)
    // Módulo 100% combinacional - calcula as flags baseado no resultado
    // -----------------------------
    FLAGS8bit flags_detector(
        .Result(result),              // Resultado da operação
        .Cout(sum_cout),              // Carry out da soma
        .Borrow(sub_cout),            // Borrow da subtração
        .MultOvf(mult_overflow),      // Overflow da multiplicação
        .DivError(div_error),         // Erro de divisão por zero
        .Op(OP_registered),           // Operação registrada
        .Overflow(overflow_calc),     // Flag de overflow calculada
        .Zero(zero_calc),             // Flag de zero calculada
        .Negative(negative_calc),     // Flag de negativo calculada
        .Error(error_calc)            // Flag de erro calculada
    );
    
    // -----------------------------
    // 11) Registradores para as FLAGS
    // Só atualizam no estado 11 (quando o resultado é salvo)
    // evito q as flags acendam antes da hora 
    // -----------------------------
    
    // Overflow PERSISTENTE: uma vez aceso, só apaga com reset - garantindo oq quero
    // overflow_novo = overflow_atual OR overflow_anterior (latch)
    wire overflow_existente;
    or or_overflow_latch(overflow_existente, overflow_calc, overflow_reg);
    
    DFF_simples reg_overflow(
        .d(overflow_existente),  // ← Usa latch (overflow_calc OR overflow_reg) qualquer um existindo o overflow vai acender
        .clk(CLOCK_50),
        .rst(reset_debounced),
        .en(enable_resultado),
        .q(overflow_reg)
    );
    
    DFF_simples reg_zero(
        .d(zero_calc),
        .clk(CLOCK_50),
        .rst(reset_debounced),
        .en(enable_resultado),
        .q(zero_reg)
    );
    
    DFF_simples reg_negative(
        .d(negative_calc),
        .clk(CLOCK_50),
        .rst(reset_debounced),
        .en(enable_resultado),
        .q(negative_reg)
    );
    
    DFF_simples reg_error(
        .d(error_calc),
        .clk(CLOCK_50),
        .rst(reset_debounced),
        .en(enable_resultado),
        .q(error_reg)
    );
    
    // -----------------------------
    // 12) Saídas - Mapeamento dos LEDs
    // -----------------------------
    // LEDR[7:0]  = Resultado da operação (8 bits)
    // LEDR[8]    = Flag OVERFLOW (não cabe em 8 bits)
    // LEDR[9]    = Flag ZERO (resultado = 0)
    // LEDR[10]   = Flag NEGATIVE (resultado negativo)
    // LEDR[11]   = Flag ERROR (divisão por zero) 
    //assign LEDR[7:0] = resultado_completo[7:0];  // Resultado (8 bits) TAVA USANDO ANTES PARA DEBUGAR O CODIGO NA PLACA
    assign LEDR[1]   = overflow_reg;             // Flag de overflow registrada
    assign LEDR[0]   = zero_reg;                 // Flag de zero registrada
    assign LEDR[2]  = negative_reg;             // Flag de negativo registrada
    assign LEDR[3]  = error_reg;                // Flag de erro registrada
	 
	 assign LEDR[8:7] = state;




    
    // -----------------------------
    // 13) Conversor para exibição nos displays
    // -----------------------------
    main conversor_display (
        .bin(resultado_completo[7:0]),  // resultado final da ULA
        .sel(sel_exibicao_registered),        // seleção: 00 octal, 01 hex, 10 decimal
        .segmentsUn(HEX0),              // display unidade
        .segmentsDez(HEX1),             // display dezena
        .segmentsCen(HEX2)              // display centena
    );
	 
	 
	 
	  // -----------------------------
    // 14) Display de 7 segmentos - operador
    // -----------------------------
    display7seg_OPERADOR disp_operador(
        .bin(OP_registered),
        .seg(seg_display_operador)
    );
	 
	 
	 
	 
    
    

endmodule