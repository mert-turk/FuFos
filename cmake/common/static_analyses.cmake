
file(GLOB_RECURSE STATIC_ANALYSES_SOURCES
    ${CMAKE_SOURCE_DIR}/app/source/*.c
    ${CMAKE_SOURCE_DIR}/bsp/${BSP_MCU}/source/*.c
)

if(CPPCHECK_EXE)

    message(STATUS "Cppcheck found: enabling static analysis support")

    # --------------------------------------------------
    # 1. Lightweight analysis for ALL targets (optional)
    # --------------------------------------------------
    # set(CMAKE_C_CPPCHECK
    #     ${CPPCHECK_EXE}
    #     --enable=warning,style,performance,portability
    #     --inline-suppr
    #     --error-exitcode=0
    # )

    # --------------------------------------------------
    #                   MISRA analysis 
    # --------------------------------------------------
    set(CPPCHECK_INC
        -I${CMAKE_SOURCE_DIR}/app/include
        -I${CMAKE_SOURCE_DIR}/BSP/include
        -isystem ${AVR_INC_PATH}
    )

 

    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/reports/misra)

    add_custom_target(cppcheck
        COMMAND ${CPPCHECK_EXE}
            
            # include paths
            ${CPPCHECK_INC}

            # Core MISRA setup
            --error-exitcode=4
            --addon=${CMAKE_SOURCE_DIR}/docs/qa/misra.json
            --suppressions-list=${CMAKE_SOURCE_DIR}/docs/qa/suppressions.txt
            
            --std=c99
     

            # behavior
            --cppcheck-build-dir=${CMAKE_BINARY_DIR}/
            --inline-suppr
            --enable=all
            --report-progress
            --language=c
            -j 5

            # output
            --output-format=xmlv2
            --output-file=${CMAKE_BINARY_DIR}/reports/misra/cppcheck-result.xml

            ${STATIC_ANALYSES_SOURCES}

        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Running MISRA cppcheck analysis..."
    )

else()
    message(WARNING "cppcheck not found - static analysis disabled")
endif()


# --------------------------------------------------
#                   CLANG-TIDY ANALYSIS
# --------------------------------------------------

if(EXISTS "${CLANG_TIDY_EXE}")

    message(STATUS "clang-tidy found: enabling static analysis support")

    # Create report directory
    file(MAKE_DIRECTORY
        ${CMAKE_BINARY_DIR}/reports/clang-tidy
    )

    # Static analysis target
    add_custom_target(clang_tidy
        COMMAND ${CLANG_TIDY_EXE}

            --export-fixes=${CMAKE_BINARY_DIR}/reports/clang-tidy/clang-tidy.yaml

            -p ${CMAKE_BINARY_DIR}

            ${STATIC_ANALYSES_SOURCES}

        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}

        COMMENT "Running clang-tidy analysis..."

        VERBATIM
    )

else()
    message(WARNING "clang-tidy not found - static analysis disabled")
endif()
