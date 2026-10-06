'' Copy-back of a byref string argument OUTSIDE the plain call path: a constructor, a method,
'' an operator, a property setter, a self-operator. Each callee writes its parameter.
type T
    as long n
    declare constructor( byref x as ustring )
    declare constructor( byref x as string, byval k as long )
    declare sub mu( byref x as ustring )
    declare sub ms( byref x as string )
    declare operator += ( byref x as ustring )
end type
constructor T( byref x as ustring )
    x = "C-u"
end constructor
constructor T( byref x as string, byval k as long )
    x = "C-s"
end constructor
sub T.mu( byref x as ustring )
    x = "M-u"
end sub
sub T.ms( byref x as string )
    x = "M-s"
end sub
operator T.+= ( byref x as ustring )
    x = "O-u"
end operator
dim as string s = "s0"
dim as string * 8 f = "f0"
dim as zstring * 8 z = "z0"
dim as wstring * 8 w = wstr( "w0" )
dim as ustring * 8 uf = "u0"
dim as T a = T( s ) : print "ctor u  s=["; s; "]"
dim as T b = T( f ) : print "ctor u  f=["; f; "]"
dim as T c2 = T( z, 1 ) : print "ctor s  z=["; z; "]"
dim as T d = T( f, 1 ) : print "ctor s  f=["; f; "]"
a.mu( s ) : print "mu s=["; s; "]"
a.mu( z ) : print "mu z=["; z; "]"
a.mu( w ) : print "mu w=["; w; "]"
a.ms( uf ) : print "ms uf=["; uf; "]"
a.ms( z ) : print "ms z=["; z; "]"
s = "s1" : a += s : print "op s=["; s; "]"
f = "f1" : a += f : print "op f=["; f; "]"
