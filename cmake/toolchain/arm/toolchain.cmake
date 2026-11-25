
# ==========================================
# ARM GCC Toolchain for ATSAMV71Q21
# ==========================================

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Tell CMake we are cross-compiling
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# ==========================================
# Toolchain binaries
# ==========================================

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")

    # Set directory of toolchain in your host machine
    set(ARM_TOOLCHAIN_DIR "C:/arm-gnu-toolchain/bin")
    set(ARM_PROGRAMMER_DIR "C:/OpenOCD/bin")

    # Set used binaries in toolchain
    set(CMAKE_C_COMPILER   "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-gcc.exe")
    set(CMAKE_CXX_COMPILER "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-g++.exe")
    set(CMAKE_ASM_COMPILER "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-gcc.exe")

    set(CMAKE_OBJCOPY  "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-objcopy.exe")
    set(CMAKE_SIZE     "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-size.exe")
    set(CMAKE_OBJDUMP  "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-objdump.exe")
    set(CMAKE_AR       "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-ar.exe")
    set(CMAKE_RANLIB   "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-ranlib.exe")
    set(CMAKE_GDB       "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-gdb.exe")

    set(OPENOCD "${ARM_PROGRAMMER_DIR}/openocd.exe")

    set(CLANG_FORMAT_EXE "C:/Program Files/clang/bin/clang-format.exe")
    set(CLANG_TIDY_EXE "C:/Program Files/clang/bin/clang-tidy.exe")
    set(CPPCHECK_EXE     "C:/Program Files/Cppcheck/cppcheck.exe")

elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")

    set(ARM_TOOLCHAIN_DIR "/usr/bin")
    set(ARM_PROGRAMMER_DIR "/usr/bin")

    set(CMAKE_C_COMPILER   "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-gcc")
    set(CMAKE_CXX_COMPILER "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-g++")
    set(CMAKE_ASM_COMPILER "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-gcc")

    set(CMAKE_OBJCOPY  "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-objcopy")
    set(CMAKE_SIZE     "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-size")
    set(CMAKE_OBJDUMP  "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-objdump")
    set(CMAKE_AR       "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-ar")
    set(CMAKE_RANLIB   "${ARM_TOOLCHAIN_DIR}/arm-none-eabi-ranlib")

    set(OPENOCD "${ARM_PROGRAMMER_DIR}/openocd")

    set(CLANG_FORMAT_EXE "/usr/bin/clang-format")
    set(CPPCHECK_EXE     "/usr/bin/cppcheck")

else()
    message(FATAL_ERROR "Unsupported host system: ${CMAKE_HOST_SYSTEM_NAME}")
endif()


# ==========================================
# Tool versions printing function
# ==========================================

function(print_tool_version TOOL_NAME TOOL_PATH)
    execute_process(
        COMMAND "${TOOL_PATH}" --version
        OUTPUT_VARIABLE TOOL_VERSION
        ERROR_VARIABLE TOOL_ERROR
        RESULT_VARIABLE TOOL_RESULT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if("${TOOL_RESULT}" STREQUAL "0" AND NOT "${TOOL_VERSION}" STREQUAL "")
        string(FIND "${TOOL_VERSION}" "\n" NEWLINE_POS)

        if(NOT NEWLINE_POS EQUAL -1)
            string(SUBSTRING "${TOOL_VERSION}" 0 ${NEWLINE_POS} TOOL_VERSION)
        endif()

        message(STATUS "${TOOL_NAME}: ${TOOL_VERSION}")
    else()
        message(WARNING "${TOOL_NAME}: unable to retrieve version. ${TOOL_ERROR}")
    endif()
endfunction()


message(STATUS "========== Development Tools ==========")

print_tool_version("ARM-GCC"      "${CMAKE_C_COMPILER}")
print_tool_version("ARM-G++"      "${CMAKE_CXX_COMPILER}")
print_tool_version("OpenOCD"      "${OPENOCD}")
print_tool_version("Clang-Format" "${CLANG_FORMAT_EXE}")
print_tool_version("Cppcheck"     "${CPPCHECK_EXE}")

message(STATUS "===========================================")
