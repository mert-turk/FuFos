cmake_minimum_required(VERSION 3.15)

# Pull in cross-compilation toolchain flags
include(${CMAKE_MODULE_PATH}/options.cmake)
include(${CMAKE_MODULE_PATH}/common/compiler_flags.cmake)
include(${CMAKE_MODULE_PATH}/common/linker_flags.cmake)
include(${CMAKE_MODULE_PATH}/common/static_analyses.cmake)
include(${CMAKE_MODULE_PATH}/common/format.cmake)
# include(${CMAKE_FLASH_PATH})


# ============================================================
#  Add source files
# ============================================================
set(FIRMWARE_COMMON_SOURCES
    hello_world/main.c
    # ... add your implementation files
)

# ============================================================
# Common include directories
# ============================================================
set(FIRMWARE_INCLUDE_DIRS
    # ... add include directories here
)

# ============================================================
# Common part (shared by all architectures)
# Not meant to be called directly, use add_executable_variant()
# ============================================================
function(_add_executable_common TARGET_NAME COMM_SOURCE BSP_TARGET)

    add_executable(${TARGET_NAME}
        ${FIRMWARE_COMMON_SOURCES}
        ${COMM_SOURCE}
    )

    set_target_properties(${TARGET_NAME} PROPERTIES SUFFIX ".elf")

    if(FIRMWARE_INCLUDE_DIRS)
        target_include_directories(${TARGET_NAME} PRIVATE
            ${FIRMWARE_INCLUDE_DIRS}
        )
    endif()

    target_compile_options(${TARGET_NAME} PRIVATE
        ${PROJECT_COMPILE_OPTIONS}
    )

    target_link_options(${TARGET_NAME} PRIVATE
        ${PROJECT_LINK_OPTIONS}
    )

    target_link_libraries(${TARGET_NAME}
        PRIVATE
        ${BSP_TARGET}
    )

    # HEX + BIN
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY}
            -O ihex
            $<TARGET_FILE:${TARGET_NAME}>
            $<TARGET_FILE_DIR:${TARGET_NAME}>/${TARGET_NAME}.hex

        COMMAND ${CMAKE_OBJCOPY}
            -O binary
            $<TARGET_FILE:${TARGET_NAME}>
            $<TARGET_FILE_DIR:${TARGET_NAME}>/${TARGET_NAME}.bin

        COMMENT "Generating HEX and BIN for ${TARGET_NAME}..."
    )

    # Disassembly listing
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_OBJDUMP}
            -h
            -SD
            $<TARGET_FILE:${TARGET_NAME}> >
            $<TARGET_FILE_DIR:${TARGET_NAME}>/${TARGET_NAME}.lss

        COMMENT "Generating disassembly listing for ${TARGET_NAME}..."
    )

    # Size report
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_SIZE}
            $<TARGET_FILE:${TARGET_NAME}>
        COMMENT "Displaying firmware size for ${TARGET_NAME}..."
    )

endfunction()


# ============================================================
# AVR variant
# ============================================================
function(add_executable_variant_avr TARGET_NAME COMM_SOURCE BSP_TARGET)

    _add_executable_common(${TARGET_NAME} "${COMM_SOURCE}" ${BSP_TARGET})

    # EEPROM image (AVR only)
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY}
            -O ihex
            -j .eeprom
            --change-section-lma .eeprom=0
            $<TARGET_FILE:${TARGET_NAME}>
            $<TARGET_FILE_DIR:${TARGET_NAME}>/${TARGET_NAME}.eep

        COMMENT "Generating EEPROM image for ${TARGET_NAME}..."
    )


endfunction()


# ============================================================
# ARM variant
# ============================================================
function(add_executable_variant_arm TARGET_NAME COMM_SOURCE BSP_TARGET)

    _add_executable_common(${TARGET_NAME} "${COMM_SOURCE}" ${BSP_TARGET})

    # Map file (ARM only)
    target_link_options(${TARGET_NAME} PRIVATE
        -Wl,-Map=$<TARGET_FILE_DIR:${TARGET_NAME}>/${TARGET_NAME}.map
    )



endfunction()


# ============================================================
# Dispatcher: the call site stays architecture-neutral
# ============================================================
function(add_executable_variant TARGET_NAME COMM_SOURCE BSP_TARGET)

    if(ARCH STREQUAL "AVR")
        add_executable_variant_avr(${TARGET_NAME} "${COMM_SOURCE}" ${BSP_TARGET})
    elseif(ARCH STREQUAL "ARM")
        add_executable_variant_arm(${TARGET_NAME} "${COMM_SOURCE}" ${BSP_TARGET})
    else()
        message(FATAL_ERROR "No executable variant for ARCH='${ARCH}'")
    endif()

endfunction()


# ============================================================
# Create executable or many executables :)
# ============================================================
add_executable_variant(
    hello_world
    ""
    platform
)

# ============================================================
# Create flash target, make sure name is matched with your elf
# ============================================================
# setup_flash_targets(firmware)