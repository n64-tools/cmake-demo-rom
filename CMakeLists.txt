cmake_minimum_required(VERSION 3.23)

include(CMakeToolsHelpers OPTIONAL)
include(ExternalProject)

set(CMAKE_VERBOSE_MAKEFILE ON CACHE BOOL "ON" FORCE) # debug helper

# the following prevents launching a build in the source tree
set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

message(STATUS "Building for hardware: ${HARDWARE_TYPE} with SDK: ${SDK_TYPE}")

# make sure the version is set
if(NOT BUILD_VERSION)
	set(BUILD_VERSION 0.0.1)
endif()

string(REPLACE "." ";" VERSION_LIST ${BUILD_VERSION})
list(GET VERSION_LIST 0 BUILD_VER_MAJOR)
list(GET VERSION_LIST 1 BUILD_VER_MINOR)
list(GET VERSION_LIST 2 BUILD_VER_REV)

project(BUILD-DEMO # rename for your ROM name
		VERSION ${BUILD_VERSION}
		LANGUAGES C ASM)


set( ELF_NAME 			${PROJECT_NAME}.elf )
set( BIN_NAME 			${PROJECT_NAME}.bin )
set( ROM_NAME 			${PROJECT_NAME}.z64 )

set( LINKER_FILE_NAME "${LIBDRAGON_PREFIX}/ldscripts/n64.ld" )
set(ROM_HEADER ${LIBDRAGON_PREFIX}/headers/header)

add_executable( ${ELF_NAME}
# Add libs here:
	#${LIBDRAGON_SOURCES}
	#${FATFS_SOURCES}
)

target_compile_definitions( ${ELF_NAME} PUBLIC
	ROM_VER_MAJOR=${BUILD_VER_MAJOR}
	ROM_VER_MINOR=${BUILD_VER_MINOR}
	ROM_VER_REV=${BUILD_VER_REV}
	FLASHCART_TARGET_TYPE=${HARDWARE_TYPE}
	FLASHCART_TARGET_REVISION=${HARDWARE_REVISION}
)

target_sources( ${ELF_NAME}
PUBLIC
	${CMAKE_CURRENT_LIST_DIR}/src/main.c
)

# probably a better way to do this, but if you need to build for something that uses different compiler flags...
#SET_SOURCE_FILES_PROPERTIES(${CMAKE_CURRENT_LIST_DIR}/src/gscore.c PROPERTIES COMPILE_FLAGS -O0) 

target_include_directories( ${ELF_NAME}
	PUBLIC
	${CMAKE_CURRENT_LIST_DIR}/inc
	# Add extra includes from libs here:
	#${LIBDRAGON_INCLUDE_DIRS}
	#${FATFS_INCLUDE_DIRS}
)

target_link_directories( ${ELF_NAME}
	PUBLIC
	${CMAKE_CURRENT_LIST_DIR}/lib
)

set_target_properties( ${ELF_NAME} 
	PROPERTIES LINK_FLAGS "-T${LINKER_FILE_NAME}"
	) 

add_custom_command(TARGET ${ELF_NAME}
                  POST_BUILD
                  COMMAND ${CMAKE_OBJCOPY} ARGS -O binary ${ELF_NAME} ${BIN_NAME}
				  )
					  
# if the toolchain is different, we need to handle it here, or push it to a module, or even the toolchain?!
if(TOOLCHAIN_LIBDRAGON)

# FIXME: There is a regression with N64-Tool where it cannot overwrite an existing file.
# This command is a workaround:
add_custom_command(TARGET ${ELF_NAME}
                  POST_BUILD # Delete the ROM file so it can be overwritten by N64Tool
                  COMMAND DEL -F ${ROM_NAME}
				  )

add_custom_command(TARGET ${ELF_NAME}
                  POST_BUILD # Make sure your ROM size is big enough... perhaps we could use "size" on the bin to check?
                  COMMAND ${N64_TOOL} ARGS -l 1M -t "${PROJECT_NAME}" -h ${ROM_HEADER} -o ${ROM_NAME} ${BIN_NAME}
				  )

add_custom_command(TARGET ${ELF_NAME}
                  POST_BUILD
                  COMMAND ${CHECKSUM_TOOL} ARGS ${ROM_NAME}
				  )
else() # add some other compilation flags
# show error?
endif(TOOLCHAIN_LIBDRAGON)
unset(TOOLCHAIN_LIBDRAGON CACHE) # <---- this is the important to make sure the next build succeeds!!
