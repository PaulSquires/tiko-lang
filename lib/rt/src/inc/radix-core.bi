'' radix-core.bi -- HEX, OCT and BIN, one copy, instantiated per width.
''
'' NO INCLUDE GUARD, deliberately: this file is included ONCE PER CODE-UNIT
'' WIDTH, exactly as inc/ops-core.bi is. src/str/hexoctbin.bas instantiates it
'' for FBSTRING and src/strw/hexoctbin.bas for WSTRING.
''
'' fbc ships SIX near-identical copies of this loop -- hex, oct and bin, narrow
'' and wide -- differing only in a shift width, a digit mapping and a destination
'' type. Sharing them here is the same trade inc/ops-core.bi made and it paid the
'' same way: when the 16-bit instantiation was added, a branch that had been
'' deleted as dead at byte width turned out to be load-bearing.
''
'' The includer must define:
''     RDX( name )   identifier mangling for this width
''     RDX_UNIT      the character type
''
'' ============================================================ THE CONTRACT
''
'' digits <= 0 means "as many as the value needs, minimum one". Zero therefore
'' prints "0" rather than "".
''
'' A digits COUNT SMALLER THAN THE VALUE NEEDS TRUNCATES FROM THE TOP, because
'' the fill walks down from the last position and simply runs out. HEX( &hFF, 1 )
'' is "F", not "FF" and not an error. That is fbc's behaviour and it is what a
'' fixed-width field is for.

'' The digit table is shared by both widths -- the values are ASCII either way,
'' and the store widens on assignment.
private function RDX(hDigits) _
	( byval num as ulongint, byval shift as long ) as long

	'' COUNTS SIGNIFICANT CHUNKS, not bits: a 4-bit shift for hex, 3 for octal,
	'' 1 for binary. The loop stops when the value is exhausted, which is why
	'' HEX( 0 ) needs the special case below rather than falling out at zero.
	dim as long digits = 0
	dim as ulongint n = num
	while( n <> 0 )
		digits += 1
		n shr= shift
	wend
	if( digits = 0 ) then digits = 1
	return digits

end function

'' Fill `digits` positions from the LOW end upward, so the top is what gets lost
'' when the field is too narrow.
private sub RDX(hFill) _
	( byval d as RDX_UNIT ptr, byval num as ulongint, _
	  byval digits as long, byval shift as long, byval mask as ulongint, _
	  byval ishex as long )

	dim as long i = digits - 1
	while( i >= 0 )
		dim as ulongint v = num and mask
		if( ishex <> 0 ) then
			'' 0-9 then A-F. Not a table lookup: the two ranges are contiguous
			'' in ASCII apart from the seven characters between '9' and 'A'.
			if( v < 10 ) then
				d[i] = cast( RDX_UNIT, 48 + v )
			else
				d[i] = cast( RDX_UNIT, 55 + v )        '' 'A' is 65, v is 10..15
			end if
		else
			d[i] = cast( RDX_UNIT, 48 + v )
		end if
		num shr= shift
		i -= 1
	wend

end sub
