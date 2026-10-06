'' A 'ustring * N' and a wide value for a 'byref as ustring' parameter OUTSIDE the call path:
'' a constructor, an operator, a self-operator. Each callee writes its parameter.
type T
    as ustring seen
    declare constructor( byref x as ustring )
    declare operator += ( byref x as ustring )
end type
constructor T( byref x as ustring )
    seen = x : x = "C"
end constructor
operator T.+= ( byref x as ustring )
    seen = x : x = "O"
end operator
operator & ( byref a as T, byref x as ustring ) as string
    x = "A"
    return a.seen & "&" & x
end operator
dim as ustring * 8 uf = "uf"
dim as wstring * 8 w = wstr( "ww" )
dim as T a = T( uf ) : print "ctor uf: ["; a.seen; "] uf=["; uf; "]"
uf = "u2" : a += uf : print "op uf: ["; a.seen; "] uf=["; uf; "]"
dim as T b = T( w ) : print "ctor w: ["; b.seen; "]"
uf = "u3" : print "cat: ["; a & uf; "] uf=["; uf; "]"
