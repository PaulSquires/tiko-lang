'' A USER-DEFINED BINARY OPERATOR IS A CALL, and it was not being made. 'x - y' over
'' two UDTs went down the builtin path -- and a UDT with an 'operator cast' to a number
'' then SUBTRACTED THE RAW AGGREGATES as integers, emitting code, verifying, and never
'' reaching the operator that was written. Which is how every value type in fbc's own
'' headers does arithmetic.
''
'' The mangled name was wrong too: a global operator is _ZmiR1DS0_ to fbc -- the
'' operator CODE and its parameters -- and fbx emitted a function literally named '-',
'' because "not nested and not overloaded" took the spelling verbatim.
type D
    v as long
    declare operator cast( ) as long
end type
operator D.cast( ) as long
    return this.v
end operator

declare operator - ( byref a as D, byref b as D ) as D
operator - ( byref a as D, byref b as D ) as D
    dim r as D
    return r
end operator

declare operator * ( byref a as D, byval n as long ) as D
operator * ( byref a as D, byval n as long ) as D
    dim r as D
    return r
end operator

sub G( )
    dim x as D, y as D
    dim as D a = x - y
    '' AN OPERAND WITH NO ADDRESS -- another operator's result -- gets a temporary,
    '' the same answer a byref call argument gets.
    dim as D b = ( x - y ) * 2
    '' A MEMBER arithmetic operator is not written here on purpose: fbc REFUSES one --
    '' error 153, 'Operator cannot be a member function (TODO)' -- so the global form is
    '' the only one a real program can have.
end sub
