'' String arguments to 'zstring ptr' / 'wstring ptr' CONSTRUCTOR and METHOD parameters.
type T
    as string seen
    declare constructor( byval p as zstring ptr )
    declare constructor( byval p as wstring ptr, byval k as long )
    declare sub mz( byval p as zstring ptr )
end type
constructor T( byval p as zstring ptr )
    seen = "z:" & *p
end constructor
constructor T( byval p as wstring ptr, byval k as long )
    seen = "w:" & *p
end constructor
sub T.mz( byval p as zstring ptr )
    seen = "mz:" & *p
end sub
dim as string s = "str"
dim as string * 6 f = "fix"
dim as wstring * 8 w = wstr( "wid" )
dim as ustring u = "ust"
dim as T a = T( s ) : print a.seen
dim as T b = T( f ) : print b.seen
dim as T c2 = T( w ) : print c2.seen
dim as T e = T( s, 1 ) : print e.seen
dim as T g = T( u, 1 ) : print g.seen
a.mz( f ) : print a.seen
a.mz( w ) : print a.seen
a.mz( s & "+" ) : print a.seen
