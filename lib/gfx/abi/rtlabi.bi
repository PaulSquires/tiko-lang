'' rtlabi.bi -- FreeBASIC mirrors of the private rtlib / gfxlib2 structures.
''
'' ORIGINAL WORK. Transcribed from the MEASURED layout in abi/offsets/*.txt,
'' not from any gfxlib2 source body. The C declarations these describe live in
'' fbc-modern's rtlib and gfxlib2 headers.
''
'' Part of libtkogfx: LGPL-2.1-or-later with the static-linking exception.
''
'' THESE STRUCTS BELONG TO A RUNTIME WE DO NOT OWN. Every offset here is checked
'' against a C probe by tools/gate-abi.sh on every build, and a mismatch is a
'' build failure. Do not "tidy" a field, reorder one, or change a type without
'' re-running that gate -- a wrong offset here corrupts memory several calls
'' away from the mistake, which is the worst kind of bug this project can have.
''
'' Type mapping, and why:
''   C int / unsigned int  -> long / ulong   (4 bytes on every target we build)
''   C ssize_t / size_t    -> integer        (pointer-width, 8 on x64, 4 on x86)
''   C pointer             -> any ptr        (pointer-width)
''   C float               -> single
''   FB_WCHAR              -> ushort on Windows, ulong elsewhere (see below)

#pragma once

namespace TkoAbi

'' FB_WCHAR is the platform wchar_t: 2 bytes on Windows, 4 on Linux. It shows up
'' inside GFX_CHAR_CELL, whose total size is 12 on BOTH -- on Windows because a
'' 2-byte field is padded to the 4-byte alignment of the field after it, on
'' Linux because the field is genuinely 4 bytes. Same size, different reason.
#ifdef __FB_WIN32__
    type FB_WCHAR as ushort
#else
    type FB_WCHAR as ulong
#endif

'' ---------------------------------------------------------------- rtlib core

'' FBSTRING -- 24 bytes on x64, 12 on x86.
type FBSTRING
    dat      as zstring ptr   '' 'data' in C; DATA is a FB keyword
    len      as integer
    size     as integer
end type

type FBARRAYDIM
    elements as integer
    lbound_  as integer       '' LBOUND is a FB keyword
    ubound_  as integer
end type

'' FBARRAY -- 72 bytes on x64, 36 on x86. 'data' must stay at offset 0.
type FBARRAY
    dat         as any ptr
    ptr_        as any ptr
    size        as integer
    element_len as integer
    dimensions  as integer
    flags       as integer
    dimTB(0 to 0) as FBARRAYDIM   '' dimTB[dimensions]; declared [1] in C
end type

'' EVENT -- packed, 20 bytes on every target. Matches FB.EVENT in fbgfx.bi.
type EVENT field = 1
    etype as long                 '' 'type' in C
    union
        type
            scancode as long
            ascii    as long
        end type
        type
            x  as long
            y  as long
            dx as long
            dy as long
        end type
        button as long
        z      as long
        w      as long
    end union
end type

'' ------------------------------------------------------- the hook table

'' FB_HOOKSTB -- 28 function pointers, 224 bytes on x64 / 112 on x86.
'' Installed wholesale into the rtlib on SCREEN, zeroed on SCREEN 0. The order
'' is load-bearing: the rtlib indexes this by field, so a reordering silently
'' calls the wrong function.
type FB_HOOKSTB
    inkeyproc       as any ptr
    getkeyproc      as any ptr
    keyhitproc      as any ptr
    clsproc         as any ptr
    colorproc       as any ptr
    locateproc      as any ptr
    widthproc       as any ptr
    getxproc        as any ptr
    getyproc        as any ptr
    getxyproc       as any ptr
    getsizeproc     as any ptr
    printbuffproc   as any ptr
    printbuffwproc  as any ptr
    readstrproc     as any ptr
    multikeyproc    as any ptr
    getmouseproc    as any ptr
    setmouseproc    as any ptr
    inproc          as any ptr
    outproc         as any ptr
    viewupdateproc  as any ptr
    lineinputproc   as any ptr
    lineinputwproc  as any ptr
    readxyproc      as any ptr
    sleepproc       as any ptr
    isredirproc     as any ptr
    pagecopyproc    as any ptr
    pagesetproc     as any ptr
    posteventproc   as any ptr
end type

'' ------------------------------------------------------------ the image header

const PUT_HEADER_NEW = &h7

'' PUT_HEADER / FB.IMAGE -- packed, 32 bytes on EVERY target. This is the
'' interchange contract: a GET buffer written by one library must be readable by
'' the other, so this layout is not ours to change.
''
'' NOTE: fbgfx.bi declares twelve reserved bytes from offset 20. That is WRONG.
'' The C header puts the OpenGL texture id at 20..23 and leaves only eight
'' reserved bytes at 24..31. Measured, see abi/offsets/.
type PUT_HEADER field = 1
    htype    as ulong          '' must equal PUT_HEADER_NEW; overlays the old bitfields
    bpp      as long           '' BYTES per pixel: 1, 2 or 4
    width    as ulong
    height   as ulong
    pitch    as ulong
    tex      as ulong          '' OpenGL texture id -- NOT reserved space
    reserved(0 to 7) as ubyte
end type

'' ------------------------------------------------------- the drawing context

const PUT_MODES = 10

'' FB_GFXCTX -- per-thread, 216 bytes on x64 / 148 on x86. Lives in the rtlib's
'' TLS slot FB_TLSKEY_GFX.
''
'' The padding after target_pitch is real: it sits at offset 24 with size 4, and
'' last_target follows at 32, not 28, because a pointer wants 8-byte alignment.
'' FB inserts the same padding for the same reason; the gate proves it.
type FB_GFXCTX
    id           as long
    work_page    as long
    line         as any ptr        '' unsigned char **
    max_h        as long
    target_bpp   as long
    target_pitch as long
    last_target  as any ptr        '' NULL = screen, else PUT_HEADER ptr
    last_x       as single
    last_y       as single
    view(0 to 3)     as long       '' view_x, view_y, view_w, view_h
    old_view(0 to 3) as long
    win_x        as single
    win_y        as single
    win_w        as single
    win_h        as single
    fg_color     as ulong
    bg_color     as ulong
    put_pixel    as any ptr
    get_pixel    as any ptr
    pixel_set    as any ptr
    putter(0 to PUT_MODES - 1) as any ptr
    flags        as long
end type

'' ------------------------------------------------------------- global state

type GFX_CHAR_CELL
    ch as FB_WCHAR
    fg as ulong
    bg as ulong
end type

'' FBGFX -- the single global graphics state, 208 bytes on x64 / 136 on x86.
'' NULL when not in a graphics mode.
type FBGFX
    id                as long      '' mode generation; drives context invalidation
    mode_num          as long
    page              as any ptr   '' unsigned char **
    num_pages         as long
    visible_page      as long
    framebuffer       as any ptr
    w                 as long
    h                 as long
    depth             as long      '' bits per pixel
    bpp               as long      '' BYTES per pixel
    pitch             as long
    palette           as ulong ptr
    device_palette    as ulong ptr
    color_association as ubyte ptr
    dirty             as zstring ptr  '' one byte per scanline
    driver            as any ptr
    color_mask        as long
    default_palette   as any ptr
    scanline_size     as long
    cursor_x          as long
    cursor_y          as long
    font              as any ptr
    text_w            as long
    text_h            as long
    aspect            as single
    key               as zstring ptr   '' 128 MULTIKEY states
    refresh_rate      as long
    con_pages         as any ptr       '' GFX_CHAR_CELL **
    event_queue       as any ptr
    event_head        as long
    event_tail        as long
    event_mutex       as any ptr
    flags             as long          '' volatile in C
    lock_count        as long
end type

'' ------------------------------------------------------------- the driver vtable

'' GFXDRIVER -- 15 members, 120 bytes on x64 / 60 on x86. Several are nullable;
'' init/exit/lock/unlock are not.
type GFXDRIVER
    name             as zstring ptr
    init             as any ptr
    exit_            as any ptr    '' EXIT is a FB keyword
    lock_            as any ptr    '' LOCK is a FB keyword
    unlock_          as any ptr
    set_palette      as any ptr
    wait_vsync       as any ptr
    get_mouse        as any ptr
    set_mouse        as any ptr
    set_window_title as any ptr
    set_window_pos   as any ptr
    fetch_modes      as any ptr
    flip             as any ptr
    poll_events      as any ptr
    update           as any ptr
end type

end namespace
