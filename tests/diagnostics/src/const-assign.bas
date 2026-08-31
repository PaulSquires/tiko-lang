'' fbc error 119, "Cannot modify a constant". It fires for the SYMBOLIC form and for
'' the QUALIFIER alike, and a compound assignment is no different:
''
''     const i = 0 : i = 0            error 119, before '='
''     const i = 0 : i += 1           error 119, before '+'
''     dim as const integer i : i = 1 error 119, before '='
''
'' A POINTER TO CONST IS NOT A CONST POINTER. 'dim as const integer ptr p' makes the
'' POINTEE read-only and leaves p itself writable -- fbc accepts 'p = @q' -- so the
'' test is on the symbol's OWN type and never on what it points at.
const K = 0

dim shared as const integer ci = 0
dim shared as const integer ptr cp
dim shared as integer q

'' -- refused ------------------------------------------------------------------
K = 1
K += 1
ci = 1
ci += 1

'' -- accepted -----------------------------------------------------------------
cp = @q
q = K
q += K
