# =========================
# clang-format target
# =========================


if(CLANG_FORMAT_EXE)

    # Collect all source files
    file(GLOB_RECURSE FORMAT_SOURCES
        ${CMAKE_SOURCE_DIR}/app/*.c
        ${CMAKE_SOURCE_DIR}/app/*.h
        ${CMAKE_SOURCE_DIR}/bsp/*.c
        ${CMAKE_SOURCE_DIR}/bsp/*.h
    )

    add_custom_target(format
        COMMAND ${CLANG_FORMAT_EXE}
            -i
            -style=file
            ${FORMAT_SOURCES}

        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Running clang-format on all project sources..."
    )

    message(STATUS "clang-format enabled (target: format)")

else()
    message(WARNING "clang-format not found - format target disabled")
endif()