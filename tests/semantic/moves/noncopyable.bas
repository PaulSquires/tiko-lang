'' noncopyable.bas -- RFC 0018 P0, V4: returning a NON-COPYABLE type is rejected today.
''
'' The non-copyable idiom: copy constructor and let declared private (std/tasks'
'' WaitGroup, fb/comptr.bi's ComHeapPtr). Under V4 'return h' becomes a move and
'' compiles; 'dim b = a' must stay an error. The baseline is the compiler's diagnostics,
'' not a run: build/movetrace.sh records both compilers' exit code and messages.

type Owner
private:
    as long ptr p
    declare constructor( byref rhs as Owner )
    declare operator let( byref rhs as Owner )
public:
    declare constructor( byval v as long )
    declare destructor( )
    declare function Value( ) as long
end type

constructor Owner( byval v as long )
    p = callocate( sizeof( long ) ) : *p = v
end constructor
destructor Owner( )
    deallocate( p )
end destructor
function Owner.Value( ) as long
    return *p
end function

function OpenOwner( byval v as long ) as Owner
    dim as Owner h = Owner( v )
    return h                      '' V4: a move. Today: rejected.
end function

dim as Owner a = OpenOwner( 42 )
print a.Value( )
