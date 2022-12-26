
add_library(middleware INTERFACE)

target_sources(middleware INTERFACE
        ${CMAKE_CURRENT_LIST_DIR}/middleware.c
        ${CMAKE_CURRENT_LIST_DIR}/qxi.c
        )


target_include_directories(middleware INTERFACE ${CMAKE_CURRENT_LIST_DIR})

# Pull in pico libraries that we need
target_link_libraries(middleware INTERFACE pico_stdlib hardware_spi)