'' A PAREN-LESS PROCEDURE UNDER PARENTHESES OR A NO-OP CONVERSION, PASSED BYREF, IS
'' STILL A CALL. Measured with fbc64 1.20.0 -gen gcc -r, over 'byref x as ulong':
''
''     ByR( cast( ulong, a.F ) )      vr = F( &A ); TMP = vr; BYR( &TMP )
''     ByR( culng( a.F ) )            the same
''     ByR( (a.F) )                   the same
''     ByR( cast( ulong, (a.F) ) )    the same
''     ByR( cast( ulong, v ) )        BYR( (uint32*)&V ) -- a variable keeps its address
''
'' fbc prints 7 for each of the first four; tiko passed F's CODE address, 283935560
'' ('48 83 EC 10', sub rsp, 16). tiko-lang's own 'args.Push( cast( ulong, flds.Count ) )'
'' in the threadcall lowering is the first shape.

type TA
	as long n = 7
	declare function F( ) as long
	declare property P( ) as long
end type

function TA.F( ) as long
	return n
end function

property TA.P( ) as long
	return n + 1
end property

function Free( ) as long
	return 40
end function

sub ByR( byref x as ulong )
	print x
end sub

dim a as TA
dim as long v = 9

ByR( cast( ulong, a.F ) )
ByR( culng( a.F ) )
ByR( (a.F) )
ByR( cast( ulong, (a.F) ) )
ByR( cast( ulong, a.P ) )
ByR( culng( Free ) )
ByR( cast( ulong, v ) )
