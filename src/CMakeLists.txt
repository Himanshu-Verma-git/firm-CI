cmake_minimum_required(VERSION 3.13)

include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)

project(blink_simple C CXX ASM)

pico_sdk_init()

add_executable(blink_simple
    blink_simple.c
)

target_link_libraries(blink_simple pico_stdlib)

pico_enable_stdio_usb(blink_simple 1)
pico_enable_stdio_uart(blink_simple 0)

pico_add_extra_outputs(blink_simple)

