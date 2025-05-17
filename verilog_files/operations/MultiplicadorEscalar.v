
// Constantes úteis para manipulação de matrizes
`define MATRIZ_5x5 (0):(8*25-1)                        // Representação flattenada de uma matriz 5x5
`define ELEMENTO_8 7:0                                 // Índice de 8 bits
`define indice(coluna, linha) (8 * (linha + 5*coluna)) // Cálculo do índice de elemento na matriz flattenada

// Módulo: Multiplicador de Matriz por Escalar
// Realiza multiplicação de cada elemento de uma matriz 5x5 por um valor escalar.
module MultiplicadorEscalar (
    input      signed [`MATRIZ_5x5] matriz_entrada, // Matriz 5x5 de entrada (8 bits por elemento)
    input      signed [`ELEMENTO_8] escalar,        // Valor escalar para multiplicar
    output reg signed [`MATRIZ_5x5] matriz_saida    // Resultado da multiplicação
);

    genvar coluna, linha;

    generate
        // Multiplica cada elemento individual da matriz pelo escalar
        for (coluna = 0; coluna < 5; coluna = coluna + 1) begin : loop_coluna
            for (linha = 0; linha < 5; linha = linha + 1) begin : loop_linha
                always @(*) begin
                    matriz_saida[`indice(coluna, linha) +: 8] = 
                        escalar * matriz_entrada[`indice(coluna, linha) +: 8];
                end
            end
        end
    endgenerate

endmodule
