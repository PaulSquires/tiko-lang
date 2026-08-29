'' uconv-parity.bas -- ustr_prim.o and ustr_conv.o.
''
'' NEEDS-GEN-LLVM -- fb_UStrDelete and fb_StrDelete are reserved names in fbc's
'' rtlLookupTB, so aliasing them under -gen gcc produces conflicting C
'' declarations.
''
'' TWO THINGS THIS FILE IS FOR.
''
'' 1. THE PRIMITIVES' NULL AND EMPTY CONTRACTS. hUStrCompare treats NULL as
''    "orders below a non-empty operand and equal to an empty one" rather than
''    as an empty string; hUStrStr says an empty pattern matches at 0, which is
''    not "not found"; hUStrCopy terminates and hUStrCopyN does not. None of
''    these is visible in ordinary use and all of them are load-bearing.
''
'' 2. THAT THE BYTE WORLD IS UTF-8 AND MALFORMED INPUT BECOMES U+FFFD.
''    STRING <-> WSTRING goes through the C locale; STRING <-> USTRING does not,
''    on any target. So the round trip of a byte string that is not valid UTF-8
''    is LOSSY, deliberately, and the exact replacement pattern is contract.
#include once "fbc-int/string.bi"

extern "c"
    declare function pP_Len alias "fb_hUStrLen" ( byval s as ushort ptr ) as integer
    declare function pP_Cmp alias "fb_hUStrCompare" _
        ( byval a as ushort ptr, byval al as integer, byval b as ushort ptr, byval bl as integer ) as long
    declare sub pP_Copy  alias "fb_hUStrCopy"  ( byval d as ushort ptr, byval s as ushort ptr, byval n as integer )
    declare sub pP_CopyN alias "fb_hUStrCopyN" ( byval d as ushort ptr, byval s as ushort ptr, byval n as integer )
    declare sub pP_Move  alias "fb_hUStrMove"  ( byval d as ushort ptr, byval s as ushort ptr, byval n as integer )
    declare sub pP_Fill  alias "fb_hUStrFill"  ( byval d as ushort ptr, byval c as ushort, byval n as integer )
    declare function pP_Chr alias "fb_hUStrChr" ( byval s as ushort ptr, byval n as integer, byval c as ushort ) as integer
    declare function pP_Str alias "fb_hUStrStr" _
        ( byval h as ushort ptr, byval hl as integer, byval nd as ushort ptr, byval nl as integer ) as integer
    declare function pP_Skip alias "fb_hUStrSkipChar" _
        ( byval s as ushort ptr, byval n as integer, byval c as ushort ) as ushort ptr
    declare function pP_SkipRev alias "fb_hUStrSkipCharRev" _
        ( byval s as ushort ptr, byval n as integer, byval c as ushort ) as ushort ptr
end extern

'' ---- the primitives, on a buffer built by hand so no allocator is involved.
dim shared as ushort buf(0 to 31), b2(0 to 31), out_(0 to 31)
sub setu( byval p as ushort ptr, byref s as string )
    for i as integer = 0 to len(s) - 1
        p[i] = asc( mid( s, i + 1, 1 ) )
    next
    p[len(s)] = 0
end sub
function showu( byval p as ushort ptr, byval n as integer ) as string
    dim as string o = ""
    for i as integer = 0 to n - 1
        o += right( "000" + hex$( p[i] ), 4 ) + " "
    next
    return o
end function

setu( @buf(0), "hello world" )
print "Len            = "; pP_Len( @buf(0) )
print "Len( NULL )    = "; pP_Len( 0 )
print "Chr 'o'        = "; pP_Chr( @buf(0), 11, asc("o") )
print "Chr 'z'        = "; pP_Chr( @buf(0), 11, asc("z") )
print "Chr( NULL )    = "; pP_Chr( 0, 5, asc("o") )

setu( @b2(0), "world" )
print "Str found      = "; pP_Str( @buf(0), 11, @b2(0), 5 )
print "Str empty pat  = "; pP_Str( @buf(0), 11, @b2(0), 0 )
print "Str too long   = "; pP_Str( @buf(0), 3, @b2(0), 5 )
print "Str NULL hay   = "; pP_Str( 0, 11, @b2(0), 5 )
print "Str NULL needle= "; pP_Str( @buf(0), 11, 0, 5 )

