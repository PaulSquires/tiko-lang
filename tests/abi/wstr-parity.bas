'' wstr-parity.bas -- the WSTRING core and slice families, sixteen entry points.
''
'' NEEDS-GEN-LLVM -- fb_WstrDelete and several others are reserved names in
'' fbc's rtlLookupTB.
''
'' THE FAMILY-WIDE RULE THIS FILE ASSERTS FIRST: on WSTRING, "empty" and
'' "absent" are THE SAME VALUE. Every function here returns NULL rather than a
'' zero-length wstring, because there is no descriptor to hold a length of
'' nought. That is the exact opposite of the ustring family, where an empty
'' result is the shared empty DESCRIPTOR and is never NULL -- so the two cannot
'' share an implementation however similar the signatures look.
''
'' AND TWO QUIRKS ARE PINNED DELIBERATELY, both reproduced rather than fixed:
''   fb_WstrConcatAssign appends NOTHING through a bare pointer, and
''   fb_WstrAssignMid refuses to overwrite the LAST character of the field.
'' A "corrected" tiko-rt would disagree with fbc on both, which is the one thing
'' the contract forbids.

extern "rtlib"
    declare function pAlloc  alias "fb_WstrAlloc"  ( byval n as integer ) as wstring ptr
    declare sub      pDel    alias "fb_WstrDelete" ( byval s as wstring ptr )
    declare function pAssign alias "fb_WstrAssign" ( byval d as wstring ptr, byval dc as integer, byval s as wstring ptr ) as wstring ptr
    declare function pConcat alias "fb_WstrConcat" ( byval a as wstring ptr, byval b as wstring ptr ) as wstring ptr
    declare function pCatAsg alias "fb_WstrConcatAssign" ( byval d as wstring ptr, byval dc as integer, byval s as wstring ptr ) as wstring ptr
    declare function pLeft   alias "fb_WstrLeft"   ( byval s as wstring ptr, byval n as integer ) as wstring ptr
    declare function pRight  alias "fb_WstrRight"  ( byval s as wstring ptr, byval n as integer ) as wstring ptr
    declare function pMid    alias "fb_WstrMid"    ( byval s as wstring ptr, byval st as integer, byval n as integer ) as wstring ptr
    declare sub      pAsgMid alias "fb_WstrAssignMid" ( byval d as wstring ptr, byval dl as integer, byval st as integer, byval n as integer, byval s as wstring ptr )
    declare function pSpace  alias "fb_WstrSpace"  ( byval n as integer ) as wstring ptr
    declare function pFill1  alias "fb_WstrFill1"  ( byval n as integer, byval c as long ) as wstring ptr
    declare function pFill2  alias "fb_WstrFill2"  ( byval n as integer, byval s as wstring ptr ) as wstring ptr
    declare function pAsc    alias "fb_WstrAsc"    ( byval s as wstring ptr, byval p as integer ) as ulong
    declare sub      pLset   alias "fb_WstrLset"   ( byval d as wstring ptr, byval s as wstring ptr )
    declare sub      pRset   alias "fb_WstrRset"   ( byval d as wstring ptr, byval s as wstring ptr )
end extern

extern "c"
    declare function pChr cdecl alias "fb_WstrChr" ( byval args as long, ... ) as wstring ptr
end extern

'' Read the buffer as RAW BYTES at a stride of sizeof(wstring). Indexing a
'' wstring ptr and casting does NOT yield the character -- that mistake made an
'' earlier differential print 0000 for every case and PASS, because both
'' runtimes printed the same zeros.
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

'' Walks to the NUL, so it shows what the runtime thinks the length is rather
'' than what the test assumed.
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

dim as wstring * 32 w1 = "abcdef", we = "", wx = "XY"

'' ---- alloc / delete
dim as wstring ptr a1 = pAlloc( 4 )
print "Alloc 4 non-null = "; iif( a1 <> 0, 1, 0 )
pDel( a1 )
print "Alloc 0          = "; iif( pAlloc( 0 ) = 0, 1, 0 )
print "Alloc -1         = "; iif( pAlloc( -1 ) = 0, 1, 0 )
pDel( 0 )

'' ---- assign. dst_chars is the capacity INCLUDING the terminator, and an empty
'' source CLEARS the destination rather than leaving it alone.
dim as wstring * 32 d
d = "ZZZZZZZZ" : pAssign( @d, 8, @w1 )  : print "Assign cap8      "; wshow( @d, 8 ); " len="; wlen_( @d )
d = "ZZZZZZZZ" : pAssign( @d, 4, @w1 )  : print "Assign cap4      "; wshow( @d, 5 ); " len="; wlen_( @d )
d = "ZZZZZZZZ" : pAssign( @d, 0, @w1 )  : print "Assign cap0      "; wshow( @d, 7 ); " len="; wlen_( @d )
d = "ZZZZZZZZ" : pAssign( @d, 8, @we )  : print "Assign empty src "; wshow( @d, 2 ); " len="; wlen_( @d )
d = "ZZZZZZZZ" : pAssign( @d, 8, 0 )    : print "Assign NULL src  "; wshow( @d, 2 ); " len="; wlen_( @d )
print "Assign NULL dst  = "; iif( pAssign( 0, 8, @w1 ) = 0, 1, 0 )

