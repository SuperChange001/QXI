#include "stub_skeleton.h"

uint8_t skeleton_get_id()
{
    middleware_userlogic_enable();
    uint8_t id = middleware_userlogic_get_design_id();
    // printf("design id: %02x\r\n", id);
    middleware_userlogic_disable();

    return id;
}

bool skeleton_switch(uint8_t id)
{
    bool res = true;
    if(id==0x05)
    {
        middleware_configure_fpga(0x0000);
    }

    else if(id==0x16)
    {
        middleware_configure_fpga(0x00100000);
    }
    else
    {
        // do nothing
    }

    sleep_ms(200);
    if(skeleton_get_id()!=id)
    {
        res = false;
    }
    return res;

}

void skeleton_enable()
{
    middleware_userlogic_enable();
}

void skeleton_disable()
{
    middleware_userlogic_disable();
}


void skeleton_write_inputs(int8_t* inputs)
{
    // it adds the offset already!
    middleware_userlogic_write_blocking(ADDR_SKELETON_INPUTS, (uint8_t* )(inputs), LEN_INPUTS);
}

int8_t skeleton_read_result(void)
{   
    int8_t result;
    middleware_userlogic_read_blocking(1, (uint8_t* )(&result), 1);
    return result;
}


void skeleton_model_compute(bool enable)
{
    uint8_t cmd[1] = {0x01};
    if(enable)
        cmd[0] = 1;
    else
        cmd[0] = 0;

    middleware_userlogic_write_blocking(ADDR_COMPUTATION_ENABLE, cmd, 1);
}

bool skeleton_busy(void)
{
   return middleware_userlogic_get_busy_status();
}



