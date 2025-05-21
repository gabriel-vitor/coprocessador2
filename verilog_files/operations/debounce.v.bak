// Módulo para eliminar os efeitos de bouncing de botões mecânicos.
// Usa divisão de clock e flip-flops para estabilizar o sinal de entrada.

module debounce(
    input botao_bruto,        // Sinal direto do botão (com bouncing)
    input clk_entrada,        // Clock principal do sistema
    output sinal_estavel      // Sinal de saída com bouncing eliminado
);

    wire clk_lento;
    wire estado1, estado2, estado2_invertido, estado0;

    // Divisor de clock: gera um clock mais lento a partir do clock principal
    DivisorClock divisor(clk_entrada, clk_lento);

    // Cadeia de flip-flops para eliminar bouncing
    FlipFlopEstavel ff0(clk_lento, botao_bruto, estado0);
    FlipFlopEstavel ff1(clk_lento, estado0, estado1);
    FlipFlopEstavel ff2(clk_lento, estado1, estado2);

    assign estado2_invertido = ~estado2;

    // Sinal estável: ativo apenas na transição correta
    assign sinal_estavel = estado1 & estado2_invertido;

endmodule

// Módulo para divisão de clock
// Gera um clock mais lento para uso em debounce

module DivisorClock(
    input clk_rapido,         // Clock de entrada (ex: 100 MHz)
    output reg clk_lento      // Clock de saída (reduzido)
);

    reg [26:0] contador = 0;

    always @(posedge clk_rapido) begin
        contador <= (contador >= 249999) ? 0 : contador + 1;
        clk_lento <= (contador < 125000) ? 1'b0 : 1'b1;
    end

endmodule

// Flip-flop D simples, usado na cadeia de debounce

module FlipFlopEstavel(
    input clk_ff,             // Clock para o flip-flop
    input dado_entrada,       // Dado de entrada
    output reg saida_q        // Saída Q
);

    always @(posedge clk_ff) begin
        saida_q <= dado_entrada;
    end

endmodule
