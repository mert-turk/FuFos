
# =========================================================
# Flash system (EDBG / OpenOCD).
# This CMake file is platform dependent.
# Change if you have a different MCU or debugger.
# =========================================================


# ---------------------------------------------------------
# Programmer configuration
# ---------------------------------------------------------

set(OPENOCD_INTERFACE "interface/cmsis-dap.cfg")
set(OPENOCD_TARGET "target/at91sam3ax_8x.cfg")
set(OPENOCD_CHIPNAME "at91sam3")

set(OPENOCD_TRANSPORT "swd")




set(GDB_PORT 3333)
set(GDB_HOST "localhost")


# ---------------------------------------------------------
# Base OpenOCD command
# ---------------------------------------------------------
set(OPENOCD_SCRIPTS_DIR "C:/OpenOCD/share/openocd/scripts")

set(OPENOCD_BASE_COMMAND
    "${OPENOCD}"
    -s "${OPENOCD_SCRIPTS_DIR}"
    -f "${OPENOCD_INTERFACE}"
    -c "transport select ${OPENOCD_TRANSPORT}"
    -c "set CHIPNAME ${OPENOCD_CHIPNAME}"
    -f "${OPENOCD_TARGET}"
    -c "adapter speed 100"
)

# =========================================================
# Flash target
#
# Usage:
# add_openocd_flash_target(target_name firmware_target)
# =========================================================

function(add_openocd_flash_target FLASH_TARGET FW_TARGET)

    add_custom_target(${FLASH_TARGET}
        COMMAND ${OPENOCD_BASE_COMMAND}
            -c "init"
            -c "reset halt"
            -c "program $<TARGET_FILE:${FW_TARGET}> verify"
            -c "reset run"
            -c "shutdown"
        DEPENDS ${FW_TARGET}
        COMMENT "Flashing ${FW_TARGET} using OpenOCD"
        USES_TERMINAL
        VERBATIM
    )

endfunction()


# =========================================================
# Erase flash target
#
# Usage:
# add_openocd_erase_target(target_name)
# =========================================================

function(add_openocd_erase_target TARGET_NAME)

    add_custom_target(${TARGET_NAME}
        COMMAND ${OPENOCD_BASE_COMMAND}
            -c "init"
            -c "reset halt"
            -c "at91sam3 chip-erase"
            -c "shutdown"
        COMMENT "Erasing at91sam3 internal flash"
        VERBATIM
    )

endfunction()

#=========================================================
# Debug client target
# =========================================================
function(add_gdb_debug_target DEBUG_TARGET FW_TARGET)

    add_custom_target(${DEBUG_TARGET}
        COMMAND ${CMAKE_GDB}
                $<TARGET_FILE:${FW_TARGET}>
                -ex "target remote ${GDB_HOST}:${GDB_PORT}"
        DEPENDS ${FW_TARGET}
        COMMENT "Starting GDB debugger for ${FW_TARGET}"
        USES_TERMINAL
        VERBATIM
    )

endfunction()


# =========================================================
# Debug server target
#
# Usage:
# add_openocd_debug_server(debug_server)
# =========================================================
function(add_openocd_debug_server TARGET_NAME)

    add_custom_target(${TARGET_NAME}
        COMMAND ${OPENOCD_BASE_COMMAND}
            -c "init"
            -c "reset halt"
        COMMENT "Starting OpenOCD GDB server (CPU halted)"
        USES_TERMINAL
        VERBATIM
    )

endfunction()



# ============================================================
# Flash target
# ============================================================
function(setup_flash_targets APP_TARGET)
    add_openocd_flash_target(flash ${APP_TARGET})
    add_openocd_debug_server(debug_server)
    add_gdb_debug_target(debug_client ${APP_TARGET})
endfunction()