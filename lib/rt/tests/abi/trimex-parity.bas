'' trimex-parity.bas -- the pattern-taking TRIM family, SPACE, CHR, LEFTSELF and
'' the two legacy wide-case wrappers. Eleven entry points across eleven fbc
'' members.
''
'' NEEDS-GEN-LLVM
''
'' EVERY MULTI-CHARACTER PATTERN IS RUN THROUGH BOTH FAMILIES, and that is the
'' design. `...Ex` treats the pattern as a SUBSTRING and `...Any` as a CHARACTER
'' SET, and with a ONE-CHARACTER pattern the two agree exactly -- so a test suite
'' built only on single-character patterns would not distinguish them at all, and
'' an implementation that mixed them up would pass it completely.
''
'' THE Ex FAMILY HAS TWO SEPARATE ARITHMETICS and both are driven. A pattern of
'' length 1 goes through fb_hStrSkipChar / fb_hStrSkipCharRev and computes the
'' result by POINTER DIFFERENCE; anything longer walks in pattern-sized steps and
'' computes it from an INDEX that is allowed to go negative. The cases below
'' cross that boundary in both directions on purpose.
''
'' THE EMPTY PATTERN AND THE OVER-LONG PATTERN ARE BOTH NO-OPS, by two different
'' routes -- one falls through the `len_pattern != 0` test and the other fails
'' `len >= len_pattern` -- and they are checked separately because a
'' reimplementation can easily get one right and the other wrong.
''
'' fb_LEFTSELF IS CALLED ON A NON-TEMPORARY ONLY. It adjusts a descriptor IN
'' PLACE and then deletes it if it is a temp -- so calling it on a temporary
'' truncates something about to be freed, which is a legitimate thing to do and a
'' useless thing to observe. The cases here use real variables so the truncation
'' is visible afterwards.
''
'' EVERY TEMPORARY THIS FILE CREATES IS DELETED. All six trim entry points
'' consume both their arguments, so the descriptors handed to them are built
'' fresh per call; the RESULTS are temps and are deleted explicitly. A missing
'' delete is a leak that only allocation-count parity would report, and it would
'' report it against whichever file ran next.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pTrimEx   alias "fb_TrimEx"   ( byval s as any ptr, byval p as any ptr ) as any ptr
	declare function pLTrimEx  alias "fb_LTrimEx"  ( byval s as any ptr, byval p as any ptr ) as any ptr
	declare function pRTrimEx  alias "fb_RTrimEx"  ( byval s as any ptr, byval p as any ptr ) as any ptr
	declare function pTrimAny  alias "fb_TrimAny"  ( byval s as any ptr, byval p as any ptr ) as any ptr
	declare function pLTrimAny alias "fb_LTrimAny" ( byval s as any ptr, byval p as any ptr ) as any ptr
	declare function pRTrimAny alias "fb_RTrimAny" ( byval s as any ptr, byval p as any ptr ) as any ptr
	declare function pSPACE    alias "fb_SPACE"    ( byval l as integer ) as any ptr
	declare sub      pLeftSelf alias "fb_LEFTSELF" ( byval s as any ptr, byval n as integer )
	declare function pWUcase   alias "fb_WstrUcase" ( byval s as wstring ptr ) as wstring ptr
	declare function pWLcase   alias "fb_WstrLcase" ( byval s as wstring ptr ) as wstring ptr
	declare function pDelTemp  alias "fb_hStrDelTemp" ( byval s as any ptr ) as long
end extern

extern "c"
	declare function pCHR alias "fb_CHR" ( byval argc as long, ... ) as any ptr
	declare sub crt_free alias "free" ( byval p as any ptr )
end extern

print "-- all eleven resolve"
dim shared as any ptr addrs( 0 to 10 )
addrs(0) = cast( any ptr, @pTrimEx )   : addrs(1) = cast( any ptr, @pLTrimEx )
addrs(2) = cast( any ptr, @pRTrimEx )  : addrs(3) = cast( any ptr, @pTrimAny )
addrs(4) = cast( any ptr, @pLTrimAny ) : addrs(5) = cast( any ptr, @pRTrimAny )
addrs(6) = cast( any ptr, @pSPACE )    : addrs(7) = cast( any ptr, @pLeftSelf )
addrs(8) = cast( any ptr, @pWUcase )   : addrs(9) = cast( any ptr, @pWLcase )
addrs(10) = cast( any ptr, @pCHR )
dim as long n = 0, distinct = 1
for i as integer = 0 to 10
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "  count="; n; " distinct="; distinct

