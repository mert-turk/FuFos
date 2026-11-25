# ==================================================
# Toolchain
# ==================================================
set(TOOLCHAIN_FAMILY arm-gcc)
set(TOOLCHAIN_PATH "")
set(TOOLCHAIN_PREFIX arm-none-eabi-)

# ==================================================
# Target platform
# ==================================================
set(BSP_MCU xc7z010)

# ==================================================
# MCU Related flags
# ==================================================
set(MCU_TYPE cortex-a9)
set(MCU_INSTRUCTION_SET "")    # arm | thumb | empty (compiler default)
set(MCU_FPU vfpv3)
set(MCU_FLOAT_ABI hard)
set(MCU_F_CPU "")

# ==================================================
# Linker script
# ==================================================
set(LINKER_SCRIPT
    "${CMAKE_SOURCE_DIR}/platform/${BSP_MCU}/linker/lscript.ld"
)

# ==================================================
# Linker Related Flags
# ==================================================
set(ENABLE_GC_SECTIONS OFF)
set(ENABLE_MAP_FILE ON)
set(ENABLE_NANO_SPECS OFF)
set(ENABLE_STDLIB ON)

# ==================================================
# User defines
# ==================================================
set(USER_DEFINES
    SDT
    LOG_LEVEL=3
    "FW_VERSION=\"0.1.0\""
)

# ==================================================
# Extra Compiler flags
# ==================================================
set(EXTRA_USER_COMPILE_FLAGS
    -marm
    -ffunction-sections
    -fdata-sections
    "-specs=${CMAKE_SOURCE_DIR}/platform/${BSP_MCU}/bsp/Xilinx.spec"
)

# ==================================================
# Extra Linker flags
# ==================================================
set(EXTRA_USER_LINKER_FLAGS
    "-specs=${CMAKE_SOURCE_DIR}/platform/${BSP_MCU}/bsp/Xilinx.spec"
)

# ==================================================
# Build-specific definitions
# ==================================================
set(USER_DEFINES_DEBUG DEBUG_ENABLED)
set(USER_DEFINES_RELEASE NDEBUG)

# ==================================================
# JTAG Debugging
# ==================================================
set(XSCT_EXECUTABLE
    "/tools/Xilinx/Vitis/2024.2/bin/xsct"
)

set(PS7_INIT_SCRIPT
    "${CMAKE_SOURCE_DIR}/platform/${BSP_MCU}/hw/ps7_init.tcl"
)

# ==================================================
# Compiler warnings
# ==================================================
set(ENABLE_WALL   ON)
set(ENABLE_WEXTRA ON)
set(ENABLE_WERROR OFF)

# ==================================================
# Static analysis
# ==================================================
set(ENABLE_CPPCHECK ON)
set(ENABLE_CLANG_TIDY ON)