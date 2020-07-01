#include "flashcart.h"

#if defined(FLASHCART_TARGET_TYPE) && FLASHCART_TARGET_TYPE == ED64

#include <stdint.h>
#include <libdragon.h>
#include "video.h"
#include "everdrive.h"

static volatile struct PI_regs_s * const PI_regs = (struct PI_regs_s *) 0xa4600000;

void everdrive_dma_read_ex(void * ram_address, unsigned long pi_address, unsigned long len)
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

void everdrive_dma_write_ex(void * ram_address, unsigned long pi_address, unsigned long len)
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

void everdrive_dma_read(void *ram, unsigned long addr, unsigned long len)
{
    if (((unsigned long) ram & 0xF0000000) == 0x80000000) {
        data_cache_hit_writeback_invalidate(ram, len);
        everdrive_dma_read_ex(ram, addr, len);
    } else {
        everdrive_dma_read_ex(ram, addr, len);
    }
}

void everdrive_dma_write(void *ram, unsigned long addr, unsigned long len)
{
    if (((unsigned long) ram & 0xF0000000) == 0x80000000)data_cache_hit_writeback(ram, len);
    everdrive_dma_write_ex(ram, addr, len);
}

void dma_read_rom(void *ram, unsigned long saddr, unsigned long slen)
{
    everdrive_dma_read(ram, ROM_ADDR + saddr * 512, slen * 512);
}

void dma_write_rom(void *ram, unsigned long saddr, unsigned long slen)
{
    everdrive_dma_write(ram, ROM_ADDR + saddr * 512, slen * 512);
}

unsigned long register_read(unsigned long reg)
{
    *(volatile unsigned long *) (REGS_BASE);
    return *(volatile unsigned long *) (REGS_BASE + reg * 4);
}

void register_write(unsigned long reg, unsigned long data)
{
    *(volatile unsigned long *) (REGS_BASE);
    *(volatile unsigned long *) (REGS_BASE + reg * 4) = data;
    *(volatile unsigned long *) (ROM_ADDR);
}

unsigned char everdrive_dma_busy()
{
    while ((register_read(REG_STATUS) & STATE_DMA_BUSY) != 0);
    return register_read(REG_STATUS) & STATE_DMA_TOUT;
}

unsigned char usb_read_busy()
{
    return register_read(REG_STATUS) & STATE_USB_RXF;
}

unsigned char usb_write_busy()
{
    return register_read(REG_STATUS) & STATE_USB_TXE;
}

unsigned char usb_read(unsigned long saddr, unsigned long slen)
{
    saddr /= 4;
    while (usb_read_busy() != 0);

    register_write(REG_DMA_LEN, slen - 1);
    register_write(REG_DMA_RAM_ADDR, saddr);
    register_write(REG_DMA_CFG, DCFG_USB_TO_RAM);

    if (everdrive_dma_busy() != 0)return EVD_ERROR_FIFO_TIMEOUT;

    return 0;
}

unsigned char usb_write(unsigned long saddr, unsigned long slen)
{
    saddr /= 4;
    while (usb_write_busy() != 0);

    register_write(REG_DMA_LEN, slen - 1);
    register_write(REG_DMA_RAM_ADDR, saddr);
    register_write(REG_DMA_CFG, DCFG_RAM_TO_USB);

    if (everdrive_dma_busy() != 0)return EVD_ERROR_FIFO_TIMEOUT;

    return 0;
}


unsigned char usb_to_ram(void *addr, unsigned long slen)
{
    unsigned char resp;

    while (slen--) {
        resp = usb_read(ROM_BUFF, 1);
        if (resp)return resp;
        dma_read_rom(addr, ROM_BUFF, 1);

        addr += 512;
    }

    return 0;
}

unsigned char ram_to_usb(void *addr, unsigned long slen) 
{
    unsigned char resp;

    while (slen--) {

        dma_write_rom(addr, ROM_BUFF, 1);
        resp = usb_write(ROM_BUFF, 1);
        if (resp)return resp;
        addr += 512;
    }

    return 0;
}

unsigned char send_ack( void ) 
{
    unsigned char buff[512];
    buff[0] = 'R';
    buff[1] = 'S';
    buff[2] = 'P';
    buff[3] = 'k';
    return ram_to_usb(buff, 1);
}

unsigned char screen_resolution( void ) 
{
    uint8_t res[512];
    res[1] = ((vScreenResolutionW() >> 8) & 0xFF);
    res[0] = (vScreenResolutionW() & 0xFF);
    res[3] = ((vScreenResolutionH() >> 8) & 0xFF);
    res[2] = (vScreenResolutionH() & 0xFF);

    return ram_to_usb(res, 1);
}

volatile unsigned long *vregbase = (volatile unsigned long *) 0xa4400000;
void handle_everdrive( void ) 
{
    unsigned char resp;
    unsigned char buff[512];

    if (usb_read_busy() != 0)return;

    resp = usb_to_ram(buff, 1);
    if (resp)return;
    if (buff[0] != 'C' || buff[1] != 'M' || buff[2] != 'D')return;


    switch (buff[3]) {

        case 'T':
            send_ack();
            break;
        case 'P': //pixels
            screen_resolution();
         break;
        case 'C': //capture
        //Return Framebuffer VI_DRAM_ADDR_REG (0x04)
            ram_to_usb((void*)vregbase[1], (vScreenResolutionH() * vScreenResolutionW() * 2)/512);
        break;

    }
}

void everdrive_init( void ) 
{
    register_write(REG_KEY, 0x1234); //Unlock the everdrive for writing.
}


#endif
