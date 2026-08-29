'' uslice-parity.bas -- ustr_trim.o and ustr_slice.o, eighteen entry points.
''
'' THE HEADLINE CASE IS chr(0). Plain wide TRIM strips spaces AND NULs from
'' BOTH ends; the narrow TRIM strips NULs from the RIGHT only, because STRING * N
'' is space-padded and a NUL in the text is data, while USTRING * N is
'' zero-filled. That asymmetry has already cost this project a Linux gate run in
'' the other direction, so it is asked about at each end separately rather than
'' assumed to match the family next door.
''
'' THE SHARED EMPTY DESCRIPTOR is checked by POINTER IDENTITY, not by length. An
'' empty result must be __fb_ctx.unull_desc and must allocate nothing; a
'' zero-length temporary would print len=0 exactly the same way and leak a pool
'' slot on every call.
#include once "fbc-int/string.bi"
#include once "uarg.bi"

extern "rtlib"
    declare function pT_Trim   alias "fb_UStrTrim"    ( byval s as any ptr, byval sz as integer ) as any ptr
    declare function pT_LTrim  alias "fb_UStrLTrim"   ( byval s as any ptr, byval sz as integer ) as any ptr
    declare function pT_RTrim  alias "fb_UStrRTrim"   ( byval s as any ptr, byval sz as integer ) as any ptr
    declare function pT_TrimEx alias "fb_UStrTrimEx"  ( byval s as any ptr, byval sz as integer, byval p as any ptr, byval psz as integer ) as any ptr
    declare function pT_LTrimEx alias "fb_UStrLTrimEx" ( byval s as any ptr, byval sz as integer, byval p as any ptr, byval psz as integer ) as any ptr
    declare function pT_RTrimEx alias "fb_UStrRTrimEx" ( byval s as any ptr, byval sz as integer, byval p as any ptr, byval psz as integer ) as any ptr
    declare function pT_TrimAny alias "fb_UStrTrimAny" ( byval s as any ptr, byval sz as integer, byval p as any ptr, byval psz as integer ) as any ptr
    declare function pT_LTrimAny alias "fb_UStrLTrimAny" ( byval s as any ptr, byval sz as integer, byval p as any ptr, byval psz as integer ) as any ptr
    declare function pT_RTrimAny alias "fb_UStrRTrimAny" ( byval s as any ptr, byval sz as integer, byval p as any ptr, byval psz as integer ) as any ptr
    declare function pS_Left   alias "fb_UStrLeft"   ( byval s as any ptr, byval sz as integer, byval n as integer ) as any ptr
    declare function pS_Right  alias "fb_UStrRight"  ( byval s as any ptr, byval sz as integer, byval n as integer ) as any ptr
    declare function pS_Mid    alias "fb_UStrMid"    ( byval s as any ptr, byval sz as integer, byval st as integer, byval n as integer ) as any ptr
    declare sub      pS_AsgMid alias "fb_UStrAssignMid" ( byval d as any ptr, byval dsz as integer, byval st as integer, byval n as integer, byval s as any ptr, byval ssz as integer )
    declare function pS_Space  alias "fb_UStrSpace"  ( byval n as integer ) as any ptr
    declare function pS_Fill1  alias "fb_UStrFill1"  ( byval n as integer, byval u as long ) as any ptr
    declare function pS_Fill2  alias "fb_UStrFill2"  ( byval n as integer, byval s as any ptr, byval sz as integer ) as any ptr
    declare function pS_LeftD  alias "fb_UStrLeftD"  ( byval s as any ptr, byval n as integer ) as any ptr
    declare function pS_RightD alias "fb_UStrRightD" ( byval s as any ptr, byval n as integer ) as any ptr
    declare function pU_DelTmp alias "fb_hUStrDelTemp" ( byval s as any ptr ) as long
end extern

type UDESC field = 1
    as ushort ptr data_
    as integer  len_
    as integer  size_
end type
#define ULN(d) cint( (d)->len_ and cast( integer, &h7fffffffffffffffull ) )
#define VARLEN -1
#define FIXED(n) ((n) or cast( integer, &h8000000000000000ull ))

'' A FIXED argument is a POINTER TO RAW UNITS, not a descriptor -- so these
'' cases pass @ub(0) and the VARLEN ones pass @ud. Getting that backwards is how
'' the first run of this file went: BOTH runtimes read the descriptor's own bytes
'' as text and printed garbage, differing only in the pointer values inside it.
'' The differential caught it on sight, which is the argument for running it on
'' every new test rather than eyeballing the first output.
''
'' A ustring built by hand -- the only way to place a chr(0) or a lone surrogate
'' inside one without asking the compiler to encode it.
dim shared as ushort ub(0 to 63), ub2(0 to 63), ub3(0 to 63)
dim shared as UDESC ud, ud2, ud3
sub mku( byval p as ushort ptr, byval d as UDESC ptr, byref s as string )
    for i as integer = 0 to len(s) - 1
        p[i] = asc( mid( s, i + 1, 1 ) )
    next
    p[len(s)] = 0
    d->data_ = p : d->len_ = len(s) : d->size_ = len(s)
