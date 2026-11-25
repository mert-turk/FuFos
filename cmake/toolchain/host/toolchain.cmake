# ==========================================
# Host toolchain settings
# ==========================================
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")

    set(CLANG_DIR "C:/Program Files/clang/bin")
    set(CMAKE_C_COMPILER    "${CLANG_DIR}/clang.exe")
    #set(CMAKE_CXX_COMPILER  "${CLANG_DIR}/clang++.exe")
    set(CMAKE_ASM_COMPILER "${CLANG_DIR}/clang.exe")

elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")

    set(CLANG_DIR "/bin")
    set(CMAKE_C_COMPILER    "${CLANG_DIR}/clang")
    #set(CMAKE_CXX_COMPILER  "${CLANG_DIR}/clang++")
    set(CMAKE_ASM_COMPILER "${CLANG_DIR}/clang")

else()
    message(FATAL_ERROR "Unsupported host system: ${CMAKE_HOST_SYSTEM_NAME}")
endif()