'' Compare: NULL is NOT an empty string, and length breaks a common prefix.
setu( @b2(0), "hello" )
print "Cmp eq         = "; pP_Cmp( @buf(0), 5, @b2(0), 5 )
print "Cmp prefix     = "; pP_Cmp( @buf(0), 11, @b2(0), 5 )
print "Cmp NULL/NULL  = "; pP_Cmp( 0, 0, 0, 0 )
print "Cmp NULL/empty = "; pP_Cmp( 0, 0, @b2(0), 0 )
print "Cmp NULL/text  = "; pP_Cmp( 0, 0, @b2(0), 5 )
print "Cmp text/NULL  = "; pP_Cmp( @buf(0), 5, 0, 0 )
print "Cmp empty/NULL = "; pP_Cmp( @buf(0), 0, 0, 0 )
'' Surrogates sort BELOW U+E000..U+FFFF -- code-unit order, not codepoint order.
b2(0) = &hD83D : b2(1) = 0
out_(0) = &hE000 : out_(1) = 0
print "Cmp astral/E000= "; pP_Cmp( @b2(0), 1, @out_(0), 1 )

'' Copy terminates, CopyN does not -- the buffer is poisoned first so the
'' difference is one visible unit rather than an accident of what was there.
setu( @b2(0), "abc" )
for i as integer = 0 to 7 : out_(i) = &hEEEE : next
pP_Copy( @out_(0), @b2(0), 3 )  : print "Copy   = "; showu( @out_(0), 5 )
for i as integer = 0 to 7 : out_(i) = &hEEEE : next
pP_CopyN( @out_(0), @b2(0), 3 ) : print "CopyN  = "; showu( @out_(0), 5 )
for i as integer = 0 to 7 : out_(i) = &hEEEE : next
pP_Copy( @out_(0), 0, 3 )       : print "Copy N = "; showu( @out_(0), 5 )

'' Fill: the memset fast path needs both halves of the unit equal.
for i as integer = 0 to 7 : out_(i) = &hEEEE : next
pP_Fill( @out_(0), &h2020, 4 ) : print "Fill even = "; showu( @out_(0), 6 )
for i as integer = 0 to 7 : out_(i) = &hEEEE : next
pP_Fill( @out_(0), &h1234, 4 ) : print "Fill odd  = "; showu( @out_(0), 6 )
pP_Fill( 0, &h1234, 4 )

'' Move: overlapping, both directions.
setu( @out_(0), "abcdefgh" )
pP_Move( @out_(0), @out_(2), 6 ) : print "Move left  = "; showu( @out_(0), 8 )
setu( @out_(0), "abcdefgh" )
pP_Move( @out_(2), @out_(0), 6 ) : print "Move right = "; showu( @out_(0), 8 )

'' Skip: USTRING * N is NUL-padded, so trimming strips NULs -- the wstring rule.
setu( @out_(0), "..ab.." )
print "Skip '.'    = "; pP_Skip( @out_(0), 6, asc(".") ) - @out_(0)
print "SkipRev '.' = "; pP_SkipRev( @out_(0), 6, asc(".") ) - @out_(0)
print "Skip all    = "; pP_Skip( @out_(0), 2, asc(".") ) - @out_(0)
print "Skip NULL   = "; iif( pP_Skip( 0, 6, asc(".") ) = 0, 1, 0 )

'' ---- ustr_conv: the four argument forms, both directions, and U+FFFD.
extern "rtlib"
    declare function pC_ToU alias "fb_StrToUStr" ( byval s as any ptr, byval sz as integer ) as any ptr
    declare function pC_ToA alias "fb_UStrToStr" ( byval s as any ptr, byval sz as integer ) as any ptr
    declare function pC_AU  alias "fb_UStrConcatAU" _
        ( byval d as any ptr, byval a as any ptr, byval asz as integer, byval b as any ptr, byval bsz as integer ) as any ptr
    declare function pC_UA  alias "fb_UStrConcatUA" _
        ( byval d as any ptr, byval a as any ptr, byval asz as integer, byval b as any ptr, byval bsz as integer ) as any ptr
    declare function pC_FromA alias "fb_UStrAssignFromA" _
        ( byval d as any ptr, byval dsz as integer, byval s as any ptr, byval ssz as integer, _
          byval fr as long, byval ii as long ) as any ptr
    declare function pC_ToAasg alias "fb_UStrAssignToA" _
        ( byval d as any ptr, byval dsz as integer, byval s as any ptr, byval ssz as integer, _
          byval fr as long, byval ii as long ) as any ptr
    declare function pU_DelTmp alias "fb_hUStrDelTemp" ( byval s as any ptr ) as long
    declare function pS_DelTmp alias "fb_hStrDelTemp" ( byval s as any ptr ) as long
