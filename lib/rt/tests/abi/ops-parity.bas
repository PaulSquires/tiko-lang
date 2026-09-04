'' ops-parity.bas -- str_ops.o, all 38 entry points.
''
'' The pattern arguments are USTRING descriptors, which is the whole reason this
'' member is awkward to test: a byte-family pattern arrives as UTF-16 and is
'' encoded back to bytes inside each call.
''
'' Every case here targets a rule the C states in a comment, because those are
'' the rules a rewrite gets wrong. The empty-argument rules especially are NOT
'' uniform -- Find misses on an empty pattern, Verify succeeds on an empty set,
'' StartsWith is true for an empty prefix, Extract's miss returns everything and
'' Remain's returns nothing.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function p_Tally      alias "fb_StrTally"      ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as integer
    declare function p_TallyChars alias "fb_StrTallyChars" ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as integer
    declare function p_InstrChars alias "fb_StrInstrChars" ( byval st as integer, byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as integer
    declare function p_VerifySet  alias "fb_StrVerifySet"  ( byval st as integer, byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as integer
    declare function p_SpanOf     alias "fb_StrSpanOf"     ( byval st as integer, byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as integer
    declare function p_StartsWith alias "fb_StrStartsWith" ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as long
    declare function p_EndsWith   alias "fb_StrEndsWith"   ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as long
    declare function p_Contains   alias "fb_StrContains"   ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as long
    declare function p_IsNumeric  alias "fb_StrIsNumeric"  ( byval s as FBC.FBSTRING ptr ) as long
    declare function p_IsBlank    alias "fb_StrIsBlank"    ( byval s as FBC.FBSTRING ptr ) as long
    declare function p_Extract    alias "fb_StrExtract"    ( byval st as integer, byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_ExtractChars alias "fb_StrExtractChars" ( byval st as integer, byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_Remain     alias "fb_StrRemain"     ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval st as integer, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_RemainChars alias "fb_StrRemainChars" ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval st as integer, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_Between    alias "fb_StrBetween"    ( byval s as FBC.FBSTRING ptr, byval a as FBC.FBUSTRING ptr, byval b as FBC.FBUSTRING ptr, byval st as integer, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_ClipLeft   alias "fb_StrClipLeft"   ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
    declare function p_ClipRight  alias "fb_StrClipRight"  ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
    declare function p_DeleteAt   alias "fb_StrDeleteAt"   ( byval s as FBC.FBSTRING ptr, byval st as integer, byval n as integer ) as FBC.FBSTRING ptr
    declare function p_InsertAt   alias "fb_StrInsertAt"   ( byval s as FBC.FBSTRING ptr, byval i as FBC.FBUSTRING ptr, byval p as integer ) as FBC.FBSTRING ptr
    declare function p_Replace    alias "fb_StrReplace"    ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval r as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_Remove     alias "fb_StrRemove"     ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_RemoveChars alias "fb_StrRemoveChars" ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_RetainChars alias "fb_StrRetainChars" ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_ReplaceChars alias "fb_StrReplaceChars" ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBUSTRING ptr, byval w as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_Reverse    alias "fb_StrReverse"    ( byval s as FBC.FBSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_Repeat     alias "fb_StrRepeat"     ( byval n as integer, byval s as FBC.FBSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_Shrink     alias "fb_StrShrink"     ( byval s as FBC.FBSTRING ptr, byval m as FBC.FBUSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_MCase      alias "fb_StrMCase"      ( byval s as FBC.FBSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_RemoveBetween alias "fb_StrRemoveBetween" ( byval s as FBC.FBSTRING ptr, byval a as FBC.FBUSTRING ptr, byval b as FBC.FBUSTRING ptr, byval all as long, byval st as integer, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_PadRight   alias "fb_StrPadRight"   ( byval s as FBC.FBSTRING ptr, byval w as integer, byval p as FBC.FBUSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_PadLeft    alias "fb_StrPadLeft"    ( byval s as FBC.FBSTRING ptr, byval w as integer, byval p as FBC.FBUSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_PadCenter  alias "fb_StrPadCenter"  ( byval s as FBC.FBSTRING ptr, byval w as integer, byval p as FBC.FBUSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_Wrap       alias "fb_StrWrap"       ( byval s as FBC.FBSTRING ptr, byval a as FBC.FBUSTRING ptr, byval b as FBC.FBUSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_Unwrap     alias "fb_StrUnwrap"     ( byval s as FBC.FBSTRING ptr, byval a as FBC.FBUSTRING ptr, byval b as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBSTRING ptr
    declare function p_Escape     alias "fb_StrEscape"     ( byval s as FBC.FBSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_Unescape   alias "fb_StrUnescape"   ( byval s as FBC.FBSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_Split      alias "fb_StrSplitSpans" ( byval s as FBC.FBSTRING ptr, byval d as FBC.FBUSTRING ptr, byval ic as long, byval o as integer ptr, byval m as integer ) as integer
    declare function p_SplitChars alias "fb_StrSplitCharsSpans" ( byval s as FBC.FBSTRING ptr, byval d as FBC.FBUSTRING ptr, byval ic as long, byval o as integer ptr, byval m as integer ) as integer
end extern

#define LN(p) cint( (p)->len and &h7fffffffffffffff )
#define D(v) cptr( FBC.FBSTRING ptr, @v )
#define U(v) cptr( FBC.FBUSTRING ptr, @v )

'' Hex, not characters -- escape and reverse produce bytes a terminal hides.
sub sh( byref tag as string, byval r as FBC.FBSTRING ptr )
    if( r = 0 ) then print tag; " NULL" : exit sub
    dim as integer n = LN(r)
    dim as string b = ""
    if( r->data <> 0 ) then
        for i as integer = 0 to n - 1
            b += right( "0" + hex$( cptr( ubyte ptr, r->data )[i] ), 2 ) + " "
        next
    end if
    print tag; " len="; n; " ["; b; "]"
end sub

dim as string s1 = "the quick brown fox"
dim as string s2 = "a,b,,c"
dim as string s3 = "AaBbCc"
dim as string emp = ""
dim as string ws = "  hello   world  "
dim as ustring pcomma = ",", pempty = "", po = "o", pOup = "O"
dim as ustring pvow = "aeiou", pAEIOU = "AEIOU", pq = "quick", pQup = "QUICK"
dim as ustring pop = "(", pcl = ")", pquote = """"

'' ---- counts and positions, both fold flags
print "Tally o        "; p_Tally( D(s1), U(po), 0 ); p_Tally( D(s1), U(pOup), 0 ); p_Tally( D(s1), U(pOup), 1 )
print "Tally empty    "; p_Tally( D(s1), U(pempty), 0 )
print "Tally NULLpat  "; p_Tally( D(s1), 0, 0 )
print "Tally NULLs    "; p_Tally( 0, U(po), 0 )
print "TallyChars vow "; p_TallyChars( D(s1), U(pvow), 0 ); p_TallyChars( D(s1), U(pAEIOU), 0 ); p_TallyChars( D(s1), U(pAEIOU), 1 )
print "TallyChars emp "; p_TallyChars( D(s1), U(pempty), 0 )

for st as integer = 0 to 6
    print "InstrChars st="; st; " -> "; p_InstrChars( st, D(s1), U(pvow), 0 )
next
print "InstrChars empty set "; p_InstrChars( 1, D(s1), U(pempty), 0 )
for st as integer = 0 to 6
    print "VerifySet st="; st; " -> "; p_VerifySet( st, D(s1), U(pvow), 0 )
next
'' an EMPTY SET makes `from` the answer -- the opposite of InstrChars
print "VerifySet empty set  "; p_VerifySet( 1, D(s1), U(pempty), 0 )
for st as integer = 0 to 4
    print "SpanOf st="; st; " -> "; p_SpanOf( st, D(s3), U(pvow), 1 )
next
print "SpanOf empty set     "; p_SpanOf( 1, D(s1), U(pempty), 0 )

'' ---- affixes: an EMPTY affix is in every string, including the empty one
dim as ustring pthe = "the", pTHEup = "THE", pfox = "fox"
print "StartsWith     "; p_StartsWith( D(s1), U(pthe), 0 ); p_StartsWith( D(s1), U(pTHEup), 0 ); p_StartsWith( D(s1), U(pTHEup), 1 )
print "StartsWith emp "; p_StartsWith( D(s1), U(pempty), 0 ); p_StartsWith( D(emp), U(pempty), 0 )
print "EndsWith       "; p_EndsWith( D(s1), U(pfox), 0 ); p_EndsWith( D(s1), U(pthe), 0 )
print "EndsWith emp   "; p_EndsWith( D(s1), U(pempty), 0 ); p_EndsWith( D(emp), U(pempty), 0 )
print "Contains       "; p_Contains( D(s1), U(pq), 0 ); p_Contains( D(s1), U(pQup), 0 ); p_Contains( D(s1), U(pQup), 1 )
'' Contains follows StartsWith, NOT hFind: every string contains ""
print "Contains emp   "; p_Contains( D(s1), U(pempty), 0 ); p_Contains( D(emp), U(pempty), 0 )

'' ---- predicates
sub isnum( byref v as string )
    dim as string t = v
    print "IsNumeric ["; v; "] = "; p_IsNumeric( D(t) ); " IsBlank="; p_IsBlank( D(t) )
end sub
isnum( "0" ) : isnum( "12" ) : isnum( "-12" ) : isnum( "+12" ) : isnum( "1.5" )
isnum( ".5" ) : isnum( "5." ) : isnum( "1e5" ) : isnum( "1E+5" ) : isnum( "1d5" )
isnum( "1e" ) : isnum( "e5" ) : isnum( "." ) : isnum( "+" ) : isnum( "" )
isnum( "12abc" ) : isnum( " 12 " ) : isnum( "&hFF" ) : isnum( "++--.." )
isnum( "   " ) : isnum( !"\t\n" ) : isnum( "a" )

'' ---- extract family: the miss rules are OPPOSITES
sh( "Extract , 1    ", p_Extract( 1, D(s2), U(pcomma), 0 ) )
sh( "Extract , 3    ", p_Extract( 3, D(s2), U(pcomma), 0 ) )
sh( "Extract miss   ", p_Extract( 1, D(s1), U(pcomma), 0 ) )
sh( "Extract emptypat", p_Extract( 1, D(s1), U(pempty), 0 ) )
sh( "Extract st=0   ", p_Extract( 0, D(s2), U(pcomma), 0 ) )
sh( "Extract st=99  ", p_Extract( 99, D(s2), U(pcomma), 0 ) )
sh( "ExtractChars   ", p_ExtractChars( 1, D(s1), U(pvow), 0 ) )
sh( "Remain , 1     ", p_Remain( D(s2), U(pcomma), 1, 0 ) )
sh( "Remain miss    ", p_Remain( D(s1), U(pcomma), 1, 0 ) )
sh( "RemainChars    ", p_RemainChars( D(s1), U(pvow), 1, 0 ) )
dim as string paren = "x(a)(b)y"
sh( "Between        ", p_Between( D(paren), U(pop), U(pcl), 1, 0 ) )
sh( "Between st=5   ", p_Between( D(paren), U(pop), U(pcl), 5, 0 ) )
sh( "Between miss   ", p_Between( D(s1), U(pop), U(pcl), 1, 0 ) )

'' ---- clip / delete / insert
for n as integer = -1 to 5
    sh( "ClipLeft " + str(n) + "   ", p_ClipLeft( D(s3), n ) )
next
for n as integer = -1 to 5
    sh( "ClipRight " + str(n) + "  ", p_ClipRight( D(s3), n ) )
next
sh( "DeleteAt 2,2   ", p_DeleteAt( D(s3), 2, 2 ) )
sh( "DeleteAt 0,2   ", p_DeleteAt( D(s3), 0, 2 ) )
sh( "DeleteAt 2,0   ", p_DeleteAt( D(s3), 2, 0 ) )
sh( "DeleteAt 2,99  ", p_DeleteAt( D(s3), 2, 99 ) )
sh( "DeleteAt 99,2  ", p_DeleteAt( D(s3), 99, 2 ) )
dim as ustring pins = "XY"
sh( "InsertAt 1     ", p_InsertAt( D(s3), U(pins), 1 ) )
sh( "InsertAt 3     ", p_InsertAt( D(s3), U(pins), 3 ) )
sh( "InsertAt 99    ", p_InsertAt( D(s3), U(pins), 99 ) )
sh( "InsertAt 0     ", p_InsertAt( D(s3), U(pins), 0 ) )
sh( "InsertAt -1    ", p_InsertAt( D(s3), U(pins), -1 ) )

dim as string twoch = "ab"
'' ---- transforms
dim as ustring pab = "ab", pABup = "AB", pxy = "XY", pdash = "-"
dim as string rep = "abcabcABC"
sh( "Replace        ", p_Replace( D(rep), U(pab), U(pxy), 0 ) )
sh( "Replace ic     ", p_Replace( D(rep), U(pab), U(pxy), 1 ) )
sh( "Replace emptypat", p_Replace( D(rep), U(pempty), U(pxy), 0 ) )
sh( "Replace emptyrep", p_Replace( D(rep), U(pab), U(pempty), 0 ) )
sh( "Remove         ", p_Remove( D(rep), U(pab), 0 ) )
sh( "Remove ic      ", p_Remove( D(rep), U(pab), 1 ) )
sh( "RemoveChars    ", p_RemoveChars( D(s1), U(pvow), 0 ) )
sh( "RemoveChars emp", p_RemoveChars( D(s1), U(pempty), 0 ) )
sh( "RetainChars    ", p_RetainChars( D(s1), U(pvow), 0 ) )
'' an EMPTY SET keeps nothing -- the complement of dropping nothing
sh( "RetainChars emp", p_RetainChars( D(s1), U(pempty), 0 ) )
sh( "ReplaceChars   ", p_ReplaceChars( D(s1), U(pvow), U(pdash), 0 ) )
'' a replacement that is not exactly ONE byte copies through unchanged
sh( "ReplaceChars 2 ", p_ReplaceChars( D(s1), U(pvow), U(pxy), 0 ) )
sh( "ReplaceChars 0 ", p_ReplaceChars( D(s1), U(pvow), U(pempty), 0 ) )
sh( "Reverse        ", p_Reverse( D(s3) ) )
sh( "Reverse empty  ", p_Reverse( D(emp) ) )
dim as string dashS = "-"
sh( "Repeat 3       ", p_Repeat( 3, D(dashS) ) )
sh( "Repeat 0       ", p_Repeat( 0, D(dashS) ) )
sh( "Repeat -1      ", p_Repeat( -1, D(dashS) ) )
sh( "Repeat empty   ", p_Repeat( 3, D(emp) ) )
dim as ustring pspace = " "
sh( "Shrink         ", p_Shrink( D(ws), U(pspace) ) )
'' an EMPTY MASK returns the input unchanged -- fbc deliberately does NOT copy
'' AfxStrShrink, which returns the empty string here
sh( "Shrink emptymask", p_Shrink( D(ws), U(pempty) ) )
dim as string title = "hello world/foo_bar-baz.qux"
sh( "MCase          ", p_MCase( D(title) ) )
sh( "MCase empty    ", p_MCase( D(emp) ) )
dim as string rb = "a(x)b(y)c"
sh( "RemoveBetween 1", p_RemoveBetween( D(rb), U(pop), U(pcl), 0, 1, 0 ) )
sh( "RemoveBetween a", p_RemoveBetween( D(rb), U(pop), U(pcl), 1, 1, 0 ) )
sh( "RemoveBetween 0", p_RemoveBetween( D(rb), U(pop), U(pcl), 1, 0, 0 ) )
dim as string unbal = "a(xb"
sh( "RemoveBetween u", p_RemoveBetween( D(unbal), U(pop), U(pcl), 1, 1, 0 ) )

'' ---- pad: the result is EXACTLY width, centring puts the odd unit RIGHT
for w as integer = 0 to 6
    sh( "PadRight " + str(w) + "   ", p_PadRight( D(twoch), w, U(pdash) ) )
next
for w as integer = 0 to 6
    sh( "PadLeft " + str(w) + "    ", p_PadLeft( D(twoch), w, U(pdash) ) )
next
for w as integer = 0 to 6
    sh( "PadCenter " + str(w) + "  ", p_PadCenter( D(twoch), w, U(pdash) ) )
next
'' a pad that is not exactly ONE byte becomes a space
sh( "Pad multibyte  ", p_PadRight( D(twoch), 6, U(pxy) ) )
sh( "Pad empty      ", p_PadRight( D(twoch), 6, U(pempty) ) )

'' ---- wrap: an EMPTY closing means "same as opening"
sh( "Wrap ( )       ", p_Wrap( D(twoch), U(pop), U(pcl) ) )
sh( "Wrap quote     ", p_Wrap( D(twoch), U(pquote), U(pempty) ) )
dim as string wrapped = "(ab)", quoted = """ab"""
sh( "Unwrap ( )     ", p_Unwrap( D(wrapped), U(pop), U(pcl), 0 ) )
sh( "Unwrap quote   ", p_Unwrap( D(quoted), U(pquote), U(pempty), 0 ) )
'' unbalanced: BOTH ends required, unlike AfxStrUnWrap
dim as string halfw = "(ab"
sh( "Unwrap unbal   ", p_Unwrap( D(halfw), U(pop), U(pcl), 0 ) )
dim as string tripleq = """""""ab"""""""
sh( "Unwrap triple  ", p_Unwrap( D(tripleq), U(pquote), U(pempty), 0 ) )
dim as string justq = """"
sh( "Unwrap one     ", p_Unwrap( D(justq), U(pquote), U(pempty), 0 ) )

'' ---- escape / unescape, and the round trip
dim as string esc = "a" + chr(9) + "b" + chr(10) + "c" + chr(13) + "d" + chr(0) + "e\f" + chr(1) + chr(127) + chr(200)
sh( "Escape         ", p_Escape( D(esc) ) )
dim as FBC.FBSTRING ptr e1 = p_Escape( D(esc) )
sh( "Unescape(Escape)", p_Unescape( e1 ) )
dim as string une = "a\qb\c\" + chr(0) + "d\xZZ\x41\x"
sh( "Unescape odd   ", p_Unescape( D(une) ) )
dim as string trail = "ab\"
sh( "Unescape trail ", p_Unescape( D(trail) ) )

'' ---- split: N delimiters always give N+1 fields
dim shared as integer pairs(0 to 63)
sub dosplit( byref v as string, byref delim as ustring, byval bychar as integer )
    dim as string t = v
    dim as ustring dd = delim
    dim as integer n = any
    if( bychar = 0 ) then
        n = p_Split( D(t), U(dd), 0, 0, 0 )
    else
        n = p_SplitChars( D(t), U(dd), 0, 0, 0 )
    end if
    for i as integer = 0 to 63 : pairs(i) = -9 : next
    if( bychar = 0 ) then
        p_Split( D(t), U(dd), 0, @pairs(0), 32 )
    else
        p_SplitChars( D(t), U(dd), 0, @pairs(0), 32 )
    end if
    print "split ["; v; "] n="; n;
    for i as integer = 0 to n - 1
        print " ("; pairs(i*2); ","; pairs(i*2+1); ")";
    next
    print
end sub
dosplit( "a,b,c", ",", 0 )
dosplit( "a,,c", ",", 0 )
dosplit( ",a", ",", 0 )
dosplit( "a,", ",", 0 )
dosplit( "", ",", 0 )
dosplit( "abc", ",", 0 )
dosplit( "a,b,c", "", 0 )
dosplit( "a-b,c", ",-", 1 )
dosplit( "abc", "", 1 )
'' maxpairs bounds the write: a caller that guessed cannot overrun
for i as integer = 0 to 63 : pairs(i) = -9 : next
dim as string many = "a,b,c,d,e"
dim as ustring dc = ","
print "split maxpairs=2 n="; p_Split( D(many), U(dc), 0, @pairs(0), 2 );
print " pairs:"; pairs(0); pairs(1); pairs(2); pairs(3); pairs(4); pairs(5)
