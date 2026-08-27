'' 'u += v' OVER A UDT IS A MEMBER CALL.
''
'' It was not lowered at all: the compound-assignment path bailed on an aggregate target
'' before it ever looked for an operator, so every self-operator over a UDT declined --
'' while 'u = u + v' beside it, through a global 'operator +', lowered perfectly. Nothing
'' in the checker resolves one either, so the operator is found here, by name.
''
'' Measured: no temporary anywhere and no read-modify-write. fbc emits the member call
'' with the TARGET'S ADDRESS as the receiver and nothing else --
''
''     _ZN1TpLERS_( &U$0, &V$0 );
''
'' THE MEMBER NAME IS THE SPELLING IT WAS DECLARED WITH. The punctuation forms lex as one
'' token and the word forms as two, which the parser joins -- so 'operator and=' is a
'' member called 'and=', and looking for 'and' would find the binary operator instead.
''
'' THE OVERLOAD IS CHOSEN BY THE PARAMETER'S TYPE. A type may declare '+=' for several
'' right-hand types, and taking the head of the chain would take one at random; an
'' operand that matches none declines rather than being converted on a guess.
type T
    as long i
    declare operator += ( byref rhs as T )
    declare operator += ( byval n as long )
    declare operator -= ( byref rhs as T )
    declare operator shl= ( byval n as long )
end type

operator T.+= ( byref rhs as T )
    this.i += rhs.i
end operator

operator T.+= ( byval n as long )
    this.i += n
end operator

operator T.-= ( byref rhs as T )
    this.i -= rhs.i
end operator

operator T.shl= ( byval n as long )
    this.i shl= n
end operator

sub s1( )
    dim as T u, v
    v.i = 3
    u += v
    u += 10
    u -= v
    u shl= 2
    print u.i
end sub

s1( )
