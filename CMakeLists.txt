cmake_minimum_required(VERSION 3.15)

include(CMakeToolsHelpers OPTIONAL)
include(ExternalProject)

set(CMAKE_VERBOSE_MAKEFILE ON CACHE BOOL "ON" FORCE) # debug helper

# the following prevents launching a build in the source tree
set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

message(STATUS "Building for hardware: ${HARDWARE_TYPE} v${HARDWARE_REVISION}")

project(${ROM_NAME}
		VERSION ${BUILD_VERSION}
		LANGUAGES C ASM)


set( ELF_NAME 			${PROJECT_NAME}.elf )
set( BIN_NAME 			${PROJECT_NAME}.bin )
set( ROM_NAME 			${PROJECT_NAME}.v64 )
set( FILESYS_NAME		${PROJECT_NAME}.dfs )

set( LINKER_FILE_NAME "${LIBDRAGON_PREFIX}/ldscripts/n64.ld" )
set(ROM_HEADER ${LIBDRAGON_PREFIX}/headers/header)

# make sure the version is set
if(NOT BUILD_VERSION)
	set(BUILD_VERSION 0.0.1)
endif()

# string(REPLACE "." ";" VERSION_LIST ${BUILD_VERSION})
# list(GET VERSION_LIST 0 BUILD_VER_MAJOR)
# list(GET VERSION_LIST 1 BUILD_VER_MINOR)
# list(GET VERSION_LIST 2 BUILD_VER_REV)

string(TIMESTAMP COMPILE_TIME "%Y-%m-%d")

set (BITDEPTH_16 16)
set (BITDEPTH_32 32)

add_executable( ${ELF_NAME}
#Add libs here:
	#${LIBDRAGON_SOURCES}
	#${FATFS_SOURCES}
)

target_compile_definitions( ${ELF_NAME} PUBLIC
	#ROM_VER_MAJOR=${BUILD_VER_MAJOR}
	#ROM_VER_MINOR=${BUILD_VER_MINOR}
	#ROM_VER_REV=${BUILD_VER_REV}
	#FLASHCART_TARGET_TYPE=${HARDWARE_TYPE}
	#FLASHCART_TARGET_REVISION=${HARDWARE_REVISION}
	VERSION_NUMBER="${BUILD_VERSION}-Preview"
	VERSION_DATE="${COMPILE_TIME}"
	#USE_N64MEM
	DEBUG_BENCHMARK
)

target_sources( ${ELF_NAME}
PUBLIC
	${CMAKE_CURRENT_LIST_DIR}/src/240pSuite.c
	${CMAKE_CURRENT_LIST_DIR}/src/controller.c
	${CMAKE_CURRENT_LIST_DIR}/src/everdrive.c #needed for ed64?!
	${CMAKE_CURRENT_LIST_DIR}/src/help.c
	${CMAKE_CURRENT_LIST_DIR}/src/image.c
	${CMAKE_CURRENT_LIST_DIR}/src/language.c
	${CMAKE_CURRENT_LIST_DIR}/src/menu.c
	${CMAKE_CURRENT_LIST_DIR}/src/patterns.c
	${CMAKE_CURRENT_LIST_DIR}/src/tests.c
	${CMAKE_CURRENT_LIST_DIR}/src/utils.c
	${CMAKE_CURRENT_LIST_DIR}/src/video.c
)

set( SPRITE_LIST_16
	601701cb
	back
	buzzbomber
	checkneg
	checkpos
	circles_grid
	circlesNTSC
	circlesPAL
	color
	colorbleed
	colorbleedchk
	EBUColorBars75
	EBUColorBars100
	#font #missing!
	grayramp
	grid
	grid480
	help
	menu
	motoko
	nish
	pluge
	PLUGEBorder
	plugePAL
	sd
	shadow
	sharpness
	SMPTECB75
	SMPTECB100
	sonicback1
	sonicback2
	sonicback3
	sonicback4
	sonicfloor
	stripespos
	stripesneg
	vertstripespos
	vertstripesneg
)

