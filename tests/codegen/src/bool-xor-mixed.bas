'' XOR over two booleans when one is a CONSTANT or a COMPARISON: both are -1 where a
'' boolean variable holds 1, and 'true xor b' was -2, true. Expected output is fbc 1.10.1's.
dim as boolean a = true, b = true, f = false
print ( a xor b ); ( true xor b ); ( (f = false) xor b ); ( b xor (f = false) )
print ( false xor b ); ( true xor f ); ( (f = false) xor f ); ( true xor (f = false) )
dim as boolean r = true xor b : print r; cint( true xor b ); cint( true xor f )
if (f = false) xor b then print "T" else print "F"
print not ( true xor b ); ( (true xor b) = false )
dim as boolean c = true : c xor= true : print c;
c = true : c xor= (f = false) : print c;
c = b : c or= true : print ( c xor b )
dim as boolean arr(1) = { true, true }
arr(0) xor= true : print arr(0); ( true xor arr(1) )
dim as int32 n = true xor b : print n
