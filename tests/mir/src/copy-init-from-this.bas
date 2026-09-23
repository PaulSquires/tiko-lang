'' 'dim child as T = this' COPY-CONSTRUCTS child, as 'dim child as T = v' does.
''
'' 'this' is held as a POINTER, so the initialiser's type was 'T ptr', the copy path's
'' same-UDT test failed, and the declaration fell through to the DEFAULT constructor and a
'' BITWISE store of the object over it: child and the receiver shared every buffer, and
'' both destructors freed them -- 0xC0000374. fb/logger.bi's Logger_.WithName and
'' WithField are exactly this, 'dim child as Logger_ = this', and logger_sinks crashed.
'' Measured, fbc runs the implicit copy constructor -- each field default-constructed,
'' then assigned -- and never the type's own constructor body.
''
'' fbc prints, one per line:
''   Buf ctor # 1 / Outer ctor / Buf ctor # 2 / Buf let # 2 = # 1 / Buf ctor # 3 /
''   Buf let # 3 = # 2 / Outer dtor [db] / Buf dtor # 2 / n2 = [db] o = [] /
''   Outer dtor [db] / Buf dtor # 3 / Outer dtor [] / Buf dtor # 1 / end
type Buf
    dim as long ptr p
    dim as long id
    declare constructor( )
    declare constructor( byref o as Buf )
    declare operator let( byref o as Buf )
    declare destructor( )
end type
dim shared as long nextId = 0
constructor Buf( )
    nextId += 1 : id = nextId
    p = allocate( 16 )
    print "  Buf ctor #"; id
end constructor
constructor Buf( byref o as Buf )
    nextId += 1 : id = nextId
    p = allocate( 16 )
    print "  Buf copy #"; id; " from #"; o.id
end constructor
operator Buf.let( byref o as Buf )
    print "  Buf let #"; id; " = #"; o.id
end operator
destructor Buf( )
    print "  Buf dtor #"; id
    deallocate( p )
end destructor

type Outer
    declare constructor( )
    declare destructor( )
    declare function WithTag( byref n as ustring ) as Outer
    dim as ustring m_name
    dim as Buf m_b
end type
constructor Outer( )
    print " Outer ctor"
end constructor
destructor Outer( )
    print " Outer dtor ["; m_name; "]"
end destructor
function Outer.WithTag( byref n as ustring ) as Outer
    dim child as Outer = this
    child.m_name = n
    return child
end function

scope
    dim o as Outer
    dim n2 as Outer = o.WithTag( "db" )
    print "n2 = ["; n2.m_name; "] o = ["; o.m_name; "]"
end scope
print "end"
