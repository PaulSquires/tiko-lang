'' moveonly.bas -- RFC 0018 P3, V4: a NON-COPYABLE type is MOVABLE.
''
'' TIKO-ONLY: fbc refuses 'return h' over a private copy constructor (its 205), and has no
'' 'move'.
''
'' Owner owns a heap cell and declares its copy constructor and 'let' private and never
'' defines them -- the idiom std/tasks' WaitGroup and fb/comptr.bi use. A copy would fail to
'' LINK, so every line below that runs is proof that nothing copied. Handle is the same idiom
'' over a type with NO destructor, whose temporaries are never registered for destruction.
'' tests/diagnostics/move-noncopyable.test holds the copies that must still be refused.

dim shared as long liveCells

type Owner
private:
    as long ptr p
    declare constructor( byref rhs as Owner )
    declare operator let( byref rhs as Owner )
public:
    declare constructor( )
    declare constructor( byval v as long )
    declare destructor( )
    declare function Value( ) as long
end type

constructor Owner( )
end constructor
constructor Owner( byval v as long )
    p = callocate( sizeof( long ) ) : *p = v : liveCells += 1
end constructor
destructor Owner( )
    if p then deallocate( p ) : liveCells -= 1
end destructor
function Owner.Value( ) as long
    if p = 0 then return -1
    return *p
end function

type Handle
private:
    declare constructor( byref rhs as Handle )
public:
    as long id
    declare constructor( byval i as long )
end type
constructor Handle( byval i as long )
    id = i
end constructor

function OpenLocal( byval v as long ) as Owner
    dim as Owner h = Owner( v )
    return h                          '' a local: moved
end function

function OpenTemp( byval v as long ) as Owner
    return OpenLocal( v * 10 )        '' a call's result: moved
end function

function OpenMoved( byval v as long ) as Owner
    dim as Owner a = Owner( v )
    return move( a )
end function

function MakeHandle( byval i as long ) as Handle
    dim as Handle h = Handle( i )
    return h                          '' no destructor, still moved
end function

function PassHandle( ) as Handle
    return MakeHandle( 7 )            '' an unregistered temporary, moved
end function

sub Consume( byval o as Owner )
    print "  consumed " & o.Value( )
end sub

sub TakeHandle( byval h as Handle )
    print "  handle " & h.id
end sub

scope
    dim as Owner a = OpenLocal( 1 )
    print "V1 return local: " & a.Value( )
    dim as Owner b = OpenTemp( 2 )
    print "V2 return f( ): " & b.Value( )
    dim as Owner c = OpenMoved( 3 )
    print "V3 return move( a ): " & c.Value( )
    dim as Owner d = move( a )
    print "V4 dim d = move( a ): d=" & d.Value( ) & " a=" & a.Value( )
    b = move( c )
    print "V5 b = move( c ): b=" & b.Value( ) & " c=" & c.Value( )
    Consume( move( d ) )
    print "V6 Consume( move( d ) ): d=" & d.Value( )
    Consume( OpenLocal( 4 ) )
    print "V7 Consume( OpenLocal( ) ) done"
    dim as Handle h = PassHandle( )
    print "V8 Handle through two returns: " & h.id
    TakeHandle( MakeHandle( 8 ) )
    print "V9 cells live in scope: " & liveCells
end scope
print "V10 cells live after scope: " & liveCells
