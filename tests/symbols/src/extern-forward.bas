'' An EXTERN is a FORWARD DECLARATION, not a definition. Measured against fbc:
''
''   extern a as integer  +  dim shared a as integer = 1     accepted
''   extern a as integer  twice                              accepted
''   extern a() as integer twice                             accepted
''   extern a(any) + extern a(any)                           accepted
''   extern a(0 to 2) + dim a(0 to ...) = {1,2,3}            accepted -- the ellipsis
''                                                           resolves to the same bound
''
'' and REJECTED, each with its own fbc error:
''
''   different dtype                 error 4    Duplicated definition
''   different array shape           error 54   Expected var-len array
''   different fixed-string length   error 20   Type mismatch
''   different bounds                error 37   Array boundaries do not match
''   extern byref vs a plain dim     error 20   Type mismatch
''   extern a(any) vs dim a(0 to 2)  error 54
''
'' The comparison is SYNTACTIC, because Collect runs before any type exists, and
'' PERMISSIVE: anything it cannot compare counts as agreeing. Rejecting is the
'' direction that loses a working file -- 'extern a as MyInt' against 'dim shared a as
'' integer' is legal when MyInt is a typedef for integer.
''
'' This file holds only the ACCEPTED shapes. The rejections are checked against the
'' corpus, where 29 files exist for exactly that and were passing by accident.

extern a as integer
dim shared a as integer = 1

extern b as integer
extern b as integer

extern c( ) as integer
extern c( ) as integer

extern d( any ) as integer
extern d( any ) as integer

extern e as zstring * 4
dim shared e as zstring * 4

extern f( 0 to 2 ) as integer
dim shared f( 0 to 2 ) as integer

print a

'' VAR-LEN against FIXED is the distinction between two array shapes, not the dimension
'' count. Measured, and it took two passes because the obvious rule fits three rows and
'' not the fourth:
''
''   ()        vs (any)        accepted, either order
''   ()        vs (any,any)    accepted
''   (any)     vs (any,any)    fbc error 36, wrong number of dimensions
''   ()        vs (0 to 1)     fbc error 54, EXPECTED VAR-LEN ARRAY
''
'' A bounds list with nothing written, or with every dimension 'any', is VAR-LEN. One
'' with a real bound is FIXED. The two never agree; two var-len forms agree unless both
'' wrote a count and the counts differ.

extern g( ) as integer
extern g( any ) as integer

extern h( any, any ) as integer
extern h( ) as integer

print a