set( SPRITE_LIST_32
	color_grid
	colorlow
	colorhigh
)

#probably a better way to do this, but if you need to build for something that uses different compiler flags...
#SET_SOURCE_FILES_PROPERTIES(${CMAKE_CURRENT_LIST_DIR}/src/gscore.c PROPERTIES COMPILE_FLAGS -O0) 

target_include_directories( ${ELF_NAME}
	PUBLIC
	${CMAKE_CURRENT_LIST_DIR}/inc
	#Add extra includes from libs here:
	#${LIBDRAGON_INCLUDE_DIRS}
	#${FATFS_INCLUDE_DIRS}
)

target_link_directories( ${ELF_NAME}
	PUBLIC
	${CMAKE_CURRENT_LIST_DIR}/lib
)

set_target_properties( ${ELF_NAME} 
	PROPERTIES LINK_FLAGS "-T ${LINKER_FILE_NAME}"
	) 

add_custom_command(TARGET ${ELF_NAME}
                  POST_BUILD
				  COMMAND ${CMAKE_OBJCOPY} ARGS -O binary ${ELF_NAME} ${BIN_NAME}
				  )
					  
#if the toolchain is different, we need to handle it here, or push it to a module, or even the toolchain?!
if(TOOLCHAIN_LIBDRAGON)

foreach( file_i ${SPRITE_LIST_16}) #need to loop through the files!
add_custom_command(TARGET ${ELF_NAME}
                  PRE_BUILD
				  COMMAND ${MKSPRITE_TOOL} ARGS ${BITDEPTH_16} ../res/graphics/${file_i}.png ../res/filesystem/${file_i}.bin
				  )
endforeach( file_i )

foreach( file_i ${SPRITE_LIST_32}) #need to loop through the files!
add_custom_command(TARGET ${ELF_NAME}
                  PRE_BUILD
				  COMMAND ${MKSPRITE_TOOL} ARGS ${BITDEPTH_32} ../res/graphics/${file_i}.png ../res/filesystem/${file_i}.bin
				  )
endforeach( file_i )

add_custom_command(TARGET ${ELF_NAME}
                  PRE_LINK
                  COMMAND ${MKDFS_TOOL} ARGS ${FILESYS_NAME} ../res/filesystem/
				  )

add_custom_command(TARGET ${ELF_NAME}
                  POST_BUILD #Make sure your ROM size is big enough... perhaps we could use "size" on the bin to check?
                  COMMAND ${N64_TOOL} ARGS -l 6M -t "${PROJECT_NAME}" -h ${ROM_HEADER} -o ${ROM_NAME} ${BIN_NAME} -s 1M ${FILESYS_NAME}
				  )
		
add_custom_command(TARGET ${ELF_NAME}
                  POST_BUILD
                  COMMAND ${CHECKSUM_TOOL} ARGS ${ROM_NAME}
				  )
				  
elseif(TOOLCHAIN_N64CHAIN)

add_custom_command(TARGET ${ELF_NAME}
	POST_BUILD
	COMMAND ${CHECKSUM_TOOL} ARGS ${ROM_HEADER}
	)
			  
else() #add some other compilation flags
#show error?
endif(TOOLCHAIN_LIBDRAGON)
unset(TOOLCHAIN_LIBDRAGON CACHE) # <---- this is the important to make sure the next build succeeds!!

if(DEPLOY)
separate_arguments(DEPLOY_EXPORT_PARAMETERS_LIST WINDOWS_COMMAND "${DEPLOY_PARAMETERS}")
add_custom_command(TARGET ${ELF_NAME}
                  POST_BUILD
                  COMMAND ${DEPLOY} ${DEPLOY_EXPORT_PARAMETERS_LIST}
				  )
endif(DEPLOY)
