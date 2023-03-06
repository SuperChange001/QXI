#ifndef MY_PROJECT_BOARD_H

#define MY_PROJECT_BOARD_H

#include <stdbool.h>
#include "pico/stdlib.h"
#include "pico/stdio.h"
#include <hardware/i2c.h>

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

// extern pac193xSensorConfiguration_t sensor1;
// extern pac193xSensorConfiguration_t sensor2;

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

void enterBootMode();
void board_setup(void);
void power_sensors_init(void);
void power_sensors_update(void);
void power_sensors_start(void);
void send_power_measurements(void);
#endif