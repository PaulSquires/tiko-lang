#!/usr/bin/env python3
"""Extract the runtime ABI from what FBC EMITS, and check it against libfb.

    python tools/gen/rtl-truth.py

Writes tests/expected/fbc-rtl.txt: one row per runtime function, with the exact C
signature fbc declares for it.

Why this and not fbc's own rtl-*.bas tables: those are compiler SOURCE and are GPL,
and docs/plan/11 already flags the runtime's licence as a prerequisite for release.
The signatures are recoverable from the artifact instead -- 'fbc -r' leaves a C
intermediate that DECLARES every runtime function it calls -- which is both
licence-clean and better evidence, because it is what fbc actually emits rather than
what a table says it should.

Every name is then checked against libfb.a, so a signature that no longer matches an
exported symbol is caught here rather than at link time.
"""
import re
import subprocess
import sys
from pathlib import Path

import tkotargets

ROOT = Path(__file__).resolve().parents[2]

# The toolchains live in tkotargets, so control.py can point a half elsewhere.
# THE GRAPHICS ENTRY POINTS ARE IN A DIFFERENT ARCHIVE. libfbgfx.a, not libfb.a, and
# looking in only the first made every one of them read as ABSENT -- which is a
# perfectly good way to describe a symbol that is simply somewhere else, and says
# nothing about whether the signature is right.
TARGETS = {
    "win64": (tkotargets.FBC64,
              [tkotargets.TC / "lib/win64/libfb.a", tkotargets.TC / "lib/win64/libfbgfx.a"],
              ROOT / "tests/expected/fbc-rtl.txt", ROOT / "build/.rt", []),
    "win32": (tkotargets.FBC32,
              [tkotargets.TC / "lib/win32/libfb.a", tkotargets.TC / "lib/win32/libfbgfx.a"],
              ROOT / "tests/expected/fbc-rtl-win32.txt", ROOT / "build/.rt32",
              ["-gen", "gcc"]),
}

# Each probe is a fragment whose lowering pulls in a family of runtime calls. They are
# deliberately small: the point is to make fbc declare the functions, not to exercise
# them.
# Probes that must be compiled as the MAIN module. fb_Init/fb_End are emitted only for
# the entry translation unit, so without -m they never appear and the inventory cannot
# be checked against them.
MAIN_MODULE = {"module"}

