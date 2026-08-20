'' An IDENTICAL redeclaration is not a duplicate -- for an ALIAS. Measured:
''
''   type INT_ as long   twice              accepted
''   type INT_ as long / as double          fbc error 4
''   const I1 = 0        twice              accepted
''   const I1 = 0 / const I1 = 1            fbc error 4
''   const as long I1 = 0 / as double I1 = 0  fbc error 4 -- the TYPE counts too
''   an identical UDT BODY twice            fbc error 4
''   an identical DIM twice                 fbc error 4
''
'' A DEFINITION may not be restated; an ALIAS may. Same rule family as the identical
'' '#define', which is the third member of it.
''
'' The Windows headers rely on the typedef half: 'type INT_ as long' appears in ntdef.bi,
'' windef.bi AND winnt.bi, and 14 corpus files include more than one of them.
''
'' The value comparison is permissive: only integer literals are compared, and anything
'' else counts as agreeing. That can accept a pair fbc would reject, which is the
'' direction that does not lose a working file.

type INT_ as long
type INT_ as long

const I1 = 0
const I1 = 0

const as long L1 = 7
const as long L1 = 7

dim shared x as INT_
print x, I1, L1
