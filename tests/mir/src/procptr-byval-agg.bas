'' STRUCTS BY VALUE THROUGH A PROCEDURE POINTER, and a 16-byte struct RETURNED through one.
''
'' A call through a pointer carried a signature only when it RETURNED an aggregate, so the
'' ABI pass skipped the ARGUMENTS of every other one: a struct passed by value went out as
'' a raw '[8 x i8]' .. '[32 x i8]' where the procedure takes an i64, two registers, or a
'' pointer to a copy. And on SysV a 16-byte result through a pointer was never stored --
'' the emitter's two-register path excluded indirect calls. Measured, the same program:
''
''                  direct          ptr               ret16
''     fbc          8 16 24 321     8 16 24 321       77 4096
''     tiko msvc    8 16 24 321     garbage, SEGV     --
''     tiko linux   8 16 24 321     8 0 0 3           2048 7602176
''
'' -- and after the fix all three print fbc's lines. Every libclang entry point tiko's C
'' importer calls is this shape: a CXCursor or CXType by value, a scalar back, and
'' clang_getCString's CXString is the 16-byte return. goldenrun executes this file.
type S8
    as longint a
end type
type S16
    as any ptr p
    as ulong f
end type
type S24
    as long k
    as any ptr d1, d2
end type
type S32
    as long k
    as long x
    as any ptr d(0 to 2)
end type

function T8 cdecl ( byval s as S8 ) as long
    return clng( s.a )
end function
function T16 cdecl ( byval s as S16 ) as long
    return clng( s.f )
end function
function T24 cdecl ( byval s as S24 ) as long
    return s.k + clng( cast( integer, s.d2 ) )
end function
function T32 cdecl ( byval a as S32, byval b as S32, byval z as long ) as long
    return a.k * 100 + b.k * 10 + z
end function
function Ret16 cdecl ( byval n as long ) as S16
    dim as S16 r
    r.p = cast( any ptr, 4096 )
    r.f = n
    return r
end function

dim as function cdecl ( byval s as S8 ) as long p8 = @T8
dim as function cdecl ( byval s as S16 ) as long p16 = @T16
dim as function cdecl ( byval s as S24 ) as long p24 = @T24
dim as function cdecl ( byval a as S32, byval b as S32, byval z as long ) as long p32 = @T32
dim as function cdecl ( byval n as long ) as S16 pr16 = @Ret16

dim as S8 a8 : a8.a = 8
dim as S16 a16 : a16.f = 16
dim as S24 a24 : a24.k = 20 : a24.d2 = cast( any ptr, 4 )
dim as S32 x32, y32 : x32.k = 3 : y32.k = 2
print "direct:", T8( a8 ), T16( a16 ), T24( a24 ), T32( x32, y32, 1 )
print "ptr:   ", p8( a8 ), p16( a16 ), p24( a24 ), p32( x32, y32, 1 )
dim as S16 r = pr16( 77 )
print "ret16: ", r.f, cast( integer, r.p )
