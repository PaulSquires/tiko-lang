'' VIRTUAL AND ABSTRACT COME LAST, BELONG TO A TYPE, AND ARE NOT FOR A CONSTRUCTOR.
'' MEASURED against fbc:
''     const virtual sub          OK       -- the modifier run may lead with const
''     virtual const / virtual static / static virtual / virtual abstract   error 17
''     declare virtual sub f( ) at module level                             error 17
''     declare virtual constructor( )      error 211    abstract constructor  error 210
''     declare abstract destructor( )      error 212    virtual destructor    OK
type Good extends object
    dummy as integer
    declare virtual sub v( )
    declare const virtual sub cv( )
    declare abstract sub a( )
    declare virtual destructor( )
end type

type Bad extends object
    dummy as integer
    declare virtual const sub b1( )
    declare virtual static sub b2( )
    declare static virtual sub b3( )
    declare virtual abstract sub b4( )
    declare virtual constructor( )
    declare abstract destructor( )
end type

declare virtual sub loose( )
