'' wconv-parity.bas -- STRING <-> WSTRING, eight entry points.
''
'' NEEDS-GEN-LLVM -- fb_StrDelete and others here are reserved names.
''
'' THE HEADLINE ASSERTION IS THAT `size` AND `len` DISAGREE after a
'' wstring-to-string assignment. There is no way to ask wcstombs how long its
'' output will be without converting, so fbc allocates 4 BYTES PER CHARACTER and
'' then sets `len` from what was actually written, leaving the buffer
'' over-allocated. Both numbers are published through fbc-int/string.bi, so the
'' guess is CONTRACT and a tighter one would be a visible divergence rather than
'' an improvement.
''
'' AND THE TWO MIXED CONCATENATIONS ARE NOT MIRROR IMAGES. WstrConcatWA copies
'' the wide half first at a length it computed; WstrConcatAW converts the narrow
'' half first and uses the CONVERSION'S RETURN VALUE to decide where the wide
'' half goes, then moves str2_len + 1 characters so the terminator travels with
'' it. One trusts a length it worked out, the other trusts a length it was told.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function pToStr   alias "fb_WstrToStr"   ( byval s as wstring ptr ) as FBC.FBSTRING ptr
    declare function pFromA   alias "fb_WstrAssignFromA" ( byval d as wstring ptr, byval dc as integer, byval s as any ptr, byval sz as integer ) as wstring ptr
    declare function pToAEx   alias "fb_WstrAssignToAEx" ( byval d as any ptr, byval dc as integer, byval s as wstring ptr, byval fr as long, byval ii as long ) as any ptr
    declare function pToA     alias "fb_WstrAssignToA" ( byval d as any ptr, byval dc as integer, byval s as wstring ptr, byval fr as long ) as any ptr
    declare function pToAInit alias "fb_WstrAssignToA_Init" ( byval d as any ptr, byval dc as integer, byval s as wstring ptr, byval fr as long ) as any ptr
    declare function pCatWA   alias "fb_WstrConcatWA" ( byval a as wstring ptr, byval b as any ptr, byval bsz as integer ) as wstring ptr
    declare function pCatAW   alias "fb_WstrConcatAW" ( byval a as any ptr, byval asz as integer, byval b as wstring ptr ) as wstring ptr
    declare sub      pWDel    alias "fb_WstrDelete"  ( byval s as wstring ptr )
    declare function pSDelTmp alias "fb_hStrDelTemp" ( byval s as any ptr ) as long
end extern

extern "c"
    declare function pConvToA alias "fb_wstr_ConvToA" ( byval d as zstring ptr, byval dc as integer, byval s as wstring ptr ) as integer
end extern

#define VARLEN -1
#define FIXED(n) ((n) or cast( integer, &h8000000000000000ull ))
#define SLN(d) cint( (d)->len and cast( integer, &h7fffffffffffffffull ) )

function wshow( byval p as wstring ptr, byval n as integer ) as string
    if( p = 0 ) then return "<NULL>"
    dim as ubyte ptr b = cptr( ubyte ptr, p )
    dim as string o = ""
    for i as integer = 0 to n - 1
        dim as ulongint v = 0
        for k as integer = 0 to sizeof( wstring ) - 1
            v or= cast( ulongint, b[i * sizeof( wstring ) + k] ) shl (k * 8)
        next
        o += right( "00000000" + hex$( v ), 4 ) + " "
    next
    return o
end function
function wlen_( byval p as wstring ptr ) as integer
    if( p = 0 ) then return -1
    dim as ubyte ptr b = cptr( ubyte ptr, p )
    dim as integer n = 0
    do
        dim as ulongint v = 0
        for k as integer = 0 to sizeof( wstring ) - 1
            v or= cast( ulongint, b[n * sizeof( wstring ) + k] ) shl (k * 8)
        next
        if( v = 0 ) then return n
        n += 1
    loop while( n < 64 )
    return n
end function
'' Prints only as many characters as the string actually has -- reading a fixed
'' window past the allocation shows uninitialised heap, which legitimately
'' differs between the two runtimes and fails the diff on CORRECT output.
sub wshowp( byref tag as string, byval p as wstring ptr )
    dim as integer n = wlen_( p )
    print tag; " len="; n; "  "; wshow( p, iif( n > 0, n, 0 ) )
    pWDel( p )
