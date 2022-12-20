
#include "pico/stdlib.h"
#include <stdio.h>
#include "hardware/spi.h"

#define ENv5_SPI spi0
#define ENv5_SPI_RX_PIN 16 // MISO
#define ENv5_SPI_TX_PIN 19 // MOSI
#define ENv5_SPI_SCK_PIN 18
#define ENv5_SPI_CS_PIN 17

#define FLASH_PAGE_SIZE        256

#define FLASH_CMD_PAGE_PROGRAM 0x02
#define FLASH_CMD_READ         0x03

static inline void cs_select(uint cs_pin) {
    asm volatile("nop \n nop \n nop"); // FIXME
    gpio_put(cs_pin, 0);
    asm volatile("nop \n nop \n nop"); // FIXME
}

static inline void cs_deselect(uint cs_pin) {
    asm volatile("nop \n nop \n nop"); // FIXME
    gpio_put(cs_pin, 1);
    asm volatile("nop \n nop \n nop"); // FIXME
}

void spi_data_read(spi_inst_t *spi, uint cs_pin, uint16_t addr, uint8_t *buf, size_t len) {
    cs_select(cs_pin);
    uint8_t cmdbuf[3] = {
            0x40,
            addr >> 8,
            addr
    };
    spi_write_blocking(spi, cmdbuf, 3);
    spi_read_blocking(spi, 0, buf, len);
    cs_deselect(cs_pin);
}

void spi_data_send(spi_inst_t *spi, uint cs_pin, uint16_t addr, uint8_t data[], uint16_t len) {
    uint8_t cmdbuf[3] = {
            0x80,
            addr >> 8,
            addr
    };
    cs_select(cs_pin);
    spi_write_blocking(spi, cmdbuf, 3);
    spi_write_blocking(spi, data, len);
    cs_deselect(cs_pin);

}

void printbuf(uint8_t *buf, int16_t len) {
    for (int i = 0; i < len; ++i) {
        if (i % 16 == 15)
            printf("%02x\n", buf[i]);
        else
            printf("%02x ", buf[i]);
    }
}

int main()
{
    stdio_init_all();
    

    // Enable SPI 0 at 1 MHz and connect to GPIOs
    spi_set_format(ENv5_SPI, 8, SPI_CPOL_0, SPI_CPHA_1, SPI_MSB_FIRST);
    spi_init(ENv5_SPI, 1000 * 1000);
    
    gpio_set_function(ENv5_SPI_RX_PIN, GPIO_FUNC_SPI);
    gpio_set_function(ENv5_SPI_TX_PIN, GPIO_FUNC_SPI);
    gpio_set_function(ENv5_SPI_SCK_PIN, GPIO_FUNC_SPI);

    gpio_init(ENv5_SPI_CS_PIN);
    gpio_put(ENv5_SPI_CS_PIN, 1);
    gpio_set_dir(ENv5_SPI_CS_PIN, GPIO_OUT);

    while(1)
    {
        char c = getchar_timeout_us(10000);
        // if(c=='t')
        // {
        //     printf("hello\r\n");
        // }

        if (c == 't')
        {
            printf("got the test command\r\n");
        }
        if (c == '0')
        {
            printf("cs select\r\n");
            cs_select(ENv5_SPI_CS_PIN);
            sleep_ms(100);
            cs_deselect(ENv5_SPI_CS_PIN);
            sleep_ms(100);
            printf("cs deselect\r\n");
        }
        if(c =='w')
        {
            printf("Start write data to the FPGA.\r\n");
            uint8_t dat[] = {1,2,3,4,5,6,7,8};
            spi_data_send(ENv5_SPI, ENv5_SPI_CS_PIN, 0x0000, dat, 4);
            printf("Done write data to the FPGA.\r\n");
        }
        if(c=='r')
        {
            uint8_t dat[10] = {0,0,0,0,0,0,0,0,0,0};
            spi_data_read(ENv5_SPI, ENv5_SPI_CS_PIN, 0x0000, dat, 10);
            printbuf(dat, 10);
        }
    }

}

//  ToDo:
// * refactoring the sht31 lib
// * refactoring the adxl345 lib
// * refactoring the hardware_test.c
// *
// * /
