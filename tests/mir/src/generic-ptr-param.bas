'' 'byval p as T ptr' -- A POINTER PARAMETER STILL NAMES T. Pointers were skipped with
'' the array and procedure-type forms, so this inferred NOTHING and never instantiated
'' -- and the call went out as 'declare void DEREF()', a name with no body and no result
'' type, WITH NO DECLINE to say so. fbc emits '_Z5DerefIiEPi( &V$0 )' and prints 99.
''
'' Two halves were missing: the pointer parameter itself, whose name is one level in --
'' a pointer type-ref WRAPS, so the NF_PTR flag and the name are on different nodes --
'' and '@v' as an ARGUMENT, which was answered only when it named a PROCEDURE.
function Deref( of T )( byval p as T ptr ) as T
	return *p
end function

dim as integer v = 99
print Deref( @v )
dim as double d = 1.5
print Deref( @d )

'' The procedure form beside it, which is what the existing '@' case was written for.
function less( byref x as long, byref y as long ) as boolean
	return x < y
end function

sub apply_( of TC )( byref f as TC )
	print f( 3, 4 )
end sub

apply_( @less )
