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




uint8_t recv_buf[18];
int8_t inputs[6];

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



void decode_sensor_data(uint8_t* recv_buf, int8_t* inputs)
{
    for(int i=0; i<6;i++)
    {
        inputs[i] = ((recv_buf[i*3]-0x30)*100 + (recv_buf[i*3+1]-0x30)*10 + (recv_buf[i*3+2]-0x30))-500;
    }
}

void fifo_add_num_char(uint8_t* recv_buf, char new_c)
{
    for(int i=0; i<18;i++)
    {
        recv_buf[i] = recv_buf[i+1];
    }
    recv_buf[17] = new_c;
    decode_sensor_data(recv_buf, inputs);
}






int8_t prediction;
absolute_time_t last_absolute_time=0;
int main()
{   
    uint8_t counter=0;
    stdio_init_all();

    board_setup();
    
    while(1)
    {
        absolute_time_t t_now = get_absolute_time(); 
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
                fifo_add_num_char(recv_buf, c);
            }
            else if (c=='s')
            {
                skeleton_switch(0x05);
            }
            else if (c=='S') // change the command
            {
                skeleton_switch(0x16);
            }
            else if (c=='p')
            {
                send_power_measurements();
            }
            else if (c==0x0d)
            {
                prediction = predict_on_fpga(inputs);
                          
                printf("x,%03d,\r\n", prediction+500);

                // counter++;
                // if(counter%2)
                // {
                //     leds_all_on();
                // }
                // else
                // {
                //     leds_all_off();
                // }
                
            }

        }

    }

}






