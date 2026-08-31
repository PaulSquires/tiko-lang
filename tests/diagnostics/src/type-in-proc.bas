'' A TYPE DECLARED INSIDE A PROCEDURE MAY NOT HAVE METHODS -- fbc error 263, "Objects
'' with default [con|de]structors or methods are only allowed in the module level". The
'' reason is in the corpus test's own comment: a method would need a NESTED PROCEDURE,
'' and FreeBASIC has none.
''
'' Every way of acquiring one counts. Measured, one probe each, all error 263:
''
''     declare sub / constructor / destructor / property / operator let   direct
''     x as UDT1        where UDT1 has a constructor or a destructor      by FIELD
''     extends UDT1     where UDT1 has one                                by BASE
''
'' 'extends' needs no case of its own: fbc spells the base as a FIELD NAMED 'base', so
'' it is walked with the rest. A SCOPE BLOCK INSIDE A PROCEDURE IS STILL INSIDE IT.
type HasCtor
    dummy as integer
    declare constructor( )
end type

constructor HasCtor( )
end constructor

'' -- refused ------------------------------------------------------------------
sub withMethod( )
    type A
        dummy as integer
        declare sub f( )
    end type
end sub

sub withCtor( )
    type B
        dummy as integer
        declare constructor( )
    end type
end sub

sub withOperator( )
    type C
        dummy as integer
        declare operator let( byref rhs as C )
    end type
end sub

sub withFieldCtor( )
    type D
        x as HasCtor
    end type
end sub

sub withBaseCtor( )
    type E extends HasCtor
        dummy as integer
    end type
end sub

'' A var-len string carries its own destructor. A FIXED one does not, and telling the
'' two apart is why 'string * len( K )' had to start folding first.
sub withVarLenString( )
    type F0
        s as string
    end type
end sub

sub inNestedScope( )
    scope
        type F1
            dummy as integer
            declare sub f( )
        end type
    end scope
end sub

'' -- accepted -----------------------------------------------------------------
sub plainFields( )
    type G
        a as integer
        b as double
    end type
    dim as G g
end sub

sub plainUnion( )
    union H
        a as integer
        b as integer
    end union
    dim as H h
end sub

'' At MODULE level a method is exactly what a type is for.
type AtModuleLevel
    dummy as integer
    declare sub f( )
end type

sub AtModuleLevel.f( )
end sub
