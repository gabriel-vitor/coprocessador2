#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "header.h"

// Define a dimensão total da matriz quadrada (5x5)
#define MATRIX_SIZE 25

/**
 * Imprime uma matriz formatada com delimitação de linhas e colunas.
 * @param label   Etiqueta que será exibida antes da matriz.
 * @param matrix  Ponteiro para o buffer linear contendo os elementos.
 * @param size    Ordem da matriz (ex.: 3 para 3x3, 0..3 permitido).
 */
void print_matrix(const char* label, const int8_t* matrix, int size) {
    // n = ordem da matriz + 2 (margem para indices extras na FPGA)
    uint8_t n = (uint8_t)size + 2;
    uint8_t total = n * n;
    printf("%s (ordem=%u):\n", label, n);

    // Itera por todos os slots do buffer linear
    for (uint8_t idx = 0; idx < total; ++idx) {
        // A cada início de nova linha, imprime o delimitador esquerdo
        if (idx % n == 0) {
            printf("| ");
        }
        // Exibe valor com largura fixa para alinhamento
        printf("%4d", matrix[idx]);
        // Se não for fim de linha, separa com vírgula
        if ((idx + 1) % n != 0) {
            printf(",");
        } else {
            // Delimitador direito ao fim da linha
            printf(" |\n");
        }
    }
    printf("\n");
}

/**
 * Valida se o código de operação e tamanho da matriz estão dentro dos limites suportados.
 * @param op_code     Código da operação (0..7 válido).
 * @param matrix_size Ordem da matriz (0..3 válido).
 * @return HW_SUCCESS se tudo for válido, HW_SEND_FAIL caso contrário.
 */
int validate_operation(uint32_t op_code, uint32_t matrix_size) {
    if (op_code > 7) {
        fprintf(stderr, "Erro: código de operação inválido (%u). Deve estar entre 0 e 7.\n", op_code);
        return HW_SEND_FAIL;
    }
    if (matrix_size > 3) {
        fprintf(stderr, "Erro: tamanho de matriz inválido (%u). Deve estar entre 0 e 3.\n", matrix_size);
        return HW_SEND_FAIL;
    }
    return HW_SUCCESS;
}

int main(void) {
    // Nova configuração dos elementos da matriz A, para demonstração
    int8_t matrix_a[MATRIX_SIZE] = {
        10, 15, 20, 25, 5,
        6, 7, 8, 9, 10,
        10, 12,  10, 20, 15,
        4, 5, 6, 7, 8,
        9,  1,   2,   3,   4
    };

    // Matriz B permanece preenchida com 1 para operação de exemplo
    int8_t matrix_b[MATRIX_SIZE] = {
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    };

    // Buffer de resultados inicializado em zero
    int8_t matrix_result[MATRIX_SIZE] = {0};
    uint8_t overflow_flag = 0;

    // Parâmetros de exemplo para envio à FPGA
    uint32_t op_code     = 2;   // Ex: operação de soma matricial
    uint32_t matrix_size = 2;   // Ordem 4x4 (2+2)
    uint32_t scalar      = 11;  // Valor escalar para operações específicas

    // Empacotamento dos parâmetros em struct
    struct Params params = {
        .a      = matrix_a,
        .b      = matrix_b,
        .opcode = op_code,
        .size   = matrix_size,
        .scalar = scalar
    };

    // Validação de parâmetros antes do handshake com hardware
    if (validate_operation(op_code, matrix_size) != HW_SUCCESS) {
        return EXIT_FAILURE;
    }

    // Inicializa comunicação com a FPGA
    printf(">> Iniciando módulo de hardware FPGA...\n");
    if (begin_hw() != HW_SUCCESS) {
        fprintf(stderr, "Erro: falha ao inicializar hardware.\n");
        return EXIT_FAILURE;
    }

    // Envio de parâmetros e dados brutos para FPGA
    printf(">> Enviando matrizes e configuração (opcode=%u, tamanho=%u)...\n", op_code, matrix_size);
    if (send_data(&params) != HW_SUCCESS) {
        fprintf(stderr, "Erro: falha ao enviar dados à FPGA.\n");
        end_hw();
        return EXIT_FAILURE;
    } else {
      printf("deu erro aqui");
    }
    
    /*// Preparo para receber resultados: limpa buffers
    for (int i = 0; i < MATRIX_SIZE; ++i) {
        matrix_result[i] = 0;
    }
    overflow_flag = 0;
    */
    
    printf(">> Aguardando conclusão da operação na FPGA...\n");
    if (read_results(matrix_result, &overflow_flag) != HW_SUCCESS) {
        fprintf(stderr, "Erro: falha ao ler resultados da FPGA.\n");
        end_hw();
        return EXIT_FAILURE;
    }

    // Exibe as matrizes de entrada e saída formatadas
    print_matrix("Matriz A",          matrix_a,      matrix_size);
    print_matrix("Matriz B",          matrix_b,      matrix_size);
    print_matrix("Resultado da FPGA", matrix_result, matrix_size);

    // Indica se houve overflow na operação
    printf("Overflow detectado: %s\n", (overflow_flag & 0x1) ? "SIM" : "NÃO");

    // Finaliza comunicação com hardware e encerra
    end_hw();
    return EXIT_SUCCESS;
}
