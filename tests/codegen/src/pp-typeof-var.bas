'' T61: typeof( name ) in #if, of variables, pointers, typedefs, a UDT named by a keyword.
type Point
    x as long
end type
type Alias_ as Point
type MyLong as long
enum Shade
    LIGHT
end enum
dim as long n = 3
dim as long ptr pn
dim as Point pt
dim as MyLong ml
dim as Shade sh
dim as string s
#if typeof( n ) = typeof( long )
print "n long"
#endif
#if typeof( pn ) = typeof( long ptr )
print "pn long ptr"
#endif
#if typeof( pn ) = typeof( long )
print "WRONG pn long"
#endif
#if typeof( pt ) = typeof( Point )
print "pt Point"
#endif
#if typeof( pt ) = typeof( Alias_ )
print "pt Alias_"
#endif
#if typeof( ml ) = typeof( long )
print "ml long"
#endif
#if typeof( sh ) = typeof( Shade )
print "sh Shade"
#endif
#if typeof( s ) = typeof( string )
print "s string"
#endif
#if typeof( n ) = typeof( integer )
print "WRONG n integer"
#endif
#if typeof( long ptr ) = typeof( long )
print "WRONG long ptr = long"
#endif
