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
