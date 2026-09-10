'' AN ENUM MEMBER YIELDS THE UNQUALIFIED NAME TO ANYTHING ELSE, in either declaration
'' order, and stays reachable as 'E.K'. Measured on fbc by running, and the member never
'' wins:
''
''     enum E : K = 9 : end enum : dim shared K as long = 7
''         K -> 7    E.K -> 9        ...and the same with the DIM written FIRST
''     enum E : K = 9 : end enum : const K = 1
''         K -> 1    E.K -> 9
''     enum E : K = 9 : end enum : sub K( ) ... end sub      accepted
''     the member alone                     K -> 9
''
'' Collect already implemented the enum-LAST half: N_ENUM_ITEM declines to publish
'' unqualified when the name is already taken, with the rule written above it. THE OTHER
'' ORDER was the gap -- the enum published first and the 'dim' after it was reported as
'' 'already declared in this scope', for a program fbc compiles.
''
'' Overwriting the enclosing binding is safe because the member has its OWN copy in the
'' enum's scope, which is what 'E.K' resolves through; the enclosing one is the
'' unqualified convenience alone.
''
'' HANDOFF's entry for this named five corpus files. FOUR of them no longer reproduce it
'' -- only namespace/enum-shadowed-by-var did, and it is this shape.
enum E
	K = 9
end enum
dim shared K as long = 7

enum E2
	M = 5
end enum
const M = 1

'' ...and with nothing else claiming the name, the member still answers unqualified.
enum E3
	Q = 3
end enum

print K, E.K
print M, E2.M
print Q, E3.Q
