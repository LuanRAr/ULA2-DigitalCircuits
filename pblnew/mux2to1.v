module mux2to1(A, B, Selector, Y);

input Selector, A, B;     
output Y;                  

wire a1, a2;               
wire w_notS;              

//Inverte o seletor para usar na lógica AND
not notS(w_notS, Selector);

//AND entre A e ~Selector -> seleciona A quando Selector = 0
and And1(a1, A, w_notS);

//AND entre B e Selector -> seleciona B quando Selector = 1
and And2(a2, Selector, B);

//OR entre as saídas intermediárias -> gera a saída final Y
or Or0(Y, a1, a2);

endmodule
