'' utf-parity.bas -- the four codecs and fb_hUStrCodepointAt.
''
'' The area RFC-0004 section 3.3 named as the one that could stop the project.
'' Every case here is one PROBE-34/35/36 measured against fbc, so a divergence
'' names the contract it broke rather than just failing.
''
'' Buffers are over-allocated by more than one unit on purpose: the terminator
'' lands at dst[min(need, capacity)], which is OUTSIDE the stated capacity, and
'' a buffer sized exactly to the capacity would make every truncation test
'' corrupt the next variable instead of reporting a difference.
extern "c"   '' NON-FBCALL -- no @N on win32
    declare function u8to16  alias "fb_hUtf8ToUtf16"  ( byval s as ubyte ptr, byval nb as integer, byval d as ushort ptr, byval du as integer ) as integer
    declare function u16to8  alias "fb_hUtf16ToUtf8"  ( byval s as ushort ptr, byval nu as integer, byval d as ubyte ptr, byval db as integer ) as integer
    declare function u32to16 alias "fb_hUtf32ToUtf16" ( byval s as ulong ptr,  byval nu as integer, byval d as ushort ptr, byval du as integer ) as integer
    declare function u16to32 alias "fb_hUtf16ToUtf32" ( byval s as ushort ptr, byval nu as integer, byval d as ulong ptr,  byval du as integer ) as integer
    declare function cpat    alias "fb_hUStrCodepointAt" ( byval s as ushort ptr, byval ln as integer, byval i as integer, byval used as integer ptr ) as ulong
end extern

dim shared as ubyte  b8(0 to 127)
dim shared as ushort b16(0 to 127)
dim shared as ulong  b32(0 to 127)
dim shared as ubyte  s(0 to 15)
dim shared as ushort w(0 to 15)
dim shared as ulong  q(0 to 15)

'' Dumps one past the reported length, so the terminator is part of the result.
sub show16( byref tag as string, byval got as integer )
    dim as string o = ""
    for i as integer = 0 to got
        o += right( "000" + hex$( b16(i) ), 4 ) + " "
    next
    print tag; " -> "; got; " ["; o; "]"
end sub

sub show8( byref tag as string, byval got as integer )
    dim as string o = ""
    for i as integer = 0 to got
        o += right( "0" + hex$( b8(i) ), 2 ) + " "
    next
    print tag; " -> "; got; " ["; o; "]"
end sub

'' A dst = NULL measure and a real write must agree, always. That is the
'' snprintf-like half of the contract, and it is cheap to assert on every case.
sub t8( byref tag as string, byval n as integer, byval a as integer, byval b as integer, byval c as integer, byval d as integer )
    s(0)=a : s(1)=b : s(2)=c : s(3)=d
    for i as integer = 0 to 127 : b16(i) = &hCCCC : next
    dim as integer need = u8to16( @s(0), n, 0, 0 )
    dim as integer got  = u8to16( @s(0), n, @b16(0), 64 )
    if( need <> got ) then print tag; " MEASURE/WRITE DISAGREE "; need; " "; got
    show16( "u8->16 " + tag, got )
end sub

sub t16( byref tag as string, byval n as integer, byval a as integer, byval b as integer )
    w(0)=a : w(1)=b
    for i as integer = 0 to 127 : b8(i) = &hCC : next
    dim as integer need = u16to8( @w(0), n, 0, 0 )
    dim as integer got  = u16to8( @w(0), n, @b8(0), 64 )
    if( need <> got ) then print tag; " MEASURE/WRITE DISAGREE "; need; " "; got
    show8( "u16->8 " + tag, got )
end sub

'' ---- well-formed UTF-8
t8( "ascii A      ", 1, &h41, 0, 0, 0 )
t8( "2byte C3A9   ", 2, &hC3, &hA9, 0, 0 )
t8( "3byte E282AC ", 3, &hE2, &h82, &hAC, 0 )
t8( "4byte F09F9880", 4, &hF0, &h9F, &h98, &h80 )
t8( "NUL          ", 1, 0, 0, 0, 0 )
t8( "A NUL B      ", 3, &h41, 0, &h42, 0 )

