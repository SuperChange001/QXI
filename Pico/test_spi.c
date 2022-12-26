
#include "pico/stdlib.h"
#include <stdio.h>
#include "hardware/spi.h"
#include <stdlib.h>
#include <stdbool.h>

#define ENv5_SPI spi0
#define ENv5_SPI_RX_PIN 16 // MISO
#define ENv5_SPI_TX_PIN 19 // MOSI
#define ENv5_SPI_SCK_PIN 18
#define ENv5_SPI_CS_PIN 17

#define LED0_PIN 22
#define LED1_PIN 24
#define LED2_PIN 25

#define FPGA_VOL_REGULATOR_EN_PIN 23 // 1 -> on, 0 -> off
#define FPGA_MOS_EN_PIN 21 // 1 -> off, 0 -> on
#define FPGA_RESET_CTRL_PIN 12

// release them when you configure the FPGA
// what configure means? configure means FPGA wants to
// read the bit file from flash.
#define SPI_FPGA_FLASH_CS 1
#define SPI_FPGA_FLASH_MISO 0
#define SPI_FPGA_FLASH_MOSI 3
#define SPI_FPGA_FLASH_SCK 2


#define FLASH_PAGE_SIZE        256

#define FLASH_CMD_PAGE_PROGRAM 0x02
#define FLASH_CMD_READ         0x03


static inline void fpga_spi_cs_select(uint cs_pin) {
    asm volatile("nop \n nop \n nop"); // FIXME
    gpio_put(cs_pin, 0);
    asm volatile("nop \n nop \n nop"); // FIXME
}

static inline void fpga_spi_cs_deselect(uint cs_pin) {
    asm volatile("nop \n nop \n nop"); // FIXME
    gpio_put(cs_pin, 1);
    asm volatile("nop \n nop \n nop"); // FIXME
}



void fpga_flash_spi_deinit()
{
    gpio_init(SPI_FPGA_FLASH_CS);
    gpio_set_dir(SPI_FPGA_FLASH_CS, GPIO_IN);
    gpio_init(SPI_FPGA_FLASH_MISO);
    gpio_set_dir(SPI_FPGA_FLASH_MISO, GPIO_IN);
    gpio_init(SPI_FPGA_FLASH_MOSI);
    gpio_set_dir(SPI_FPGA_FLASH_MOSI, GPIO_IN);
    gpio_init(SPI_FPGA_FLASH_SCK);
    gpio_set_dir(SPI_FPGA_FLASH_SCK, GPIO_IN);
}

// PAC1934 is using pio6 and pio7 which is connected to I2C1
void fpga_powers_init()
{
    // voltage regulator off
    gpio_init(FPGA_VOL_REGULATOR_EN_PIN);
    gpio_set_dir(FPGA_VOL_REGULATOR_EN_PIN, GPIO_OUT);
    gpio_put(FPGA_VOL_REGULATOR_EN_PIN, 0);

    // MOS FETS off
    gpio_init(FPGA_MOS_EN_PIN);
    gpio_set_dir(FPGA_MOS_EN_PIN, GPIO_OUT);
    gpio_put(FPGA_MOS_EN_PIN, 1);
}


void fpga_powers_on()
{
    // voltage regulator on
    gpio_put(FPGA_VOL_REGULATOR_EN_PIN, 1);

    sleep_ms(10);

    // MOS FETS on
    gpio_put(FPGA_MOS_EN_PIN, 0);
}

void fpga_powers_off()
{
    // voltage regulator on
    gpio_put(FPGA_VOL_REGULATOR_EN_PIN, 0);

    // MOS FETS on
    gpio_put(FPGA_MOS_EN_PIN, 1);
}

void fpga_reset_init(void)
{
    gpio_init(FPGA_RESET_CTRL_PIN);
    gpio_set_dir(FPGA_RESET_CTRL_PIN, GPIO_OUT);
    gpio_put(FPGA_RESET_CTRL_PIN, 1);
}

