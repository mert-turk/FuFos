# =========================
# Project linker options
# =========================
set(PROJECT_LINK_OPTIONS "")

# MCU flags must also go to the linker (selects the right multilib)
if(ARCH STREQUAL "ARM")

    list(APPEND PROJECT_LINK_OPTIONS 
        -mcpu=${MCU_TYPE} 
    )

    if(MCU_INSTRUCTION_SET)
        list(APPEND PROJECT_LINK_OPTIONS
            -m${MCU_INSTRUCTION_SET}
        )
    endif()
    
    if(MCU_FPU)
        list(APPEND PROJECT_LINK_OPTIONS
            -mfpu=${MCU_FPU}
        )
    endif()

    if(MCU_FLOAT_ABI)
        list(APPEND PROJECT_LINK_OPTIONS
            -mfloat-abi=${MCU_FLOAT_ABI}
        )
    endif()


    if(NOT EXISTS "${LINKER_SCRIPT}")
        message(FATAL_ERROR "LINKER_SCRIPT not found: ${LINKER_SCRIPT}")
    endif()
    
    list(APPEND PROJECT_LINK_OPTIONS 
        -T${LINKER_SCRIPT}
    )

    # =========================
    # Standard libraries
    # =========================
    if(NOT ENABLE_STDLIB)
        list(APPEND PROJECT_LINK_OPTIONS 
            -nostdlib
        )
    endif()


    # =========================
    # Nano specifications
    # =========================
    if(ENABLE_NANO_SPECS)
        list(APPEND PROJECT_LINK_OPTIONS 
            --specs=nano.specs 
            --specs=nosys.specs
        )
    endif()

elseif(ARCH STREQUAL "AVR")

    list(APPEND PROJECT_LINK_OPTIONS
        -mmcu=${MCU_TYPE}
    )

endif()

# =========================
# Garbage collection
# =========================
if(ENABLE_GC_SECTIONS) 
    list(APPEND PROJECT_LINK_OPTIONS
         -Wl,--gc-sections
    ) 
endif()

# =========================
# Extra user linker flags
# =========================
if(EXTRA_USER_LINKER_FLAGS)
    list(APPEND PROJECT_LINK_OPTIONS ${EXTRA_USER_LINKER_FLAGS})
endif()





