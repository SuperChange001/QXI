#ifndef MY_PROJECT_STUB_TRAFFIC_H

#define MY_PROJECT_STUB_TRAFFIC_H

#include <stdbool.h>
#include "pico/stdlib.h"
#include "middleware/middleware.h"

bool skeleton_switch(uint8_t id);
void skeleton_model_compute(bool enable);
void skeleton_write_inputs(int8_t* inputs);
void skeleton_enable();
void skeleton_disable();
bool skeleton_busy(void);
int8_t skeleton_read_result(void);

#define ADDR_SKELETON_INPUTS 0
#define LEN_INPUTS 6
#define ADDR_COMPUTATION_ENABLE 100

#endif