'' ---- concat. TWO EMPTY OPERANDS YIELD NULL, not an empty wstring.
dim as wstring ptr c1 = pConcat( @w1, @wx )
print "Concat           "; wshow( c1, 8 ); " len="; wlen_( c1 ) : pDel( c1 )
c1 = pConcat( @w1, 0 )
print "Concat b NULL    "; wshow( c1, 6 ); " len="; wlen_( c1 ) : pDel( c1 )
c1 = pConcat( 0, @wx )
print "Concat a NULL    "; wshow( c1, 2 ); " len="; wlen_( c1 ) : pDel( c1 )
print "Concat both ''   = "; iif( pConcat( @we, @we ) = 0, 1, 0 )
print "Concat both NULL = "; iif( pConcat( 0, 0 ) = 0, 1, 0 )

'' ---- concat-assign, and the two quirks.
d = "ab" : pCatAsg( @d, 8, @wx )
print "CatAsg cap8      "; wshow( @d, 5 ); " len="; wlen_( @d )
'' QUIRK 1: no declared capacity -> appends NOTHING. Every other family assumes
'' a bare pointer is big enough and appends.
d = "ab" : pCatAsg( @d, 0, @wx )
print "CatAsg cap0      "; wshow( @d, 5 ); " len="; wlen_( @d )
'' QUIRK 2: an already-full destination gives a NEGATIVE room count, which the
'' copy treats as "copy nothing" and terminates in place.
d = "abcdefg" : pCatAsg( @d, 4, @wx )
print "CatAsg full      "; wshow( @d, 8 ); " len="; wlen_( @d )
d = "abc" : pCatAsg( @d, 6, @wx )
print "CatAsg partial   "; wshow( @d, 7 ); " len="; wlen_( @d )
d = "ab" : pCatAsg( @d, 8, @we )
print "CatAsg empty src "; wshow( @d, 3 ); " len="; wlen_( @d )
pCatAsg( 0, 8, @wx )
d = "ab" : pCatAsg( @d, 8, 0 )
print "CatAsg NULL src  "; wshow( @d, 3 ); " len="; wlen_( @d )

'' ---- LEFT / RIGHT / MID. Every out-of-range case is NULL, not empty.
dim as wstring ptr r
r = pLeft( @w1, 3 )   : print "Left 3           "; wshow( r, 3 ); " len="; wlen_( r ) : pDel( r )
r = pLeft( @w1, 99 )  : print "Left 99          "; wshow( r, 6 ); " len="; wlen_( r ) : pDel( r )
print "Left 0           = "; iif( pLeft( @w1, 0 ) = 0, 1, 0 )
print "Left -1          = "; iif( pLeft( @w1, -1 ) = 0, 1, 0 )
print "Left NULL        = "; iif( pLeft( 0, 3 ) = 0, 1, 0 )
print "Left of ''       = "; iif( pLeft( @we, 3 ) = 0, 1, 0 )
r = pRight( @w1, 3 )  : print "Right 3          "; wshow( r, 3 ); " len="; wlen_( r ) : pDel( r )
r = pRight( @w1, 99 ) : print "Right 99         "; wshow( r, 6 ); " len="; wlen_( r ) : pDel( r )
print "Right 0          = "; iif( pRight( @w1, 0 ) = 0, 1, 0 )
r = pMid( @w1, 2, 3 ) : print "Mid 2,3          "; wshow( r, 3 ); " len="; wlen_( r ) : pDel( r )
r = pMid( @w1, 2, -1 ): print "Mid 2,-1         "; wshow( r, 5 ); " len="; wlen_( r ) : pDel( r )
r = pMid( @w1, 2, 99 ): print "Mid 2,99         "; wshow( r, 5 ); " len="; wlen_( r ) : pDel( r )
print "Mid 2,0          = "; iif( pMid( @w1, 2, 0 ) = 0, 1, 0 )
print "Mid 0,2          = "; iif( pMid( @w1, 0, 2 ) = 0, 1, 0 )
print "Mid 9,2          = "; iif( pMid( @w1, 9, 2 ) = 0, 1, 0 )
r = pMid( @w1, 6, 2 ) : print "Mid 6,2          "; wshow( r, 1 ); " len="; wlen_( r ) : pDel( r )

