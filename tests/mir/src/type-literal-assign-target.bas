'' 'x = type( ... )' into every kind of storage. See
'' tests/mir/type-literal-assign-target.test.
''
'' fbc-modern 1.20 prints:
''
''     shared: 1 2 30             (col, a ULONG, is 0 -- printed flush)
''     shared typed: 47
''     local: 8 10
''     byref: 21 23
''     byval inside: 31 33
''     after byval: 21
''     static: 1 2 3
''     namespace: 41 43
''     elements: 5 7 5 7

type V3
    as single x, y, z
    as ulong col
end type

namespace ns
    dim as V3 nv
end namespace

dim shared as V3 sh
dim shared as V3 arr( 0 to 1 )

sub byrefp( byref p as V3 )
    p = type( 21, 22, 23 )
end sub

sub byvalp( byval q as V3 )
    q = type( 31, 32, 33 )
    print "byval inside:"; q.x; q.z
end sub

function stat( ) as single
    static as V3 st
    st = type( st.x + 1, 2, 3 )
    return st.x
end function

sh = type( 1, 2, 3 )
print "shared:"; sh.x; sh.y; sh.z; sh.col
sh = type<V3>( 4, 5, 6, 7 )
print "shared typed:"; sh.x; sh.col
dim as V3 lv
lv = type( 8, 9, 10 )
print "local:"; lv.x; lv.z
byrefp( lv )
print "byref:"; lv.x; lv.z
byvalp( lv )
print "after byval:"; lv.x
print "static:"; stat( ); stat( ); stat( )
ns.nv = type( 41, 42, 43 )
print "namespace:"; ns.nv.x; ns.nv.z
arr( 0 ) = type( 5, 6, 7 )
arr( 1 ) = type<V3>( 5, 6, 7 )
print "elements:"; arr( 0 ).x; arr( 0 ).z; arr( 1 ).x; arr( 1 ).z
