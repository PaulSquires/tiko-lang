'' wsearch-parity.bas -- INSTRW / INSTRREVW / the Ex and Any trims / UCASEW.
''
'' NEEDS-GEN-LLVM -- several of these are reserved names in fbc's rtlLookupTB.
''
'' THE CASE THIS FILE EXISTS FOR IS RTrimEx ON AN ALL-PATTERN SOURCE. fbc's tail
'' loop decrements its index with no lower bound and reads memory IN FRONT of the
'' buffer; tiko-rt reproduces the ANSWER without performing the read, by treating
'' a negative index as a non-match. The two agree here, which is what the
'' divergence note in src/strw/trimex.tiko claims and what this pins.
''
'' Also pinned: INSTRREVW has THREE clamps, not two. A start past the END of the
'' source becomes 0 -- search nothing -- while a start merely past the last
'' position the pattern still FITS is pulled back to it. Out-of-range and
'' nearly-out-of-range therefore behave completely differently, and one clamp for
'' both looks right until a start argument goes over.

extern "rtlib"
    declare function pInstr    alias "fb_WstrInstr"       ( byval st as integer, byval s as wstring ptr, byval p as wstring ptr ) as integer
    declare function pInstrAny alias "fb_WstrInstrAny"    ( byval st as integer, byval s as wstring ptr, byval p as wstring ptr ) as integer
    declare function pIRev     alias "fb_WstrInstrRev"    ( byval s as wstring ptr, byval p as wstring ptr, byval st as integer ) as integer
    declare function pIRevAny  alias "fb_WstrInstrRevAny" ( byval s as wstring ptr, byval p as wstring ptr, byval st as integer ) as integer
    declare function pTrimAny  alias "fb_WstrTrimAny"  ( byval s as wstring ptr, byval p as wstring ptr ) as wstring ptr
    declare function pLTrimAny alias "fb_WstrLTrimAny" ( byval s as wstring ptr, byval p as wstring ptr ) as wstring ptr
    declare function pRTrimAny alias "fb_WstrRTrimAny" ( byval s as wstring ptr, byval p as wstring ptr ) as wstring ptr
    declare function pTrimEx   alias "fb_WstrTrimEx"   ( byval s as wstring ptr, byval p as wstring ptr ) as wstring ptr
    declare function pLTrimEx  alias "fb_WstrLTrimEx"  ( byval s as wstring ptr, byval p as wstring ptr ) as wstring ptr
    declare function pRTrimEx  alias "fb_WstrRTrimEx"  ( byval s as wstring ptr, byval p as wstring ptr ) as wstring ptr
    declare function pUcase    alias "fb_WstrUcase2"   ( byval s as wstring ptr, byval m as long ) as wstring ptr
    declare function pLcase    alias "fb_WstrLcase2"   ( byval s as wstring ptr, byval m as long ) as wstring ptr
    declare sub      pDel      alias "fb_WstrDelete"   ( byval s as wstring ptr )
end extern

'' Raw-byte reader at a stride of sizeof(wstring): indexing a wstring ptr and
'' casting yields 0, silently, on every target.
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
'' PRINTS EXACTLY THE STRING, NOT A FIXED WINDOW. The first version dumped 12
'' characters regardless of length, which reads uninitialised heap past a buffer
'' allocated for far fewer -- and that memory legitimately differs between the
'' two runtimes, so the differential failed on three lines that were both
'' CORRECT. Third occurrence in this project of a fixture reading past the thing
'' it is measuring.
sub show( byref tag as string, byval p as wstring ptr )
    dim as integer n = wlen_( p )
    print tag; " len="; n; "  "; wshow( p, iif( n > 0, n, 0 ) )
    pDel( p )
end sub

dim as wstring * 32 src = "abcabcX", pat = "bc", one = "b", setp = "cb", emp = ""

'' ---- INSTRW. The position is absolute even when the search starts late.
print "Instr 1        = "; pInstr( 1, @src, @pat )
print "Instr 3        = "; pInstr( 3, @src, @pat )
print "Instr 6        = "; pInstr( 6, @src, @pat )
print "Instr 0        = "; pInstr( 0, @src, @pat )
print "Instr 99       = "; pInstr( 99, @src, @pat )
print "Instr empty pat= "; pInstr( 1, @src, @emp )
print "Instr NULL src = "; pInstr( 1, 0, @pat )
print "Instr NULL pat = "; pInstr( 1, @src, 0 )

'' ---- INSTRANYW. A miss and a hit at the very last position both come back
'' from wcscspn as the remaining length, so the >size_src test is what tells
'' them apart. Both are asked here.
print "InstrAny 1     = "; pInstrAny( 1, @src, @setp )
print "InstrAny 4     = "; pInstrAny( 4, @src, @setp )
dim as wstring * 32 tailhit = "aaab"
print "InstrAny at end= "; pInstrAny( 1, @tailhit, @one )
dim as wstring * 32 nohit = "aaaa"
print "InstrAny miss  = "; pInstrAny( 1, @nohit, @one )
print "InstrAny 0     = "; pInstrAny( 0, @src, @setp )
print "InstrAny 99    = "; pInstrAny( 99, @src, @setp )

