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
'' A REFERENCE aliases its initializer. fbx does not implement the indirection, so the
'' declaration AND every use DECLINE -- 'var byref' in the sweep. That matters: parsing
'' BYREF without declining turned a statement that silently vanished into one that
'' silently aliased nothing. 'rb = 5 : print a' prints 5 under fbc; fbx would have
'' printed 1.
''
'' EXPLICIT is recorded and its SCOPING is not implemented: fbx still resolves a bare
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
