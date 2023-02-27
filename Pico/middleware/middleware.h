//
// Created by chao on 26/12/22.
//

#ifndef MY_PROJECT_MIDDLEWARE_H
#define MY_PROJECT_MIDDLEWARE_H
#include "qxi.h"


#define ADDR_LEDS 0x0003
#define ADDR_USER_LOGIC_RESET 0x0004
#define ADDR_MULTI_BOOT 0x0005
#define ADDR_USER_LOGIC_OFFSET 0x0100
#define ADDR_DESIGN_ID (ADDR_USER_LOGIC_OFFSET+2000)


void middleware_init();
void middleware_deinit();
void middleware_configure_fpag(uint32_t address);
void middleware_set_leds(uint8_t leds);
uint8_t middleware_get_leds(void);
uint8_t middleware_get_design_id(void);
void middleware_write_blocking(uint32_t address, uint8_t* data, uint16_t len);
uint8_t middleware_read_blocking(uint32_t address, uint8_t* data, uint16_t len);
void middleware_userlogic_enable(void);
void middleware_userlogic_disable(void);
#endif //MY_PROJECT_MIDDLEWARE_H