'' ---- INSTRREVW and its THREE clamps.
print "IRev -1        = "; pIRev( @src, @pat, -1 )
print "IRev 99        = "; pIRev( @src, @pat, 99 )
print "IRev 6         = "; pIRev( @src, @pat, 6 )
print "IRev 5         = "; pIRev( @src, @pat, 5 )
print "IRev 2         = "; pIRev( @src, @pat, 2 )
print "IRev 0         = "; pIRev( @src, @pat, 0 )
print "IRev pat>src   = "; pIRev( @one, @src, -1 )
print "IRev NULL      = "; pIRev( 0, @pat, -1 )

'' The Any form clamps differently: over-large start means "nothing", not
'' "pull back".
print "IRevAny -1     = "; pIRevAny( @src, @setp, -1 )
print "IRevAny 99     = "; pIRevAny( @src, @setp, 99 )
print "IRevAny 7      = "; pIRevAny( @src, @setp, 7 )
print "IRevAny 3      = "; pIRevAny( @src, @setp, 3 )
print "IRevAny 0      = "; pIRevAny( @src, @setp, 0 )
print "IRevAny miss   = "; pIRevAny( @nohit, @one, -1 )

'' ---- the Any trims: a SET of characters.
dim as wstring * 32 padded = "xyabcyx", xyset = "xy"
show( "TrimAny  xy   ", pTrimAny( @padded, @xyset ) )
show( "LTrimAny xy   ", pLTrimAny( @padded, @xyset ) )
show( "RTrimAny xy   ", pRTrimAny( @padded, @xyset ) )
show( "TrimAny  empty", pTrimAny( @padded, @emp ) )
dim as wstring * 32 allset = "xyxy"
show( "TrimAny  all  ", pTrimAny( @allset, @xyset ) )
show( "TrimAny  NULL ", pTrimAny( 0, @xyset ) )

'' ---- the Ex trims: a whole PATTERN, repeatedly.
''
'' BOTH SIDES OF THE len_pattern = 1 BOUNDARY are exercised, because that is
'' where fbc's arithmetic changes -- one character takes the SkipChar fast path
'' and anything longer takes the repeated compare.
dim as wstring * 32 abx = "ababXabab", ab = "ab"
show( "TrimEx  ab    ", pTrimEx( @abx, @ab ) )
show( "LTrimEx ab    ", pLTrimEx( @abx, @ab ) )
show( "RTrimEx ab    ", pRTrimEx( @abx, @ab ) )
dim as wstring * 32 aaXaa = "aaXaa", a1 = "a"
show( "TrimEx  a     ", pTrimEx( @aaXaa, @a1 ) )
show( "LTrimEx a     ", pLTrimEx( @aaXaa, @a1 ) )
show( "RTrimEx a     ", pRTrimEx( @aaXaa, @a1 ) )
show( "TrimEx  empty ", pTrimEx( @abx, @emp ) )
dim as wstring * 32 shortsrc = "ab", longpat = "abcd"
show( "TrimEx  pat>src", pTrimEx( @shortsrc, @longpat ) )

'' ---- THE OUT-OF-BOUNDS CASE. A source made ENTIRELY of the pattern drives
'' fbc's index negative. tiko-rt reaches the same answer without the read.
dim as wstring * 32 abab = "abab", aaaa = "aaaa", aa = "aa"
show( "RTrimEx all-pat", pRTrimEx( @abab, @ab ) )
show( "RTrimEx aaaa/aa", pRTrimEx( @aaaa, @aa ) )
show( "TrimEx  all-pat", pTrimEx( @abab, @ab ) )
show( "LTrimEx all-pat", pLTrimEx( @abab, @ab ) )
'' The one-character path on an all-pattern source, for contrast: it has no
'' index to run off and returns NULL by the ordinary length test.
show( "RTrimEx aaaa/a ", pRTrimEx( @aaaa, @a1 ) )

'' ---- UCASEW / LCASEW. Mode 1 is ASCII-only; anything else follows the locale.
dim as wstring * 32 mixed = "aBcZ"
show( "Ucase mode1   ", pUcase( @mixed, 1 ) )
show( "Ucase mode0   ", pUcase( @mixed, 0 ) )
show( "Lcase mode1   ", pLcase( @mixed, 1 ) )
show( "Lcase mode0   ", pLcase( @mixed, 0 ) )
'' A non-ASCII letter separates the two modes: mode 1 must leave it alone.
dim as wstring * 32 acc = "aeiou"
acc[0] = &h00E9 : acc[1] = &h00FF : acc[2] = 0
show( "Ucase acc m1  ", pUcase( @acc, 1 ) )
show( "Ucase acc m0  ", pUcase( @acc, 0 ) )
'' UCASEW("") ALLOCATES -- fbc allocates before testing the length, so this is a
'' real empty wstring and not NULL. The one place in this family where empty and
'' absent are not the same value.
show( "Ucase empty   ", pUcase( @emp, 0 ) )
show( "Ucase NULL    ", pUcase( 0, 0 ) )