'' ------------------------------------------------------------- the driver

'' A FRESH DESCRIPTOR PER ARGUMENT, because every trim entry point CONSUMES both
'' of its arguments. Reusing one across two calls would be a use-after-free.
''
'' The descriptors are built as ordinary FreeBASIC strings and passed by
'' STRPTR-of-descriptor -- which is what fbc's own codegen does for a byref
'' string argument.
type RESULT_
	as string text
	as long   isnull
end type

'' Renders a result: whether it is the null descriptor, its length, and its
'' bytes. THE NULL DESCRIPTOR AND AN EMPTY STRING ARE DIFFERENT ANSWERS and both
'' occur, so the two are always distinguished in the output.
function show( byval r as any ptr ) as string
	if( r = 0 ) then return "<NULL ptr>"
	dim as zstring ptr d = *cptr( zstring ptr ptr, r )
	if( d = 0 ) then return "<nulldesc>"
	return "[" + *d + "]"
end function

'' Runs one trim, prints it, and deletes the result.
sub tryTrim( byref label as string, byval fn as function( byval as any ptr, byval as any ptr ) as any ptr, _
             byref s as string, byref p as string )
	dim as string a = s, b = p
	dim as any ptr r = fn( @a, @b )
	print "  "; label; " src=["; s; "] pat=["; p; "] -> "; show( r )
	if( r <> 0 ) then pDelTemp( r )
end sub

'' Runs one case through ALL SIX entry points, which is what makes the Ex/Any
'' distinction visible rather than assumed.
sub allSix( byref s as string, byref p as string )
	print "  --- src=["; s; "] pat=["; p; "]"
	dim as string a1 = s, b1 = p : dim as any ptr r1 = pTrimEx( @a1, @b1 )
	dim as string a2 = s, b2 = p : dim as any ptr r2 = pLTrimEx( @a2, @b2 )
	dim as string a3 = s, b3 = p : dim as any ptr r3 = pRTrimEx( @a3, @b3 )
	dim as string a4 = s, b4 = p : dim as any ptr r4 = pTrimAny( @a4, @b4 )
	dim as string a5 = s, b5 = p : dim as any ptr r5 = pLTrimAny( @a5, @b5 )
	dim as string a6 = s, b6 = p : dim as any ptr r6 = pRTrimAny( @a6, @b6 )
	print "      TrimEx="; show( r1 ); " LTrimEx="; show( r2 ); " RTrimEx="; show( r3 )
	print "      TrimAny="; show( r4 ); " LTrimAny="; show( r5 ); " RTrimAny="; show( r6 )
	if( r1 <> 0 ) then pDelTemp( r1 )
	if( r2 <> 0 ) then pDelTemp( r2 )
	if( r3 <> 0 ) then pDelTemp( r3 )
	if( r4 <> 0 ) then pDelTemp( r4 )
	if( r5 <> 0 ) then pDelTemp( r5 )
	if( r6 <> 0 ) then pDelTemp( r6 )
end sub

'' ---------------------------------------------------- single-character patterns

'' WHERE THE TWO FAMILIES AGREE, and where the Ex family takes its pointer-
'' difference path. If these were the only cases, an implementation that
'' confused Ex with Any would pass everything.
print "-- one-character patterns (Ex and Any must AGREE here)"
allSix( "xxhelloxx", "x" )
allSix( "xxhello", "x" )
allSix( "helloxx", "x" )
allSix( "hello", "x" )
allSix( "xxxx", "x" )
allSix( "x", "x" )
allSix( "", "x" )
allSix( "  padded  ", " " )

'' -------------------------------------------- multi-character patterns

