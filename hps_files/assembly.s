.equ DELAY_CYCLES, 1000

.section .data
devmem_path:        .asciz "/dev/mem"     @ Caminho para acesso à memória física
BRIDGE_BASE_ADDR:   .word 0xFF200000      @ Endereço base da ponte leve
BRIDGE_SPAN:        .word 0x1000          @ Tamanho do mapeamento

.global ptr_hw_fd
ptr_hw_fd:          .word 0               @ File descriptor retornado pelo open()

.global ptr_data_in
ptr_data_in:        .word 0               @ Ponteiro para registrador de entrada

.global ptr_data_out
ptr_data_out:       .word 0               @ Ponteiro para registrador de saída

.align 2

.section .text

@ Declaração das novas funções
.global hw_init
.type hw_init, %function

.global hw_close
.type hw_close, %function

.global hw_send_all
.type hw_send_all, %function

.global hw_read_all
.type hw_read_all, %function

.global hw_sync_send
.type hw_sync_send, %function

.global hw_sync_recv
.type hw_sync_recv, %function


hw_init:
    PUSH {r1-r7, lr}

    @ --- Abre /dev/mem ---
    LDR r0, =devmem_path
    MOV r1, #2                     @ flags: O_RDWR
    MOV r2, #0
    MOV r7, #5                     @ syscall: open
    SVC 0

    CMP r0, #0
    BLT .fail_open                 @ erro ao abrir /dev/mem

    @ --- Salva file descriptor ---
    LDR r1, =ptr_hw_fd
    STR r0, [r1]

    @ --- Mapeia a memória ---
    MOV r0, #0
    LDR r1, =BRIDGE_SPAN
    LDR r1, [r1]
    MOV r2, #3                     @ PROT_READ | PROT_WRITE
    MOV r3, #1                     @ MAP_SHARED
    LDR r4, =ptr_hw_fd
    LDR r4, [r4]
    LDR r5, =BRIDGE_BASE_ADDR
    LDR r5, [r5]
    MOV r7, #192                   @ syscall: mmap2
    SVC 0

    CMP r0, #1
    BEQ .fail_mmap

    @ --- Salva ponteiros de entrada e saída ---
    LDR r1, =ptr_data_in    
    STR r0, [r1]
    ADD r1, r0, #0x10              @ offset de 16 bytes
    LDR r2, =ptr_data_out
    STR r1, [r2]

    MOV r0, #0                     @ sucesso
    B .done_init

.fail_open:
    MOV r7, #1                     @ syscall: exit
    MOV r0, #1                     @ código de erro
    SVC #0
    B .done_init

.fail_mmap:
    MOV r7, #1
    MOV r0, #2                     @ erro no mmap
    SVC #0

.done_init:
    POP {r4-r7, lr}
    BX lr

hw_close:
    PUSH {r4, lr}

    @ Desfaz mapeamento com munmap
    LDR r0, =ptr_data_in
    LDR r0, [r0]
    LDR r1, =BRIDGE_SPAN
    LDR r1, [r1]
    MOV r7, #91                    @ syscall: munmap
    SVC 0

    @ Fecha file descriptor com close
    LDR r0, =ptr_hw_fd
    LDR r0, [r0]
    MOV r7, #6                     @ syscall: close
    SVC 0

    POP {r4, lr}
    BX lr

@verificar se vai funcionar com 5 parâmetros
hw_send_all:
    PUSH {r4-r12, lr}

    @ R0 aponta para struct Params
    LDR r4, [r0]      @ ponteiro para vetor A
    LDR r5, [r0, #4]  @ ponteiro para vetor B
    LDR r6, [r0, #8]  @ opcode
    LDR r7, [r0, #12] @ size
    LDR r8, [r0, #16] @ scalar

    @ Endereço base dos registradores
    LDR r2, =ptr_data_in
    LDR r2, [r2]

    @ Pulso de reset
    MOV r9, #1
    LSL r9, r9, #29
    STR r9, [r2]
    MOV r0, #0
    STR r0, [r2]

    @ Delay após reset
    MOV r12, #DELAY_CYCLES
    BL hw_delay_loop

    @ Pulso de start
    MOV r9, #1
    LSL r9, r9, #30
    STR r9, [r2]
    MOV r0, #0
    STR r0, [r2]

    @ Envia até 25 elementos
    MOV r9, #25
    MOV r10, #0

.send_loop:
    CMP r10, r9
    BGE .end_send

    LDRSB r0, [r4, r10]     @ elemento de A
    LDRSB r1, [r5, r10]     @ elemento de B

    LSL r1, r1, #8
    ORR r0, r0, r1          @ B << 8 | A

    ORR r0, r0, r6, LSL #16
    ORR r0, r0, r7, LSL #19
    ORR r0, r0, r8, LSL #21

    PUSH {r0}
    MOV r1, #1              @ tipo: dado normal
    BL hw_sync_send
    POP {r0}

    ADD r10, r10, #1
    B .send_loop

.end_send:
    MOV r0, #0              @ sucesso
    POP {r4-r12, lr}
    BX lr

@ Loop de atraso para reset/start
hw_delay_loop:
    SUBS r12, r12, #1
    BNE hw_delay_loop
    BX lr

hw_read_all:
    PUSH {r4-r7, lr}

    MOV r4, r0              @ ponteiro para resultados
    MOV r5, r1              @ ponteiro para flags de overflow

    MOV r6, #25             @ número de elementos
    MOV r7, #0              @ índice

.read_loop:
    CMP r7, r6
    BGE .read_done

    ADD r0, r4, r7
    MOV r1, r5
    BL hw_sync_recv

    ADD r7, r7, #1
    B .read_loop

.read_done:
    POP {r4-r7, lr}
    BX lr

@ Envia valor com sincronização
hw_sync_send:
    PUSH {r1-r4, lr}

    LDR r1, =ptr_data_in
    LDR r1, [r1]
    LDR r2, =ptr_data_out
    LDR r2, [r2]

    ORR r3, r0, #(1 << 31)     @ ativa bit de controle
    STR r3, [r1]

.wait_ack_set:
    LDR r4, [r2]
    TST r4, #(1 << 31)
    BEQ .wait_ack_set

    MOV r3, #0
    STR r3, [r1]

.wait_ack_clear:
    LDR r4, [r2]
    TST r4, #(1 << 31)
    BNE .wait_ack_clear

    POP {r1-r4, lr}
    BX lr

@ Recebe valor com sincronização
hw_sync_recv:
    PUSH {r2-r5, lr}

    LDR r2, =ptr_data_in
    LDR r2, [r2]
    LDR r3, =ptr_data_out
    LDR r3, [r3]

    MOV r4, #(1 << 31)
    STR r4, [r2]

.wait_recv_ack:
    LDR r5, [r3]
    TST r5, #(1 << 31)
    BEQ .wait_recv_ack

    AND r4, r5, #0xFF
    STRB r4, [r0]             @ resultado

    LSR r4, r5, #30
    AND r4, r4, #1
    STRB r4, [r1]             @ flag de overflow

    MOV r4, #0
    STR r4, [r2]

.wait_recv_clear:
    LDR r5, [r3]
    TST r5, #(1 << 31)
    BNE .wait_recv_clear

    POP {r2-r5, lr}
    BX lr
