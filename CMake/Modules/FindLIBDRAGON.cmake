list(APPEND LIBDRAGON_INCLUDE_DIRS ${PROJECT_BINARY_DIR}/LibDragon_Source/include)


set(LIBDRAGON_SRCS
    n64sys.c
    interrupt.c
    inthandler.c
    entrypoint.S
    dragonfs.c
    inthandler.S
    audio.c
    display.c
    console.c
    controller.c
    mempak.c
    tpak.c
    graphics.c
    rdp.c
    regs.S
    rsp.c
    dma.c
    timer.c
    version.c
    exception.c
    do_ctors.c
)

foreach(SRC_FILE ${LIBDRAGON_SRCS})
    set(LIBDRAGON_SRC_FILE SRC_FILE -NOTFOUND)
    find_file(LIBDRAGON_SRC_FILE ${SRC_FILE}
        PATHS 
            ${PROJECT_BINARY_DIR}/LibDragon_Source/source

        CMAKE_FIND_ROOT_PATH_BOTH
    )
    # message("${SRC_FILE} >> ${FATFS_SRC_FILE}") # debug helper
    list(APPEND LIBDRAGON_SOURCES ${LIBDRAGON_SRC_FILE})
endforeach()

include(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBDRAGON DEFAULT_MSG LIBDRAGON_INCLUDE_DIRS LIBDRAGON_SOURCES)
