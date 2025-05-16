// Constantes para manipulação de matriz 5x5
`define MATRIZ_5x5 (0):(8*25-1)                         // Intervalo de bits para matriz 5x5
`define indice(coluna, linha) (8 * (linha + 5*coluna))  // Acesso a elemento em vetor flattenado

// Módulo: Transposição de Matriz
// Transpõe uma matriz 5x5 de inteiros com sinal (8 bits por elemento).
module TransporMatriz (
    input  wire signed [`MATRIZ_5x5] matriz_entrada,  // Matriz original (entrada)
    output wire signed [`MATRIZ_5x5] matriz_transposta // Matriz transposta (saída)
);

    genvar linha, coluna;
    generate
        // A matriz transposta é obtida trocando linha por coluna
        for (linha = 0; linha < 5; linha = linha + 1) begin : linha_loop
            for (coluna = 0; coluna < 5; coluna = coluna + 1) begin : coluna_loop
                assign matriz_transposta[`indice(linha, coluna) +: 8] = 
                       matriz_entrada[`indice(coluna, linha) +: 8];
            end
        end
    endgenerate

endmodule
