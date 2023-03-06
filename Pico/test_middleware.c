// This program only works with the logic design with middleware
#include "pico/stdlib.h"
#include <stdio.h>
#include "hardware/spi.h"
#include <stdlib.h>
#include <stdbool.h>
#include "middleware/middleware.h"
#include <pico/bootrom.h>
#include "Common.h"
#include "pac193x/Pac193x.h"
#include "pac193x/Pac193xTypedefs.h"
#include <hardware/i2c.h>
#include <time.h>
#include "stub_skeleton.h"

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

// Functions declaration
void fpga_flash_spi_deinit();
void fpga_powers_init();
void fpga_powers_on();

void fpga_powers_off();
void fpga_reset(unsigned int reset_en);
void leds_init(void);
void leds_all_on();
void fpga_reset_init(void);
void leds_all_off();
void printbuf(uint8_t *buf, int16_t len);
static void enterBootMode();

uint8_t dat_sent[14];
uint8_t dat_recv[14];

uint8_t dataset_logic[24] = {0,0,0,0,0,16,0,16,0,0,16,16,16,0,0,16,0,16,16,16,0,16,16,16};
// uint8_t dataset[24] = {0,16,16};
uint8_t cmd[1] = {0x01};
uint8_t read_data[3];
int8_t reults[8];

int8_t predict_on_fpga(int8_t* inputs)
{
    int8_t result;

    skeleton_enable();

    skeleton_write_inputs(inputs);
    skeleton_model_compute(true);
    while(skeleton_busy());
    result = skeleton_read_result();

    skeleton_model_compute(false);

    skeleton_disable();
    return result;
}


uint8_t recv_buf[18];
int8_t inputs[6];
void mem_copy(uint8_t* recv_buf)
{
    for(int i=0; i<18;i++)
    {
        recv_buf[i] = recv_buf[i+1];
    }
}

void decode_sensor_data(uint8_t* recv_buf, int8_t* inputs)
{
    for(int i=0; i<6;i++)
    {
        inputs[i] = ((recv_buf[i*3]-0x30)*100 + (recv_buf[i*3+1]-0x30)*10 + (recv_buf[i*3+2]-0x30))-500;
    }
}

/* region SENSOR DEFINITIONS */

static pac193xSensorConfiguration_t sensor1 = {
    .i2c_host = i2c1,
    .i2c_slave_address = PAC193X_I2C_ADDRESS_499R,
    .powerPin = -1,
    .usedChannels = {.uint_channelsInUse = 0b00001111},
    .rSense = {0.82f, 0.82f, 0.82f, 0.82f},
};
#define PAC193X_CHANNEL_SENSORS PAC193X_CHANNEL01
#define PAC193X_CHANNEL_RAW PAC193X_CHANNEL02
#define PAC193X_CHANNEL_MCU PAC193X_CHANNEL03
#define PAC193X_CHANNEL_WIFI PAC193X_CHANNEL04
// VCC_SENSORS, VCC_USB, VCC_MCU, VCC_WIFI, VCC_FPGA_IO, VCC_FPGA_AUX, VCC_FPGA_INT, VCC_FPGA_SRAM
static pac193xSensorConfiguration_t sensor2 = {
    .i2c_host = i2c1,
    .i2c_slave_address = PAC193X_I2C_ADDRESS_806R,
    .powerPin = -1,
    .usedChannels = {.uint_channelsInUse = 0b00001111},
    .rSense = {0.82f, 0.82f, 0.82f, 0.82f},
};
#define PAC193X_CHANNEL_FPGA_IO PAC193X_CHANNEL01
#define PAC193X_CHANNEL_FPGA_1V8 PAC193X_CHANNEL02
#define PAC193X_CHANNEL_FPGA_1V PAC193X_CHANNEL03
#define PAC193X_CHANNEL_FPGA_SRAM PAC193X_CHANNEL04

/* endregion SENSOR DEFINITIONS */


