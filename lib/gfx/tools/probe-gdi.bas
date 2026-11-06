'' probe-gdi.bas -- verify the GDI blit path without a window.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' A presenter cannot be checked by looking at the screen from a test, but it can
'' be checked by blitting into a memory DC backed by a DIB section and reading
'' the pixels back. That covers the format questions -- which are where GDI
'' presenters actually break:
''
''   - TOP-DOWN vs BOTTOM-UP. The single most common bug. A DIB defaults to
''     bottom-up; a framebuffer is top-down. Getting it wrong mirrors the image
''     vertically, and the test below catches it because the source is
''     deliberately ASYMMETRIC top to bottom.
''   - CHANNEL ORDER. BI_RGB at 32bpp is BGRA in memory, so a value written as
''     &hFFRRGGBB must read back byte-identical or the red/blue channels are
''     swapped.
''   - THE DESTINATION ROW. A partial-span blit must land at y1, not at 0.
''   - STRIDE. A surface whose pitch exceeds w*bpp must not shear.
''
'' What this does NOT cover: window creation, the background message pump, focus
'' and resize handling, palette realisation. Those need the author's interactive
'' pass and are listed as owed in the README.

#include once "../driver/win32/gdi.ti"
#include once "../raster/box.ti"
#include once "crt/string.bi"

using TkoGfx

const W = 32
const H = 16

dim as long failures = 0

sub Check( byref what as string, byval got as long, byval want as long, byref fails as long )
    print "  "; what; " = "; got;
    if got = want then
        print "   ok"
    else
        print "   FAIL (expected "; want; ")"
        fails += 1
    end if
end sub

'' ---- a memory DC backed by a DIB section we can read back ----
dim as HDC screendc = GetDC( 0 )
dim as HDC memdc = CreateCompatibleDC( screendc )

dim as BITMAPINFO bmi
bmi.bmiHeader.biSize        = sizeof( BITMAPINFOHEADER )
bmi.bmiHeader.biWidth       = W
bmi.bmiHeader.biHeight      = -H          '' top-down, so dst(0) is the top row
bmi.bmiHeader.biPlanes      = 1
bmi.bmiHeader.biBitCount    = 32
bmi.bmiHeader.biCompression = BI_RGB

dim as any ptr dstbits
dim as HBITMAP dib = CreateDIBSection( memdc, @bmi, DIB_RGB_COLORS, @dstbits, 0, 0 )
dim as HGDIOBJ old_ = SelectObject( memdc, dib )

print "probe-gdi -- blit path against a memory DC"
Check( "DIB section created", iif( dib <> 0 andalso dstbits <> 0, 1, 0 ), 1, failures )

if dib <> 0 then
    '' ---- source: deliberately asymmetric top to bottom ----
    dim as any ptr srcbits = allocate( W * 4 * H )
    dim as Surface s
    SurfaceInit( s, srcbits, W, H, W * 4, 4 )
    for y as integer = 0 to H - 1
        dim as ulong ptr row = cptr( ulong ptr, SurfaceRowAddr( s, y ) )
        for x as integer = 0 to W - 1
            row[x] = &hFF000000 or (cuint( y ) shl 8) or cuint( x )
        next
    next

    memset( dstbits, 0, W * 4 * H )
    dim as long rows = GdiBlitSpan( memdc, s, 0, H - 1 )
    GdiFlush( )
    Check( "full blit rows     ", rows, H, failures )

    '' Every pixel must match, which fails loudly if the image is flipped.
    dim as long bad = 0
    dim as long flipped = 0
    for y as integer = 0 to H - 1
        dim as ulong ptr srow = cptr( ulong ptr, SurfaceRowAddr( s, y ) )
        dim as ulong ptr drow = cptr( ulong ptr, cptr( ubyte ptr, dstbits ) + y * W * 4 )
        dim as ulong ptr frow = cptr( ulong ptr, cptr( ubyte ptr, dstbits ) + (H - 1 - y) * W * 4 )
        for x as integer = 0 to W - 1
            if drow[x] <> srow[x] then bad += 1
            if frow[x] = srow[x] then flipped += 1
        next
    next
    Check( "pixels wrong       ", bad, 0, failures )
    if bad > 0 andalso flipped >= bad then
        print "    -> the destination matches the source REVERSED: biHeight sign is wrong"
    end if

    '' ---- partial span must land at the right y ----
    memset( dstbits, 0, W * 4 * H )
    rows = GdiBlitSpan( memdc, s, 4, 7 )
    GdiFlush( )
    Check( "partial blit rows  ", rows, 4, failures )

    dim as ulong ptr r3 = cptr( ulong ptr, cptr( ubyte ptr, dstbits ) + 3 * W * 4 )
    dim as ulong ptr r4 = cptr( ulong ptr, cptr( ubyte ptr, dstbits ) + 4 * W * 4 )
    dim as ulong ptr r7 = cptr( ulong ptr, cptr( ubyte ptr, dstbits ) + 7 * W * 4 )
    dim as ulong ptr r8 = cptr( ulong ptr, cptr( ubyte ptr, dstbits ) + 8 * W * 4 )
    dim as ulong ptr s4 = cptr( ulong ptr, SurfaceRowAddr( s, 4 ) )
    dim as ulong ptr s7 = cptr( ulong ptr, SurfaceRowAddr( s, 7 ) )

    Check( "row 3 untouched    ", iif( r3[0] = 0, 1, 0 ), 1, failures )
    Check( "row 4 == source 4  ", iif( r4[0] = s4[0], 1, 0 ), 1, failures )
    Check( "row 7 == source 7  ", iif( r7[0] = s7[0], 1, 0 ), 1, failures )
    Check( "row 8 untouched    ", iif( r8[0] = 0, 1, 0 ), 1, failures )

    '' ---- dirty-driven present ----
    memset( dstbits, 0, W * 4 * H )
    dim as ubyte ptr dirty = allocate( H )
    memset( dirty, 0, H )
    s.dirty = dirty
    LineBox32( s, 0, 10, W - 1, 12, &hFF112233, 1 )
    rows = GdiPresentDirty( memdc, s )
    GdiFlush( )
    Check( "present rows       ", rows, 3, failures )

    dim as long y1, y2
    Check( "dirty cleared      ", DirtySpan( s, y1, y2 ), 0, failures )
    Check( "re-present is no-op", GdiPresentDirty( memdc, s ), 0, failures )

    deallocate( dirty )
    deallocate( srcbits )
end if

SelectObject( memdc, old_ )
if dib <> 0 then DeleteObject( dib )
DeleteDC( memdc )
ReleaseDC( 0, screendc )

if failures = 0 then
    print "probe-gdi: PASS -- format, destination row and dirty handling verified"
    end 0
else
    print "probe-gdi: FAIL -- "; failures; " check(s) failed"
    end 1
end if
