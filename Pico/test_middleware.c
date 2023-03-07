// This program only works with the logic design with middleware
#include "pico/stdlib.h"
#include <stdio.h>
#include "hardware/spi.h"
#include <stdlib.h>
#include <stdbool.h>
#include "Common.h"
#include <time.h>
#include "stub_skeleton.h"
#include "board/board.h"

/** Private functions**/
static void update_inputs(uint8_t* recv_buf, char new_c, uint8_t* inputs);
static void decode_sensor_data(uint8_t* recv_buf, int8_t* inputs);


/* predict_on_fpga
 * Give an array with 6 inputs
 * returns the predicted traffic speed in the next
 * */
int8_t predict_traffic_speed(int8_t* inputs)
{
    int8_t result;

    skeleton_enable();

    skeleton_write_inputs(inputs);
    skeleton_model_compute(true);
    while(skeleton_busy()); // Blocked until the inference is finished.
    result = skeleton_read_result();

    skeleton_model_compute(false);

    skeleton_disable();
    return result;
}

int main()
{
    int8_t prediction;
    absolute_time_t last_absolute_time=0;
    absolute_time_t t_now, t0, t1;
    uint8_t recv_buf[18];
    int8_t inputs[6];

    stdio_init_all();
    board_setup();

    while(1)
    {
        t_now = get_absolute_time();
        if(absolute_time_diff_us(last_absolute_time, t_now)>20000)
        {
            power_sensors_update();
            last_absolute_time = t_now;
        }
        char c = getchar_timeout_us(10000);

        if(c>=10 && c<128)
        {
            if(c>='0' && c<='9')
            {
                update_inputs(recv_buf, c, inputs);
            }
            else if (c=='f' || c=='F')
            {
                if(c=='F')
                    fpga_powers_on();
                else
                    fpga_powers_off();
            }
            else if (c=='s' || c=='S')
            {
                if(get_fpga_power_state()==1)
                {
                    if (c=='s')
                        skeleton_switch(0x04);
                    else
                        skeleton_switch(0x14);
                }
                else
                {
                    printf("d, FPGA is powered off, you cannot change model\r\n");
                }
            }
            else if (c=='p')
            {
                send_power_measurements();
            }
            else if (c==0x0d)
            {
                if(get_fpga_power_state()==1)
                {
                    t0 = get_absolute_time();
                    prediction = predict_traffic_speed(inputs);
                    t1 = get_absolute_time();
                    printf("x,%03d,%ld\r\n", prediction + 500, absolute_time_diff_us(t0, t1));
                }
                else
                {
                    printf("d, FPGA is powered off, cannot inference\r\n");
                }
            }
        }
    }
}


/** Helper functions for getting decimal sensor data from serial port**/
static void update_inputs(uint8_t* recv_buf, char new_c, uint8_t* inputs)
{
    for(int i=0; i<18;i++)
    {
        recv_buf[i] = recv_buf[i+1];
    }
    recv_buf[17] = new_c;
    decode_sensor_data(recv_buf, inputs);
}

static void decode_sensor_data(uint8_t* recv_buf, int8_t* inputs)
{
    for(int i=0; i<6;i++)
    {
        inputs[i] = ((recv_buf[i*3]-0x30)*100 + (recv_buf[i*3+1]-0x30)*10 + (recv_buf[i*3+2]-0x30))-500;
    }
}
/** Helper functions for getting decimal sensor data from serial port**/




