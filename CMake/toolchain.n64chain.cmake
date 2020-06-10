# TODO: this file is incomplete!!!!
option(TOOLCHAIN_N64CHAIN "Use N64CHAIN" ON) #only set if this file is called~?


include_directories(
	${N64CHAIN_PREFIX}/include
)

link_directories(
	${N64CHAIN_PREFIX}/lib/
)

# link_libraries(
# 	dragon
# )

# set the necessary tools we need for building the rom
set(CHECKSUM_TOOL       ${N64CHAIN_PREFIX}/tools/bin/checksum)
set(RSPASM_TOOL       ${N64CHAIN_PREFIX}/tools/bin/rspasm)

# set(LINKER_FLAGS_START		"-ldragon")
# set(LINKER_FLAGS_END		"-ldragonsys")


include(${CMAKE_CURRENT_LIST_DIR}/toolchain.mips64-elf.cmake)