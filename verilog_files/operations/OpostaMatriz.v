// Constantes para manipulação de matrizes
`define MATRIZ_5x5 (0):(8*25-1)                         // Representação flattenada de uma matriz 5x5
`define indice(coluna, linha) (8 * (linha + 5*coluna))  // Índice de elemento no vetor

// Módulo: Oposto de Matriz
// Calcula o oposto (inverso aditivo) de todos os elementos de uma matriz 5x5.
module OpostaMatriz (
    input      [`MATRIZ_5x5] matriz_entrada,  // Matriz original
    output reg [`MATRIZ_5x5] matriz_oposta    // Matriz com elementos invertidos (negados)
);

    genvar coluna, linha;
    generate
        // Percorre todos os elementos da matriz e aplica o operador de negação
        for (coluna = 0; coluna < 5; coluna = coluna + 1) begin : loop_coluna
            for (linha = 0; linha < 5; linha = linha + 1) begin : loop_linha
                always @(*) begin
                    matriz_oposta[`indice(coluna, linha) +: 8] = 
                        -matriz_entrada[`indice(coluna, linha) +: 8];
                end
            end
        end
    endgenerate

endmodule
