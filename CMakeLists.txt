cmake_minimum_required(VERSION 3.15)

include(CMakeToolsHelpers OPTIONAL)
include(ExternalProject)

set(CMAKE_VERBOSE_MAKEFILE ON CACHE BOOL "ON" FORCE) # debug helper

# the following prevents launching a build in the source tree
set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)


project(BUILD-DEMO 
		VERSION "1.0"
		LANGUAGES C ASM)


set( ELF_NAME 			${PROJECT_NAME}.elf )
set( BIN_NAME 			${PROJECT_NAME}.bin )
set( ROM_NAME 			${PROJECT_NAME}.v64 )

set( LINKER_FILE_NAME "${LIBDRAGON_PREFIX}/lib/n64ld_cpp.x" ) #for some reason it must use a C++ linker script (C only one doesnt work!)
set( ROM_HEADER ${LIBDRAGON_PREFIX}/lib/header )


add_executable( ${ELF_NAME} )

target_sources( ${ELF_NAME}
	PUBLIC
	${CMAKE_CURRENT_LIST_DIR}/src/main.c
)

target_include_directories( ${ELF_NAME}
	PUBLIC
	${CMAKE_CURRENT_LIST_DIR}/inc
)

target_link_directories( ${ELF_NAME}
	PUBLIC
	${CMAKE_CURRENT_LIST_DIR}/lib
)

set_target_properties( ${ELF_NAME} 
	PROPERTIES LINK_FLAGS "-T ${LINKER_FILE_NAME}") 

target_link_libraries( ${ELF_NAME} 
	dragon
	libc.a
	libm.a
	)


add_custom_command(TARGET ${ELF_NAME}
                  POST_BUILD
                  COMMAND ${CMAKE_OBJCOPY} ARGS -O binary ${ELF_NAME} ${BIN_NAME}
				  )
				  	
add_custom_command(TARGET ${ELF_NAME}
                  POST_BUILD
                  COMMAND ${N64_TOOL} ARGS -l 1M -t "${PROJECT_NAME}" -h ${ROM_HEADER} -o ${ROM_NAME} ${BIN_NAME}
				  )
				  
add_custom_command(TARGET ${ELF_NAME}
                  POST_BUILD
                  COMMAND ${CHECKSUM_TOOL} ARGS ${ROM_NAME}
				  )