end sub
function zshow( byval p as ubyte ptr, byval n as integer ) as string
    dim as string o = ""
    for i as integer = 0 to n - 1
        o += right( "0" + hex$( p[i] ), 2 ) + " "
    next
    return o
end function

dim as wstring * 32 w1 = "hello", we = ""
dim as string s1 = "world"
dim as zstring * 8 z1 = "zs"

'' ---- WstrToStr, and the temporary it returns.
dim as FBC.FBSTRING ptr r = pToStr( @w1 )
print "ToStr        len="; SLN(r); " ["; zshow( cptr( ubyte ptr, r->data ), SLN(r) ); "]"
pSDelTmp( r )
print "ToStr NULL   len="; SLN( pToStr( 0 ) )
print "ToStr empty  len="; SLN( pToStr( @we ) )

'' ---- fb_wstr_ConvToA. dst_chars is the room EXCLUDING the terminator.
dim as zstring * 16 zbuf
print "ConvToA 8    ret="; pConvToA( @zbuf, 8, @w1 ); " ["; zshow( cptr( ubyte ptr, @zbuf ), 6 ); "]"
'' THE TRUNCATION QUIRK: when the text exactly fills the buffer wcstombs writes
'' no terminator, so fbc writes one by hand -- cutting off the last character --
'' and then reports dst_chars - 1 rather than dst_chars.
print "ConvToA 5    ret="; pConvToA( @zbuf, 5, @w1 ); " ["; zshow( cptr( ubyte ptr, @zbuf ), 6 ); "]"
print "ConvToA 3    ret="; pConvToA( @zbuf, 3, @w1 ); " ["; zshow( cptr( ubyte ptr, @zbuf ), 5 ); "]"
print "ConvToA NULL ret="; pConvToA( @zbuf, 8, 0 ); " ["; zshow( cptr( ubyte ptr, @zbuf ), 2 ); "]"

'' ---- STRING -> WSTRING, over the narrow argument forms.
dim as wstring * 32 wd
wd = "ZZZZZZZZ" : pFromA( @wd, 8, cptr( any ptr, @s1 ), VARLEN )
print "FromA varlen "; wshow( @wd, 6 ); " len="; wlen_( @wd )
wd = "ZZZZZZZZ" : pFromA( @wd, 8, cptr( any ptr, @z1 ), FIXED(2) )
print "FromA fixed  "; wshow( @wd, 3 ); " len="; wlen_( @wd )
wd = "ZZZZZZZZ" : pFromA( @wd, 8, cptr( any ptr, @z1 ), 0 )
print "FromA zptr   "; wshow( @wd, 3 ); " len="; wlen_( @wd )
'' A capacity of 0 means "no declared size": the source length is used.
wd = "ZZZZZZZZ" : pFromA( @wd, 0, cptr( any ptr, @s1 ), VARLEN )
print "FromA cap0   "; wshow( @wd, 6 ); " len="; wlen_( @wd )
'' And a capacity smaller than the source truncates.
wd = "ZZZZZZZZ" : pFromA( @wd, 3, cptr( any ptr, @s1 ), VARLEN )
print "FromA cap3   "; wshow( @wd, 4 ); " len="; wlen_( @wd )
pFromA( 0, 8, cptr( any ptr, @s1 ), VARLEN )

'' ---- WSTRING -> STRING assignment, over all four destination forms.
''
'' THE VAR-LEN CASE IS THE ONE THAT MATTERS: `size` keeps the 4x guess while
'' `len` is set from what was actually written, so the two disagree. Printing
'' both is the whole point -- a tighter allocation would be invisible in the
'' text and obvious here.
dim as string sd
sd = "" : pToAEx( cptr( any ptr, @sd ), VARLEN, @w1, 0, 1 )
print "ToA varlen init  len="; len( sd ); " ["; sd; "]"
dim as FBC.FBSTRING ptr sdp = cptr( FBC.FBSTRING ptr, @sd )
print "  size="; sdp->size; "  len="; SLN(sdp); "  size is the 4x guess"
pToAEx( cptr( any ptr, @sd ), VARLEN, @w1, 0, 0 )
print "ToA varlen reasgn len="; len( sd ); " size="; sdp->size
pToAEx( cptr( any ptr, @sd ), VARLEN, @we, 0, 0 )
print "ToA varlen empty len="; len( sd ); " data0="; iif( sdp->data = 0, 1, 0 )
pToAEx( cptr( any ptr, @sd ), VARLEN, 0, 0, 0 )
print "ToA varlen NULL  len="; len( sd )

