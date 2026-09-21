'' abrun-bloadsave.bas -- BSAVE, BLOAD and SCREENLIST, A/B'd as whole programs.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' Run by abrun-bloadsave.sh, which compiles this ONE source twice -- with
'' fbc-modern (gfxlib2) and with tiko (libtkogfx) -- runs both and diffs what they
'' print. Not an abtest-*: those draw into IMAGECREATE buffers in one process,
'' and these paths need a SCREEN, a palette and files.
''
'' What is covered: BSAVE of 8, 16 and 32bpp screens and of images, as BMP and as
'' the raw block, with and without a caller's palette (file length and hash);
'' BLOAD of those files and of hand-built BMPs -- 1, 4, 8, 16, 16 BITFIELDS, 24,
'' 32 top-down, 32 V3 with alpha, OS/2 V1, RLE8 -- onto 8, 16 and 32bpp screens,
'' images and bare buffers (framebuffer and palette hashes); the return codes and
'' ERR; and SCREENLIST's walk, which lists the DISPLAY's modes and so is only
'' comparable between the two builds on one machine.
''
'' ONE SIDE-EFFECTING CALL PER STATEMENT. fbc evaluates `a & f( ) & g( )`
'' right to left, so `bsave( ... ) & FileHash( ... )` hashes before it saves.
''
'' The 16bpp screen is filled through SCREENPTR, not PSET: 16bpp drawing does not
'' pack RGB565 yet (Learnings, 2026-09-21), and this tests the file paths.

dim shared as long o

function Fnv( byval p as ubyte ptr, byval n as long, byval h as ulong = 2166136261 ) as ulong
    for i as long = 0 to n - 1
        h = (h xor p[i]) * 16777619
    next
    return h
end function

