cmake_minimum_required(VERSION 3.4.1)

add_library(native_bridge SHARED
            src/main/cpp/native_bridge.cpp)

target_link_libraries(native_bridge
                     android
                     log)
