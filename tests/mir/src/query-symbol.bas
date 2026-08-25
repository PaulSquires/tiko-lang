'' '__FB_QUERY_SYMBOL__' -- fbc's compile-time symbol query, and the enum-member paths
'' that are the only way its query codes are ever written.
namespace ns1
    sub proc1( ) : end sub
end namespace

type T
    fld1 as integer
end type

union U
    a as integer
end union

enum E
    elem
end enum

type ALIAS_L as long ptr

sub proc( byval p as integer ) : end sub
declare function fnc( ) as double

dim shared v as integer
const kk as integer = 1
dim shared s as string
dim shared d as double
dim shared pl as long ptr
dim shared cz as const zstring ptr
dim shared ci as const integer = 1
dim shared t0 as T
dim shared arr( 0 to 3 ) as long
dim shared zf as zstring * 8
dim shared wf as wstring * 8
dim shared us as ustring
dim shared fsx as string * 8
dim shared pp as any ptr
dim shared ppp as long ptr ptr

#define Q(sym) print __FB_QUERY_SYMBOL__( 0, sym ), __FB_QUERY_SYMBOL__( 1, sym ), __FB_QUERY_SYMBOL__( 2, sym ), __FB_QUERY_SYMBOL__( 7, sym )

Q( v )
Q( kk )
Q( proc )
Q( fnc )
Q( ns1 )
Q( ns1.proc1 )
Q( T )
Q( U )
Q( E )
Q( ALIAS_L )
Q( s )
Q( d )
Q( pl )
Q( cz )
Q( ci )
Q( t0 )
Q( arr )
Q( zf )
Q( wf )
Q( us )
Q( fsx )
Q( pp )
Q( ppp )
Q( T.fld1 )
Q( elem )
Q( E.elem )
