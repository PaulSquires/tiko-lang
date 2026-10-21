'' 'new T( u )' with a ustring u for a 'byval as wstring ptr' constructor parameter passes
'' u's UTF-16 data pointer (NULL for ""), as 'T( u )' and a plain call do; an rvalue
'' passes a temporary's, deleted after the statement.

type T
    as long n
    declare constructor( byval p as wstring ptr )
    declare constructor( byval h as any ptr, byval x as long )
end type
constructor T( byval p as wstring ptr )
    if p then this.n = len( *p ) else this.n = -1
end constructor
constructor T( byval h as any ptr, byval x as long )
    this.n = -2
end constructor

type S1
    as long n
    declare constructor( byval p as wstring ptr )
end type
constructor S1( byval p as wstring ptr )
    if p then this.n = len( *p ) else this.n = -1
end constructor

function Mk( byval s as ustring ) as ustring
    return s & "!"
end function

sub Go( byval s as ustring )
    dim as T ptr q = new T( s )
    dim as S1 ptr r = new S1( s )
    dim as T ptr m = new T( Mk( s ) )
    print q->n; r->n; m->n
    delete q : delete r : delete m
end sub

Go( "hello" )
Go( "" )
