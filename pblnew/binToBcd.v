module binToBcd (
    input  wire [7:0] S,           // Entrada binária de 8 bits
    output wire [6:0] segmentsUn,
    output wire [6:0] segmentsDez,
    output wire [6:0] segmentsCen   
);

    // --- Fios Internos ---
    
    // Fios para os BCD (saídas da lógica, entradas dos decodificadores)
    wire [3:0] unidade_out;
    wire [3:0] dezena_out;
    wire [3:0] centena_out;

    // Fios para as entradas invertidas (not)
    // nB0 = not S[7], nB1 = not S[6], ..., nB7 = not S[0]
    wire nB0, nB1, nB2, nB3, nB4, nB5, nB6, nB7;

    // Fio de terra (GND) para C2 e C3
    wire gnd_wire;

    // --- Fios para os termos de produto (saídas das portas AND) ---

    // Fios para U1 (35 termos)
    wire U1_term1, U1_term2, U1_term3, U1_term4, U1_term5, U1_term6, U1_term7, U1_term8, U1_term9, U1_term10, U1_term11, U1_term12, U1_term13, U1_term14, U1_term15, U1_term16, U1_term17, U1_term18, U1_term19, U1_term20, U1_term21, U1_term22, U1_term23, U1_term24, U1_term25, U1_term26, U1_term27, U1_term28, U1_term29, U1_term30, U1_term31, U1_term32, U1_term33, U1_term34, U1_term35;
    
    // Fios para U2 (35 termos)
    wire U2_term1, U2_term2, U2_term3, U2_term4, U2_term5, U2_term6, U2_term7, U2_term8, U2_term9, U2_term10, U2_term11, U2_term12, U2_term13, U2_term14, U2_term15, U2_term16, U2_term17, U2_term18, U2_term19, U2_term20, U2_term21, U2_term22, U2_term23, U2_term24, U2_term25, U2_term26, U2_term27, U2_term28, U2_term29, U2_term30, U2_term31, U2_term32, U2_term33, U2_term34, U2_term35;
    
    // Fios para U3 (25 termos)
    wire U3_term1, U3_term2, U3_term3, U3_term4, U3_term5, U3_term6, U3_term7, U3_term8, U3_term9, U3_term10, U3_term11, U3_term12, U3_term13, U3_term14, U3_term15, U3_term16, U3_term17, U3_term18, U3_term19, U3_term20, U3_term21, U3_term22, U3_term23, U3_term24, U3_term25;
    
    // Fios para D0 (31 termos)
    wire D0_term1, D0_term2, D0_term3, D0_term4, D0_term5, D0_term6, D0_term7, D0_term8, D0_term9, D0_term10, D0_term11, D0_term12, D0_term13, D0_term14, D0_term15, D0_term16, D0_term17, D0_term18, D0_term19, D0_term20, D0_term21, D0_term22, D0_term23, D0_term24, D0_term25, D0_term26, D0_term27, D0_term28, D0_term29, D0_term30, D0_term31;
    
    // Fios para D1 (11 termos)
    wire D1_term1, D1_term2, D1_term3, D1_term4, D1_term5, D1_term6, D1_term7, D1_term8, D1_term9, D1_term10, D1_term11;
    
    // Fios para D2 (8 termos)
    wire D2_term1, D2_term2, D2_term3, D2_term4, D2_term5, D2_term6, D2_term7, D2_term8;
    
    // Fios para D3 (5 termos)
    wire D3_term1, D3_term2, D3_term3, D3_term4, D3_term5;
    
    // Fios para C0 (5 termos)
    wire C0_term1, C0_term2, C0_term3, C0_term4, C0_term5;
    
    // Fios para C1 (3 termos)
    wire C1_term1, C1_term2, C1_term3;


    // --- LÓGICA ESTRUTURAL ---

    // 1. Inversores de Entrada (Mapeamento B0=S[7] ... B7=S[0])
    not inv_B0 (nB0, S[7]); // nB0 = not S[7]
    not inv_B1 (nB1, S[6]); // nB1 = not S[6]
    not inv_B2 (nB2, S[5]); // nB2 = not S[5]
    not inv_B3 (nB3, S[4]); // nB3 = not S[4]
    not inv_B4 (nB4, S[3]); // nB4 = not S[3]
    not inv_B5 (nB5, S[2]); // nB5 = not S[2]
    not inv_B6 (nB6, S[1]); // nB6 = not S[1]
    not inv_B7 (nB7, S[0]); // nB7 = not S[0]

    // 2. Lógica de "Terra" (GND) para C2 e C3
    // Um AND de um sinal e seu inverso (S[0] e not S[0]) sempre resulta em 0
    and gnd_inst (gnd_wire, S[0], nB7);


    // 3. Lógica BCD - UNIDADES (U)
    // U0 = B7
    buf buf_U0 (unidade_out[0], S[0]);

    // U1 = (B0 and B1 and B2 and B4 and B5 and not B6) or ... (35 termos)
    and and_U1_1 (U1_term1, S[7], S[6], S[5], S[3], S[2], nB6);
    and and_U1_2 (U1_term2, S[7], S[6], S[3], S[2], S[1], nB2);
    and and_U1_3 (U1_term3, S[7], S[5], S[4], S[2], S[1], nB4);
    and and_U1_4 (U1_term4, S[5], S[4], S[3], S[2], S[1], nB0);
    and and_U1_5 (U1_term5, S[7], S[6], S[5], S[3], nB3, nB6);
    and and_U1_6 (U1_term6, S[7], S[6], S[5], S[1], nB4, nB5);
    and and_U1_7 (U1_term7, S[7], S[6], S[3], S[1], nB2, nB3);
    and and_U1_8 (U1_term8, S[7], S[5], S[3], S[2], nB3, nB6);
    and and_U1_9 (U1_term9, S[7], S[3], S[2], S[1], nB2, nB3);
    and and_U1_10(U1_term10, S[6], S[5], S[3], S[1], nB0, nB5);
    and and_U1_11(U1_term11, S[7], S[6], S[2], nB2, nB4, nB6);
    and and_U1_12(U1_term12, S[7], S[5], S[1], nB1, nB3, nB4);
    and and_U1_13(U1_term13, S[7], S[4], S[3], nB1, nB2, nB6);
    and and_U1_14(U1_term14, S[7], S[4], S[3], nB2, nB5, nB6);
    and and_U1_15(U1_term15, S[6], S[3], S[2], nB0, nB2, nB6);
    and and_U1_16(U1_term16, S[5], S[4], S[2], nB0, nB4, nB6);
    and and_U1_17(U1_term17, S[5], S[3], S[1], nB0, nB1, nB3);
    and and_U1_18(U1_term18, S[4], S[2], S[1], nB0, nB2, nB4);
    and and_U1_19(U1_term19, S[7], S[5], S[4], S[3], S[1], nB1, nB5);
    and and_U1_20(U1_term20, S[7], S[6], nB2, nB3, nB4, nB6);
    and and_U1_21(U1_term21, S[7], S[3], nB1, nB2, nB5, nB6);
    and and_U1_22(U1_term22, S[7], S[2], nB2, nB3, nB4, nB6);
    and and_U1_23(U1_term23, S[6], S[5], nB0, nB4, nB5, nB6);
    and and_U1_24(U1_term24, S[6], S[3], nB0, nB2, nB3, nB6);
    and and_U1_25(U1_term25, S[6], S[1], nB0, nB2, nB4, nB5);
    and and_U1_26(U1_term26, S[3], S[2], nB0, nB2, nB3, nB6);
    and and_U1_27(U1_term27, S[6], S[5], S[2], S[1], nB0, nB3, nB4);
    and and_U1_28(U1_term28, S[5], nB0, nB1, nB3, nB4, nB6);
    and and_U1_29(U1_term29, S[1], nB0, nB1, nB2, nB3, nB4);
    and and_U1_30(U1_term30, S[7], S[5], S[4], nB1, nB4, nB5, nB6);
    and and_U1_31(U1_term31, S[7], S[4], S[1], nB1, nB2, nB4, nB5);
    and and_U1_32(U1_term32, S[5], S[4], S[3], nB0, nB1, nB5, nB6);
    and and_U1_33(U1_term33, S[4], S[3], S[1], nB0, nB1, nB2, nB5);
    and and_U1_34(U1_term34, S[4], nB0, nB1, nB2, nB4, nB5, nB6);
    and and_U1_35(U1_term35, S[4], nB0, nB1, nB2, nB4, nB5, nB6); // Termo 35: (B3 and not B0 and not B1 and not B2 and not B4 and not B5 and not B6) -> B3 é S[4]
    or or_U1 (unidade_out[1], U1_term1, U1_term2, U1_term3, U1_term4, U1_term5, U1_term6, U1_term7, U1_term8, U1_term9, U1_term10, U1_term11, U1_term12, U1_term13, U1_term14, U1_term15, U1_term16, U1_term17, U1_term18, U1_term19, U1_term20, U1_term21, U1_term22, U1_term23, U1_term24, U1_term25, U1_term26, U1_term27, U1_term28, U1_term29, U1_term30, U1_term31, U1_term32, U1_term33, U1_term34, U1_term35);

    // U2 = (B1 and B2 and B3 and B4 and B5 and B6) or ... (35 termos)
    and and_U2_1 (U2_term1, S[6], S[5], S[4], S[3], S[2], S[1]);
    and and_U2_2 (U2_term2, S[7], S[6], S[4], S[2], S[1], nB4);
    and and_U2_3 (U2_term3, S[6], S[4], S[3], S[2], S[1], nB0);
    and and_U2_4 (U2_term4, S[7], S[6], S[3], S[2], nB2, nB3);
    and and_U2_5 (U2_term5, S[7], S[6], S[3], S[2], nB3, nB6);
    and and_U2_6 (U2_term6, S[7], S[4], S[3], S[1], nB1, nB5);
    and and_U2_7 (U2_term7, S[6], S[5], S[4], S[2], nB0, nB6);
    and and_U2_8 (U2_term8, S[6], S[5], S[4], S[2], nB4, nB6);
    and and_U2_9 (U2_term9, S[6], S[5], S[3], S[1], nB3, nB5);
    and and_U2_10(U2_term10, S[5], S[3], S[2], S[1], nB1, nB3);
    and and_U2_11(U2_term11, S[7], S[6], S[2], nB2, nB3, nB6);
    and and_U2_12(U2_term12, S[7], S[6], S[1], nB3, nB4, nB5);
    and and_U2_13(U2_term13, S[7], S[2], S[1], nB1, nB3, nB4);
    and and_U2_14(U2_term14, S[6], S[4], S[2], nB0, nB2, nB4);
    and and_U2_15(U2_term15, S[6], S[3], S[2], nB2, nB3, nB6);
    and and_U2_16(U2_term16, S[6], S[3], S[1], nB0, nB3, nB5);
    and and_U2_17(U2_term17, S[5], S[4], S[3], nB1, nB5, nB6);
    and and_U2_18(U2_term18, S[4], S[3], S[1], nB1, nB2, nB5);
    and and_U2_19(U2_term19, S[3], S[2], S[1], nB0, nB1, nB3);
    and and_U2_20(U2_term20, S[7], S[4], nB1, nB2, nB4, nB5);
    and and_U2_21(U2_term21, S[7], S[4], nB1, nB4, nB5, nB6);
    and and_U2_22(U2_term22, S[6], S[5], nB0, nB3, nB5, nB6);
    and and_U2_23(U2_term23, S[6], S[5], nB3, nB4, nB5, nB6);
    and and_U2_24(U2_term24, S[5], S[2], nB0, nB1, nB3, nB6);
    and and_U2_25(U2_term25, S[5], S[2], nB1, nB3, nB4, nB6);
    and and_U2_26(U2_term26, S[7], S[6], S[4], S[3], nB2, nB5, nB6);
    and and_U2_27(U2_term27, S[7], S[4], S[3], S[2], nB1, nB2, nB6);
    and and_U2_28(U2_term28, S[6], S[5], S[4], S[1], nB0, nB4, nB5);
    and and_U2_29(U2_term29, S[5], S[4], S[2], S[1], nB0, nB1, nB4);
    and and_U2_30(U2_term30, S[6], nB0, nB2, nB3, nB4, nB5);
    and and_U2_31(U2_term31, S[4], nB0, nB1, nB2, nB5, nB6);
    and and_U2_32(U2_term32, S[2], nB0, nB1, nB2, nB3, nB4);
    and and_U2_33(U2_term33, S[7], S[3], nB1, nB2, nB3, nB5, nB6);
    and and_U2_34(U2_term34, S[5], S[1], nB0, nB1, nB3, nB4, nB5);
    and and_U2_35(U2_term35, S[5], S[1], nB0, nB1, nB3, nB4, nB5); // Termo 35: (B2 and B6 and not B0 and not B1 and not B3 and not B4 and not B5) -> B2=S[5], B6=S[1]
    or or_U2 (unidade_out[2], U2_term1, U2_term2, U2_term3, U2_term4, U2_term5, U2_term6, U2_term7, U2_term8, U2_term9, U2_term10, U2_term11, U2_term12, U2_term13, U2_term14, U2_term15, U2_term16, U2_term17, U2_term18, U2_term19, U2_term20, U2_term21, U2_term22, U2_term23, U2_term24, U2_term25, U2_term26, U2_term27, U2_term28, U2_term29, U2_term30, U2_term31, U2_term32, U2_term33, U2_term34, U2_term35);

    // U3 = (B0 and B1 and B2 and B4 and B5 and B6 and not B3) or ... (25 termos)
    and and_U3_1 (U3_term1, S[7], S[6], S[5], S[3], S[2], S[1], nB3);
    and and_U3_2 (U3_term2, S[7], S[6], S[5], S[4], S[3], nB5, nB6);
    and and_U3_3 (U3_term3, S[7], S[6], S[4], S[3], S[1], nB2, nB5);
    and and_U3_4 (U3_term4, S[7], S[5], S[4], S[3], S[2], nB1, nB6);
    and and_U3_5 (U3_term5, S[7], S[4], S[3], S[2], S[1], nB1, nB2);
    and and_U3_6 (U3_term6, S[6], S[5], S[4], S[2], S[1], nB0, nB4);
    and and_U3_7 (U3_term7, S[7], S[6], S[5], S[2], nB3, nB4, nB6);
    and and_U3_8 (U3_term8, S[7], S[6], S[2], S[1], nB2, nB3, nB4);
    and and_U3_9 (U3_term9, S[7], S[5], S[4], S[1], nB1, nB4, nB5);
    and and_U3_10(U3_term10, S[6], S[5], S[3], S[2], nB0, nB3, nB6);
    and and_U3_11(U3_term11, S[6], S[3], S[2], S[1], nB0, nB2, nB3);
    and and_U3_12(U3_term12, S[5], S[4], S[3], S[1], nB0, nB1, nB5);
    and and_U3_13(U3_term13, S[7], S[6], S[4], nB2, nB4, nB5, nB6);
    and and_U3_14(U3_term14, S[7], S[5], S[3], nB1, nB3, nB5, nB6);
    and and_U3_15(U3_term15, S[7], S[4], S[2], nB1, nB2, nB4, nB6);
    and and_U3_16(U3_term16, S[7], S[3], S[1], nB1, nB2, nB3, nB5);
    and and_U3_17(U3_term17, S[6], S[5], S[1], nB0, nB3, nB4, nB5);
    and and_U3_18(U3_term18, S[6], S[4], S[3], nB0, nB2, nB5, nB6);
    and and_U3_19(U3_term19, S[5], S[2], S[1], nB0, nB1, nB3, nB4);
    and and_U3_20(U3_term20, S[4], S[3], S[2], nB0, nB1, nB2, nB6);
    and and_U3_21(U3_term21, S[6], S[2], nB0, nB2, nB3, nB4, nB6);
    and and_U3_22(U3_term22, S[5], S[4], nB0, nB1, nB4, nB5, nB6);
    and and_U3_23(U3_term23, S[4], S[1], nB0, nB1, nB2, nB4, nB5);
    and and_U3_24(U3_term24, S[7], nB1, nB2, nB3, nB4, nB5, nB6);
    and and_U3_25(U3_term25, S[3], nB0, nB1, nB2, nB3, nB5, nB6);
    or or_U3 (unidade_out[3], U3_term1, U3_term2, U3_term3, U3_term4, U3_term5, U3_term6, U3_term7, U3_term8, U3_term9, U3_term10, U3_term11, U3_term12, U3_term13, U3_term14, U3_term15, U3_term16, U3_term17, U3_term18, U3_term19, U3_term20, U3_term21, U3_term22, U3_term23, U3_term24, U3_term25);

    // 4. Lógica BCD - DEZENAS (D)
    // D0 = (B0 and B1 and B2 and B4 and B5) or ... (31 termos)
    and and_D0_1 (D0_term1, S[7], S[6], S[5], S[3], S[2]);
    and and_D0_2 (D0_term2, S[7], S[6], S[5], S[3], S[1]);
    and and_D0_3 (D0_term3, S[7], S[5], S[3], S[2], S[1]);
    and and_D0_4 (D0_term4, S[7], S[6], S[5], S[3], nB3);
    and and_D0_5 (D0_term5, S[7], S[5], S[3], S[2], nB3);
    and and_D0_6 (D0_term6, S[7], S[5], S[3], S[1], nB3);
    and and_D0_7 (D0_term7, S[7], S[6], S[2], nB2, nB4);
    and and_D0_8 (D0_term8, S[7], S[6], S[1], nB2, nB4);
    and and_D0_9 (D0_term9, S[7], S[4], S[3], nB1, nB2);
    and and_D0_10(D0_term10, S[7], S[4], S[3], nB2, nB5);
    and and_D0_11(D0_term11, S[7], S[2], S[1], nB2, nB4);
    and and_D0_12(D0_term12, S[6], S[3], S[2], nB0, nB2);
    and and_D0_13(D0_term13, S[6], S[3], S[1], nB0, nB2);
    and and_D0_14(D0_term14, S[5], S[4], S[2], nB0, nB4);
    and and_D0_15(D0_term15, S[3], S[2], S[1], nB0, nB2);
    and and_D0_16(D0_term16, S[7], S[6], nB2, nB3, nB4);
    and and_D0_17(D0_term17, S[7], S[3], nB1, nB2, nB5);
    and and_D0_18(D0_term18, S[7], S[2], nB2, nB3, nB4);
    and and_D0_19(D0_term19, S[7], S[1], nB2, nB3, nB4);
    and and_D0_20(D0_term20, S[6], S[5], nB0, nB4, nB5);
    and and_D0_21(D0_term21, S[6], S[3], nB0, nB2, nB3);
    and and_D0_22(D0_term22, S[5], S[1], nB0, nB1, nB4);
    and and_D0_23(D0_term23, S[3], S[2], nB0, nB2, nB3);
    and and_D0_24(D0_term24, S[3], S[1], nB0, nB2, nB3);
    and and_D0_25(D0_term25, S[7], S[6], S[2], S[1], nB3, nB4);
    and and_D0_26(D0_term26, S[6], S[3], S[2], S[1], nB0, nB3);
    and and_D0_27(D0_term27, S[5], nB0, nB1, nB3, nB4);
    and and_D0_28(D0_term28, S[7], S[5], S[4], nB1, nB4, nB5);
    and and_D0_29(D0_term29, S[6], S[2], S[1], nB0, nB2, nB3);
    and and_D0_30(D0_term30, S[5], S[4], S[3], nB0, nB1, nB5);
    and and_D0_31(D0_term31, S[4], nB0, nB1, nB2, nB4, nB5);
    or or_D0 (dezena_out[0], D0_term1, D0_term2, D0_term3, D0_term4, D0_term5, D0_term6, D0_term7, D0_term8, D0_term9, D0_term10, D0_term11, D0_term12, D0_term13, D0_term14, D0_term15, D0_term16, D0_term17, D0_term18, D0_term19, D0_term20, D0_term21, D0_term22, D0_term23, D0_term24, D0_term25, D0_term26, D0_term27, D0_term28, D0_term29, D0_term30, D0_term31);

    // D1 = (B0 and B2 and not B3) or ... (11 termos)
    and and_D1_1 (D1_term1, S[7], S[5], nB3);
    and and_D1_2 (D1_term2, S[6], S[5], S[4], S[3], nB0);
    and and_D1_3 (D1_term3, S[7], nB1, nB3, nB4);
    and and_D1_4 (D1_term4, S[7], nB1, nB3, nB5);
    and and_D1_5 (D1_term5, S[6], nB0, nB2, nB3);
    and and_D1_6 (D1_term6, S[5], nB1, nB3, nB4);
    and and_D1_7 (D1_term7, S[4], S[3], S[2], nB0, nB1);
    and and_D1_8 (D1_term8, S[7], S[6], S[4], S[3], S[2], nB2);
    and and_D1_9 (D1_term9, S[7], S[5], nB1, nB4, nB5);
    and and_D1_10(D1_term10, S[4], S[3], nB0, nB1, nB2);
    and and_D1_11(D1_term11, S[4], S[2], nB0, nB1, nB2);
    or or_D1 (dezena_out[1], D1_term1, D1_term2, D1_term3, D1_term4, D1_term5, D1_term6, D1_term7, D1_term8, D1_term9, D1_term10, D1_term11);

    // D2 = (B0 and B1 and B2 and B3) or ... (8 termos)
    and and_D2_1 (D2_term1, S[7], S[6], S[5], S[4]);
    and and_D2_2 (D2_term2, S[7], S[5], nB1, nB3);
    and and_D2_3 (D2_term3, S[7], S[4], nB1, nB2);
    and and_D2_4 (D2_term4, S[5], S[4], nB0, nB1);
    and and_D2_5 (D2_term5, S[5], S[3], nB0, nB1);
    and and_D2_6 (D2_term6, S[6], nB0, nB2, nB3);
    and and_D2_7 (D2_term7, S[7], S[3], S[2], nB1, nB2);
    and and_D2_8 (D2_term8, S[5], S[4], nB1, nB4, nB5);
    or or_D2 (dezena_out[2], D2_term1, D2_term2, D2_term3, D2_term4, D2_term5, D2_term6, D2_term7, D2_term8);

    // D3 = (B1 and B3 and not B0 and not B2) or ... (5 termos)
    and and_D3_1 (D3_term1, S[6], S[4], nB0, nB2);
    and and_D3_2 (D3_term2, S[7], S[5], S[4], S[3], nB1);
    and and_D3_3 (D3_term3, S[7], S[5], S[4], S[2], nB1);
    and and_D3_4 (D3_term4, S[7], S[6], nB2, nB3, nB4);
    and and_D3_5 (D3_term5, S[6], S[5], nB0, nB3, nB4, nB5);
    or or_D3 (dezena_out[3], D3_term1, D3_term2, D3_term3, D3_term4, D3_term5);

    // 5. Lógica BCD - CENTENAS (C)
    // C0 = (B0 and not B1) or ... (5 termos)
    and and_C0_1 (C0_term1, S[7], nB1);
    and and_C0_2 (C0_term2, S[6], S[5], S[4], nB0);
    and and_C0_3 (C0_term3, S[6], S[5], S[3], nB0);
    and and_C0_4 (C0_term4, S[6], S[5], S[2], nB0);
    and and_C0_5 (C0_term5, S[7], nB2, nB3, nB4);
    or or_C0 (centena_out[0], C0_term1, C0_term2, C0_term3, C0_term4, C0_term5);

    // C1 = (B0 and B1 and B2) or ... (3 termos)
    and and_C1_1 (C1_term1, S[7], S[6], S[5]);
    and and_C1_2 (C1_term2, S[7], S[6], S[4]);
    and and_C1_3 (C1_term3, S[7], S[6], S[3]);
    or or_C1 (centena_out[1], C1_term1, C1_term2, C1_term3);

    // C2 = 0
    buf buf_C2 (centena_out[2], gnd_wire);

    // C3 = 0
    buf buf_C3 (centena_out[3], gnd_wire);


    // 6. Instância dos Decodificadores de Saída (conforme seu código)
    // (Assumindo que o módulo 'decoderSaida' existe no seu projeto)
    decoderSaida dec0 (.S(unidade_out), .segments(segmentsUn)); //unidades
    decoderSaida dec1 (.S(dezena_out),  .segments(segmentsDez)); //dezenas
    decoderSaida dec2 (.S(centena_out), .segments(segmentsCen)); //centenas

endmodule