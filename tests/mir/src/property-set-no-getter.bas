'' AN INDEXED PROPERTY SET WITH NO GETTER OF THAT ARITY. fbc binds the SETTER with the
'' written arguments first and the assigned value LAST -- measured on 1.20.0, this
'' program prints 703, so 'o.Opt( 7 ) = 3' calls Opt( 7, 3 ).
''
'' tiko typed the assignment TARGET as an ordinary expression, where a property setter
'' is deliberately not a candidate. With a getter of the same arity beside it that
'' typing happened to succeed and nothing showed -- which is why tests/mir/
'' indexed-property, declaring all four accessors, passed throughout. With only a plain
'' getter and an indexed setter, no candidate had the written arity and it reported
'' TKO0632 over a program fbc compiles.
''
'' AfxNova's CRichEditCtx declares exactly this pair:
''     DECLARE PROPERTY TypographyOptions () AS DWORD
''     DECLARE PROPERTY TypographyOptions (BYVAL pto AS LONG, BYVAL fMask AS LONG)
type T
    m as long
    declare property Opt( ) as long
    declare property Opt( byval idx as long, byval mask as long )
end type

property T.Opt( ) as long
    return this.m
end property

property T.Opt( byval idx as long, byval mask as long )
    this.m = idx * 100 + mask
end property

dim as T o
o.Opt( 7 ) = 3
print o.Opt
