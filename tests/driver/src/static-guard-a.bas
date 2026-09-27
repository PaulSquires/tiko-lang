'' Module one of the pair: the constructor, and a private nextId holding a constructed
'' static. Module two has a private nextId of the same name with its own static; both
'' guards are named NEXTID$c$init and must be module-local, as fbc emits them.
type Cnt
    n as long
    declare constructor( )
end type
constructor Cnt( )
    n = 10
end constructor
private function nextId( ) as long
    static c as Cnt
    c.n += 1
    return c.n
end function
declare sub other( )
print nextId( )
other( )
