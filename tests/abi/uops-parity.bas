'' uops-parity.bas -- ustr_ops.o: the 16-bit instantiation and the WSTRING bridge.
''
'' Two things here that the byte family cannot test at all:
''
''   SURROGATE PAIRS. hReverseFill must keep a pair together at this width --
''   reversing code units blindly emits a low surrogate before its high one,
''   which is invalid UTF-16 every time an astral character appears.
''
''   THE REAL FOLD TABLE. Case folding is the generated BMP table, not ASCII, so
''   ignore-case works on accented letters here and deliberately does not in the
''   byte family.
''
'' And the WSTRING bridge is platform-conditional: a pointer reinterpret where
'' FB_WCHAR is 16 bits, a re-encode into a released temporary where it is wider.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function pU_Tally    alias "fb_UStrTally"    ( byval s as FBC.FBUSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as integer
    declare function pU_Instr    alias "fb_UStrInstrChars" ( byval st as integer, byval s as FBC.FBUSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as integer
    declare function pU_Verify   alias "fb_UStrVerifySet" ( byval st as integer, byval s as FBC.FBUSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as integer
    declare function pU_Span     alias "fb_UStrSpanOf"   ( byval st as integer, byval s as FBC.FBUSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as integer
    declare function pU_Starts   alias "fb_UStrStartsWith" ( byval s as FBC.FBUSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as long
    declare function pU_Ends     alias "fb_UStrEndsWith" ( byval s as FBC.FBUSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as long
    declare function pU_Contains alias "fb_UStrContains" ( byval s as FBC.FBUSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as long
    declare function pU_IsNum    alias "fb_UStrIsNumeric" ( byval s as FBC.FBUSTRING ptr ) as long
    declare function pU_IsBlank  alias "fb_UStrIsBlank"  ( byval s as FBC.FBUSTRING ptr ) as long
    declare function pU_Reverse  alias "fb_UStrReverse"  ( byval s as FBC.FBUSTRING ptr ) as FBC.FBUSTRING ptr
    declare function pU_MCase    alias "fb_UStrMCase"    ( byval s as FBC.FBUSTRING ptr ) as FBC.FBUSTRING ptr
    declare function pU_Replace  alias "fb_UStrReplace"  ( byval s as FBC.FBUSTRING ptr, byval p as FBC.FBUSTRING ptr, byval r as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBUSTRING ptr
    declare function pU_Extract  alias "fb_UStrExtract"  ( byval st as integer, byval s as FBC.FBUSTRING ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBUSTRING ptr
    declare function pU_Remain   alias "fb_UStrRemain"   ( byval s as FBC.FBUSTRING ptr, byval p as FBC.FBUSTRING ptr, byval st as integer, byval ic as long ) as FBC.FBUSTRING ptr
    declare function pU_Pad      alias "fb_UStrPadCenter" ( byval s as FBC.FBUSTRING ptr, byval w as integer, byval p as FBC.FBUSTRING ptr ) as FBC.FBUSTRING ptr
    declare function pU_Wrap     alias "fb_UStrWrap"     ( byval s as FBC.FBUSTRING ptr, byval a as FBC.FBUSTRING ptr, byval b as FBC.FBUSTRING ptr ) as FBC.FBUSTRING ptr
    declare function pU_Escape   alias "fb_UStrEscape"   ( byval s as FBC.FBUSTRING ptr ) as FBC.FBUSTRING ptr
    declare function pU_Unescape alias "fb_UStrUnescape" ( byval s as FBC.FBUSTRING ptr ) as FBC.FBUSTRING ptr
    declare function pU_ClipLeft alias "fb_UStrClipLeft" ( byval s as FBC.FBUSTRING ptr, byval n as integer ) as FBC.FBUSTRING ptr
    declare function pU_Del      alias "fb_UStrDeleteAt" ( byval s as FBC.FBUSTRING ptr, byval st as integer, byval n as integer ) as FBC.FBUSTRING ptr
    declare function pU_Ins      alias "fb_UStrInsertAt" ( byval s as FBC.FBUSTRING ptr, byval i as FBC.FBUSTRING ptr, byval p as integer ) as FBC.FBUSTRING ptr
    declare function pU_Split    alias "fb_UStrSplitSpans" ( byval s as FBC.FBUSTRING ptr, byval d as FBC.FBUSTRING ptr, byval ic as long, byval o as integer ptr, byval m as integer ) as integer
    declare function pW_Tally    alias "fb_WStrTally"    ( byval s as wstring ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as integer
    declare function pW_Starts   alias "fb_WStrStartsWith" ( byval s as wstring ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as long
    declare function pW_Contains alias "fb_WStrContains" ( byval s as wstring ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as long
    declare function pW_IsNum    alias "fb_WStrIsNumeric" ( byval s as wstring ptr ) as long
    declare function pW_Reverse  alias "fb_WStrReverse"  ( byval s as wstring ptr ) as FBC.FBUSTRING ptr
    declare function pW_Extract  alias "fb_WStrExtract"  ( byval st as integer, byval s as wstring ptr, byval p as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBUSTRING ptr
    declare function pW_Replace  alias "fb_WStrReplace"  ( byval s as wstring ptr, byval p as FBC.FBUSTRING ptr, byval r as FBC.FBUSTRING ptr, byval ic as long ) as FBC.FBUSTRING ptr
    declare function pW_Pad      alias "fb_WStrPadLeft"  ( byval s as wstring ptr, byval w as integer, byval p as FBC.FBUSTRING ptr ) as FBC.FBUSTRING ptr
    declare function pW_Del      alias "fb_WStrDeleteAt" ( byval s as wstring ptr, byval st as integer, byval n as integer ) as FBC.FBUSTRING ptr
end extern

#define ULN(p) cint( (p)->len and &h7fffffffffffffff )
#define UU(v) cptr( FBC.FBUSTRING ptr, @v )

'' Hex of the code units: astral text and fold results are invisible otherwise.
sub su( byref tag as string, byval r as FBC.FBUSTRING ptr )
    if( r = 0 ) then print tag; " NULL" : exit sub
    dim as integer n = ULN(r)
    dim as string b = ""
    if( r->data <> 0 ) then
        for i as integer = 0 to n - 1
            b += right( "000" + hex$( r->data[i] ), 4 ) + " "
        next
    end if
    print tag; " len="; n; " ["; b; "]"
end sub

'' ---- ASCII behaviour, mirroring the byte family so the two widths can be
''      compared by eye as well as by the runtime
dim as ustring s1 = "the quick brown fox", vow = "aeiou", vowup = "AEIOU"
dim as ustring po = "o", poup = "O", pempty = "", pthe = "the", ptheup = "THE"
print "Tally o      "; pU_Tally( UU(s1), UU(po), 0 ); pU_Tally( UU(s1), UU(poup), 0 ); pU_Tally( UU(s1), UU(poup), 1 )
print "Tally empty  "; pU_Tally( UU(s1), UU(pempty), 0 )
print "Tally NULL   "; pU_Tally( UU(s1), 0, 0 ); pU_Tally( 0, UU(po), 0 )
for st as integer = 0 to 6
    print "Instr st="; st; " -> "; pU_Instr( st, UU(s1), UU(vow), 0 );
    print " verify="; pU_Verify( st, UU(s1), UU(vow), 0 );
    print " span="; pU_Span( st, UU(s1), UU(vow), 0 )
next
'' the empty-set asymmetry, at this width too
print "Instr emptyset  "; pU_Instr( 1, UU(s1), UU(pempty), 0 )
print "Verify emptyset "; pU_Verify( 1, UU(s1), UU(pempty), 0 )
print "Starts/Ends/Contains "; pU_Starts( UU(s1), UU(pthe), 0 ); pU_Starts( UU(s1), UU(ptheup), 0 ); pU_Starts( UU(s1), UU(ptheup), 1 );
print " "; pU_Ends( UU(s1), UU(po), 0 ); pU_Contains( UU(s1), UU(pempty), 0 )

'' ---- the REAL fold table: accented letters fold here and not in the byte family
dim as ustring acc = wstr( !"éÉüÜ" )     '' e-acute, E-acute, u-umlaut, U-umlaut
dim as ustring accU = wstr( !"É" )
print "fold acc ic=0 "; pU_Tally( UU(acc), UU(accU), 0 )
print "fold acc ic=1 "; pU_Tally( UU(acc), UU(accU), 1 )
su( "MCase acc    ", pU_MCase( UU(acc) ) )

'' ---- SURROGATES: a pair must survive Reverse intact
dim as ustring astral = wstr( !"a\U0001F600b" )
su( "astral       ", UU(astral) )
su( "Reverse astral", pU_Reverse( UU(astral) ) )
dim as ustring twopair = wstr( !"\U0001F600\U0001F601" )
su( "Reverse 2pair", pU_Reverse( UU(twopair) ) )
'' a LONE high surrogate has no partner and must not be paired with its neighbour
dim as ustring lone = wstr( !"a\uD83Db" )
su( "Reverse lone ", pU_Reverse( UU(lone) ) )
su( "Reverse ascii", pU_Reverse( UU(s1) ) )

'' ---- lengths count CODE UNITS, so an astral character counts as 2
print "astral clip 1 "; : su( "", pU_ClipLeft( UU(astral), 1 ) )
print "astral clip 2 "; : su( "", pU_ClipLeft( UU(astral), 2 ) )
su( "astral del 2,2", pU_Del( UU(astral), 2, 2 ) )
su( "astral ins    ", pU_Ins( UU(astral), UU(po), 2 ) )

'' ---- the rest of the family, briefly
dim as ustring rep = "abcabcABC", pab = "ab", pxy = "XY", pdash = "-"
su( "Replace      ", pU_Replace( UU(rep), UU(pab), UU(pxy), 0 ) )
su( "Replace ic   ", pU_Replace( UU(rep), UU(pab), UU(pxy), 1 ) )
dim as ustring csv = "a,b,,c", comma = ","
su( "Extract      ", pU_Extract( 1, UU(csv), UU(comma), 0 ) )
su( "Remain       ", pU_Remain( UU(csv), UU(comma), 1, 0 ) )
su( "Extract miss ", pU_Extract( 1, UU(s1), UU(comma), 0 ) )
dim as ustring ab2 = "ab"
for w as integer = 0 to 5
    su( "PadCenter " + str(w), pU_Pad( UU(ab2), w, UU(pdash) ) )
next
dim as ustring pq = "(", pcl = ")"
su( "Wrap         ", pU_Wrap( UU(ab2), UU(pq), UU(pcl) ) )
dim as ustring esc = wstr( !"a\tb\nc\"d\e" )
su( "Escape       ", pU_Escape( UU(esc) ) )
su( "Unescape rt  ", pU_Unescape( pU_Escape( UU(esc) ) ) )
dim as ustring nums = "12.5"
print "IsNumeric/IsBlank "; pU_IsNum( UU(nums) ); pU_IsNum( UU(s1) ); pU_IsBlank( UU(pempty) )

dim shared as integer up(0 to 31)
print "Split n="; pU_Split( UU(csv), UU(comma), 0, 0, 0 );
pU_Split( UU(csv), UU(comma), 0, @up(0), 16 )
for i as integer = 0 to 3 : print " ("; up(i*2); ","; up(i*2+1); ")"; : next
print

'' ---- the WSTRING bridge. On Windows this reinterprets; on Linux it re-encodes
''      into a temporary that hWstrRel must release.
dim as wstring * 64 w1 = wstr("the quick brown fox")
print "W Tally o    "; pW_Tally( @w1, UU(po), 0 ); pW_Tally( @w1, UU(poup), 1 )
print "W Starts     "; pW_Starts( @w1, UU(pthe), 0 ); pW_Starts( @w1, UU(ptheup), 1 )
print "W Contains   "; pW_Contains( @w1, UU(pempty), 0 )
dim as wstring * 16 wnum = wstr("12.5")
print "W IsNumeric  "; pW_IsNum( @wnum ); pW_IsNum( @w1 )
su( "W Reverse    ", pW_Reverse( @w1 ) )
dim as wstring * 32 wcsv = wstr("a,b,,c")
su( "W Extract    ", pW_Extract( 1, @wcsv, UU(comma), 0 ) )
su( "W Replace    ", pW_Replace( @wcsv, UU(comma), UU(pdash), 0 ) )
su( "W PadLeft    ", pW_Pad( @w1, 25, UU(pdash) ) )
su( "W DeleteAt   ", pW_Del( @wcsv, 2, 2 ) )
'' a NULL wstring is the empty string, and must not crash the bridge
print "W NULL       "; pW_Tally( 0, UU(po), 0 ); pW_IsNum( 0 )
su( "W NULL rev   ", pW_Reverse( 0 ) )
'' astral through the bridge -- the surrogate pair must survive on both platforms
dim as wstring * 16 wast = wstr( !"a\U0001F600b" )
su( "W Reverse ast", pW_Reverse( @wast ) )
