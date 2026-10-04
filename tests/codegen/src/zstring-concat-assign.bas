dim z as zstring * 30 = "abc"
z &= "def"
print z
dim zp as zstring ptr = allocate( 40 )
*zp = "dyn"
*zp &= "+more"
print *zp
dim f as string * 8 = "ab"
f &= "cd"
print "[" & f & "]"
dim w as wstring * 20 = wstr( "w1" )
w &= wstr( "w2" )
print w
