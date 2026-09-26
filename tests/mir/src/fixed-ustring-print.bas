'' A 'ustring * N', PRINTED AND ASSIGNED A LITERAL. 'print u' over one printed NOTHING -- it
'' had no branch in PrintOne -- while 'print u & "!"' worked. And a literal with non-ASCII
'' characters in an ESCAPED spelling went into one a UTF-8 byte per unit: seven units for
'' four characters, and a real escape fourteen. Measured, fbc-modern prints 11 and 520,
'' Test string, [Test string], Test string and 1, el, then 4 4 4 2 3 and -1.
dim u as ustring * 260
u = "Test string"
print len( u ), sizeof( u )
print u
print "[" ; u ; "]"
print u, 1
dim a(1) as ustring * 8
a(1) = "el"
print a(1)
dim f as ustring * 16
dim v as ustring
f = !"aé中b"
print len( f );
v = !"aé中b"
print len( v );
f = !"a\u00E9\u4E2Db"
print len( f );
dim f2 as ustring * 16 = "xé"
print len( f2 );
dim f3 as ustring * 16 = !"x\té"
print len( f3 )
print f = v
