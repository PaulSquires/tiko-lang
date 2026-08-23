'' Two constructs that used to parse into something plausible and WRONG, with no
'' diagnostic either way. Both only surfaced on a SECOND occurrence, as a redeclaration.
''
''   dim byref rb as string = a    parsed as a variable NAMED 'byref', rest discarded
''   enum E explicit               EXPLICIT eaten as the enum's first member
''
'' Measured against fbc:
''
''   dim byref rb as integer = a   accepted, with and without SHARED
''   dim byref rb as integer       fbc error 320, 'Reference not initialized'
''   enum E explicit               accepted; members reachable ONLY as E.A
''   a bare A for an explicit enum fbc error 42
''   a bare A for a plain enum     accepted
''
'' A REFERENCE ALIASES ITS INITIALIZER, and its slot holds a POINTER -- the same shape a
'' byref PARAMETER has, which is what made the rest fall out: Resolve types it as a
'' reference, so the slot lowers to a pointer and AddrOfVar loads it, and every read,
'' write and '@' of the alias goes through the indirection because all of them ask that
'' one function. Only the declaration had to learn to store an ADDRESS.
''
'' It declined for a while first, and that was the right answer at the time: parsing
'' BYREF without declining turned a statement that silently vanished into one that
'' silently aliased nothing. 'rb = 5 : print a' prints 5 under fbc; tiko-lang would have
'' printed 1.
''
'' A SHARED or STATIC alias is module storage holding an address, and fbc initialises it
'' STATICALLY -- 'int64* RG$ = &G$;'. A MIR global carries an integer, a float or a byte
'' image, none of which is a relocation, so the address is stored where the DECLARATION
'' is instead. Same value either way: the referent is module storage too, so its address
'' does not change between passes.
''
'' EXPLICIT is recorded and its SCOPING is not implemented: tiko-lang still resolves a bare
'' member where fbc gives error 42. Accepting more than fbc never loses a file; the
'' diagnostic is owed.

dim a as integer = 1
dim byref rb as integer = a
dim shared as integer g = 2
dim shared byref rg as integer = g

enum E explicit
	Ea
	Eb
end enum

enum Plain
	Pa
	Pb
end enum

print E.Ea, Plain.Pa, Pa
