option(TOOLCHAIN_LIBDRAGON "Use LIBDRAGON" ON) #only set if this file is called~?

include_directories(
	${LIBDRAGON_PREFIX}/include
)

link_directories(
	${LIBDRAGON_PREFIX}/lib/
)

link_libraries(
	dragon
)

# set the necessary tools we need for building the rom
set(N64_TOOL	       	${LIBDRAGON_PREFIX}/tools/n64tool)
set(CHECKSUM_TOOL       ${LIBDRAGON_PREFIX}/tools/chksum64)
set(ED64ROMCONFIG_TOOL  ${LIBDRAGON_PREFIX}/tools/ed64romconfig)
set(MKDFS_TOOL          ${LIBDRAGON_PREFIX}/tools/mkdfs/mkdfs)
set(DUMPDFS_TOOL        ${LIBDRAGON_PREFIX}/tools/dumpdfs/dumpdfs)
set(AUDIOCONV_TOOL      ${LIBDRAGON_PREFIX}/tools/audioconv64/audioconv64)
set(MKSPRITE_TOOL       ${LIBDRAGON_PREFIX}/tools/mksprite/mksprite)
set(MKSPRITECONV_TOOL   ${LIBDRAGON_PREFIX}/tools/mksprite/convtool)

set(LINKER_FLAGS_START		"-ldragon")
set(LINKER_FLAGS_END		"-ldragonsys")


include(${CMAKE_CURRENT_LIST_DIR}/toolchain.mips64-elf.cmake)