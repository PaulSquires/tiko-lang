'' A bare 'width' used as a value is a call. See tests/mir/bare-width-value.test.

dim as long a = width
var wd = loword( width )
dim as long b = width( )
dim as long c = hiword( width )
print hex( a ), wd, hex( b ), c
