'' A private copy constructor and a byval copy with no variable to name: TKO0633 at line 14
'' named '' -- it now names the type.
type NC
    a as long
    declare constructor( )
    private:
    declare constructor( byref o as const NC )
end type
constructor NC( )
end constructor
constructor NC( byref o as const NC )
end constructor
sub Take( byval x as NC ) : end sub
dim as NC n : Take( n )