'' WHERE THEY MUST DIFFER. "abcabcx" with pattern "abc": Ex strips two whole
'' copies leaving "x"; Any strips a, b and c as a SET, which also reaches x --
'' so the more telling case is one where the set matches characters the
'' substring does not, and both shapes are below.
print "-- multi-character patterns (Ex and Any must DIFFER here)"
allSix( "abcabcxabcabc", "abc" )
allSix( "abcXabc", "abc" )
'' THE DECISIVE PAIR: "cbaXabc" is not a repetition of "abc" at either end, so
'' Ex strips NOTHING and Any strips everything around the X.
allSix( "cbaXabc", "abc" )
allSix( "bacXcab", "abc" )
'' A PARTIAL COPY at the end -- "ab" is not a whole "abc", so Ex stops.
allSix( "abcabXabcab", "abc" )
'' THE PATTERN AS THE WHOLE STRING, and one copy more than fits.
allSix( "abc", "abc" )
allSix( "abcabc", "abc" )
'' THE BOUNDARY where the front pass takes the length below the pattern's, so
'' the back pass's `len >= len_pattern` guard is what stops it.
allSix( "abcab", "abc" )
allSix( "ababc", "abc" )
'' A TWO-CHARACTER PATTERN, which is the smallest that is not the special path.
allSix( "ababXabab", "ab" )
allSix( "aXa", "ab" )

'' ----------------------------------------------------- degenerate patterns

'' THE EMPTY PATTERN falls through `len_pattern <> 0` in every one of the six and
'' must return the string unchanged. NOT the null descriptor.
print "-- the empty pattern (a no-op, not a failure)"
allSix( "hello", "" )
allSix( "", "" )

'' A PATTERN LONGER THAN THE STRING fails `len >= len_pattern` instead, which is
'' a different route to the same answer -- and one of the two is easy to get
'' wrong on its own.
print "-- an over-long pattern (a no-op by a different route)"
allSix( "ab", "abcdef" )
allSix( "abc", "abcd" )

'' EMBEDDED NULs. FreeBASIC strings carry a length, so a NUL is data -- and
'' memchr/memcmp respect that while strchr/strcmp would not. An implementation
'' that reached for the str* family would truncate here and nowhere else.
print "-- embedded NULs"
dim shared as string withnul
withnul = "ab" + chr(0) + "cd"   '' NOT an initialiser: a var-len string
                                  '' cannot have one (error 87).
allSix( withnul, "a" )
allSix( withnul, chr(0) )

'' A NULL src DELETES THE PATTERN AND RETURNS THE NULL DESCRIPTOR -- and it does
'' so BEFORE taking the string lock, which is the one place the locking form of
'' the delete is used. Only the answer is observable here.
print "-- null src"
dim shared as string pat
pat = "x"
print "  TrimEx  (null src) -> "; show( pTrimEx( 0, 0 ) )
print "  TrimAny (null src) -> "; show( pTrimAny( 0, 0 ) )
print "  LTrimEx (null src) -> "; show( pLTrimEx( 0, 0 ) )
print "  RTrimAny(null src) -> "; show( pRTrimAny( 0, 0 ) )

'' A NULL PATTERN with a real src: len_pattern is 0, so this is the empty-pattern
'' case reached by the NULL branch of the test rather than the empty-data one.
dim shared as string realsrc
realsrc = "hello"
dim as string rs1 = realsrc : print "  TrimEx  (null pat) -> "; show( pTrimEx( @rs1, 0 ) )
dim as string rs2 = realsrc : print "  TrimAny (null pat) -> "; show( pTrimAny( @rs2, 0 ) )

'' ---------------------------------------------------------------- SPACE

'' ZERO AND NEGATIVE ARE BOTH THE NULL DESCRIPTOR, so SPACE(0) is not an empty
'' string -- a distinction the output makes explicit.
print "-- fb_SPACE"
for i as integer = -2 to 4
	dim as any ptr r = pSPACE( i )
	print "  SPACE("; i; ") -> "; show( r ); " len=";
	if( (r <> 0) andalso (*cptr( zstring ptr ptr, r ) <> 0) ) then
		print len( *(*cptr( zstring ptr ptr, r )) )
	else
		print "-"
	end if
	if( r <> 0 ) then pDelTemp( r )
next
dim as any ptr sp = pSPACE( 40 )
print "  SPACE(40) length="; len( *(*cptr( zstring ptr ptr, sp )) ); _
      " all spaces="; ( *(*cptr( zstring ptr ptr, sp )) = space( 40 ) )
pDelTemp( sp )

'' ------------------------------------------------------------------ CHR

