// Constantes de uso geral
`define MATRIZ_5x5 (0):(8*25-1)                       // Define o intervalo da matriz 5x5 vetorizada unidimensional (flattenada)
`define indice(coluna, linha) (8 * (linha + 5*coluna)) // Acessa elemento específico da matriz 5x5

// Módulo: Somador de Matrizes
// Realiza a soma elemento a elemento de duas matrizes 5x5 de 8 bits com sinal.
module SomadorMatrizes (
    input      signed [`MATRIZ_5x5] matriz_entrada_a,  // Matriz A de entrada
    input      signed [`MATRIZ_5x5] matriz_entrada_b,  // Matriz B de entrada
    output reg signed [`MATRIZ_5x5] matriz_resultado   // Matriz resultante da soma
);

    genvar coluna, linha;

    generate
        // Itera sobre colunas e linhas para somar os elementos correspondentes
        for (coluna = 0; coluna < 5; coluna = coluna + 1) begin : loop_coluna
            for (linha = 0; linha < 5; linha = linha + 1) begin : loop_linha
                always @(*) begin
                    matriz_resultado[`indice(coluna, linha) +: 8] = 
                        matriz_entrada_a[`indice(coluna, linha) +: 8] + 
                        matriz_entrada_b[`indice(coluna, linha) +: 8];
                end
            end
        end
    endgenerate

endmodule
