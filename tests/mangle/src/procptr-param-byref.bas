'' A PROCEDURE TYPE'S PARAMETERS TAKE THE SAME DEFAULT A PROCEDURE'S DO -- byref for a
'' UDT or a string, byval for everything else. WalkStmt settles that for a real
'' declaration by writing NF_BYREF onto the node; these N_PARAMs belong to a TYPEREF and
'' it never reaches them, so 'sub( as UDT1 )' came out taking a UDT BY VALUE.
''
'' Measured against fbc's own object symbols, which is the only oracle for a name.
type UDT1
	i as integer
end type

'' AND A TYPEDEF WHOSE TARGET IS NEVER DEFINED IS A FORWARD REFERENCE, not nothing.
'' 'type FWDREF1 as FWDREF1_' is how FreeBASIC spells an opaque handle. tiko left the
'' alias with no type at all, so the parameter came out VOID and two overloads that
'' differ only in it mangled to the SAME NAME: clang's 'invalid redefinition of
'' function _Z2F1PFvvE'. Silently, with no diagnostic before the emitter.
type FWDREF1 as FWDREF1_
type FWDREF2 as FWDREF2_

sub g1 overload( byval p as sub( as UDT1     ) ) : end sub
sub g1 overload( byval p as sub( as FWDREF1  ) ) : end sub
sub g1 overload( byval p as sub( as FWDREF2  ) ) : end sub
sub g1 overload( byval p as sub( as string   ) ) : end sub
sub g1 overload( byval p as sub( as long     ) ) : end sub
sub g1 overload( byval p as sub( byval as UDT1 ) ) : end sub

'' AN ARRAY PARAMETER IS A REFERENCE TO THE FBARRAY TEMPLATE, AND THE RANK IS IN THE
'' TEMPLATE'S NAME. Every rank was written '7FBARRAY', so two overloads differing only
'' in it were ONE SYMBOL -- ordinary code, no generics and no procedure pointers.
sub k1 overload( a( ) as integer ) : end sub
sub k2 overload( a( any ) as integer ) : end sub
sub k3 overload( a( any, any ) as integer ) : end sub

'' ...and the same inside a PROCEDURE TYPE, where the parameter was dropped entirely.
sub m1 overload( byval p as sub( array( ) as integer ) ) : end sub
sub m2 overload( byval p as sub( array( any ) as integer ) ) : end sub
sub m3 overload( byval p as sub( array( any, any ) as integer ) ) : end sub

'' AN ELLIPSIS IN A PROCEDURE TYPE IS PART OF THE TYPE. It carries no argument, but
'' 'sub cdecl( byval as integer, ... )' and 'sub cdecl( byval as integer )' are two
'' different procedure-pointer types.
sub n1 overload( byval p as sub cdecl( byval as integer ) ) : end sub
sub n2 overload( byval p as sub cdecl( byval as integer, ... ) ) : end sub
