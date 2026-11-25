# ============================================================
# Information: This file gathers your Platform files and include
#              and creates final Platform object file for 
#              application complilation.
# ============================================================
cmake_minimum_required(VERSION 3.15)


# ============================================================
# include files for Platform
# ============================================================
include(${CMAKE_SOURCE_DIR}/platform/${BSP_MCU}/platformSources.cmake)
include(${CMAKE_MODULE_PATH}/common/compiler_flags.cmake)


# ============================================================
# Function to create Platform library with specified name 
# and specific clock frequency.
#
# Usage:
#   add_platform_variant(
#       <target_name>
#   )
# ============================================================
function(add_platform_variant TARGET_NAME)

    if(PLATFORM_SOURCES)

        add_library(${TARGET_NAME} OBJECT
            ${PLATFORM_SOURCES}
        )

        set(SCOPE PUBLIC)

        target_compile_options(${TARGET_NAME} PRIVATE
            ${PROJECT_COMPILE_OPTIONS}
        )

    else()

        add_library(${TARGET_NAME} INTERFACE)

        set(SCOPE INTERFACE)

    endif()

    target_include_directories(${TARGET_NAME} ${SCOPE}
        ${PLATFORM_INCLUDE_DIRS}
    )

    target_link_libraries(${TARGET_NAME} ${SCOPE}
        ${PLATFORM_LIBRARIES}
    )

    target_link_options(${TARGET_NAME} INTERFACE
        "-T${PLATFORM_LINKER_SCRIPT}"
    )

endfunction()

# ============================================================
# Create platform library.
# ============================================================
add_platform_variant(platform)

message(STATUS "Platform flags: ${PROJECT_COMPILE_OPTIONS}")
