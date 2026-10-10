'' DRAW STRING's METHOD -- PUT's words, after the font -- and the one or two values a
'' method takes. fbc's call for each, measured 2026-10-10 (mode, then what differs):
function cb( byval s as ulong, byval d as ulong, byval p as any ptr ) as ulong
    return s
end function
dim shared as long k
dim as long a = 200
screenres 64, 64, 32
draw string (1, 2), "A", 7                      '' 0: no method is TRANS
draw string (1, 2), "B", 7, , PSET              '' 1
draw string (1, 2), "C", 7, , TRANS             '' 0
draw string (1, 2), "D", 7, , ALPHA             '' 6, colour 7
draw string (1, 2), "E", 7, , ALPHA, 128        '' 9, colour 128u: the value takes its slot
draw string (1, 2), "F", 7, , XOR               '' 5
draw string (1, 2), "G", 7, , CUSTOM, @cb, @k   '' 8, ..., &CB, &K$
draw string (1, 2), "H", 7, , ADD, 99           '' 7, colour 99u
draw string (1, 2), "I", , , PSET               '' 1, colour 0u under the no-colour bit
draw string (1, 2), "J", , , ALPHA, 128         '' 9, colour 128u, still the no-colour bit
draw string (1, 2), "K", 7, , ADD               '' 7, colour 255u: ADD's own default
draw string (1, 2), "L", 7, , CUSTOM, @cb       '' 8, ..., &CB, 0
draw string (1, 2), "M", 7, , alpha, a          '' 9, colour (uint32)A$0
draw string step (1, 2), "N", 7, , and          '' 3, flags 5