void fpga_reset(unsigned int reset_en)
{
    if(reset_en)
    {
        gpio_put(FPGA_RESET_CTRL_PIN, 0);
    }
    else
    {
        gpio_put(FPGA_RESET_CTRL_PIN, 1);
    }

}


void leds_init(void)
{
    gpio_init(LED0_PIN);
    gpio_set_dir(LED0_PIN, GPIO_OUT);
    gpio_put(LED0_PIN, 0);

    gpio_init(LED1_PIN);
    gpio_set_dir(LED1_PIN, GPIO_OUT);
    gpio_put(LED1_PIN, 0);

    gpio_init(LED2_PIN);
    gpio_set_dir(LED2_PIN, GPIO_OUT);
    gpio_put(LED2_PIN, 0);
}


void leds_all_on()
{
    gpio_put(LED0_PIN, 1);
    gpio_put(LED1_PIN, 1);
    gpio_put(LED2_PIN, 1);
}

void leds_all_off()
{
    gpio_put(LED0_PIN, 0);
    gpio_put(LED1_PIN, 0);
    gpio_put(LED2_PIN, 0);
}

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
    for (int i = 0; i < len; i++) {
        printf("%02x ", buf[i]);
    }
    printf("\r\n");
}
uint8_t dat_sent[14];
uint8_t dat_recv[14];
int main()
{

    fpga_flash_spi_deinit();


    fpga_reset_init();
    leds_init();
    fpga_powers_init();
    fpga_reset(0);
    sleep_ms(100);
//    fpga_powers_on();
//    sleep_ms(100);
    // Enable SPI 0 at 1 MHz and connect to GPIOs
    spi_init(ENv5_SPI, 100 * 1000);
    sleep_ms(1);
    spi_set_format(ENv5_SPI, 8, SPI_CPOL_0, SPI_CPHA_1, SPI_MSB_FIRST);
    sleep_ms(1);
    gpio_set_function(ENv5_SPI_RX_PIN, GPIO_FUNC_SPI);
    gpio_set_function(ENv5_SPI_TX_PIN, GPIO_FUNC_SPI);
    gpio_set_function(ENv5_SPI_SCK_PIN, GPIO_FUNC_SPI);

    gpio_init(ENv5_SPI_CS_PIN);
    gpio_put(ENv5_SPI_CS_PIN, 1);
    gpio_set_dir(ENv5_SPI_CS_PIN, GPIO_OUT);

    stdio_init_all();
    while(1)
    {
        char c = getchar_timeout_us(10000);
         if(c=='t')
         {
             printf("hello\r\n");
         }
        else if (c == 'L')
        {
            leds_all_on();
        }
        else if (c == 'l')
        {
            leds_all_off();
        }
        else if (c == 'F')
        {
            fpga_powers_on();
        }
        else if (c == 'f')
        {
            fpga_powers_off();
        }
        else if (c=='r')
        {
            fpga_reset(1);
            sleep_ms(100);
            fpga_reset(0);

        }
        else if (c =='w')
        {
            int err_cnt =0;
            for (int k=0; k<100; k++)
            {
                for(int i=0;i<14;i++)
                    dat_sent[i] = rand()%256;
                spi_data_send(ENv5_SPI, ENv5_SPI_CS_PIN, 0x0000, dat_sent, 14);

                spi_data_read(ENv5_SPI, ENv5_SPI_CS_PIN, 0x0000, dat_recv, 14);
                bool err_flag = false;
                for(int i=0;i<14;i++)
                {
                    if (dat_sent[i]!=dat_recv[i])
                    {
                        err_flag = true;
                        break;
                    }
                }
                if(err_flag)
                {
                    printf("Error in sequence %d, read doesn't match the write: \r\n Sent: ", k);
                    printbuf(dat_sent, 14);
                    printf("Recv: ");
                    printbuf(dat_recv, 14);
                    printf("\r\n");
                    err_cnt++;
                }
            }
            printf("SPI interface text finished, %d times error happened.\r\n", err_cnt);
        }

        else if (c>20 && c<128){
             printf("unknown char %c\r\n",c);
        }
    }

}