end sub
function ushow( byval p as any ptr ) as string
    dim as UDESC ptr d = cptr( UDESC ptr, p )
    if( d = 0 ) then return "<null>"
    dim as string o = "len=" + str( ULN(d) ) + " ["
    for i as integer = 0 to ULN(d) - 1
        o += right( "000" + hex$( d->data_[i] ), 4 ) + " "
    next
    return o + "]"
end function

'' ---- the shared empty descriptor, by identity.
dim as any ptr e1 = pS_Space( 0 )
dim as any ptr e2 = pS_Left( 0, VARLEN, 5 )
print "empty is shared        = "; iif( e1 = e2, 1, 0 ); "  len="; ULN( cptr( UDESC ptr, e1 ) )

'' ---- TRIM and chr(0), at each end separately.
mku( @ub(0), @ud, "  ab  " )
print "Trim  spaces           "; ushow( pT_Trim( UFIX( ub, 6 ) ) )
print "LTrim spaces           "; ushow( pT_LTrim( UFIX( ub, 6 ) ) )
print "RTrim spaces           "; ushow( pT_RTrim( UFIX( ub, 6 ) ) )

'' NUL on the LEFT only, then on the RIGHT only. A fixed-size argument is used
'' so the embedded NULs survive the argument decode.
ub(0) = 0 : ub(1) = 0 : ub(2) = asc("a") : ub(3) = asc("b") : ub(4) = 0
ud.data_ = @ub(0) : ud.len_ = 4 : ud.size_ = 4
print "Trim  NUL left         "; ushow( pT_Trim( UVAR( ud ) ) )
ub(0) = asc("a") : ub(1) = asc("b") : ub(2) = 0 : ub(3) = 0 : ub(4) = 0
ud.data_ = @ub(0) : ud.len_ = 4 : ud.size_ = 4
print "Trim  NUL right        "; ushow( pT_Trim( UVAR( ud ) ) )
'' Mixed: a NUL and a space at each end.
ub(0) = 0 : ub(1) = 32 : ub(2) = asc("a") : ub(3) = 32 : ub(4) = 0 : ub(5) = 0
ud.data_ = @ub(0) : ud.len_ = 5 : ud.size_ = 5
print "Trim  NUL+space both   "; ushow( pT_Trim( UVAR( ud ) ) )

'' All-strippable, and empty input.
mku( @ub(0), @ud, "    " )
print "Trim  all spaces       "; ushow( pT_Trim( UFIX( ub, 4 ) ) )
mku( @ub(0), @ud, "" )
print "Trim  empty            "; ushow( pT_Trim( UVAR( ud ) ) )
print "Trim  NULL             "; ushow( pT_Trim( 0, VARLEN ) )

'' ---- Any: a set of units.
mku( @ub(0), @ud, "xyabyx" )
mku( @ub2(0), @ud2, "xy" )
print "TrimAny  set xy        "; ushow( pT_TrimAny( UFIX( ub, 6 ), UFIX( ub2, 2 ) ) )
print "LTrimAny set xy        "; ushow( pT_LTrimAny( UFIX( ub, 6 ), UFIX( ub2, 2 ) ) )
print "RTrimAny set xy        "; ushow( pT_RTrimAny( UFIX( ub, 6 ), UFIX( ub2, 2 ) ) )
mku( @ub2(0), @ud2, "" )
print "TrimAny  empty set     "; ushow( pT_TrimAny( UFIX( ub, 6 ), UVAR( ud2 ) ) )

'' ---- Ex: a whole pattern, stripped REPEATEDLY.
mku( @ub(0), @ud, "abababXabab" )
mku( @ub2(0), @ud2, "ab" )
print "TrimEx  ab             "; ushow( pT_TrimEx( UFIX( ub, 11 ), UFIX( ub2, 2 ) ) )
print "LTrimEx ab             "; ushow( pT_LTrimEx( UFIX( ub, 11 ), UFIX( ub2, 2 ) ) )
print "RTrimEx ab             "; ushow( pT_RTrimEx( UFIX( ub, 11 ), UFIX( ub2, 2 ) ) )
'' An empty pattern must strip nothing rather than loop.
mku( @ub2(0), @ud2, "" )
print "TrimEx  empty pat      "; ushow( pT_TrimEx( UFIX( ub, 11 ), UVAR( ud2 ) ) )
'' A pattern longer than the source.
mku( @ub(0), @ud, "ab" )
mku( @ub2(0), @ud2, "abcd" )
print "TrimEx  pat > src      "; ushow( pT_TrimEx( UFIX( ub, 2 ), UFIX( ub2, 4 ) ) )
'' A source made ENTIRELY of the pattern.
mku( @ub(0), @ud, "abab" )
mku( @ub2(0), @ud2, "ab" )
print "TrimEx  all pattern    "; ushow( pT_TrimEx( UFIX( ub, 4 ), UFIX( ub2, 2 ) ) )

