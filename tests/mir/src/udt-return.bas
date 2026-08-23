'' RETURNING A UDT.
''
'' fbc makes a TWO-valued frontend decision, not a three-valued one, and leaves
'' register-versus-memory to the C compiler. MIR says the same thing and leaves it to
'' whatever consumes MIR.
''
''     explicit hidden pointer  <==>  the type has a DESTRUCTOR or a COPY CONSTRUCTOR
''
'' SIZE PLAYS NO PART. A one-byte type with a destructor goes through the pointer; a
'' twenty-four-byte POD does not. See docs/internals/phase-6-udt-return.md.

'' TRIVIAL -- returned by value out of a result slot, exactly as fbc returns fb$result.
type V
    x as double
    y as double
    z as double
end type

function MakeV( byval a as double ) as V
    dim as V t
    t.x = a
    function = t
end function

function MakeV2( ) as V
    dim as V t
    return t
end function

'' NON-TRIVIAL -- a destructor forces the hidden pointer at any size. It is PARAMETER
'' 0, before 'this', so every later parameter shifts up one; the function returns that
'' same pointer; and there is no result local at all -- the pointer IS the result
'' object, so 'function = t' writes straight through it.
type D
    v as integer
    declare destructor( )
end type
destructor D( )
end destructor

function MakeD( byval k as integer ) as D
    dim as D t
    t.v = k
    function = t
end function

sub P( )
    dim as V a = MakeV( 1.0 )
    dim as V b
    b = MakeV2( )

    '' The caller provides the storage for the hidden-pointer form: a temporary passed
    '' as argument 0. STATED DEFECT: fbc destroys that temporary at the end of the
    '' statement and tiko-lang does not model that yet, so this leaks one object per call.
    dim as D c1 = MakeD( 1 )
    dim as D c2
    c2 = MakeD( 2 )
end sub
