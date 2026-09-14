'' A term after the first that reads the destination builds in a temporary.
dim as string w = "XY"
dim as string s = "abcdefghij"
s = w & mid( s, 5 )
dim as wstring * 32 ww = "XY"
dim as wstring * 32 x = "abcdefghij"
x = ww & mid( x, 5 )
print s, x
