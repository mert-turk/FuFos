# =========================
# Base project compile options
# =========================
set(PROJECT_COMPILE_OPTIONS "")

# =========================
# Get the Flags based on architecture
# =========================
if(ARCH STREQUAL "ARM")

    list(APPEND PROJECT_COMPILE_OPTIONS 
        -mcpu=${MCU_TYPE} 
    )

    if(MCU_INSTRUCTION_SET)
        list(APPEND PROJECT_COMPILE_OPTIONS
            -m${MCU_INSTRUCTION_SET}
        )
    endif()


    if(MCU_FPU)
        list(APPEND PROJECT_COMPILE_OPTIONS
            -mfpu=${MCU_FPU}
        )
    endif()

    if(MCU_FLOAT_ABI)
        list(APPEND PROJECT_COMPILE_OPTIONS
            -mfloat-abi=${MCU_FLOAT_ABI}
        )
    endif()

    if(MCU_F_CPU)
        list(APPEND PROJECT_COMPILE_OPTIONS
            -DF_CPU=${MCU_F_CPU}UL
        )
    endif()

elseif(ARCH STREQUAL "AVR")

    list(APPEND PROJECT_COMPILE_OPTIONS 
        -mmcu=${MCU_TYPE} 
        -DF_CPU=${MCU_F_CPU}UL
    )

endif()

# =========================
# Warnings
# =========================
if(ENABLE_WALL)   
    list(APPEND PROJECT_COMPILE_OPTIONS 
        -Wall
    )   
endif()

if(ENABLE_WEXTRA) 
    list(APPEND PROJECT_COMPILE_OPTIONS -Wextra) 
endif()

if(ENABLE_WERROR) 
    list(APPEND PROJECT_COMPILE_OPTIONS -Werror) 
endif()

# =========================
# Debug info
# =========================
if(ENABLE_DEBUG_INFO)   
    list(APPEND PROJECT_COMPILE_OPTIONS -g3) 
endif()

# =========================
# Optimization
# =========================
if(ENABLE_OPTIMIZATION) 
    list(APPEND PROJECT_COMPILE_OPTIONS -O0) 
else() 
    list(APPEND PROJECT_COMPILE_OPTIONS -O0) 
endif()

# =========================
# User defines
# =========================
set(_defs ${USER_DEFINES})

if(ENABLE_DEBUG_INFO)
    list(APPEND _defs ${USER_DEFINES_DEBUG})
else()
    list(APPEND _defs ${USER_DEFINES_RELEASE})
endif()

foreach(_d IN LISTS _defs)
    if(NOT _d MATCHES "^[A-Za-z_][A-Za-z0-9_]*(=.*)?$")
        message(FATAL_ERROR "userConfig.cmake: invalid define '${_d}'")
    endif()
endforeach()

list(REMOVE_DUPLICATES _defs)
list(TRANSFORM _defs PREPEND "-D")          # needs CMake >= 3.12
list(APPEND PROJECT_COMPILE_OPTIONS ${_defs})


# =========================
# Extra user compile flags
# =========================
if(EXTRA_USER_COMPILE_FLAGS)
    list(APPEND PROJECT_COMPILE_OPTIONS 
        ${EXTRA_USER_COMPILE_FLAGS}
    )
endif()
