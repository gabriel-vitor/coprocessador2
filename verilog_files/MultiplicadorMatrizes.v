
// Constantes e macros auxiliares
`define ELEMENTO_8 7:0                                  // Um único elemento 8 bits
`define MATRIZ_5x5 (8*25-1):0                           // Matriz flattenada 5x5
`define indice(linha, coluna) (8 * (coluna + 5*linha))  // Cálculo da posição de um elemento

// Módulo: Multiplicador de Matrizes
// Multiplica duas matrizes 5x5 (com sinais de 8 bits) e acumula linha a linha
// a cada pulso de clock. Cada elemento do resultado é armazenado após somas.
module MultiplicadorMatrizes (
    input      signed [`MATRIZ_5x5] matriz_a,      // Matriz A de entrada (flattenada)
    input      signed [`MATRIZ_5x5] matriz_b,      // Matriz B de entrada (flattenada)
    input             [7:0] tamanho,               // Tamanho da matriz (não utilizado diretamente)
    input                    clk,                  // Clock do sistema

    output reg signed [`MATRIZ_5x5] matriz_result  // Resultado da multiplicação A x B
);

    reg [`ELEMENTO_8] linha = 0;

    always @(posedge clk) begin
        // Cálculo de cada elemento da linha 'linha' da matriz resultado
        matriz_result[`indice(linha, 0) +: 8] <= 
              matriz_a[`indice(linha, 0) +: 8] * matriz_b[`indice(0, 0) +: 8]
            + matriz_a[`indice(linha, 1) +: 8] * matriz_b[`indice(1, 0) +: 8]
            + matriz_a[`indice(linha, 2) +: 8] * matriz_b[`indice(2, 0) +: 8]
            + matriz_a[`indice(linha, 3) +: 8] * matriz_b[`indice(3, 0) +: 8]
            + matriz_a[`indice(linha, 4) +: 8] * matriz_b[`indice(4, 0) +: 8];

        matriz_result[`indice(linha, 1) +: 8] <= 
              matriz_a[`indice(linha, 0) +: 8] * matriz_b[`indice(0, 1) +: 8]
            + matriz_a[`indice(linha, 1) +: 8] * matriz_b[`indice(1, 1) +: 8]
            + matriz_a[`indice(linha, 2) +: 8] * matriz_b[`indice(2, 1) +: 8]
            + matriz_a[`indice(linha, 3) +: 8] * matriz_b[`indice(3, 1) +: 8]
            + matriz_a[`indice(linha, 4) +: 8] * matriz_b[`indice(4, 1) +: 8];

        matriz_result[`indice(linha, 2) +: 8] <= 
              matriz_a[`indice(linha, 0) +: 8] * matriz_b[`indice(0, 2) +: 8]
            + matriz_a[`indice(linha, 1) +: 8] * matriz_b[`indice(1, 2) +: 8]
            + matriz_a[`indice(linha, 2) +: 8] * matriz_b[`indice(2, 2) +: 8]
            + matriz_a[`indice(linha, 3) +: 8] * matriz_b[`indice(3, 2) +: 8]
            + matriz_a[`indice(linha, 4) +: 8] * matriz_b[`indice(4, 2) +: 8];

        matriz_result[`indice(linha, 3) +: 8] <= 
              matriz_a[`indice(linha, 0) +: 8] * matriz_b[`indice(0, 3) +: 8]
            + matriz_a[`indice(linha, 1) +: 8] * matriz_b[`indice(1, 3) +: 8]
            + matriz_a[`indice(linha, 2) +: 8] * matriz_b[`indice(2, 3) +: 8]
            + matriz_a[`indice(linha, 3) +: 8] * matriz_b[`indice(3, 3) +: 8]
            + matriz_a[`indice(linha, 4) +: 8] * matriz_b[`indice(4, 3) +: 8];

        matriz_result[`indice(linha, 4) +: 8] <= 
              matriz_a[`indice(linha, 0) +: 8] * matriz_b[`indice(0, 4) +: 8]
            + matriz_a[`indice(linha, 1) +: 8] * matriz_b[`indice(1, 4) +: 8]
            + matriz_a[`indice(linha, 2) +: 8] * matriz_b[`indice(2, 4) +: 8]
            + matriz_a[`indice(linha, 3) +: 8] * matriz_b[`indice(3, 4) +: 8]
            + matriz_a[`indice(linha, 4) +: 8] * matriz_b[`indice(4, 4) +: 8];

        // Controle da linha atual
        if (linha == 4)
            linha <= 0;
        else
            linha <= linha + 1;
    end

endmodule
