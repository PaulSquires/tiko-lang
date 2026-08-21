'' A TYPEDEF MAY NAME A TYPE DECLARED LATER.
''
'' Resolve walks in source order, so 't' below resolved against a 'u' that had nothing
'' behind it yet. Two things went wrong at once and only the second was visible:
''
''   - 't' stayed bound to u's PLACEHOLDER, the TK_TYPEDEF named type Collect gives
''     every typedef before Resolve reaches its declaration.
''   - 'dim as t i' therefore bound to something that lowers to VOID -- and it never
''     LOOKED unresolved, so nothing came back to it.
''
'' A placeholder is now treated as not-yet-resolved, which makes the declaration
'' record itself as pending, and a fixpoint pass finishes both.

type t as u
type u as integer
dim as t i
i = 0

'' A CHAIN needs one round per link.
type a2 as b2
type b2 as c2
type c2 as double
dim as a2 z
z = 1.5

'' The ordinary backward case still works.
type myint as long
dim as myint k
k = 5
