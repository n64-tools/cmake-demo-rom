# TODO: this file is incomplete!!!!
option(TOOLCHAIN_LIBULTRA "Use LIBULTRA" ON) #only set if this file is called~?


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
# set(N64_TOOL	       	${LIBULTRA_PREFIX}/tools/spicy)
# set(CHECKSUM_TOOL       ${LIBULTRA_PREFIX}/tools/checksum)

# set(LINKER_FLAGS_START		"-ldragon")
# set(LINKER_FLAGS_END		"-ldragonsys")


include(${CMAKE_CURRENT_LIST_DIR}/toolchain.mips64-elf.cmake)