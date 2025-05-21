// Módulo Principal: MainTopLevel
// Responsável por coordenar o funcionamento do coprocessador, controlando a 
// leitura de memória, operações sobre matrizes e gravação de resultados.
module MainTopLevel (
    input botao,                     // Botão de controle (pressionado pelo usuário)
    input [2:0] operacao,            // Código da operação a ser realizada
    input clock,                     // Clock do sistema

    output LED_0,                    // Estado da máquina (bit 0)
    output LED_1,                    // Estado da máquina (bit 1)
    output LED_2                     // Estado da máquina (bit 2)
);

    reg [199:0] matriz_A;            // Matriz A (5x5 elementos de 8 bits)
    reg [199:0] matriz_B;            // Matriz B (5x5 elementos de 8 bits)
    reg [199:0] dado_escrita;        // Dados a serem escritos na memória
    reg        escrita_habilitada;   // Sinal de habilitação de escrita na memória
    reg [2:0]  endereco_mem;         // Endereço de leitura/escrita na memória
    reg [7:0]  estado;               // Estado atual da máquina de controle

    wire [199:0] dado_lido;          // Saída de dados da RAM
    wire [199:0] resultado_operacao; // Resultado da operação realizada
    wire botao_estabilizado;         // Sinal do botão sem bouncing

    // Instancia a RAM (gerada pelo IP Catalog)
    ram memory (
        endereco_mem,
        clock,
        dado_escrita,
        escrita_habilitada,
        dado_lido
    );

    // Instancia a unidade de operações aritméticas
    UnidadeOperacoesMatriz unidade_operacoes (
        operacao,
        matriz_A,
        matriz_B,
        matriz_B[0 +: 8],                         // Escalar: primeiro elemento da matriz B
        clock,
        resultado_operacao
    );

    // Instancia o debounce do botão
    debounce debouncer (
        botao,
        clock,
        botao_estabilizado
    );

    // Máquina de estados: controla leitura, operação e escrita na RAM
    always @(posedge botao_estabilizado) begin
        case (estado)
            3'b000: begin
                escrita_habilitada = 0;
                matriz_A = dado_lido;
                estado = estado + 1;
            end
            3'b001: begin
                escrita_habilitada = 0;
                matriz_A = dado_lido;
                endereco_mem = endereco_mem + 1;
                estado = estado + 1;
            end
            3'b010: begin
                escrita_habilitada = 0;
                matriz_B = dado_lido;
                estado = estado + 1;
            end
            3'b011: begin
                escrita_habilitada = 0;
                matriz_B = dado_lido;
                endereco_mem = endereco_mem + 1;
                estado = estado + 1;
            end
            3'b100: begin
                escrita_habilitada = 1;
                estado = estado + 1;
            end
            3'b101: begin
                dado_escrita = resultado_operacao;
                escrita_habilitada = 1;
                estado = estado + 1;
            end
            3'b110: begin
                dado_escrita = resultado_operacao;
                escrita_habilitada = 1;
                estado = estado + 1;
            end
            3'b111: begin
                dado_escrita = resultado_operacao;
                escrita_habilitada = 0;
                endereco_mem = 3'b000;
                estado = 3'b000;
            end
        endcase
    end

    // LEDs exibem os 3 bits menos significativos do estado
    assign LED_0 = estado[0];
    assign LED_1 = estado[1];
    assign LED_2 = estado[2];

endmodule
