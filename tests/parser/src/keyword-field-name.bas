'' A FIELD whose NAME is a keyword that also starts a declaration. winnt.bi writes
'' 'Function as ULONGLONG' inside two unions, and tiko-lang read it as a nested FUNCTION
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

'' THE ARRAY FORM IS NARROWER THAN THE 'as T' FORM. Measured over all 247 keywords:
'' 'name as T' takes 223 of them, 'name( lo to hi ) as T' only 221 -- TYPE and UNION
'' are fbc error 14, "Expected identifier, found '('", spelled the second way and are
'' fields spelled the first.
''
'' And the bounds have to reach the LAYOUT. They were parsed into the payload slot a
'' VARIABLE uses rather than the one a FIELD uses, so they were dropped in silence and
'' the type laid out as if every one of these were a scalar. fbc says this one is 48
'' bytes with Fix at 8, Len at 32 and b at 40; tiko-lang said 24, 8, 16 and 16.
type KA
	a as byte
	Fix( 0 to 2 ) as integer
	Len( 0 to 1 ) as long
	b as byte
end type

'' The shape from winnt.bi.
union U
	ForwarderString as ulongint
	Function as ulongint
	Ordinal as ulongint
end union

dim a as T
dim b as U
dim c as KA
print sizeof( T ), sizeof( U )

'' The union's size was WRONG here for one commit -- 24 for three ULONGINTs, where
'' fbc says 8 -- because tiko-lang laid a NAMED union out sequentially. It was pinned
'' deliberately, flagged in this comment, and fixed in the very next change. It is 8
'' now, and the golden says so.
