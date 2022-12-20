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

    add_executable(test_spi test_spi.c)

    # Pull in our pico_stdlib which aggregates commonly used features
    target_link_libraries(test_spi pico_stdlib hardware_spi)


    # enable usb output, disable uart output
    pico_enable_stdio_usb(test_spi 1)
    pico_enable_stdio_uart(test_spi 0)

    # create map/bin/hex/uf2 file etc.
    pico_add_extra_outputs(test_spi)


elseif(PICO_ON_DEVICE)
    message(WARNING "not building hello_usb because TinyUSB submodule is not initialized in the SDK")
endif()