PROBES = {
    # Module-level code, which fbc wraps in main(): fb_Init before the body, fb_End
    # after the cleanups.
    "module": '''
dim as long g = 7
dim as string s = "hi"
print g
''',
    "string": '''
sub P( )
    dim as string a, b
    a = "x"
    a = b
    a = a + b
    a = "abc" + b
    a = b + a
    if a = b then
    end if
    a = left(b, 1)
    a = mid(b, 1, 2)
    a = str(1)
    dim as long n = len(a)
    dim as long v = valint(a)
end sub
''',
    # SWAP: strings go through the runtime, scalars are a temporary and three stores.
    # The FIXED-LENGTH and aggregate forms are different entry points again --
    # fb_WstrSwap for wide, fb_MemSwap for a UDT by size -- and a probe that swaps only
    # two var-length strings never makes fbc emit them.
    "swap": '''
type SwapU
    as integer a, b
end type
sub S( )
    dim as string a, b
    dim as zstring * 5 z1, z2
    dim as wstring * 5 w1, w2
    dim as SwapU u1, u2
    swap a, b
    swap z1, z2
    swap w1, w2
    swap u1, u2
end sub
''',
    # A STATIC LOCAL OBJECT is constructed LAZILY behind a guard flag, and its
    # destructor is registered with libc's atexit -- not with anything in libfb. The
    # entry point is therefore 'atexit' itself, which no other probe here makes fbc
    # declare.
    "staticobj": '''
type StatU
    as integer a
    declare constructor( )
    declare destructor( )
end type
constructor StatU( )
end constructor
destructor StatU( )
end destructor
sub SP( )
    static as StatU s
    s.a = 1
end sub
''',
    # The CVx / MKx family -- a number's BYTES as a string and back. Every width has
    # its own entry point, and 'cvi'/'mki' follow the INTEGER width rather than having
    # one of their own: measured, 'cvi' is fb_CVLONGINT on win64 and fb_CVL on win32,
    # while fb_MKI exists on both and takes int64 there and int32 here.
    "cvmk": '''
sub CvProbe( )
    dim as string s
    dim as long l = cvl( s )
    dim as short sh = cvshort( s )
    dim as longint li = cvlongint( s )
    dim as double d = cvd( s )
    dim as single sg = cvs( s )
    dim as integer i = cvi( s )
    s = mki( i )
    s = mkl( l )
    s = mkshort( sh )
    s = mklongint( li )
    s = mkd( d )
    s = mks( sg )
end sub
''',
    # INSTRREV's ANY form, narrow and wide. The start position is its THIRD argument
    # and is passed LAST -- the opposite of INSTR, whose start is the first argument
    # and is passed first -- and neither entry point is named after the other's.
    "instrrevany": '''
sub RevProbe( )
    dim as string s, p
    dim as wstring * 20 w, q
    dim as integer a
    a = instrrev( s, any p )
    a = instrrev( s, any p, 3 )
    a = instrrev( w, any q )
    a = instrrev( w, q, 3 )
    a = instr( w, q )
    a = instr( w, any q )
    a = instr( 2, w, q )
    dim as double d = val( w )
    dim as longint q1 = vallng( w )
    dim as ulongint q2 = valulng( w )
    dim as integer q3 = valint( w )
    dim as uinteger q4 = valuint( w )
    dim as wstring * 8 f1, f2
    f1 = wstring( 3, 65 )
    f2 = wstring( 3, w )
    '' A RUNTIME argument: 'wchr( 65 )' with a literal FOLDS to a wide literal and
    '' fbc emits no call at all.
    dim as long code_ = 65
    f1 = wchr( code_ )
    f2 = wchr( code_, code_ )
end sub
''',
    # BOOLEAN's own renderers, narrow and WIDE. 'wstr( b )' is fb_BoolToWstr, not
    # fb_IntToWstr: the two differ in what they write, "true" against -1.
    "boolwstr": '''
sub BwProbe( )
    dim as boolean b
    dim as wstring * 8 w
    dim as string s
    w = wstr( b )
    s = str( b )
end sub
''',
    # ASC over a WIDE operand, which has its own entry point like the val family.
    "wideasc": '''
sub WAscProbe( )
    dim as wstring * 8 w
    dim as long r
    r = asc( w, 1 )
end sub
''',
    # DELETE is not an fb_* entry point at all: fbc emits libc's free, guarded by a
    # null check, with the destructor called first.
    "deletestmt": '''
type DelU
    as integer a
    declare destructor( )
end type
destructor DelU( )
end destructor
sub D( )
    dim as DelU ptr p = new DelU
    delete p
end sub
''',
    # FILE GET and PUT, the BINARY forms. Probed with a scalar so the byte count is a
    # compile-time size rather than a descriptor's length.
    "fileget": '''
sub GetProbe( byval f as long )
    dim as byte b
    dim as long r
    r = get( #f, 1, b )
    put #f, 1, b
end sub
''',
    # USTRING -- the UTF-16 flavour, which has its OWN descriptor and its own entry
    # points. Every shape is touched separately for the same reason the narrow family
    # is: fbc picks a different entry for a declaration, a later store, a concat and a
    # concat-assign, and the LENGTH ARGUMENT IS TAGGED differently for a literal, a
    # var-length destination and a fixed 'ustring * N'.
    "ustring": '''
declare sub UTake( byref x as const ustring )
sub UProbe( )
    dim as ustring a = "x"
    dim as ustring b
    dim as ustring * 8 f = "abc"
    dim as long n
    dim as long c = 0
    b = a
    b = "y"
    f = "d"
    b = a & "y"
    b &= "z"
    f &= a
    n = len( a )
    if a = "x" then c = 1
    print a, b, f, n, c
    '' fb_UStrConcat proper is emitted only where the result is a genuine RVALUE:
    '' assigning into a ustring is optimised into assign + concat-assign, exactly as
    '' the wide family above.
    UTake( a & b )
end sub
sub UTake( byref x as const ustring )
end sub

'' THE CONVERSION SURFACE, which is a different set of entry points again and was
'' entirely absent: a ustring never converts by copying, it TRANSCODES. A narrow source
'' is UTF-8 and takes fb_UStrAssignFromA, a wide one is UTF-16 and goes through
'' fb_WstrToUStr first, and the two concat entries differ by WHICH SIDE is the ustring.
sub UConv( byref p as const wstring, byref q as const string, byref z as const zstring )
    dim as ustring u, v
    dim as string s
    dim as wstring * 8 w
    dim as string * 8 fs
    u = q
    u = z
    u = p
    u = fs
    u = w
    dim as ustring c0 = q
    dim as ustring c1 = q + q
    s = u
    w = u
    u = u + q
    u = q + u
    u = u & q
    u = q & u
    '' A COMPARISON promotes the OTHER side to a ustring first -- fb_StrToUStr for a
    '' narrow operand and fb_WstrToUStr for a wide one -- and only then compares. It is
    '' the only place fb_StrToUStr appears.
    dim as long c2 = 0
    if u = q then c2 = 1
    if u = p then c2 = 2
    if u < q then c2 = 3
    v = q + q
    v = c2 & u
    print u, v, s, w, c0, c1
end sub
''',
    # WIDE STRINGS. A wstring value is a bare uint16*; there is no descriptor and no
    # var-length form. The probe has to touch each shape separately because fbc picks a
    # different entry for wide-to-wide, wide-from-narrow and wide-to-narrow.
    "wstring": '''
declare sub WTake( byref x as const wstring )
sub WProbe( )
    dim as wstring * 50 w, w2
    dim as string s
    dim as long n
    w = "abc"
    w = w2
    s = w
    n = len( w )
    if w = w2 then
    end if
    w = w & w2
    w &= w2
    print w
    w = wstr( n )
    dim as ulong u : w = wstr( u )
    dim as longint q : w = wstr( q )
    dim as ulongint uq : w = wstr( uq )
    dim as single f : w = wstr( f )
    dim as double d : w = wstr( d )
    w = wstr( s )
    s = str( w )
    dim as wstring ptr p = @w
    dim as wstring * 8 w3
    w3 = w & s
    w3 = s & w
    '' fb_WstrConcat proper is emitted only where the result is a genuine RVALUE:
    '' assigning into a fixed wstring is optimised into assign + concat-assign.
    WTake( w & w2 )
    '' A NARROW DESTINATION AT ITS DECLARATION takes its own entry point, the '_Init'
    '' variant -- 'fb_WstrAssignToA_Init( &C, -1, tmp, 0 )' -- where a later store takes
    '' fb_WstrAssignToA. The same distinction fb_StrInit and fb_StrAssign make.
    dim as string ci = w & s
    dim as string cj = w & w2
    print ci, cj
end sub
sub WTake( byref x as const wstring )
end sub
''',
    # THE WIDE SUBSTRING AND TRIM FAMILY. The argument orders are NOT uniform:
    # instr takes its start first, instrrev takes it last, and a 'mid' with no
    # length passes -1 rather than 0. Each one is probed separately rather than
    # assumed from its narrow counterpart.
    # PRINT USING, SPC and TAB. Every integral type is probed separately even though
    # they all widen to 64 bits, because "they all widen" is the thing being checked.
    "printusing": '''
sub PUProbe( )
    dim as string s
    dim as wstring * 8 w
    dim as long l : dim as ulong ul
    dim as longint q : dim as ulongint uq
    dim as single f : dim as double d
    dim as boolean bo
    dim as long n = 2
    print using "###.##"; d; f
    print using "#"; l; ul; q; uq
    print using "&"; s
    print using "&"; w
    print using "#"; bo
    print "a"; tab( n ); "b"; spc( n ); "c"
end sub
''',
    # ERASE over a FIXED array. Each of the four shapes has to be a separate array:
    # what erase emits depends on the ELEMENT type, and the fixed-string row is
    # fb_ArrayDestructStr rather than the fb_ArrayClear the name would suggest.
    "arrayerase": '''
type EU
    declare constructor( )
    declare destructor( )
    x as long
end type
constructor EU( )
end constructor
destructor EU( )
end destructor
sub AEProbe( )
    dim as long a(0 to 4)
    dim as string sa(0 to 4)
    dim as EU ua(0 to 2)
    dim as long m(1 to 2, 3 to 5)
    erase a
    erase sa
    erase ua
    erase m
end sub
''',
    # DYNAMIC arrays: redim in both preserve and Obj forms, the three erase entries,
    # and the two bound queries. The Obj forms need an element type with a structor,
    # and the four Redim* entries are the only array routines that are CDECL on win32.
    "arraydyn": '''
type DU
    declare constructor( )
    declare destructor( )
    x as long
end type
constructor DU( )
end constructor
destructor DU( )
end destructor
sub ADProbe( byval n as long )
    dim as long a( )
    dim as string s( )
    dim as DU u( )
    dim as long m( any, any )
    redim a( 0 to n )
    redim preserve a( 0 to n )
    redim s( 0 to n )
    redim u( 0 to n )
    redim preserve u( 0 to n )
    redim m( 1 to n, 3 to n )
    print lbound( a ), ubound( a )
    print lbound( m, 2 ), ubound( m, 2 )
    erase a
    erase s
    erase u
end sub
''',
    # hex / oct / bin and the two fill entries. FOUR WIDTHS EACH, and the digit-count
    # form is a separate entry point with a different capitalisation -- fb_HEX_i beside
    # fb_HEXEx_i -- so every one of the twenty-four is probed. The argument must be
    # NON-CONSTANT: fbc folds 'hex( 123 )' to a literal and calls nothing.
    "radix": '''
sub RadixProbe( )
    dim as string s
    dim as byte b : dim as short sh : dim as long l : dim as longint q
    dim as long n = 2
    s = hex( b )   : s = hex( sh )   : s = hex( l )   : s = hex( q )
    s = hex( b, n ): s = hex( sh, n ): s = hex( l, n ): s = hex( q, n )
    s = oct( b )   : s = oct( sh )   : s = oct( l )   : s = oct( q )
    s = oct( b, n ): s = oct( sh, n ): s = oct( l, n ): s = oct( q, n )
    s = bin( b )   : s = bin( sh )   : s = bin( l )   : s = bin( q )
    s = bin( b, n ): s = bin( sh, n ): s = bin( l, n ): s = bin( q, n )
    '' A POINTER has its own six, which is not a width the table can express.
    dim as any ptr pz
    s = hex( pz ) : s = hex( pz, n )
    s = oct( pz ) : s = oct( pz, n )
    s = bin( pz ) : s = bin( pz, n )
    '' AND THE WIDE HALF OF ALL THIRTY, spelled fb_WstrHex rather than fb_HEX.
    dim as wstring * 90 wz
    wz = whex( b ) : wz = whex( sh ) : wz = whex( l ) : wz = whex( q ) : wz = whex( pz )
    wz = whex( b, n ) : wz = whex( sh, n ) : wz = whex( l, n ) : wz = whex( q, n ) : wz = whex( pz, n )
    wz = woct( b ) : wz = woct( sh ) : wz = woct( l ) : wz = woct( q ) : wz = woct( pz )
    wz = woct( b, n ) : wz = woct( sh, n ) : wz = woct( l, n ) : wz = woct( q, n ) : wz = woct( pz, n )
    wz = wbin( b ) : wz = wbin( sh ) : wz = wbin( l ) : wz = wbin( q ) : wz = wbin( pz )
    wz = wbin( b, n ) : wz = wbin( sh, n ) : wz = wbin( l, n ) : wz = wbin( q, n ) : wz = wbin( pz, n )
    s = space( n )
    s = string( n, l )
    s = string( n, s )
end sub
''',
    # STR and CHR, and the string intrinsics whose RESULT IS A NUMBER. str's narrow
    # types do NOT get their own entry points -- byte, short and long all widen to
    # int32 -- which is the one thing about it that hex/oct/bin sitting beside it would
    # have led you to guess wrong.
    "strconv": '''
sub StrConvProbe( )
    dim as string s, t
    dim as byte b : dim as ubyte ub : dim as short sh : dim as ushort ush
    dim as long l : dim as ulong ul : dim as longint q : dim as ulongint uq
    dim as single f : dim as double dd : dim as boolean bo
    dim as long n = 3
    s = str( b ) : s = str( ub ) : s = str( sh ) : s = str( ush )
    s = str( l ) : s = str( ul ) : s = str( q ) : s = str( uq )
    s = str( f ) : s = str( dd ) : s = str( bo )
    s = chr( n ) : s = chr( n, n )
    n = asc( s ) : n = asc( s, n )
    n = instr( s, t ) : n = instr( n, s, t ) : n = instr( s, any t )
    n = instrrev( s, t )
    dd = val( s ) : q = vallng( s ) : uq = valulng( s )
    n = valint( s ) : ul = valuint( s )
end sub
''',
    # The math intrinsics that ARE runtime calls. sqr/sin/cos and the rest are gcc
    # BUILTINS to fbc and are opcodes in tiko-lang, so they are deliberately not here: a
    # builtin is declared nowhere and would look like a missing entry.
    "mathrtl": '''
sub MathProbe( )
    dim as single f = 1.0, g
    dim as double x = 5.0, y
    dim as longint q = -3
    dim as long n = 3
    g = fix( f )  : y = fix( x )
    g = frac( f ) : y = frac( x )
    n = sgn( f )  : n = sgn( x ) : n = sgn( q )
    y = atan2( x, x )
    y = x ^ y
end sub
''',
    # THE CONSOLE, THE FILESYSTEM, THE CLOCK, THE ENVIRONMENT AND THE THREAD FOUR.
    # None of these statements is lowered yet; the inventory is measured first because
    # warnings/rtl-prototypes.bas takes the ADDRESS of each and a name tiko does not
    # know declines at the procptr, whatever the statement does.
    "console": '''
sub ConsoleProbe( )
    color 1, 2
    width 80, 25
    view print 1 to 2
    dim as long x = pos( 0 ), y = csrlin
    cls
    locate 1, 1
    beep
end sub
''',
    # THE NO-ARGUMENT SPELLINGS ARE DIFFERENT ENTRY POINTS. 'pos( 0 )' is fb_Pos and a
    # bare 'pos' is fb_GetX; 'dir( pattern )' is fb_Dir and a bare 'dir( )' is
    # fb_DirNext, which continues the walk the first one started.
    "bareforms": '''
sub BareFormProbe( )
    dim as long x = pos
    dim as string d = dir( )
    dim as wstring * 8 w
    w = wspace( 4 )
end sub
''',
    # THE REST OF THE INTRINSIC KEYWORDS warnings/rtl-prototypes.bas takes the address
    # of: the console keyboard and mouse, the ports, the dynamic loader, the graphics
    # page and palette helpers, and the two process replacements.
    #
    # 'stop' and 'system' are not here because both are fb_End( 0 ), which the module
    # probe already carries.
    "kwrest": '''
sub KwRestProbe( )
    dim as long a( 0 to 3 )
    bload "f", @a(0)
    bsave "f", @a(0), 16
    dim as any ptr h = dylibload( "x" )
    dim as any ptr sy = dylibsymbol( h, "y" )
    dylibfree( h )
    dim as string k = inkey
    dim as long gk = getkey
    out 1, 2
    dim as long i2 = inp( 1 )
    pcopy 0, 1
    dim as long px = pmap( 1, 0 )
    dim as ulong pc = point( 1, 1 )
    dim as long pcz = pointcoord( 0 )
    setdate "01-01-2000"
    settime "00:00:00"
    dim as long m = multikey( 1 )
    screenlist 32
    getmouse px, px
    setmouse 1, 1
    dim as double fr = fre
    wait 1, 2
    run "a"
    chain "b"
end sub
''',
    # GET, PUT, LOCK and the five special OPEN forms. THE NAMES ARE TARGET-DEPENDENT:
    # win64 declares fb_FileGetLarge and win32 fb_FileGet, because the offset follows
    # the pointer -- so the two expectation files legitimately name different symbols
    # for the same statement.
    "fileio3": '''
sub FioProbe( )
    dim as long f = freefile
    open "x" for binary as #f
    dim as long v
    dim as long arr( 0 to 3 )
    dim as string s
    dim as wstring * 8 w
    get #f, , v
    get #f, , arr( )
    get #f, , s
    get #f, , w
    put #f, , v
    put #f, , arr( )
    put #f, , s
    put #f, , w
    lock #f, 1 to 2
    unlock #f, 1 to 2
    dim as string li
    line input #f, li
    input #f, v
    close #f
    open com "COM1:9600" as #f
    open cons for output as #f
    open err for output as #f
    open lpt "LPT1:" for output as #f
    open pipe "cmd" for input as #f
    open scrn for output as #f
end sub
''',
    "fsdir": '''
sub FsDirProbe( )
    name "a", "b"
    chdir "a"
    mkdir "a"
    rmdir "a"
    kill "a"
    dim as string cd = curdir
    dim as string dd = dir( "*" )
end sub
''',
    "fileio2": '''
sub FileIoProbe( )
    dim as long f = freefile
    open "x" for binary as #f
    dim as long v
    get #f, , v
    put #f, , v
    dim as longint l = loc( f ), l2 = lof( f )
    dim as long e = eof( f )
    seek #f, 1
    l = seek( f )
    close #f
    reset
end sub
''',
    "clockenv": '''
sub ClockEnvProbe( )
    dim as string d = date, t = time
    dim as double tm = timer
    randomize
    dim as double r = rnd
    sleep 1
    dim as string e = environ( "PATH" )
    setenviron "A=1"
    dim as string c = command( )
    dim as string x = exepath( )
    dim as long rc = exec( "a", "b" )
    rc = shell( "a" )
end sub
''',
    "threads": '''
sub ThreadProbe( )
    dim as any ptr t = threadcreate( 0, 0 )
    threadwait( t )
    dim as any ptr m = mutexcreate( )
    mutexlock( m )
    mutexunlock( m )
    mutexdestroy( m )
    dim as any ptr cv = condcreate( )
    condsignal( cv )
    condbroadcast( cv )
    conddestroy( cv )
end sub
''',
    # ERR, ERL, ERMN, ERFN and the setter behind 'err = n'.
    "errinfo": '''
sub ErrProbe( )
    dim as long e = err
    e = erl
    dim as zstring ptr s = ermn
    s = erfn
    err = 5
end sub
''',
    # 'mid( s, i, n ) = t' -- an ASSIGNMENT INTO a string, which is its own entry point
    # in both widths and is not the mid() that reads.
    "midassign": '''
sub MidAssignProbe( )
    dim as string s = "abc"
    dim as wstring * 8 w
    mid( s, 1, 1 ) = "z"
    mid( w, 1, 1 ) = wstr( "z" )
end sub
''',
    # A WIDE 'iif'. Its arms ALLOCATE -- fb_WstrAlloc is the only wide entry point that
    # does -- which is why it needs a pointer temporary where the narrow form needs a
    # descriptor. The condition has to be NON-CONSTANT or fbc folds the whole thing.
    "wideiif": '''
dim shared as integer wiifCt
sub WideIifProbe( )
    dim as wstring * 32 a, b, c
    c = iif( wiifCt, a, b )
end sub
''',
    # 'string * N' -- the FIXED-LENGTH, space-padded flavour. A third string type, not
    # a spelling of either of the others: N raw bytes, no terminator, and a length
    # argument tagged with the SIGN BIT. Its descriptor wrapper is its own entry point.
    "fixstr": '''
sub FixStrProbe( )
    dim as string * 32 a, b
    dim as string s
    dim as long n
    a = b : a = s : s = a
    n = instr( a, s )
    s = trim( a )
    print a
end sub
''',
    # The NARROW substring and trim family. The spellings are not consistent --
    # fb_TRIM but fb_TrimEx, fb_LEFT but fb_StrMid -- so every one is probed.
    "strsub": '''
sub SSubProbe( )
    dim as string a, p, b
    dim as long n = 2
    b = trim( a )
    b = trim( a, p )
    b = trim( a, any p )
    b = ltrim( a )
    b = ltrim( a, p )
    b = ltrim( a, any p )
    b = rtrim( a )
    b = rtrim( a, p )
    b = rtrim( a, any p )
    b = left( a, n )
    b = right( a, n )
    b = mid( a, n )
    b = mid( a, n, n )
    b = ucase( a )
    b = lcase( a )
end sub
''',
    # DATA / READ / RESTORE. Every destination width is probed because the
    # DESTINATION TYPE alone picks the entry point, and INTEGER differs by target.
    "datastmt": '''
data 1, 2, "three"
dim as byte b : dim as ubyte ub
dim as short sh : dim as ushort ush
dim as long l : dim as ulong ul
dim as longint q : dim as ulongint uq
dim as integer i : dim as uinteger ui
dim as single f : dim as double d
dim as boolean bo
dim as string s
dim as zstring * 8 z
dim as wstring * 8 w
read b, ub, sh, ush, l, ul, q, uq, i, ui, f, d, bo, s, z, w
restore
''',
    # WRITE and the LSET/RSET pair. Every WRITE width is probed because the
    # destination type alone picks the entry point, exactly as PRINT does.
    "writeset": '''
sub WSProbe( )
    dim as string s1, s2
    dim as zstring * 8 z
    dim as string * 8 fx, fx2
    dim as wstring * 8 w, w2
    dim as byte b : dim as ubyte ub
    dim as short sh : dim as ushort ush
    dim as long l : dim as ulong ul
    dim as longint q : dim as ulongint uq
    dim as single f : dim as double d
    dim as boolean bo
    write b, ub, sh, ush, l, ul, q, uq, f, d, bo, s1, w
    write
    lset s1 = s2
    rset s1 = s2
    lset z = s2
    '' A 'string * N' DESTINATION IS NOT A DESCRIPTOR. It takes the bytes and the
    '' TAGGED length instead, through entry points of its own, and a source of that
    '' shape borrows a temporary descriptor from fb_StrAllocTempDescF.
    lset fx = s2
    rset fx = fx2
    lset w = w2
    rset w = w2
end sub
''',
    "wstrsub": '''
sub WSubProbe( )
    dim as wstring * 50 w, w2, r
    dim as long n = 3
    r = trim( w )
    r = trim( w, w2 )
    r = trim( w, any w2 )
    r = ltrim( w )
    r = ltrim( w, w2 )
    r = ltrim( w, any w2 )
    r = rtrim( w )
    r = rtrim( w, w2 )
    r = rtrim( w, any w2 )
    r = left( w, n )
    r = right( w, n )
    r = mid( w, n )
    r = mid( w, n, n )
    r = ucase( w )
    r = lcase( w )
end sub
''',
    # A STRING-RETURNING FUNCTION builds its value in a local descriptor and hands the
    # runtime that descriptor on the way out; what it returns is the pointer.
    "strresult": '''
function SR( ) as string
    return "hi"
end function
''',
    # INPUT: a start call, then one per destination. LINE INPUT is one call with the
    # destination inside it.
    "inputstmt": '''
sub I( )
    dim as byte b : dim as ubyte ub : dim as short sh : dim as ushort ush
    dim as long l : dim as ulong ul : dim as longint li : dim as ulongint uli
    dim as single f : dim as double d
    dim as string s : dim as wstring * 8 w
    input b : input ub : input sh : input ush
    input l : input ul : input li : input uli
    input f : input d : input s : input w
    input "prompt"; l
    input ; l
    input #1, l
    line input s
    line input "p"; s
end sub
''',
    # FreeBASIC's BUILT-IN PROCEDURES. fbc predeclares these and lowers each straight
    # to a runtime call -- 'allocate' is libc malloc, the mutex four are fb_Mutex*, and
    # fb_Assert is reachable with nothing declaring it at all.
    "builtins": '''
sub B( )
    dim as any ptr p = allocate( 16 )
    dim as any ptr q = callocate( 4, 8 )
    dim as any ptr r = reallocate( p, 32 )
    deallocate( q )
    '' A NON-CONSTANT size: with a constant one fbc folds to __builtin_memset and
    '' never declares the libc prototype at all.
    dim as long ca(0 to 3)
    dim as long cn = 16
    clear ca(0), 0, cn
    dim as any ptr m = mutexcreate( )
    mutexlock( m )
    mutexunlock( m )
    mutexdestroy( m )
    fb_Assert( __FILE__, __LINE__, __FUNCTION__, "e" )
end sub
''',
    # CLOSE with no operand closes every open file, which is its own entry point.
    # ERROR raises a runtime error; its return value is the address of the installed
    # handler, so its signature is only visible where fbc emits the call.
    "fileerr": '''
sub F( )
    dim as string ln
    close #1
    close
    line input #1, ln
    error( 5 )
end sub
''',
    "print": '''
sub P( )
    dim as string s
    print s
    print 1
    print
    print "lit"
    print s; 1
    print s, 1
end sub
''',
    # Every scalar type has its OWN print entry point; there is no generic one. A
    # POINTER has no entry of its own and goes through fb_PrintULongint.
    "printtypes": '''
sub Q( )
    dim as byte b : dim as ubyte ub : dim as short sh : dim as ushort ush
    dim as long l : dim as ulong ul : dim as longint li : dim as ulongint uli
    dim as single f : dim as double d : dim as boolean bo
    dim as any ptr pp
    print b : print ub : print sh : print ush
    print l : print ul : print li : print uli
    print f : print d : print bo : print pp
end sub
''',
    "array": '''
sub P( )
    dim as long a( )
    redim a(0 to 3)
    redim preserve a(0 to 7)
    erase a
end sub
''',
    "mem": '''
type U
    as long v
end type
sub P( )
    dim as U ptr p = new U
    delete p
end sub
''',
    "file": '''
sub P( )
    dim as string s
    open "f" for input as #1
    line input #1, s
    '' A WIDE destination and the CONSOLE form are three more entry points.
    dim as wstring * 20 fw
    line input #1, fw
    line input "", s
    line input "", fw
    close #1
    '' The ENCODING clause is a DIFFERENT entry point, fb_FileOpenEncod, taking a
    '' trailing char* rather than an extra integer.
    open "g" for output encoding "utf-16" as #2
    close #2
end sub
''',
    # THE GRAPHICS FAMILY. Coordinates are SINGLES throughout -- fbc passes each one
    # as a separate 'float', never a struct -- and that is the fact a table of
    # integer-looking arguments would get wrong on both targets at once.
    #
    # A graphics mode has to be OPEN for these to lower, hence the screenres. The
    # probe is never run; only the declarations fbc emits are read.
    "gfx": '''
function cb cdecl( byval a as ulong, byval b as ulong, byval p as any ptr ) as ulong
    return a
end function
sub P( )
    dim as any ptr buf
    dim as long c
    dim as string pat
    screenres 320, 200, 8
    '' SCREEN, IMAGECREATE and POINT are keywords rather than declared
    '' procedures, and each has its own entry point.
    screen 13
    dim as any ptr im2 = imagecreate( 8, 8 )
    dim as ulong pc = point( 1, 2 )

    line (1,2)-(3,4), c, BF
    pset (1,2), c
    preset (1,2), c
    circle (1,2), 3, c, 0.5, 1.5, 2.0, F
    paint (1,2), pat, c
    get (1,2)-(3,4), buf
    put (1,2), buf, XOR
    put (1,2), buf, TRANS
    put (1,2), buf, PSET
    put (1,2), buf, PRESET
    put (1,2), buf, AND
    put (1,2), buf, OR
    put (1,2), buf, ALPHA
    put (1,2), buf, ALPHA, 128
    put (1,2), buf, CUSTOM, @cb
    view (0,0)-(1,1), c, c
    window (0,0)-(1,1)
    draw "U10"
    palette 1, 2, 3, 4
    palette get 1, c
    dim as long arr(0 to 3)
    palette using arr
    palette get using arr
    '' Each of the three has a 64-bit twin, chosen by the width it writes into.
    dim as longint arr64(0 to 3), c64
    palette get 1, c64
    palette using arr64
    palette get using arr64
end sub
''',
}


