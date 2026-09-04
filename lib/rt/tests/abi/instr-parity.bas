'' instr-parity.bas -- fb_StrInstr.
''
'' The guards, the 1-based result, the one-character memchr path, the
'' Boyer-Moore path, and operand consumption. Written against the C body
'' (R2 lifted) but VERIFIED the same way as everything before it: the answer
'' comes from running both runtimes, not from having read one of them.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function p_Instr alias "fb_StrInstr" ( byval start as integer, byval src as FBC.FBSTRING ptr, byval patt as FBC.FBSTRING ptr ) as integer
    declare function p_AllocTemp alias "fb_hStrAllocTemp" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
end extern

#define LN(p) cint( (p)->len and &h7fffffffffffffff )
#define D(v) cptr( FBC.FBSTRING ptr, @v )

dim as string hay = "the quick brown fox jumps over the lazy dog"
dim as string one = "q", two = "ow", none = "zzz", whole = hay
dim as string emp = "", the_ = "the", dup = "abcabcabc", ab = "abc"

sub chk( byref tag as string, byval st as integer, byval s as FBC.FBSTRING ptr, byval p as FBC.FBSTRING ptr )
    print tag; " = "; p_Instr( st, s, p )
end sub

'' one-character pattern -- the memchr path
chk( "instr 1 hay q     ", 1, D(hay), D(one) )
chk( "instr 6 hay q     ", 6, D(hay), D(one) )
chk( "instr 8 hay q     ", 8, D(hay), D(one) )
'' multi-character -- Boyer-Moore
chk( "instr 1 hay ow    ", 1, D(hay), D(two) )
chk( "instr 13 hay ow   ", 13, D(hay), D(two) )
chk( "instr 1 hay the   ", 1, D(hay), D(the_) )
chk( "instr 2 hay the   ", 2, D(hay), D(the_) )
chk( "instr 1 hay zzz   ", 1, D(hay), D(none) )
'' whole string, and a pattern longer than the text
chk( "instr 1 hay hay   ", 1, D(hay), D(whole) )
chk( "instr 2 hay hay   ", 2, D(hay), D(whole) )
chk( "instr 1 abc hay   ", 1, D(ab), D(hay) )
'' overlapping repeats
chk( "instr 1 dup abc   ", 1, D(dup), D(ab) )
chk( "instr 2 dup abc   ", 2, D(dup), D(ab) )
chk( "instr 4 dup abc   ", 4, D(dup), D(ab) )
chk( "instr 7 dup abc   ", 7, D(dup), D(ab) )
chk( "instr 8 dup abc   ", 8, D(dup), D(ab) )
'' the guards
chk( "instr 0 hay the   ", 0, D(hay), D(the_) )
chk( "instr -5 hay the  ", -5, D(hay), D(the_) )
chk( "instr 99 hay the  ", 99, D(hay), D(the_) )
chk( "instr 1 hay ''    ", 1, D(hay), D(emp) )
chk( "instr 1 '' the    ", 1, D(emp), D(the_) )
chk( "instr 1 '' ''     ", 1, D(emp), D(emp) )
chk( "instr 1 NULL the  ", 1, 0, D(the_) )
chk( "instr 1 hay NULL  ", 1, D(hay), 0 )
chk( "instr 1 NULL NULL ", 1, 0, 0 )
'' start exactly at the last valid position
dim as string edge = "xxxay"
chk( "instr 4 xxxay ay  ", 4, D(edge), cptr( FBC.FBSTRING ptr, @two ) )
'' embedded NULs -- binary, not C-string
dim as string z1 = "a" + chr(0) + "bc", z2 = chr(0) + "b"
chk( "instr 1 a0bc 0b   ", 1, D(z1), D(z2) )

'' ---- both operands consumed
function mkTemp( byref v as string ) as FBC.FBSTRING ptr
    dim as FBC.FBSTRING ptr tp = p_AllocTemp( 0, len(v) )
    for i as integer = 0 to len(v) - 1 : tp->data[i] = v[i] : next
    tp->data[len(v)] = 0
    return tp
end function

dim as FBC.FBSTRING ptr s1 = mkTemp( "abcabc" ), p1 = mkTemp( "cab" )
dim as integer r1 = p_Instr( 1, s1, p1 )
dim as integer l1 = LN(s1), h1 = iif(s1->data=0,0,1), l2 = LN(p1), h2 = iif(p1->data=0,0,1)
print "instr temp temp = "; r1; " src len="; l1; " data="; h1; " patt len="; l2; " data="; h2

'' a guard path must release the operands too
dim as FBC.FBSTRING ptr s2 = mkTemp( "abc" ), p2 = mkTemp( "abcdef" )
p_Instr( 1, s2, p2 )
'' CAPTURE BEFORE PRINTING. Reading the operands inside the PRINT reports a
'' RECYCLED descriptor: PRINT allocates temporaries, one reclaims the slot just
'' released, and a correctly freed operand reads back as len=10 data=1. Fourth
'' occurrence in this project of the instrument perturbing its subject.
dim as integer g1 = LN(s2), g2 = iif( s2->data = 0, 0, 1 )
dim as integer g3 = LN(p2), g4 = iif( p2->data = 0, 0, 1 )
print "guarded release: src len="; g1; " data="; g2; " patt len="; g3; " data="; g4

'' non-temporaries survive
p_Instr( 1, D(hay), D(the_) )
print "non-temp survives len="; len( hay )
