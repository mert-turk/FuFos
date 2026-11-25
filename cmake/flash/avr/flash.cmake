# =========================================================
# Flash system (Atmel-ICE / avrdude). This cmake file is
# platform dependent. Change if you have different MCU
# =========================================================


# ---------------------------------------------------------
# Programmer configuration
# ---------------------------------------------------------
set(AVR_PROGRAMMER          atmelice_isp)
set(AVR_PROGRAMMER_PORT     usb)
set(AVR_PROGRAMMER_BITCLOCK 1)
set(AVRDUDE_MCU             m64m1)


# ==========================================
# Fuses (default values)
# ==========================================
set(E_FUSE 0xff)
set(H_FUSE 0xd8)
set(L_FUSE 0xd2)




# ---------------------------------------------------------
# Base avrdude command
# ---------------------------------------------------------
set(AVRDUDE_BASE_COMMAND
    ${AVRDUDE}
    -c ${AVR_PROGRAMMER}
    -P ${AVR_PROGRAMMER_PORT}
    -B ${AVR_PROGRAMMER_BITCLOCK}
    -p ${AVRDUDE_MCU}
)


# ---------------------------------------------------------
# Flash target

# Usage:
# add_avr_flash_target(target_name firmware_target hex_file eep_file)
# ---------------------------------------------------------
function(add_avr_flash_target FLASH_TARGET FW_TARGET HEX_FILE EEP_FILE)

    add_custom_target(${FLASH_TARGET}
        COMMAND ${AVRDUDE_BASE_COMMAND}
            -U flash:w:${HEX_FILE}:i
            -U eeprom:w:${EEP_FILE}:i
        DEPENDS ${FW_TARGET}
        COMMENT "Flashing ${HEX_FILE} and ${EEP_FILE} to ${MCU}"
        VERBATIM
    )

endfunction()

# =========================================================
# Used for fusing microcontroller.

# Usage:
# add_avr_fuse_target(target_name lfuse hfuse efuse)
#
# =========================================================
function(add_avr_fuse_target TARGET_NAME LFUSE HFUSE EFUSE)

    add_custom_target(${TARGET_NAME}
        COMMAND ${AVRDUDE_BASE_COMMAND}
            -U lfuse:w:${LFUSE}:m
            -U hfuse:w:${HFUSE}:m
            -U efuse:w:${EFUSE}:m
        COMMENT "Programming AVR fuses"
        VERBATIM
    )

endfunction()

# ============================================================
# Flash target
# ============================================================
function(setup_flash_targets APP_TARGET)
    add_avr_flash_target(flash ${APP_TARGET}
        $<TARGET_FILE_DIR:${APP_TARGET}>/${APP_TARGET}.hex
        $<TARGET_FILE_DIR:${APP_TARGET}>/${APP_TARGET}.eep)
    add_avr_fuse_target(fuses ${MCU_FUSES_L} ${MCU_FUSES_H} ${MCU_FUSES_E})
endfunction()