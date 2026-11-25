cmake_minimum_required(VERSION 3.15)

# Set the CMAKE folder
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Preset decides: ENABLE_TESTS, ENABLE_DEBUG_INFO, ENABLE_OPTIMIZATION
# userConfig decides: everything hardware related
include(${CMAKE_SOURCE_DIR}/cmake/userConfig.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/toolchain/resolveToolchain.cmake)          # sets ARCH + CMAKE_TOOLCHAIN_FILE

# ============================================================
# Project information
# ============================================================
project(
    FuFos
    VERSION 0.1.0
    LANGUAGES C CXX ASM
)


# Verbose is enabled to see flags in compaliton
set(CMAKE_VERBOSE_MAKEFILE ON)

# Include options...
include(options)

# Add subdirectory based on operation
if(ENABLE_TESTS)
    enable_testing()
    add_subdirectory(tests)
else()
    # add_subdirectory(include)
    # add_subdirectory(source)
    add_subdirectory(platform)
    add_subdirectory(examples)
endif()



# Messages for User
message(STATUS "Project version: ${PROJECT_VERSION}")
message(STATUS "Used BSP: ${BSP_MCU}")
message(STATUS "Toolchain Directory: ${CMAKE_TOOLCHAIN_FILE}")