'' STRING * N is SPACE-padded -- the narrow convention, and the opposite of what
'' USTRING * N does with its remainder.
dim as zstring * 16 fbuf
for i as integer = 0 to 15 : cptr( ubyte ptr, @fbuf )[i] = &hEE : next
pToAEx( cptr( any ptr, @fbuf ), FIXED(8), @w1, 0, 0 )
print "ToA STRING*8     ["; zshow( cptr( ubyte ptr, @fbuf ), 9 ); "]"
for i as integer = 0 to 15 : cptr( ubyte ptr, @fbuf )[i] = &hEE : next
pToAEx( cptr( any ptr, @fbuf ), FIXED(3), @w1, 0, 0 )
print "ToA STRING*3     ["; zshow( cptr( ubyte ptr, @fbuf ), 5 ); "]"

'' ZSTRING * N: NUL-terminated, and fill_rem zeroes the tail BEHIND the
'' terminator rather than over it.
for i as integer = 0 to 15 : cptr( ubyte ptr, @fbuf )[i] = &hEE : next
pToAEx( cptr( any ptr, @fbuf ), 9, @w1, 1, 0 )
print "ToA ZSTRING*9 fr ["; zshow( cptr( ubyte ptr, @fbuf ), 10 ); "]"
for i as integer = 0 to 15 : cptr( ubyte ptr, @fbuf )[i] = &hEE : next
pToAEx( cptr( any ptr, @fbuf ), 9, @w1, 0, 0 )
print "ToA ZSTRING*9    ["; zshow( cptr( ubyte ptr, @fbuf ), 10 ); "]"
for i as integer = 0 to 15 : cptr( ubyte ptr, @fbuf )[i] = &hEE : next
pToAEx( cptr( any ptr, @fbuf ), 9, @we, 1, 0 )
print "ToA ZSTRING*9 '' ["; zshow( cptr( ubyte ptr, @fbuf ), 10 ); "]"
'' A bare pointer assumes it is large enough and uses the 4x guess.
for i as integer = 0 to 15 : cptr( ubyte ptr, @fbuf )[i] = &hEE : next
pToAEx( cptr( any ptr, @fbuf ), 0, @w1, 0, 0 )
print "ToA zptr         ["; zshow( cptr( ubyte ptr, @fbuf ), 7 ); "]"
pToAEx( 0, VARLEN, @w1, 0, 0 )

'' The two thin callers differ only in is_init.
dim as string sd2 = "xx"
pToA( cptr( any ptr, @sd2 ), VARLEN, @w1, 0 )
print "ToA              ["; sd2; "]"
dim as string sd3
pToAInit( cptr( any ptr, @sd3 ), VARLEN, @w1, 0 )
print "ToA_Init         ["; sd3; "]"

'' ---- the two mixed concatenations.
wshowp( "CatWA        ", pCatWA( @w1, cptr( any ptr, @s1 ), VARLEN ) )
wshowp( "CatAW        ", pCatAW( cptr( any ptr, @s1 ), VARLEN, @w1 ) )
wshowp( "CatWA fixed  ", pCatWA( @w1, cptr( any ptr, @z1 ), FIXED(2) ) )
wshowp( "CatAW fixed  ", pCatAW( cptr( any ptr, @z1 ), FIXED(2), @w1 ) )
wshowp( "CatWA w NULL ", pCatWA( 0, cptr( any ptr, @s1 ), VARLEN ) )
wshowp( "CatAW w NULL ", pCatAW( cptr( any ptr, @s1 ), VARLEN, 0 ) )
dim as string se = ""
wshowp( "CatWA both '' ", pCatWA( @we, cptr( any ptr, @se ), VARLEN ) )
wshowp( "CatAW both '' ", pCatAW( cptr( any ptr, @se ), VARLEN, @we ) )