pac193xPowerMeasurements_t sensor1_measurements;
pac193xPowerMeasurements_t sensor2_measurements;
int8_t prediction;
absolute_time_t last_absolute_time=0;
int main()
{   
    uint8_t counter=0;

    fpga_flash_spi_deinit();
    fpga_reset_init();
    leds_init();
    fpga_powers_init();
    fpga_reset(0);
    sleep_ms(100);
    fpga_powers_on();
    sleep_ms(1000);
//    fpga_powers_off();
    fpga_reset(1);
    sleep_ms(100);
    fpga_reset(0);

    // enable QXI interface to the FPGA
    middleware_init();

    stdio_init_all();

    pac193xErrorCode_t errorCode;
    
    errorCode = pac193xInit(sensor1);
    errorCode = pac193xInit(sensor2);
    errorCode = pac193xStartAccumulation(sensor1);
    errorCode = pac193xStartAccumulation(sensor2);
    while(1)
    {
        absolute_time_t t_now = get_absolute_time(); 
        if(absolute_time_diff_us(last_absolute_time, t_now)>20000)
        {
            errorCode = pac193xReadAccumulatedPowerForAllChannels(sensor1, &sensor1_measurements);
            errorCode = pac193xReadAccumulatedPowerForAllChannels(sensor2, &sensor2_measurements);
            last_absolute_time = t_now;
        }


        char c = getchar_timeout_us(10000);

        if(c>=10 && c<128)
        {
            // printf("%c", c);
            if(c>='0' && c<='9')
            {
                mem_copy(recv_buf);
                recv_buf[17] = c;
            }
            else if (c=='t')
            {
                for(int i=0;i<6;i++)
                    printf("%d,", inputs[i]);
                printf("\r\n===========\r\n");
            //     if(skeleton_switch(0x05))
            //     {
            //         printf("d, switched to model 1\r\n");
            //     }
            //     else
            //     {
            //         printf("d, switching model faild\r\n");
            //     }
            // }
            // else if (c=='T') // change the command
            // {
            //     if(skeleton_switch(0x16))
            //     {
            //         printf("d, switched to model 2\r\n");
            //     }
            //     else
            //     {
            //         printf("d, switching model faild\r\n");
            //     }
            }
            else if (c=='p')
            {
                printf("p,%4.6f,%4.6f,%4.6f,%4.6f,%4.6f,%4.6f,%4.6f,%4.6f,\r\n",
                sensor1_measurements.powerChannel1/sensor1_measurements.counterOfMeasurements,
                sensor1_measurements.powerChannel2/sensor1_measurements.counterOfMeasurements,
                sensor1_measurements.powerChannel3/sensor1_measurements.counterOfMeasurements,
                sensor1_measurements.powerChannel4/sensor1_measurements.counterOfMeasurements,
                sensor2_measurements.powerChannel1/sensor1_measurements.counterOfMeasurements,
                sensor2_measurements.powerChannel2/sensor1_measurements.counterOfMeasurements,
                sensor2_measurements.powerChannel3/sensor1_measurements.counterOfMeasurements,
                sensor2_measurements.powerChannel4/sensor1_measurements.counterOfMeasurements
                );
            }
            else if (c==0x0d)
            {
                decode_sensor_data(recv_buf, inputs);
                prediction = predict_on_fpga(inputs);
                          
                printf("x,%03d,\r\n", prediction+500);

                counter++;
                if(counter%2)
                {
                    leds_all_on();
                }
                else
                {
                    leds_all_off();
                }
                
            }

        }

    }

}


void fpga_flash_spi_deinit() {
    gpio_init(SPI_FPGA_FLASH_CS);
    gpio_set_dir(SPI_FPGA_FLASH_CS, GPIO_IN);
    gpio_init(SPI_FPGA_FLASH_MISO);
    gpio_set_dir(SPI_FPGA_FLASH_MISO, GPIO_IN);
    gpio_init(SPI_FPGA_FLASH_MOSI);
    gpio_set_dir(SPI_FPGA_FLASH_MOSI, GPIO_IN);
    gpio_init(SPI_FPGA_FLASH_SCK);
    gpio_set_dir(SPI_FPGA_FLASH_SCK, GPIO_IN);
}

void fpga_powers_init() {
    // voltage regulator off
    gpio_init(FPGA_VOL_REGULATOR_EN_PIN);
    gpio_set_dir(FPGA_VOL_REGULATOR_EN_PIN, GPIO_OUT);
    gpio_put(FPGA_VOL_REGULATOR_EN_PIN, 0);

    // MOS FETS off
    gpio_init(FPGA_MOS_EN_PIN);
    gpio_set_dir(FPGA_MOS_EN_PIN, GPIO_OUT);
    gpio_put(FPGA_MOS_EN_PIN, 1);
}

void fpga_powers_on() {
    // voltage regulator on
    gpio_put(FPGA_VOL_REGULATOR_EN_PIN, 1);

    sleep_ms(10);

    // MOS FETS on
    gpio_put(FPGA_MOS_EN_PIN, 0);
}

void fpga_powers_off() {
    // voltage regulator on
    gpio_put(FPGA_VOL_REGULATOR_EN_PIN, 0);

    // MOS FETS on
    gpio_put(FPGA_MOS_EN_PIN, 1);
}

void fpga_reset(unsigned int reset_en) {
    if(reset_en)
    {
        gpio_put(FPGA_RESET_CTRL_PIN, 0);
    }
    else
    {
        gpio_put(FPGA_RESET_CTRL_PIN, 1);
    }

}

void leds_all_on() {
    gpio_put(LED0_PIN, 1);
    gpio_put(LED1_PIN, 1);
    gpio_put(LED2_PIN, 1);
}

void leds_init(void) {
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

void fpga_reset_init(void) {
    gpio_init(FPGA_RESET_CTRL_PIN);
    gpio_set_dir(FPGA_RESET_CTRL_PIN, GPIO_OUT);
    gpio_put(FPGA_RESET_CTRL_PIN, 1);
}

void leds_all_off() {
    gpio_put(LED0_PIN, 0);
    gpio_put(LED1_PIN, 0);
    gpio_put(LED2_PIN, 0);
}

void printbuf(uint8_t *buf, int16_t len) {
    for (int i = 0; i < len; i++) {
        printf("%02x ", buf[i]);
    }
    printf("\r\n");
}

static void enterBootMode() {
    reset_usb_boot(0, 0);
}
