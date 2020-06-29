//TODO: split out into seprate source files and create a lib!

#include "flashcart.h"

#if defined(FLASHCART_TARGET_TYPE) && FLASHCART_TARGET_TYPE == ED64

#include <stdint.h>
#include <libdragon.h>
#include "video.h"

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

static volatile struct PI_regs_s * const PI_regs = (struct PI_regs_s *) 0xa4600000;

void bi_dma_r(void * ram_address, unsigned long pi_address, unsigned long len)
{
    disable_interrupts();

    while (dma_busy());
    IO_WRITE(PI_STATUS_REG, 3);
    PI_regs->ram_address = ram_address;
    PI_regs->pi_address = pi_address & 0x1FFFFFFF; // (pi_address | 0x10000000) & 0x1FFFFFFF;
    PI_regs->write_length = len - 1;
    while (dma_busy());

    enable_interrupts();
}

void bi_dma_w(void * ram_address, unsigned long pi_address, unsigned long len)
{
    disable_interrupts();
    while (dma_busy());
    IO_WRITE(PI_STATUS_REG, 3);
    PI_regs->ram_address = ram_address;
    PI_regs->pi_address = pi_address & 0x1FFFFFFF; // (pi_address | 0x10000000) & 0x1FFFFFFF;
    PI_regs->read_length = len - 1;
    while (dma_busy());
    enable_interrupts();
}

void bi_dma_read(void *ram, unsigned long addr, unsigned long len)
{
    if (((unsigned long) ram & 0xF0000000) == 0x80000000) {
        data_cache_hit_writeback_invalidate(ram, len);
        bi_dma_r(ram, addr, len);
    } else {
        bi_dma_r(ram, addr, len);
    }
}

void bi_dma_write(void *ram, unsigned long addr, unsigned long len)
{
    if (((unsigned long) ram & 0xF0000000) == 0x80000000)data_cache_hit_writeback(ram, len);
    bi_dma_w(ram, addr, len);
}

void bi_dma_read_rom(void *ram, unsigned long saddr, unsigned long slen)
{
    bi_dma_read(ram, ROM_ADDR + saddr * 512, slen * 512);
}

void bi_dma_write_rom(void *ram, unsigned long saddr, unsigned long slen)
{
    bi_dma_write(ram, ROM_ADDR + saddr * 512, slen * 512);
}

unsigned long bi_reg_rd(unsigned long reg)
{
    *(volatile unsigned long *) (REGS_BASE);
    return *(volatile unsigned long *) (REGS_BASE + reg * 4);
}

void bi_reg_wr(unsigned long reg, unsigned long data)
{
    *(volatile unsigned long *) (REGS_BASE);
    *(volatile unsigned long *) (REGS_BASE + reg * 4) = data;
    *(volatile unsigned long *) (ROM_ADDR);
}

unsigned char bi_dma_busy()
{
    while ((bi_reg_rd(REG_STATUS) & STATE_DMA_BUSY) != 0);
    return bi_reg_rd(REG_STATUS) & STATE_DMA_TOUT;
}

unsigned char bi_usb_rd_busy()
{
    return bi_reg_rd(REG_STATUS) & STATE_USB_RXF;
}

unsigned char bi_usb_wr_busy()
{
    return bi_reg_rd(REG_STATUS) & STATE_USB_TXE;
}

unsigned char bi_usb_rd(unsigned long saddr, unsigned long slen)
{
    saddr /= 4;
    while (bi_usb_rd_busy() != 0);

    bi_reg_wr(REG_DMA_LEN, slen - 1);
    bi_reg_wr(REG_DMA_RAM_ADDR, saddr);
    bi_reg_wr(REG_DMA_CFG, DCFG_USB_TO_RAM);

    if (bi_dma_busy() != 0)return EVD_ERROR_FIFO_TIMEOUT;

    return 0;
}

unsigned char bi_usb_wr(unsigned long saddr, unsigned long slen)
{
    saddr /= 4;
    while (bi_usb_wr_busy() != 0);

    bi_reg_wr(REG_DMA_LEN, slen - 1);
    bi_reg_wr(REG_DMA_RAM_ADDR, saddr);
    bi_reg_wr(REG_DMA_CFG, DCFG_RAM_TO_USB);

    if (bi_dma_busy() != 0)return EVD_ERROR_FIFO_TIMEOUT;

    return 0;
}


unsigned char edUsbToRam(void *addr, unsigned long slen)
{
    unsigned char resp;

    while (slen--) {
        resp = bi_usb_rd(ROM_BUFF, 1);
        if (resp)return resp;
        bi_dma_read_rom(addr, ROM_BUFF, 1);

        addr += 512;
    }

    return 0;
}

unsigned char edRamToUsb(void *addr, unsigned long slen) 
{
    unsigned char resp;

    while (slen--) {

        bi_dma_write_rom(addr, ROM_BUFF, 1);
        resp = bi_usb_wr(ROM_BUFF, 1);
        if (resp)return resp;
        addr += 512;
    }

    return 0;
}

unsigned char edUsbCmdOk( void ) 
{
    unsigned char buff[512];
    buff[0] = 'R';
    buff[1] = 'S';
    buff[2] = 'P';
    buff[3] = 'k';
    return edRamToUsb(buff, 1);
}

unsigned char edUsbScreenResolution( void ) 
{
    uint8_t res[512];
    res[1] = ((vScreenResolutionW() >> 8) & 0xFF);
    res[0] = (vScreenResolutionW() & 0xFF);
    res[3] = ((vScreenResolutionH() >> 8) & 0xFF);
    res[2] = (vScreenResolutionH() & 0xFF);

    return edRamToUsb(res, 1);
}

volatile unsigned long *vregbase = (volatile unsigned long *) 0xa4400000;
void edUsbListener( void ) 
{
    unsigned char resp;
    unsigned char buff[512];

    if (bi_usb_rd_busy() != 0)return;

    resp = edUsbToRam(buff, 1);
    if (resp)return;
    if (buff[0] != 'C' || buff[1] != 'M' || buff[2] != 'D')return;


    switch (buff[3]) {

        case 'T':
            edUsbCmdOk();
            break;
        case 'R':
            edUsbScreenResolution();
         break;
        case 'P':
        //Return Framebuffer VI_DRAM_ADDR_REG (0x04)
            edRamToUsb((void*)vregbase[1], (vScreenResolutionH() * vScreenResolutionW() * 2)/512);
        break;

    }
}

void edInitialize( void ) 
{
    bi_reg_wr(REG_KEY, 0x1234); //Unlock the everdrive for writing.
}


#endif

