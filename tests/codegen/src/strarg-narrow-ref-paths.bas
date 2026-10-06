'' One narrow 'byref as string' rule on every path (NarrowRefStrArg_): a temporary for a fixed,
'' wide or rvalue argument, copied back into a sized fixed or wide lvalue -- after a call, a
'' constructor, an operator and a self-operator alike, CONST parameter or not.
type T
    as string seen
    declare constructor( byref x as string )
    declare constructor( byref x as const string, byval k as long )
    declare operator += ( byref x as string )
    declare operator -= ( byref x as const string )
end type
constructor T( byref x as string )
    seen = x : x = "ctor"
end constructor
constructor T( byref x as const string, byval k as long )
    seen = x
end constructor
operator T.+= ( byref x as string )
    seen = x : x = "op"
end operator
operator T.-= ( byref x as const string )
    seen = x
end operator
sub p( byref x as const string )
    print "  p saw ["; x; "]"
end sub
dim as zstring * 8 z = "zz"
dim as string * 6 f = "ff"
dim as wstring * 8 w = wstr( "ww" )
dim as T a = T( z ) : print "ctor z: ["; a.seen; "] z=["; z; "]"
dim as T b = f : print "conv f: ["; b.seen; "] f=["; f; "]"
dim as T c2 = T( w, 1 ) : print "cctor w: ["; c2.seen; "]"
a += w : print "op w: ["; a.seen; "] w=["; w; "]"
a += f : print "op f: ["; a.seen; "] f=["; f; "]"
a -= z : print "cop z: ["; a.seen; "] z=["; z; "]"
p( z ) : p( f ) : p( w )
