'' A WIDE LITERAL'S CODE UNITS, in both the shapes that reach the backend: a narrow
'' destination taking a wide source, and a 'wstring * N' field taking a narrow one.
type W
    a as wstring * 8
end type

dim as string k = wstr( "fOoBaR" )
print k

dim as W ww
ww.a = "wid"
print "["; ww.a; "]"

'' A UNIT ABOVE 255, which one byte per character cannot express at all. Spelt with
'' escapes so the file stays ASCII and its meaning does not depend on how the source
'' encoding is detected.
dim as wstring * 4 u = wstr( !"\u00E9\u4E2D" )
print u
