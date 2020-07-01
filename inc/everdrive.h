#if defined(FLASHCART_TARGET_TYPE) && FLASHCART_TARGET_TYPE == ED64

#ifndef __EVERDRIVE_H
#define __EVERDRIVE_H

#define EVD_ERROR_FIFO_TIMEOUT  0x90

#define REG_CFG                 0
#define REG_STATUS              1
#define REG_DMA_LEN             2
#define REG_DMA_RAM_ADDR        3
#define REG_DMA_CFG             5
#define REG_KEY                 8

#define DCFG_USB_TO_RAM         3
#define DCFG_RAM_TO_USB         4

#define STATE_DMA_BUSY          1
#define STATE_DMA_TOUT          2
#define STATE_USB_TXE           4
#define STATE_USB_RXF           8

#define REGS_BASE               0xA8040000

#define ROM_LEN                 0x4000000
#define ROM_ADDR                0xB0000000
#define ROM_BUFF                (ROM_LEN / 512 - 4)


#define PI_BASE_REG             0x04600000
#define PI_STATUS_REG           (PI_BASE_REG+0x10)

#define KSEG1                   0xA0000000

#define	PHYS_TO_K1(x)           ((unsigned long )(x)|KSEG1)       /* physical to kseg1 */
#define	IO_WRITE(addr,data)	    (*(volatile unsigned long *)PHYS_TO_K1(addr)=(unsigned long)(data))
#define	IO_READ(addr)		    (*(volatile unsigned long *)PHYS_TO_K1(addr))

#ifdef __cplusplus
extern "C" {
#endif

void everdrive_init();
void handle_everdrive();

typedef struct PI_regs_s {
    /** @brief Uncached address in RAM where data should be found */
    void * ram_address;
    /** @brief Address of data on peripheral */
    unsigned long pi_address;
    /** @brief How much data to read from RAM into the peripheral */
    unsigned long read_length;
    /** @brief How much data to write to RAM from the peripheral */
    unsigned long write_length;
    /** @brief Status of the PI, including DMA busy */
    unsigned long status;
} _PI_regs_s;

#ifdef __cplusplus
}
#endif

#endif

#endif