end extern

type UDESC field = 1
    as ushort ptr data_
    as integer  len_
    as integer  size_
end type
#define ULN(d) cint( (d)->len_ and cast( integer, &h7fffffffffffffffull ) )
#define VARLEN -1
#define FIXED(n) ((n) or cast( integer, &h8000000000000000ull ))

'' A narrow source built by hand, so the four FB_STRSETUP forms can each be
'' asked for by name instead of hoping the compiler picks them.
dim as string src = "A" + chr(226,130,172) + "B"        '' A U+20AC B
dim as zstring * 8 fixz = "hi"

function udump( byval p as any ptr ) as string
    dim as UDESC ptr d = cptr( UDESC ptr, p )
    if( d = 0 ) then return "<null>"
    return "len=" + str( ULN(d) ) + " size=" + str( d->size_ ) + " [" + showu( d->data_, ULN(d) ) + "]"
end function

print "-- StrToUStr --"
print "varlen   "; udump( pC_ToU( cptr( any ptr, @src ), VARLEN ) )
print "fixed*8  "; udump( pC_ToU( cptr( any ptr, @fixz ), FIXED(4) ) )
print "zptr     "; udump( pC_ToU( cptr( any ptr, @fixz ), 0 ) )
print "NULL     "; udump( pC_ToU( 0, VARLEN ) )

'' MALFORMED UTF-8 -> U+FFFD, and the round trip is therefore LOSSY. This is the
'' documented cost of the encoding policy, asserted rather than described.
dim as string bad = chr(255) + "a" + chr(192) + chr(128)
dim as any ptr u = pC_ToU( cptr( any ptr, @bad ), VARLEN )
print "malformed "; udump( u )
dim as any ptr back = pC_ToA( u, VARLEN )
dim as FBC.FBSTRING ptr bs = cptr( FBC.FBSTRING ptr, back )
print "round trip len = "; cint( bs->len and cast( integer, &h7fffffffffffffffull ) )
pS_DelTmp( back )

print "-- concat --"
dim as string a1 = "ab"
dim as any ptr uu = pC_ToU( cptr( any ptr, @a1 ), VARLEN )
'' The ustring operand is passed as a FIXED buffer so the concat does not
'' consume it -- the temp-release paths are exercised separately below.
print "AU  "; udump( pC_AU( 0, cptr( any ptr, @src ), VARLEN, cptr( any ptr, cptr( UDESC ptr, uu )->data_ ), FIXED(2) ) )
print "UA  "; udump( pC_UA( 0, cptr( any ptr, cptr( UDESC ptr, uu )->data_ ), FIXED(2), cptr( any ptr, @src ), VARLEN ) )
pU_DelTmp( uu )

print "-- assign --"
dim as UDESC d1
d1.data_ = 0 : d1.len_ = 0 : d1.size_ = 0
pC_FromA( @d1, VARLEN, cptr( any ptr, @src ), VARLEN, 0, 1 )
print "FromA init   "; udump( @d1 )
pC_FromA( @d1, VARLEN, cptr( any ptr, @fixz ), FIXED(2), 0, 0 )
print "FromA reasgn "; udump( @d1 )
dim as string e = ""
pC_FromA( @d1, VARLEN, cptr( any ptr, @e ), VARLEN, 0, 0 )
print "FromA empty  "; udump( @d1 )
pC_FromA( 0, VARLEN, cptr( any ptr, @src ), VARLEN, 0, 0 )

dim as string outs = ""
pC_FromA( @d1, VARLEN, cptr( any ptr, @src ), VARLEN, 0, 0 )
pC_ToAasg( cptr( any ptr, @outs ), VARLEN, @d1, VARLEN, 0, 0 )
print "ToA          len="; len( outs ); " ["; hex$( asc( outs, 1 ) ); " "; hex$( asc( outs, 2 ) ); "]"
pC_ToAasg( 0, VARLEN, @d1, VARLEN, 0, 0 )
