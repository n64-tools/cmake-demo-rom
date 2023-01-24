include(CMakeForceCompiler)

# set toolchain directories
set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_PREFIX}/bin)

# the name of the operating system for which CMake is to build
set(CMAKE_SYSTEM_NAME Generic)

# name of the CPU CMake is building for
set(CMAKE_SYSTEM_PROCESSOR mips64)

# set the language standard (gnu-99)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_STANDARD 99)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

# macro to setup compilers
macro(SET_COMPILER_VAR var name)
   find_program(CMAKE_${var} mips64-elf-${name} HINTS ${TOOLCHAIN_BIN_DIR} DOC "${name} tool")
endmacro()

# setup C compiler
if(NOT CMAKE_C_COMPILER)
    SET_COMPILER_VAR(C_COMPILER gcc)
endif()

# setup C++ compiler
if(NOT CMAKE_CXX_COMPILER)
    SET_COMPILER_VAR(CXX_COMPILER g++)
endif()

# setup Assembler compiler
if(NOT CMAKE_ASM_COMPILER)
    SET_COMPILER_VAR(ASM_COMPILER gcc)
    SET_COMPILER_VAR(ASM-ATT_COMPILER as)
endif()

include_directories(
	${TOOLCHAIN_PREFIX}/mips64-elf/include
	${TOOLCHAIN_PREFIX}/include
)

link_directories(
	${TOOLCHAIN_PREFIX}/lib
	${TOOLCHAIN_PREFIX}/mips64-elf/lib
)

link_libraries(
	libc.a
	libm.a
	)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# this makes the test compiles use static library option so that we don't need to pre-set linker flags and scripts
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# set the flags for an N64's architecture
set(MCPU_FLAGS "-march=vr4300 -mtune=vr4300 -MMD")

set(EXTRA_FLAGS "-falign-functions=32 -ffunction-sections -fdata-sections")

set(CMAKE_C_CXX_FLAGS "${MCPU_FLAGS} ${EXTRA_FLAGS} -Wall -Werror -Wno-error=deprecated-declarations -fdiagnostics-color=always")
set(CMAKE_C_CXX_FLAGS_DEBUG   "-O0 -g3") # TODO: -ggdb3
set(CMAKE_C_CXX_FLAGS_RELEASE "-O2") 

set(CMAKE_C_FLAGS "${CMAKE_C_CXX_FLAGS} -std=gnu99" CACHE INTERNAL "c compiler flags")
set(CMAKE_C_FLAGS_DEBUG   "${CMAKE_C_CXX_FLAGS_DEBUG}" )
set(CMAKE_C_FLAGS_RELEASE " ${CMAKE_C_CXX_FLAGS_RELEASE}" )

set(CMAKE_CXX_FLAGS "${CMAKE_C_CXX_FLAGS}" CACHE INTERNAL "cxx compiler flags")
set(CMAKE_CXX_FLAGS_DEBUG   "${CMAKE_C_CXX_FLAGS_DEBUG}" )
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_CXX_FLAGS_RELEASE}" )

set(CMAKE_ASM_FLAGS "${MCPU_FLAGS} -Wa,--fatal-warnings" CACHE INTERNAL "asm compiler flags")
set(CMAKE_ASM_FLAGS_DEBUG   "-g" )
set(CMAKE_ASM_FLAGS_RELEASE "" )

set(CMAKE_EXE_LINKER_FLAGS "-g ${LINKER_FLAGS_START} -lc -lm ${LINKER_FLAGS_END}" CACHE INTERNAL "exe link flags")
