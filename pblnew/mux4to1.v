module mux4to1(A, B, C, D, Selector, Y);

input A, B, C, D;           
input [1:0] Selector;       
output Y;                  

 //Fios intermediários para o mux hierárquico
wire y1, y2;               

//Dois primeiros mux2to1 para selecionar entre pares de entradas usando Selector[0]
mux2to1 mux1(
	.A(A),
	.B(B),
	.Selector(Selector[0]),
	.Y(y1)        
);

mux2to1 mux2(
	.A(C),
	.B(D),
	.Selector(Selector[0]),
	.Y(y2)         
);

//Mux2to1 final para selecionar entre as saídas intermediárias usando Selector[1]
mux2to1 mux3(
	.A(y1),
	.B(y2),
	.Selector(Selector[1]),
	.Y(Y)           
);

endmodule
