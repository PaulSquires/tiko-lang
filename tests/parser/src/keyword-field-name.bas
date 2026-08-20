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

'' The union's size was WRONG here for one commit -- 24 for three ULONGINTs, where
'' fbc says 8 -- because fbx laid a NAMED union out sequentially. It was pinned
'' deliberately, flagged in this comment, and fixed in the very next change. It is 8
'' now, and the golden says so.
