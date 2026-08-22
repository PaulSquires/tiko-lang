'' A PROPERTY ACCESS -- 't.V' with no parentheses, and 't.V = x'.
''
'' BOTH ARE CALLS. fbc emits '_ZN1T8V__get__Ev( &T )' and '_ZN1T8V__set__Ei( &T, 5 )',
'' and the mangler here already knew both suffixes -- it was LOWERING that had no case.
'' A bare property read declined, and a property WRITE went to the ordinary store path,
'' which looked for a field of that name, found a procedure and declined too.
''
'' 't.V( )' WITH parentheses already worked, because that is an ordinary call. The whole
'' gap was the spelling without them -- which is the one properties are actually used in.
'' 'd1.Year', 'd1.Month' and 'd1.Day' appear on one line of the chrono header, and the
'' finance headers are built on it.
''
'' WHICH OVERLOAD IS DECIDED BY ARITY, not by the name: the getter takes none and the
'' setter one, they share a symbol chain, and taking the head of it picks whichever was
'' declared first.

type T
    v_ as long
    declare property V( ) as long
    declare property V( byval n as long )
end type
property T.V( ) as long
    return this.v_
end property
property T.V( byval n as long )
    this.v_ = n
end property
sub P( )
    dim as T t
    dim as long n = t.V
    t.V = 5
    n = t.V( )
end sub