# A declaration, not a call: ends in ');' and has no assignment or body. win32 adds
# '__stdcall' and an asm() alias carrying the DECORATED name -- '_fb_StrAssign@20' --
# which is exactly what tiko-lang has to emit there, so it is captured rather than stripped.
# NOT ONLY 'fb_*'. DELETE lowers to libc's 'free' -- fbc emits 'void free( void* );'
# with no prefix at all -- so the pattern names the extra functions explicitly rather
# than assuming every runtime entry point is prefixed.
# 'atexit' is on that list for the same reason: a STATIC LOCAL object's destructor is
# registered with libc's atexit, not with anything in libfb.
# 'typedef void (*tmp$1)( void* );' -- fbc names a function-pointer parameter type
# rather than spelling it inline.
FNPTR_TYPEDEF = re.compile(r"typedef\s+[\w \*]+\(\s*\*\s*([\w$]+)\s*\)\s*\(")

DECL = re.compile(
    r"([A-Za-z_][\w \*]*?)\s+(?:__stdcall\s+)?"
    r"((?:fb_\w+|free|malloc|calloc|realloc|memset|pow|atan2|atexit))"
    r"\s*\(([^;{]*?)\)"
    r"(?:\s*asm\(\"([^\"]*)\"\))?\s*;")


def one_target(label, fbc, lib, out, work, extra) -> int:
    if not fbc.exists():
        print(f"rtl-truth: {label}: no fbc at {fbc}", file=sys.stderr)
        return 3
    work.mkdir(parents=True, exist_ok=True)

    sigs = {}
    for name, body in PROBES.items():
        src = work / (name + ".bas")
        src.write_text(body.lstrip(), encoding="utf-8")
        cmd = [str(fbc), "-c", "-r", str(src), "-o", str(work / (name + ".o"))] + extra
        if name in MAIN_MODULE:
            cmd += ["-m", name]
        proc = subprocess.run(cmd, capture_output=True, text=True, cwd=str(work))
        c = work / (name + ".c")
        if not c.exists():
            print(f"rtl-truth: {label}: {name}: no C intermediate\n"
                  + (proc.stdout or "") + (proc.stderr or ""), file=sys.stderr)
            continue
        text = c.read_text(encoding="utf-8", errors="replace")
        # A FUNCTION-POINTER PARAMETER IS EMITTED AS A TYPEDEF, not spelled inline:
        # 'typedef void (*tmp$1)( void* ); void* fb_ThreadCreate( tmp$1, void*, int64 )'.
        # Recorded as the pointer it is, or the comparison sees a type name that means
        # nothing to it and reports a disagreement where there is none.
        fnptrs = set(FNPTR_TYPEDEF.findall(text))
        for line in text.splitlines():
            m = DECL.fullmatch(line.strip())
            if m:
                ret, fn, args = m.group(1).strip(), m.group(2), m.group(3).strip()
                # 'fb_ctor__<module>' is the per-translation-unit constructor fbc
                # generates and defines ITSELF. It is not a runtime import, and
                # counting it made the libfb cross-check report five false absences.
                if fn.startswith("fb_ctor__") or ret.startswith("static"):
                    continue
                args = " ".join(args.split())
                for tn in fnptrs:
                    args = re.sub(r"(?<![\w$])" + re.escape(tn) + r"(?![\w$])",
                                  "void*", args)
                # No asm() clause means fbc did not decorate it, which on win32 is the
                # VARIADIC functions -- cdecl, because varargs need caller cleanup. They
                # still take the leading underscore: the archive holds '_fb_ArrayRedimEx'
                # with no '@N'. The C intermediate never spells that, so it is supplied
                # here rather than left looking like an undecorated symbol.
                sym = m.group(4)
                if sym is None:
                    sym = ("_" + fn) if label == "win32" else fn
                sigs.setdefault(fn, (ret, args, sym))

    if not sigs:
        print(f"rtl-truth: {label}: no runtime declarations found", file=sys.stderr)
        return 1

    # Cross-check every name against the runtime archive. A name absent from libfb is
    # a signature tiko-lang would emit and the linker would then reject.
    #
    # EXCEPT THE LIBC ONES. malloc, free, pow and atan2 come from the C runtime, not
    # from libfb, so their absence there is expected and is not a missing symbol.
    # ONE OR SEVERAL ARCHIVES. The graphics entry points are in libfbgfx.a rather than
    # libfb.a, and looking in only the first made every one of them read as ABSENT.
    libs = lib if isinstance(lib, list) else [lib]
    libdata = b"".join(x.read_bytes() for x in libs if x.exists())
    rows, missing = [], []
    for fn in sorted(sigs):
        ret, args, sym = sigs[fn]
        present = sym.encode("ascii") in libdata
        if not present:
            missing.append(fn)
        rows.append(f"{fn}\t{ret}\t{args}\t{'lib' if present else 'ABSENT'}\t{sym}")

    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"rtl-truth: {label}: {len(rows)} runtime functions -> {out.name}")
    if missing:
        print(f"rtl-truth: {label}: {len(missing)} NOT in libfb.a: " + ", ".join(missing))
    return 0


def main() -> int:
    rc = 0
    for label, (fbc, lib, out, work, extra) in TARGETS.items():
        if one_target(label, fbc, lib, out, work, extra) not in (0,):
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