function FileHash( byref fn as string ) as string
    dim as long f = freefile
    if open( fn, for binary, access read, as #f ) <> 0 then return "nofile"
    dim as long n = lof( f )
    dim as string s = ""
    if n > 0 then
        s = space( n )
        get #f, , s
    end if
    close #f
    return "len=" & n & " h=" & hex( Fnv( strptr( s ), n ), 8 )
end function

function ScreenHash( ) as string
    dim as long w, h, bpp, pitch
    screeninfo w, h, , bpp, pitch
    screenlock
    dim as ubyte ptr p = screenptr
    dim as ulong hh = 2166136261
    for y as long = 0 to h - 1
        hh = Fnv( p + y * pitch, w * bpp, hh )
    next
    screenunlock
    return hex( hh, 8 )
end function

function PalHash( ) as string
    dim as ulong hh = 2166136261
    for i as long = 0 to 255
        dim as long r, g, b
        palette get i, r, g, b
        dim as ubyte t(0 to 2) = { r, g, b }
        hh = Fnv( @t(0), 3, hh )
    next
    return hex( hh, 8 )
end function

function ArrHash( byval p as long ptr, byval n as long ) as string
    return hex( Fnv( cptr( ubyte ptr, p ), n * 4 ), 8 )
end function

sub Say( byref s as string )
    print #o, s
end sub

function LE16( byval v as long ) as string
    return chr( v and 255, (v shr 8) and 255 )
end function
function LE32( byval v as long ) as string
    return chr( v and 255, (v shr 8) and 255, (v shr 16) and 255, (v shr 24) and 255 )
end function

'' A BMP built by hand: header size hs (12, 40 or 56), bit count bc, compression comp,
'' height signed, palette entries (count np, bytes per entry pe), optional masks.
sub WriteBmp( byref fn as string, byval hs as long, byval w as long, byval h as long, _
              byval bc as long, byval comp as long, byval np as long, _
              byref masks as string, byref pixels as string )
    dim as long pe = iif( hs = 12, 3, 4 )
    dim as string pal = ""
    for i as long = 0 to np - 1
        pal &= chr( (i * 37) and 255, (i * 91 + 7) and 255, (i * 13 + 100) and 255 )
        if pe = 4 then pal &= chr( 0 )
    next
    dim as string info
    if hs = 12 then
        info = LE32( 12 ) & LE16( w ) & LE16( h ) & LE16( 1 ) & LE16( bc )
    else
        info = LE32( hs ) & LE32( w ) & LE32( h ) & LE16( 1 ) & LE16( bc ) & LE32( comp ) & _
               LE32( len( pixels ) ) & LE32( 2834 ) & LE32( 2834 ) & LE32( 0 ) & LE32( 0 )
        if hs = 56 then info &= masks : masks = ""
    end if
    dim as long off = 14 + len( info ) + len( pal ) + len( masks )
    dim as string s = "BM" & LE32( off + len( pixels ) ) & LE32( 0 ) & LE32( off ) & info & pal & masks & pixels
    dim as long f = freefile
    open fn for binary access write as #f
    put #f, , s
    close #f
end sub

'' Rows of pseudo-random bytes, each padded to 4.
function Rows( byval rowbytes as long, byval h as long, byval seed as long ) as string
    dim as long padded = (rowbytes + 3) and not 3
    dim as string s = ""
    for y as long = 0 to h - 1
        for x as long = 0 to padded - 1
            s &= chr( (x * 29 + y * 53 + seed * 17 + (x * y)) and 255 )
        next
    next
    return s
end function

sub LoadCase( byref tag as string, byref fn as string )
    cls
    dim as long r = bload( fn )
    dim as long e = err
    dim as string sh = ScreenHash( )
    Say tag & ": r=" & r & " err=" & e & " scr=" & sh & " pal=" & PalHash( )
end sub

o = freefile
open cons for output as #o

'' ---------------------------------------------------------------- SCREENLIST
scope
    dim as long n8 = 0, n32 = 0, first8, last8
    dim as long m = screenlist( 8 )
    first8 = m
    while m <> 0
        n8 += 1 : last8 = m
        m = screenlist( )
    wend
    Say "sl8 n=" & n8 & " first=" & hex( first8 ) & " last=" & hex( last8 ) & " after=" & screenlist( )
    m = screenlist( 32 )
    while m <> 0
        n32 += 1
        m = screenlist( -1 )
    wend
    Say "sl32 n=" & n32
    Say "sl24=" & hex( screenlist( 24 ) ) & " sl16=" & hex( screenlist( 16 ) ) & " sl1=" & hex( screenlist( 1 ) )
end scope

'' --------------------------------------------------------------- 8bpp screen
screenres 64, 48, 8
for y as long = 0 to 47
    for x as long = 0 to 63
        pset (x, y), (x * 3 + y * 5) and 255
    next
next
palette 1, 10, 20, 30
palette 200, 250, 5, 99
Say "s8 scr=" & ScreenHash( ) & " pal=" & PalHash( )

dim as long pal6(0 to 255)
for i as long = 0 to 255
    pal6(i) = (i and 63) or (((i * 2) and 63) shl 8) or (((i * 3) and 63) shl 16)
next

scope : dim as long r_ = bsave( "a8.bmp", 0 ) : dim as long e_ = err : Say "bsave a8.bmp r=" & r_ & " err=" & e_ & " " & FileHash( "a8.bmp" ) : end scope
scope : dim as long r_ = bsave( "a8.bsv", 0, 64 * 48 ) : dim as long e_ = err : Say "bsave a8.bsv r=" & r_ & " err=" & e_ & " " & FileHash( "a8.bsv" ) : end scope
scope : dim as long r_ = bsave( "a8p.bmp", 0, , @pal6(0) ) : dim as long e_ = err : Say "bsave a8p.bmp r=" & r_ & " err=" & e_ & " " & FileHash( "a8p.bmp" ) : end scope
scope : dim as long r_ = bsave( "a8p.bsv", 0, 64 * 48, @pal6(0) ) : dim as long e_ = err : Say "bsave a8p.bsv r=" & r_ & " err=" & e_ & " " & FileHash( "a8p.bsv" ) : end scope
scope : dim as long r_ = bsave( "a8big.bsv", 0, 999999 ) : dim as long e_ = err : Say "bsave a8big.bsv r=" & r_ & " err=" & e_ & " " & FileHash( "a8big.bsv" ) : end scope

dim as any ptr i8 = imagecreate( 10, 7, 3 )
for y as long = 0 to 6
    for x as long = 0 to 9
        pset i8, (x, y), (x * 7 + y) and 255
    next
next
scope : dim as long r_ = bsave( "i8.bmp", i8 ) : dim as long e_ = err : Say "bsave i8.bmp r=" & r_ & " err=" & e_ & " " & FileHash( "i8.bmp" ) : end scope
scope : dim as long r_ = bsave( "i8.bsv", i8 ) : dim as long e_ = err : Say "bsave i8.bsv r=" & r_ & " err=" & e_ & " " & FileHash( "i8.bsv" ) : end scope
scope : dim as long r_ = bsave( "i8raw.bsv", i8, 32 + 16 * 7 ) : dim as long e_ = err : Say "bsave i8raw.bsv r=" & r_ & " err=" & e_ & " " & FileHash( "i8raw.bsv" ) : end scope

LoadCase( "load a8.bmp", "a8.bmp" )
palette 1, 0, 0, 0
scope
    dim as long pl(0 to 255)
    cls
    dim as long r = bload( "a8.bmp", , @pl(0) )
    Say "load a8.bmp pal: r=" & r & " pl=" & ArrHash( @pl(0), 256 ) & " pl1=" & hex( pl(1) ) & " scr=" & ScreenHash( ) & " pal=" & PalHash( )
    cls
    r = bload( "a8.bsv", , @pl(0) )
    Say "load a8.bsv pal: r=" & r & " pl=" & ArrHash( @pl(0), 256 ) & " pl1=" & hex( pl(1) ) & " scr=" & ScreenHash( ) & " pal=" & PalHash( )
end scope
LoadCase( "load a8.bsv", "a8.bsv" )
LoadCase( "load a8p.bsv", "a8p.bsv" )
LoadCase( "load a8p.bmp", "a8p.bmp" )
LoadCase( "load i8.bmp", "i8.bmp" )

scope
    dim as ubyte buf(0 to 64 * 48 + 1024)
    dim as long r = bload( "a8.bmp", @buf(0) )
    dim as long ptr hp = cptr( long ptr, @buf(0) )
    Say "load buf: r=" & r & " hdr=" & hp[0] & "," & hp[1] & "," & hp[2] & "," & hp[3] & "," & hp[4] & " px=" & hex( Fnv( @buf(32), 64 * 48 ), 8 )
    dim as any ptr im = imagecreate( 20, 12, 0 )
    r = bload( "a8.bmp", im )
    Say "load img: r=" & r & " px=" & hex( Fnv( cptr( ubyte ptr, im ) + 32, 32 * 12 ), 8 )
    imagedestroy( im )
    im = imagecreate( 100, 100, 0 )
    r = bload( "i8.bmp", im )
    Say "load img big: r=" & r & " px=" & hex( Fnv( cptr( ubyte ptr, im ) + 32, 112 * 100 ), 8 )
    imagedestroy( im )
end scope

'' crafted BMPs, loaded onto the 8bpp screen
WriteBmp( "c8.bmp", 40, 13, 9, 8, 0, 256, "", Rows( 13, 9, 1 ) )
WriteBmp( "c4.bmp", 40, 13, 9, 4, 0, 16, "", Rows( 7, 9, 2 ) )
WriteBmp( "c1.bmp", 40, 13, 9, 1, 0, 2, "", Rows( 2, 9, 3 ) )
WriteBmp( "cos2.bmp", 12, 13, 9, 8, 0, 256, "", Rows( 13, 9, 4 ) )
WriteBmp( "ctd8.bmp", 40, 13, -9, 8, 0, 256, "", Rows( 13, 9, 5 ) )
WriteBmp( "c24.bmp", 40, 13, 9, 24, 0, 0, "", Rows( 39, 9, 6 ) )
WriteBmp( "c32td.bmp", 40, 13, -9, 32, 0, 0, "", Rows( 52, 9, 7 ) )
WriteBmp( "c16.bmp", 40, 13, 9, 16, 0, 0, "", Rows( 26, 9, 8 ) )
WriteBmp( "c16bf.bmp", 40, 13, 9, 16, 3, 0, LE32( &hF800 ) & LE32( &h7E0 ) & LE32( &h1F ), Rows( 26, 9, 9 ) )
WriteBmp( "c32v3.bmp", 56, 13, 9, 32, 3, 0, LE32( &hFF ) & LE32( &hFF00 ) & LE32( &hFF0000 ) & LE32( &hFF000000 ), Rows( 52, 9, 10 ) )
WriteBmp( "crle.bmp", 40, 13, 9, 8, 1, 256, "", Rows( 13, 9, 11 ) )
scope
    dim as long f = freefile
    open "bad.bin" for binary access write as #f
    dim as string s = "XYZ"
    put #f, , s
    close #f
    f = freefile
    open "badbmp.bmp" for binary access write as #f
    s = "BMnotreally"
    put #f, , s
    close #f
    f = freefile
    open "qb.bsv" for binary access write as #f
    s = chr( &hFD, 0, 0, 0, 0, 16, 0 ) & "0123456789ABCDEF" & "trailing"
    put #f, , s
    close #f
end scope

LoadCase( "8:c8", "c8.bmp" )
LoadCase( "8:c4", "c4.bmp" )
LoadCase( "8:c1", "c1.bmp" )
LoadCase( "8:cos2", "cos2.bmp" )
LoadCase( "8:ctd8", "ctd8.bmp" )
LoadCase( "8:c24", "c24.bmp" )
LoadCase( "8:crle", "crle.bmp" )
LoadCase( "8:missing", "missing.bmp" )
LoadCase( "8:bad", "bad.bin" )
LoadCase( "8:badbmp", "badbmp.bmp" )
LoadCase( "8:qb", "qb.bsv" )

'' -------------------------------------------------------------- 32bpp screen
screenres 64, 48, 32
for y as long = 0 to 47
    for x as long = 0 to 63
        pset (x, y), rgb( x * 4, y * 5, (x * y) and 255 )
    next
next
Say "s32 scr=" & ScreenHash( )
scope : dim as long r_ = bsave( "a32.bmp", 0 ) : dim as long e_ = err : Say "bsave a32.bmp r=" & r_ & " err=" & e_ & " " & FileHash( "a32.bmp" ) : end scope
dim as any ptr i32 = imagecreate( 9, 5, rgb( 1, 2, 3 ) )
scope : dim as long r_ = bsave( "i32.bmp", i32 ) : dim as long e_ = err : Say "bsave i32.bmp r=" & r_ & " err=" & e_ & " " & FileHash( "i32.bmp" ) : end scope
LoadCase( "32:a8", "a8.bmp" )
LoadCase( "32:a32", "a32.bmp" )
LoadCase( "32:c8", "c8.bmp" )
LoadCase( "32:c4", "c4.bmp" )
LoadCase( "32:c1", "c1.bmp" )
LoadCase( "32:cos2", "cos2.bmp" )
LoadCase( "32:c24", "c24.bmp" )
LoadCase( "32:c32td", "c32td.bmp" )
LoadCase( "32:c16", "c16.bmp" )
LoadCase( "32:c16bf", "c16bf.bmp" )
LoadCase( "32:c32v3", "c32v3.bmp" )
scope
    dim as any ptr im = imagecreate( 8, 8, 0 )
    dim as long r = bload( "c24.bmp", im )
    Say "32 img c24: r=" & r & " px=" & hex( Fnv( cptr( ubyte ptr, im ) + 32, 32 * 8 ), 8 )
    imagedestroy( im )
    dim as ubyte buf(0 to 4096)
    r = bload( "c24.bmp", @buf(0) )
    dim as long ptr hp = cptr( long ptr, @buf(0) )
    Say "32 buf c24: r=" & r & " hdr=" & hp[0] & "," & hp[1] & "," & hp[2] & "," & hp[3] & "," & hp[4] & " px=" & hex( Fnv( @buf(32), 64 * 9 ), 8 )
end scope

'' -------------------------------------------------------------- 16bpp screen
screenres 64, 48, 16
for y as long = 0 to 47
    for x as long = 0 to 63
        pset (x, y), rgb( x * 4, y * 5, (x * y) and 255 )
    next
next
scope
    screenlock
    dim as ushort ptr sp = screenptr
    for k as long = 0 to 64 * 48 - 1
        sp[k] = cast( ushort, k * 2654435761ul shr 7 )
    next
    screenunlock
end scope
Say "s16 scr=" & ScreenHash( )
scope : dim as long r_ = bsave( "a16.bmp", 0 ) : dim as long e_ = err : Say "bsave a16.bmp r=" & r_ & " err=" & e_ & " " & FileHash( "a16.bmp" ) : end scope
LoadCase( "16:c24", "c24.bmp" )
LoadCase( "16:c8", "c8.bmp" )
LoadCase( "16:c16bf", "c16bf.bmp" )
LoadCase( "16:c32td", "c32td.bmp" )

screen 0
dim as string files(0 to 25) = { "a8.bmp", "a8.bsv", "a8p.bmp", "a8p.bsv", "a8big.bsv", "i8.bmp", "i8.bsv", "i8raw.bsv", _
    "c8.bmp", "c4.bmp", "c1.bmp", "cos2.bmp", "ctd8.bmp", "c24.bmp", "c32td.bmp", "c16.bmp", "c16bf.bmp", "c32v3.bmp", _
    "crle.bmp", "bad.bin", "badbmp.bmp", "qb.bsv", "a32.bmp", "i32.bmp", "a16.bmp", "x" }
for i as long = 0 to 24
    kill files(i)
next
Say "done"