'' ---- ill-formed UTF-8: the maximal-subpart rule, and the four narrowed
''      second-byte ranges that make it identifiable
t8( "trunc C3     ", 1, &hC3, 0, 0, 0 )
t8( "trunc E282   ", 2, &hE2, &h82, 0, 0 )
t8( "lone 80      ", 1, &h80, 0, 0, 0 )
t8( "byte FF      ", 1, &hFF, 0, 0, 0 )
t8( "C0 AF        ", 2, &hC0, &hAF, 0, 0 )
t8( "C1 BF        ", 2, &hC1, &hBF, 0, 0 )
t8( "E0 80 AF     ", 3, &hE0, &h80, &hAF, 0 )
t8( "ED A0 80     ", 3, &hED, &hA0, &h80, 0 )
t8( "F0 82 82 AC  ", 4, &hF0, &h82, &h82, &hAC )
t8( "F4 90 80 80  ", 4, &hF4, &h90, &h80, &h80 )
t8( "resync E28241", 3, &hE2, &h82, &h41, 0 )
t8( "resync C341  ", 2, &hC3, &h41, 0, 0 )
t8( "resync F09F41", 3, &hF0, &h9F, &h41, 0 )
'' the accepting side of each narrowed range, so a wrong bound shows both ways
t8( "E0 A0 80     ", 3, &hE0, &hA0, &h80, 0 )
t8( "ED 9F BF     ", 3, &hED, &h9F, &hBF, 0 )
t8( "F0 90 80 80  ", 4, &hF0, &h90, &h80, &h80 )
t8( "F4 8F BF BF  ", 4, &hF4, &h8F, &hBF, &hBF )
t8( "C2 80        ", 2, &hC2, &h80, 0, 0 )
t8( "DF BF        ", 2, &hDF, &hBF, 0, 0 )
t8( "F5 80 80 80  ", 4, &hF5, &h80, &h80, &h80 )

'' ---- UTF-16 -> UTF-8
t16( "ascii A      ", 1, &h41, 0 )
t16( "00E9         ", 1, &h00E9, 0 )
t16( "20AC         ", 1, &h20AC, 0 )
t16( "pair D83DDE00", 2, &hD83D, &hDE00 )
t16( "lone high    ", 1, &hD83D, 0 )
t16( "lone low     ", 1, &hDE00, 0 )
t16( "high then A  ", 2, &hD83D, &h41 )
t16( "low then A   ", 2, &hDE00, &h41 )
t16( "high then hi ", 2, &hD83D, &hD83D )
t16( "NUL          ", 1, 0, 0 )
t16( "D800 DC00    ", 2, &hD800, &hDC00 )
t16( "DBFF DFFF    ", 2, &hDBFF, &hDFFF )

'' ---- capacity: truncation is unit-exact, and the terminator is one past it.
''      Swept from 0 rather than spot-checked: cap = 0 through a non-NULL dst
''      still writes dst[0] = 0, and the boundary cases are where a
''      >= / > mistake lives.
sub cap16( byval cap as integer )
    w(0)=&h20AC : w(1)=&h20AC : w(2)=&h41
    for i as integer = 0 to 127 : b8(i) = &hCC : next
    dim as integer r = u16to8( @w(0), 3, @b8(0), cap )
    dim as string o = ""
    for i as integer = 0 to 9
        o += right( "0" + hex$( b8(i) ), 2 ) + " "
    next
    print "u16->8 cap="; cap; " ret="; r; " buf["; o; "]"
end sub

for c as integer = 0 to 8
    cap16( c )
next

