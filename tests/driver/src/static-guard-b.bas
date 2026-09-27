'' Module two of the pair; see static-guard-a.bas.
type Cnt
    n as long
    declare constructor( )
end type
private function nextId( ) as long
    static c as Cnt
    c.n += 2
    return c.n
end function
sub other( )
    print nextId( )
end sub
