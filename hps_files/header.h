#ifndef HEADER_H
#define HEADER_H

#include <stdint.h>

#define SUCCESS      0
#define INIT_FAIL   -1
#define SEND_FAIL   -2
#define READ_FAIL   -3

#define DATA_IN_BASE    0x0
#define DATA_OUT_BASE   0x10
#define LW_BRIDGE_BASE  0xFF200000
#define LW_BRIDGE_SPAN  0x00005000

#define OPCODE_BITS     (3 << 16)
#define SIZE_BITS       (3 << 19)
#define SCALAR_BITS     (3 << 21)
#define RESET_BIT       (1 << 29)
#define START_PULSE_BIT (1 << 30)
#define HPS_CONTROL_BIT (1 << 31)
#define FPGA_ACK_BIT    (1 << 31)

struct Params {
    const int8_t* a;
    const int8_t* b;
    uint32_t opcode;
    uint32_t size;
    uint32_t scalar;
};

extern int hw_init(void);

extern int hw_close(void);

extern int hw_send_all(const struct Params* p);

extern int hw_read_all(int8_t* result, uint8_t* overflow_flag);

#endif
