'' See tests/diagnostics/member-of-string.test.
type B
    x as long
    declare constructor( byval p as any ptr )
end type
constructor B( byval p as any ptr )
end constructor

type T
    pb as B ptr
    declare sub Load( byval path as ustring )
end type
sub T.Load( byval path as ustring )
    pb = new B( path.sptr( ) )
end sub

dim w as wstring * 10
dim z as zstring * 10
dim s as string * 4
dim u as ustring * 4
w.sptr( )
dim p as any ptr = z.sptr( )
print s.foo
print u.foo
dim q as long ptr = new( p ) long[ len( u.n ) ]