'' ---- MID statement. THE -1 IN THE CLAMP is the quirk: when the write would
'' reach the end of the field, the LAST character is left untouched. The ustring
'' and string versions have no such rule.
d = "abcdef" : pAsgMid( @d, 6, 2, -1, @wx )
print "AsgMid 2,-1      "; wshow( @d, 6 ); " len="; wlen_( @d )
d = "abcdef" : pAsgMid( @d, 6, 5, 99, @wx )
print "AsgMid 5,99 clamp"; wshow( @d, 6 ); " len="; wlen_( @d )
'' THE CASE THAT ACTUALLY TRIGGERS THE -1. start 6 with 2 characters would run
'' one past the field, so the length is cut to (6-5)-1 = 0 and NOTHING is
'' written -- the last character survives untouched. The 5,99 case above does
'' NOT reach this branch (it fits exactly), and a test for a quirk that never
'' fires is the same mistake as a test that cannot come out two ways.
d = "abcdef" : pAsgMid( @d, 6, 6, 2, @wx )
print "AsgMid 6,2 the -1"; wshow( @d, 6 ); " len="; wlen_( @d )
d = "abcdef" : pAsgMid( @d, 6, 5, 2, @wx )
print "AsgMid 5,2 fits  "; wshow( @d, 6 ); " len="; wlen_( @d )
d = "abcdef" : pAsgMid( @d, 6, 2, 1, @wx )
print "AsgMid 2,1       "; wshow( @d, 6 ); " len="; wlen_( @d )
d = "abcdef" : pAsgMid( @d, 0, 2, -1, @wx )
print "AsgMid dl=0      "; wshow( @d, 6 ); " len="; wlen_( @d )
d = "abcdef" : pAsgMid( @d, 6, 0, 2, @wx )
print "AsgMid 0,2 skip  "; wshow( @d, 6 ); " len="; wlen_( @d )
d = "abcdef" : pAsgMid( @d, 6, 9, 2, @wx )
print "AsgMid 9,2 skip  "; wshow( @d, 6 ); " len="; wlen_( @d )
pAsgMid( 0, 6, 1, 2, @wx )
d = "abcdef" : pAsgMid( @d, 6, 1, 2, @we )
print "AsgMid empty src "; wshow( @d, 6 ); " len="; wlen_( @d )

'' ---- SPACE / STRING / CHR / ASC
r = pSpace( 3 )  : print "Space 3          "; wshow( r, 3 ); " len="; wlen_( r ) : pDel( r )
print "Space 0          = "; iif( pSpace( 0 ) = 0, 1, 0 )
r = pFill1( 3, &h20AC ) : print "Fill1 3,20AC     "; wshow( r, 3 ); " len="; wlen_( r ) : pDel( r )
print "Fill1 0          = "; iif( pFill1( 0, 65 ) = 0, 1, 0 )
r = pFill2( 3, @w1 ) : print "Fill2 3,'abcdef' "; wshow( r, 3 ); " len="; wlen_( r ) : pDel( r )
print "Fill2 3,''       = "; iif( pFill2( 3, @we ) = 0, 1, 0 )
print "Fill2 3,NULL     = "; iif( pFill2( 3, 0 ) = 0, 1, 0 )

'' CHRW is VARIADIC, the first such entry point here. Arguments arrive promoted
'' to int regardless of the wide character's width.
r = pChr( 3, 65, &h20AC, 90 ) : print "Chr 3            "; wshow( r, 3 ); " len="; wlen_( r ) : pDel( r )
r = pChr( 1, 66 ) : print "Chr 1            "; wshow( r, 1 ); " len="; wlen_( r ) : pDel( r )
print "Chr 0            = "; iif( pChr( 0 ) = 0, 1, 0 )

print "Asc 1            = "; hex$( pAsc( @w1, 1 ) )
print "Asc 6            = "; hex$( pAsc( @w1, 6 ) )
print "Asc 0            = "; pAsc( @w1, 0 )
print "Asc 9            = "; pAsc( @w1, 9 )
print "Asc NULL         = "; pAsc( 0, 1 )
print "Asc of ''        = "; pAsc( @we, 1 )

'' ---- LSET / RSET pad with SPACES, and the field width is the destination's
'' CURRENT length.
d = "......" : pLset( @d, @wx ) : print "Lset 6 <- XY     "; wshow( @d, 6 ); " len="; wlen_( @d )
d = "......" : pRset( @d, @wx ) : print "Rset 6 <- XY     "; wshow( @d, 6 ); " len="; wlen_( @d )
d = "..."    : pLset( @d, @w1 ) : print "Lset 3 <- 6chr   "; wshow( @d, 3 ); " len="; wlen_( @d )
d = "..."    : pRset( @d, @w1 ) : print "Rset 3 <- 6chr   "; wshow( @d, 3 ); " len="; wlen_( @d )
d = "..."    : pLset( @d, @we ) : print "Lset 3 <- ''     "; wshow( @d, 3 ); " len="; wlen_( @d )
d = ""       : pLset( @d, @wx ) : print "Lset '' <- XY    "; wshow( @d, 1 ); " len="; wlen_( @d )
pLset( 0, @wx ) : pRset( 0, @wx )
d = "..."    : pLset( @d, 0 ) : print "Lset 3 <- NULL   "; wshow( @d, 3 ); " len="; wlen_( @d )
