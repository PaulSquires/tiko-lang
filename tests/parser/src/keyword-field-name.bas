'' A FIELD whose NAME is a keyword that also starts a declaration. winnt.bi writes
'' 'Function as ULONGLONG' inside two unions, and fbx read it as a nested FUNCTION
'' declaration -- which ran off looking for an 'end function' and ate the 'end union'.
''
'' MEASURED, because the accepted set is not guessable: TYPE and UNION are in it and
'' ENUM and DECLARE are not.
''
''   Function Sub Property Type Union     accepted as a field name
''   Enum Declare Const Static Dim        fbc rejects
''
'' The '( bounds )' and 'as T' forms are both accepted, and so is the type-first
'' 'as ULONGLONG Function', which the shared-type path already handled.

type T
	Function as ulongint
	Sub as ulongint
	Property as ulongint
	Type as ulongint
	Union as ulongint
	Arr( 0 to 1 ) as ulongint
end type

'' The shape from winnt.bi.
union U
	ForwarderString as ulongint
	Function as ulongint
	Ordinal as ulongint
end union

dim a as T
dim b as U
print sizeof( T ), sizeof( U )

'' A WARNING ABOUT THE GOLDEN THIS FILE PINS:
''
'' 'u size 24' is WRONG. A union of three ULONGINTs is 8 bytes to fbc, and fbx lays a
'' NAMED union out sequentially -- the overlap marker is only applied to the members of
'' an ANONYMOUS union spliced into an enclosing type. That bug is PRE-EXISTING and
'' unrelated to keyword field names: the same 24 comes out of the binary from before
'' this change.
''
'' It is pinned rather than removed because the shape is winnt.bi's and belongs in the
'' test. When the named-union layout is fixed this golden must move to 8, and a reader
'' who takes 24 as correct because it is in a golden has been warned here.
