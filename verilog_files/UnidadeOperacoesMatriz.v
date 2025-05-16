// Constantes para manipulação de matrizes 5x5
`define MATRIZ_5x5 (0):(8*25-1)     // Intervalo para matriz flattenada 5x5
`define ELEMENTO_8 7:0              // Elemento de 8 bits

// Módulo: Seletor de Operações de Matriz
// Recebe duas matrizes e executa uma operação baseada no código da operação.
module UnidadeOperacoesMatriz (
    input        [2:0] operacao,                          // Código da operação
    input signed [`MATRIZ_5x5] matriz_a, matriz_b,        // Matrizes de entrada
    input signed [`ELEMENTO_8] escalar,                   // Escalar para multiplicação
    input                    clk,                         // Clock do sistema
    output reg signed [`MATRIZ_5x5] resultado             // Resultado da operação
);

    // Declaração das saídas intermediárias dos módulos
    wire signed [`MATRIZ_5x5] soma, subtracao, mult_escalar;
    wire signed [`MATRIZ_5x5] oposto, transposta, multiplicacao;

    // Instanciação dos módulos de operação
    SomadorMatrizes      soma_mod      (matriz_a, matriz_b, soma);
    SubtratorMatrizes    sub_mod       (matriz_a, matriz_b, subtracao);
    MultiplicadorEscalar escalar_mod   (matriz_a, escalar, mult_escalar);
    OpostaMatriz         oposto_mod    (matriz_a, oposto);
    TransporMatriz       transposta_mod(matriz_a, transposta);
    MultiplicadorMatrizes mult_mod     (matriz_a, matriz_b, tamanho, clk, multiplicacao);

    // Lógica de seleção da operação via `case`
    always @(posedge clk) begin
        case (operacao)
            0: resultado <= soma;
            1: resultado <= subtracao;
            2: resultado <= mult_escalar;
            3: resultado <= oposto;
            4: resultado <= transposta;
            5: resultado <= multiplicacao;
            default: resultado <= 0;
        endcase
    end

endmodule
