#include "board.h"
#include <pico/bootrom.h>
#include "pac193x/Pac193x.h"
#include "pac193x/Pac193xTypedefs.h"

pac193xPowerMeasurements_t sensor1_measurements;
pac193xPowerMeasurements_t sensor2_measurements;

static pac193xSensorConfiguration_t sensor1 = {
    .i2c_host = i2c1,
    .i2c_slave_address = PAC193X_I2C_ADDRESS_499R,
    .powerPin = -1,
    .usedChannels = {.uint_channelsInUse = 0b00001111},
    .rSense = {0.82f, 0.82f, 0.82f, 0.82f},
};

static pac193xSensorConfiguration_t sensor2 = {
    .i2c_host = i2c1,
    .i2c_slave_address = PAC193X_I2C_ADDRESS_806R,
    .powerPin = -1,
    .usedChannels = {.uint_channelsInUse = 0b00001111},
    .rSense = {0.82f, 0.82f, 0.82f, 0.82f},
};

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

void enterBootMode() {
    reset_usb_boot(0, 0);
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

void board_setup(void)
{
    pac193xErrorCode_t errorCode;

    fpga_flash_spi_deinit();
    fpga_reset_init();
    leds_init();
    fpga_powers_init();
    fpga_reset(0);
    sleep_ms(100);
    fpga_powers_on();
    sleep_ms(1000);

    fpga_reset(1);
    sleep_ms(100);
    fpga_reset(0);

    // enable QXI interface to the FPGA
    middleware_init();

    power_sensors_init();
    power_sensors_start();
}

void power_sensors_init(void)
{
    pac193xErrorCode_t errorCode;
    errorCode = pac193xInit(sensor1);
    errorCode = pac193xInit(sensor2);
}

void power_sensors_start(void)
{
    pac193xErrorCode_t errorCode;
    errorCode = pac193xStartAccumulation(sensor1);
    errorCode = pac193xStartAccumulation(sensor2);
}

void power_sensors_update(void)
{
    pac193xErrorCode_t errorCode;
    errorCode = pac193xReadAccumulatedPowerForAllChannels(sensor1, &sensor1_measurements);
    errorCode = pac193xReadAccumulatedPowerForAllChannels(sensor2, &sensor2_measurements);
}

void send_power_measurements(void)
{
    // VCC_SENSORS, VCC_USB, VCC_MCU, VCC_WIFI, VCC_FPGA_IO, VCC_FPGA_AUX, VCC_FPGA_INT, VCC_FPGA_SRAM
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