sub cap8( byval cap as integer )
    s(0)=&h41 : s(1)=&hF0 : s(2)=&h9F : s(3)=&h98 : s(4)=&h80
    for i as integer = 0 to 127 : b16(i) = &hCCCC : next
    dim as integer r = u8to16( @s(0), 5, @b16(0), cap )
    dim as string o = ""
    for i as integer = 0 to 5
        o += right( "000" + hex$( b16(i) ), 4 ) + " "
    next
    print "u8->16 cap="; cap; " ret="; r; " buf["; o; "]"
end sub

for c as integer = 0 to 4
    cap8( c )
next

'' ---- UTF-32 <-> UTF-16
q(0)=&h41 : q(1)=&h20AC : q(2)=&h1F600 : q(3)=&h10FFFF : q(4)=&h110000 : q(5)=&hD800 : q(6)=&hDFFF : q(7)=0
for i as integer = 0 to 127 : b16(i) = &hCCCC : next
show16( "u32->16 mixed", u32to16( @q(0), 8, @b16(0), 64 ) )

'' A capacity landing between the two units of a surrogate pair: fbc splits it.
sub cap32( byval cap as integer )
    q(0)=&h41 : q(1)=&h1F600 : q(2)=&h42
    for i as integer = 0 to 127 : b16(i) = &hCCCC : next
    dim as integer r = u32to16( @q(0), 3, @b16(0), cap )
    dim as string o = ""
    for i as integer = 0 to 5
        o += right( "000" + hex$( b16(i) ), 4 ) + " "
    next
    print "u32->16 cap="; cap; " ret="; r; " buf["; o; "]"
end sub

for c as integer = 0 to 4
    cap32( c )
next

w(0)=&h41 : w(1)=&hD83D : w(2)=&hDE00 : w(3)=&hD800 : w(4)=&hDC00 : w(5)=&hDE00 : w(6)=&hD83D
for i as integer = 0 to 127 : b32(i) = &hCCCCCCCC : next
dim as integer g2 = u16to32( @w(0), 7, @b32(0), 64 )
dim as string o2 = ""
for i as integer = 0 to g2
    o2 += hex$( b32(i) ) + " "
next
print "u16->32 mixed -> "; g2; " ["; o2; "]"

sub cap32b( byval cap as integer )
    w(0)=&h41 : w(1)=&hD83D : w(2)=&hDE00
    for i as integer = 0 to 127 : b32(i) = &hCCCCCCCC : next
    dim as integer r = u16to32( @w(0), 3, @b32(0), cap )
    dim as string o = ""
    for i as integer = 0 to 4
        o += hex$( b32(i) ) + " "
    next
    print "u16->32 cap="; cap; " ret="; r; " buf["; o; "]"
end sub

for c as integer = 0 to 3
    cap32b( c )
next

'' ---- zero-length sources
print "zero-len u16->8 = "; u16to8( @w(0), 0, @b8(0), 8 )
print "zero-len u8->16 = "; u8to16( @s(0), 0, @b16(0), 8 )
print "zero-len u32->16 = "; u32to16( @q(0), 0, @b16(0), 8 )
print "zero-len u16->32 = "; u16to32( @w(0), 0, @b32(0), 8 )

'' ---- fb_hUStrCodepointAt, including one index past the end
w(0)=&h41 : w(1)=&hD83D : w(2)=&hDE00 : w(3)=&hD83D : w(4)=&hDE00 : w(5)=&hDE00
for i as integer = 0 to 6
    dim as integer used = -99
    dim as ulong cp = cpat( @w(0), 6, i, @used )
    print "cpAt("; i; ") = "; hex$( cp ); " used="; used
next

dim as integer u2 = -99
print "cpAt lone-high-at-end = "; hex$( cpat( @w(0), 2, 1, @u2 ) ); " used="; u2
u2 = -99
print "cpAt negative index   = "; hex$( cpat( @w(0), 6, -1, @u2 ) ); " used="; u2