'' ---- LEFT / RIGHT, including the clamps and the negative counts.
mku( @ub(0), @ud, "abcdef" )
print "Left  3                "; ushow( pS_Left( UFIX( ub, 6 ), 3 ) )
print "Left  99               "; ushow( pS_Left( UFIX( ub, 6 ), 99 ) )
print "Left  0                "; ushow( pS_Left( UFIX( ub, 6 ), 0 ) )
print "Left  -1               "; ushow( pS_Left( UFIX( ub, 6 ), -1 ) )
print "Right 3                "; ushow( pS_Right( UFIX( ub, 6 ), 3 ) )
print "Right 99               "; ushow( pS_Right( UFIX( ub, 6 ), 99 ) )
print "Right 0                "; ushow( pS_Right( UFIX( ub, 6 ), 0 ) )
print "Right -1               "; ushow( pS_Right( UFIX( ub, 6 ), -1 ) )
print "LeftD 2                "; ushow( pS_LeftD( @ud, 2 ) )
print "RightD 2               "; ushow( pS_RightD( @ud, 2 ) )

'' ---- MID. start is 1-based; a NEGATIVE count means "to the end" and a count
'' of exactly ZERO yields empty -- three different meanings for three values.
print "Mid 2,3                "; ushow( pS_Mid( UFIX( ub, 6 ), 2, 3 ) )
print "Mid 2,-1               "; ushow( pS_Mid( UFIX( ub, 6 ), 2, -1 ) )
print "Mid 2,0                "; ushow( pS_Mid( UFIX( ub, 6 ), 2, 0 ) )
print "Mid 2,99               "; ushow( pS_Mid( UFIX( ub, 6 ), 2, 99 ) )
print "Mid 0,2                "; ushow( pS_Mid( UFIX( ub, 6 ), 0, 2 ) )
print "Mid 7,2                "; ushow( pS_Mid( UFIX( ub, 6 ), 7, 2 ) )
print "Mid 6,2                "; ushow( pS_Mid( UFIX( ub, 6 ), 6, 2 ) )

'' MID CAN SPLIT A SURROGATE PAIR, and that is documented behaviour rather than
'' a defect -- it is what WSTRING does today and what unit-based slicing means.
ub2(0) = asc("a") : ub2(1) = &hD83D : ub2(2) = &hDE00 : ub2(3) = asc("b") : ub2(4) = 0
ud2.data_ = @ub2(0) : ud2.len_ = 4 : ud2.size_ = 4
print "Mid splits a pair 2,1  "; ushow( pS_Mid( UVAR( ud2 ), 2, 1 ) )
print "Left splits a pair 2   "; ushow( pS_Left( UVAR( ud2 ), 2 ) )

'' ---- MID statement: overwrites in place, never resizes.
mku( @ub3(0), @ud3, "abcdef" )
mku( @ub2(0), @ud2, "XYZ" )
pS_AsgMid( UVAR( ud3 ), 2, -1, UFIX( ub2, 3 ) )
print "AsgMid 2,-1            "; ushow( @ud3 )
mku( @ub3(0), @ud3, "abcdef" )
pS_AsgMid( UVAR( ud3 ), 2, 2, UFIX( ub2, 3 ) )
print "AsgMid 2,2             "; ushow( @ud3 )
mku( @ub3(0), @ud3, "abcdef" )
pS_AsgMid( UVAR( ud3 ), 5, 99, UFIX( ub2, 3 ) )
print "AsgMid 5,99 clamps     "; ushow( @ud3 )
mku( @ub3(0), @ud3, "abcdef" )
pS_AsgMid( UVAR( ud3 ), 0, 2, UFIX( ub2, 3 ) )
print "AsgMid 0,2 ignored     "; ushow( @ud3 )
pS_AsgMid( UVAR( ud3 ), 9, 2, UFIX( ub2, 3 ) )
print "AsgMid 9,2 ignored     "; ushow( @ud3 )
pS_AsgMid( 0, VARLEN, 1, 2, UFIX( ub2, 3 ) )

'' ---- SPACE and STRING.
print "Space 4                "; ushow( pS_Space( 4 ) )
print "Space 0                "; ushow( pS_Space( 0 ) )
print "Space -1               "; ushow( pS_Space( -1 ) )
print "Fill1 3,'z'            "; ushow( pS_Fill1( 3, asc("z") ) )
'' The odd-byte unit: fb_hUStrFill cannot use memset unless both halves match.
print "Fill1 3,&h1234         "; ushow( pS_Fill1( 3, &h1234 ) )
print "Fill1 3,&h2020         "; ushow( pS_Fill1( 3, &h2020 ) )
mku( @ub2(0), @ud2, "qrs" )
print "Fill2 3,'qrs'          "; ushow( pS_Fill2( 3, UFIX( ub2, 3 ) ) )
mku( @ub2(0), @ud2, "" )
print "Fill2 3,''             "; ushow( pS_Fill2( 3, UVAR( ud2 ) ) )
'' STRING( n, astral ) repeats the HIGH SURROGATE -- not the character.
ub2(0) = &hD83D : ub2(1) = &hDE00 : ub2(2) = 0
ud2.data_ = @ub2(0) : ud2.len_ = 2 : ud2.size_ = 2
print "Fill2 3,astral         "; ushow( pS_Fill2( 3, UVAR( ud2 ) ) )
