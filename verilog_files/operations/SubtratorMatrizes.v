// Constantes para uso em operações com matrizes
`define MATRIZ_5x5 (0):(8*25-1)                         // Intervalo de bits para matriz 5x5 (flattenada)
`define indice(coluna, linha) (8 * (linha + 5*coluna))  // Cálculo de índice para acessar elemento da matriz

// Módulo: Subtrator de Matrizes
// Realiza subtração elemento a elemento entre duas matrizes 5x5 de 8 bits.
module SubtratorMatrizes (
    input      signed [8*25-1:0] matriz_a,         // Matriz A (entrada)
    input      signed [8*25-1:0] matriz_b,         // Matriz B (entrada)
    output reg signed [8*25-1:0] matriz_resultado  // Resultado da subtração A - B
);

    genvar coluna, linha;

    generate
        // Iteração para percorrer todos os elementos da matriz
        for (coluna = 0; coluna < 5; coluna = coluna + 1) begin : loop_coluna
            for (linha = 0; linha < 5; linha = linha + 1) begin : loop_linha
                always @(*) begin
                    matriz_resultado[`indice(coluna, linha) +: 8] =
                        matriz_a[`indice(coluna, linha) +: 8] -
                        matriz_b[`indice(coluna, linha) +: 8];
                end
            end
        end
    endgenerate

endmodule
