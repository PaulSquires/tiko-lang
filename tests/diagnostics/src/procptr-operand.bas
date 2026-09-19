'' WHAT 'procptr' TAKES HAS TO BE A PROCEDURE -- fbc's error 24, "Invalid data types",
'' over anything else that binds: a variable, a procedure-pointer variable, a CONST, an
'' enum constant, a TYPE, a namespace's variable -- and its 209 over a field. Each is
'' refused on exactly the line fbc-modern 1.20 and 1.10.1 refuse it (2026-09-19);
'' tiko-lang accepted them all.
type T
    a as integer
    declare sub m( )
    declare static sub s( )
end type
sub T.m( )
end sub
sub T.s( )
end sub
sub plain( )
end sub
namespace NS
    sub nsub( )
    end sub
    dim as integer nv
end namespace
dim as integer v
const K = 1
dim as sub( ) fp
enum E
    e1
end enum

dim as any ptr p1 = procptr( v )
dim as any ptr p2 = procptr( fp )
dim as any ptr p3 = procptr( K )
dim as any ptr p4 = procptr( T.a )
dim as any ptr p5 = procptr( NS.nv )
dim as any ptr p6 = procptr( T )
dim as any ptr p7 = procptr( e1 )
'' ...and what is no name at all -- fbc's error 8.
dim as any ptr p8 = procptr( 1 )
dim as any ptr p9 = procptr( @plain )

'' ACCEPTED: a procedure, a method, a static member, one in a namespace.
dim as any ptr q1 = procptr( plain )
dim as any ptr q2 = procptr( T.m )
dim as any ptr q3 = procptr( T.s )
dim as any ptr q4 = procptr( NS.nsub )
