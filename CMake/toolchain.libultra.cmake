# TODO: this file is incomplete!!!!


include_directories(
	${LIBULTRA_PREFIX}/include
)

link_directories(
	${LIBULTRA_PREFIX}/lib/
)

# link_libraries(
# 	dragon
# )

# set the necessary tools we need for building the rom
# set(N64_TOOL	       	${N64CHAIN_PREFIX}/tools/spicy) #TODO - Should be part of the libdragon cmake
#set(CHECKSUM_TOOL       ${LIBULTRA_PREFIX}/tools/checksum) #TODO - Should be part of the libdragon cmake

# set(LINKER_FLAGS_START		"-ldragon")
# set(LINKER_FLAGS_END		"-ldragonsys")


include(${CMAKE_CURRENT_LIST_DIR}/toolchain.mips64-elf.cmake)