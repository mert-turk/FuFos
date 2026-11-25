# ==========================================
# AVR GCC Toolchain for ATmega64M1
# ==========================================

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)

# Tell CMake we are cross-compiling
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# ==========================================
# Toolchain binaries
# ==========================================

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")

    # Set directory of toolchain in your host machine
    set(AVR_TOOLCHAIN_DIR  "C:/avr8-gnu-toolchain-win32_x86_64/bin")
    set(AVR_PROGRAMMER_DIR      "C:/avrdude")
    set(AVR_INC_PATH       "C:/avr8-gnu-toolchain-win32_x86_64/avr/include")

     # Set used binaries in toolchain
    set(CMAKE_C_COMPILER   "${AVR_TOOLCHAIN_DIR}/avr-gcc.exe")
    #set(CMAKE_CXX_COMPILER "${AVR_TOOLCHAIN_DIR}/avr-g++.exe")
    set(CMAKE_ASM_COMPILER "${AVR_TOOLCHAIN_DIR}/avr-gcc.exe")

    set(CMAKE_OBJCOPY      "${AVR_TOOLCHAIN_DIR}/avr-objcopy.exe")
    set(CMAKE_SIZE         "${AVR_TOOLCHAIN_DIR}/avr-size.exe")
    set(CMAKE_OBJDUMP      "${AVR_TOOLCHAIN_DIR}/avr-objdump.exe")

    set(AVRDUDE            "${AVR_PROGRAMMER_DIR}/avrdude.exe")

    set(CLANG_FORMAT_EXE    "C:/Program Files/clang/bin/clang-format.exe")
    set(CPPCHECK_EXE        "C:/Program Files/Cppcheck/cppcheck.exe")

    # set(CLANG_FORMAT_EXE    clang-format)
    # set(CPPCHECK_EXE        cppcheck)


elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")

    set(AVR_TOOLCHAIN_DIR   "/bin")
    set(AVR_PROGRAMMER_DIR  "/bin")
    set(AVR_INC_PATH        "/usr/lib/avr/include")
    set(CMAKE_C_COMPILER   "${AVR_TOOLCHAIN_DIR}/avr-gcc")
    #set(CMAKE_CXX_COMPILER "${AVR_TOOLCHAIN_DIR}/avr-g++")
    set(CMAKE_ASM_COMPILER "${AVR_TOOLCHAIN_DIR}/avr-gcc")

    set(CMAKE_OBJCOPY      "${AVR_TOOLCHAIN_DIR}/avr-objcopy")
    set(CMAKE_SIZE         "${AVR_TOOLCHAIN_DIR}/avr-size")
    set(CMAKE_OBJDUMP      "${AVR_TOOLCHAIN_DIR}/avr-objdump")

    set(AVRDUDE            "${AVR_PROGRAMMER_DIR}/avrdude")

    set(CLANG_FORMAT_EXE "/bin/clang-format")
    set(CPPCHECK_EXE     "/bin/cppcheck")


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

print_tool_version("AVR-GCC"      "${CMAKE_C_COMPILER}")
print_tool_version("AVRDUDE"      "${AVRDUDE}")
print_tool_version("Clang-Format" "${CLANG_FORMAT_EXE}")
print_tool_version("Cppcheck"     "${CPPCHECK_EXE}")

message(STATUS "===========================================")

