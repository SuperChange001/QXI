
add_library(board_lib INTERFACE)

target_sources(board_lib INTERFACE
        ${CMAKE_CURRENT_LIST_DIR}/board.c
        )


target_include_directories(board_lib INTERFACE ${CMAKE_CURRENT_LIST_DIR})

# Pull in pico libraries that we need
target_link_libraries(board_lib INTERFACE pico_stdlib hardware_spi hardware_gpio sensor_lib_pac193x)