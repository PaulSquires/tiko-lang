'' TWO RULES, both measured.
''
'' A LITERAL CANNOT BE ASSIGNED TO -- fbc error 24, "Invalid data types". It has no
'' storage to write into. (The corpus writes it as ': 0 = 1', the colon there only to stop
'' the 0 being read as a line label.)
''
'' AND A 'const' DECLARATION MAY NOT CROSS THE STRING/NUMBER DIVIDE -- fbc error 20 one way
'' and 24 the other:
''
''     const s as string = 1       error 20
''     const s as integer = "x"    error 24
''     const s as string = "x"     OK
''     const s as double = 1       OK        widening within the numbers is fine
''
'' NARROWED TO THAT ONE DIVIDE deliberately: everything numeric converts to everything
'' numeric in a constant, and answering which narrowings fbc also refuses is a separate
'' measurement.
''
'' NOT DONE: '*cptr( const integer ptr, pi ) = 123', which is fbc error 119. tiko-lang does
'' not yet tell 'const integer ptr' -- a pointer to a CONSTANT -- from 'integer const ptr',
'' a CONSTANT pointer to a writable integer; both put the qualifier on the pointee, so
'' testing it refused five files fbc accepts.

'' -- refused ------------------------------------------------------------------
const badStr as string = 1
const badNum as integer = "x"

sub refused( )
    : 0 = 1
end sub

'' -- accepted -----------------------------------------------------------------
const okStr as string = "x"
const okNum as integer = 1
const okWide as double = 1
const okInferred = 1
