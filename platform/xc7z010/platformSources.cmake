# ============================================================
# Platform root directory
# ============================================================
set(PLATFORM_DIR "${CMAKE_CURRENT_LIST_DIR}")

# ============================================================
# Platform source files
# ============================================================
set(PLATFORM_SOURCES
    # Add our platform-specific source files later
)

# ============================================================
# Platform include directories
# ============================================================
set(PLATFORM_INCLUDE_DIRS
    "${PLATFORM_DIR}/bsp/include"
)

# ============================================================
# Platform libraries
# ============================================================
set(PLATFORM_LIB_DIR
    "${PLATFORM_DIR}/bsp/lib"
)

set(PLATFORM_LIBRARIES
    "-Wl,--start-group"

    "${PLATFORM_LIB_DIR}/libxilstandalone.a"
    "${PLATFORM_LIB_DIR}/libxiltimer.a"
    "${PLATFORM_LIB_DIR}/libxil.a"

    gcc
    c

    "-Wl,--end-group"
)

# ============================================================
# Platform linker script
# ============================================================
set(PLATFORM_LINKER_SCRIPT
    "${PLATFORM_DIR}/linker/lscript.ld"
)