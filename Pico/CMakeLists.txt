cmake_minimum_required(VERSION 3.13)

# initialize pico-sdk from GIT
# (note this can come from environment, CMake cache etc)
set(PICO_SDK_FETCH_FROM_GIT on)

# pico_sdk_import.cmake is a single file copied from this SDK
# note: this must happen before project()
include(pico_sdk_import.cmake)

project(my_project)

# initialize the Raspberry Pi Pico SDK
pico_sdk_init()


# rest of your project

if (TARGET tinyusb_device)

    add_subdirectory(middleware)
    add_subdirectory(pac193x)
    add_subdirectory(gpio)
    add_subdirectory(i2c)

    ###########################################################
    # creates test_middleware executable
    add_executable(test_middleware test_middleware.c stub_skeleton.c)
    target_include_directories(test_middleware PUBLIC .)
    # Pull in our pico_stdlib which aggregates commonly used features
    target_link_libraries(test_middleware pico_stdlib 
            pico_time
            hardware_i2c 
            hardware_spi 
            middleware 
            sensor_lib_pac193x)

    # enable usb output, disable uart output
    pico_enable_stdio_usb(test_middleware 1)
    pico_enable_stdio_uart(test_middleware 0)

    # create map/bin/hex/uf2 file etc.
    pico_add_extra_outputs(test_middleware)


elseif(PICO_ON_DEVICE)
    message(WARNING "not building hello_usb because TinyUSB submodule is not initialized in the SDK")
endif()