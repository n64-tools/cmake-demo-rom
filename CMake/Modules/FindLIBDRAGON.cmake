list(APPEND LIBDRAGON_INCLUDE_DIRS ${PROJECT_BINARY_DIR}/LibDragon_Source/include)


set(LIBDRAGON_SRCS
    audio/libxm/context.c
    audio/libxm/load.c
    audio/libxm/play.c
    audio/libxm/xm.h
    audio/libxm/xm_internal.h
    audio/ay8910.c
    audio/lzh5.h
    audio/lzh5.h
    audio/lzh5.h
    audio/samplebuffer.c
    audio/wav64.c
    audio/xm64.c
    audio/ym64.c
    fatfs/diskio.h
    fatfs/ff.c
    fatfs/ff.h
    fatfs/ffconf.h
    fatfs/ffunicode.c
    rspq/rsp_queue.S
    rspq/rspq.c
    audio.c
    console.c
    controller.c
    debug.c
    debug_sdfs_64drive.c
    debug_sdfs_ed64.c
    debug_sdfs_sc64.c
    display.c
    dma.c
    do_ctors.c
    dragonfs.c
    eeprom.c
    eepromfs.c
    entrypoint.S
    exception.c
    graphics.c
    interrupt.c
    inthandler.S
    joybus.c
    joybusinternal.h
    mempak.c
    n64sys.c 
    rdp.c
    regs.S
    rsp.c
    rsp_crash.S
    rtc.c
    surface.c
    system.c
    timer.c
    tpak.c
    usb.c
    utils.h
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
