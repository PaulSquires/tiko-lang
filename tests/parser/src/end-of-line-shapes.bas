'' Statements fbc accepts that tiko once parsed SHORT, leaving tokens on the line. Each
'' was silent until TKO0420 began reporting what EndOfStatement discards.
dim as integer h = 25, x
dim as any ptr image
dim shared array1() as integer
declare function cb( byval s as ulong, byval d as ulong, byval u as any ptr ) as ulong

view print 10 to h - 5
view print
view% print% 1 to% 2
var p = new integer[10] {any}
put (0, 0), image, custom, @cb, 0
put (1, 2), image, (3, 4)-step(5, 6), pset
put% step%(1,2), image, (3,4)-step%(5,6), pset%

namespace ns
    sub f( )
        redim .array1(2 to 2) as integer
    end sub
end namespace
redim (array1)(0 to 1) as integer

if 1 then print else print end if
if 1 then print else print endif
if 1 then print endif
if 1 then x = 1 : endif
if% 1 then% print else% print end% if%
#print a: b
print "x" "y"; "z", 1
print "a"; using "&"; "b"
if 1 then print 1 end if
if 1 then print 1 else print 2 end if