'' EVERY ARGUMENT IS TRUNCATED TO A BYTE, with no diagnostic -- CHR(&h141) is
'' CHR(&h41). That is why fb_hMakeInkeyStr splits an extended key itself.
print "-- fb_CHR"
sub tryChr( byref label as string, byval r as any ptr )
	print "  "; label; " -> ";
	if( r = 0 ) then
		print "<NULL ptr>"
		exit sub
	end if
	dim as zstring ptr d = *cptr( zstring ptr ptr, r )
	if( d = 0 ) then
		print "<nulldesc>"
		exit sub
	end if
	dim as integer l = *cptr( integer ptr, cptr( ubyte ptr, r ) + sizeof( any ptr ) )
	l = l and (not (cast( integer, 1 ) shl (sizeof( integer ) * 8 - 1)))
	print "len="; l; " bytes:";
	for i as integer = 0 to l - 1
		print " "; cast( long, d[i] );
	next
	print
	pDelTemp( r )
end sub

tryChr( "CHR(1,65)       ", pCHR( 1, 65 ) )
tryChr( "CHR(1,0)        ", pCHR( 1, 0 ) )
tryChr( "CHR(1,255)      ", pCHR( 1, 255 ) )
'' THE TRUNCATION, made visible.
tryChr( "CHR(1,&h141)    ", pCHR( 1, &h141 ) )
tryChr( "CHR(1,256)      ", pCHR( 1, 256 ) )
tryChr( "CHR(2,72,101)   ", pCHR( 2, 72, 101 ) )
tryChr( "CHR(3,65,0,66)  ", pCHR( 3, 65, 0, 66 ) )
tryChr( "CHR(5,...)      ", pCHR( 5, 72, 101, 108, 108, 111 ) )
'' ZERO OR FEWER RETURNS BEFORE THE va_list IS EVEN OPENED.
tryChr( "CHR(0)          ", pCHR( 0 ) )
tryChr( "CHR(-1)         ", pCHR( -1 ) )

'' -------------------------------------------------------------- LEFTSELF

'' IN PLACE, NO REALLOCATION. Called on real variables so the truncation is
'' observable afterwards -- see the file header on why a temporary would prove
'' nothing.
print "-- fb_LEFTSELF"
sub tryLeftSelf( byref s as string, byval n as integer )
	dim as string a = s
	pLeftSelf( @a, n )
	print "  ["; s; "] LEFTSELF "; n; " -> ["; a; "] len="; len( a )
end sub

tryLeftSelf( "abcdefgh", 3 )
tryLeftSelf( "abcdefgh", 0 )
tryLeftSelf( "abcdefgh", 8 )
'' LONGER THAN THE STRING clamps to the length it already had.
tryLeftSelf( "abcdefgh", 20 )
'' NEGATIVE IS IGNORED ENTIRELY -- the `chars >= 0` guard fails and nothing is
'' written, so the string survives intact.
tryLeftSelf( "abcdefgh", -1 )
tryLeftSelf( "", 3 )
tryLeftSelf( "a", 1 )

'' A NULL descriptor returns immediately, before the lock.
pLeftSelf( 0, 3 )
print "  null src returned without crashing=-1"

'' ------------------------------------------------- the legacy wide wrappers

'' ONE LINE EACH, forwarding to the `2` forms with a null mode -- so what is
'' checked is that they forward at all and that the result matches the direct
'' call's shape.
print "-- fb_WstrUcase / fb_WstrLcase"
sub tryWCase( byref label as string, byval w as wstring ptr )
	dim as wstring ptr u = pWUcase( w )
	dim as wstring ptr l = pWLcase( w )
	print "  "; label; " ucase=[";
	if( u <> 0 ) then print *u; else print "<null>";
	print "] lcase=[";
	if( l <> 0 ) then print *l; else print "<null>";
	print "]"
	'' THE `2` FORMS RETURN A MALLOC'D BUFFER, not a descriptor -- so free, not
	'' fb_hStrDelTemp. Getting that wrong would corrupt the temp list rather
	'' than leak.
	if( u <> 0 ) then crt_free( u )
	if( l <> 0 ) then crt_free( l )
end sub

tryWCase( "mixed  ", @wstr( "Hello World" ) )
tryWCase( "upper  ", @wstr( "ABC" ) )
tryWCase( "lower  ", @wstr( "abc" ) )
tryWCase( "digits ", @wstr( "123!@#" ) )
tryWCase( "empty  ", @wstr( "" ) )

print "done"
