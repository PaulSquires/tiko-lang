'' ops.bas -- str_ops.o: the FB.* string algorithms at BYTE width.
''
'' THE LARGEST SINGLE MEMBER IN THE RUNTIME: 38 exported entry points over 38
'' internal algorithms, and all-or-nothing -- gate.sh replaces members, so this
'' file cannot be landed a function at a time.
''
'' In C the algorithms live in str_ops_core.h and are instantiated TWICE, once
'' per code-unit width, through FB_SOP_UNIT / FB_SOP(name) macros. FreeBASIC has
'' no templates, so this is the byte instantiation written out. The 16-bit
'' instantiation (ustr_ops.c) is a separate member and stays fbc's for now; when
'' it is taken, the two will be hand-maintained copies -- which is exactly the
'' drift the C header exists to prevent. Recorded as a known cost rather than
'' discovered later.
''
'' TWO CONVENTIONS RUN THROUGH EVERYTHING BELOW.
''
'' 1. THE ALGORITHMS ARE 0-BASED AND RETURN -1 FOR "NOT FOUND". FreeBASIC's
''    1-based, 0-means-absent convention is applied ONCE, in the wrappers.
''    fbc's reason is a good one: off-by-ones live at conversion boundaries, so
''    there should be exactly one boundary.
''
'' 2. CASE FOLDING IS ASCII ONLY, DELIBERATELY. A STRING is a byte buffer with
''    no declared encoding -- UTF-8, CP-1252 or binary -- so folding anything
''    above 127 would be guessing at a codepage and would make the same program
''    fold differently on two machines. A-Z only; USTRING has the real table.
''
'' THE EMPTY-ARGUMENT RULES ARE NOT UNIFORM, and that is intentional in the
'' original. Collected here because they are the whole contract and are spread
'' across forty comments in the C:
''
''   hFind        empty pattern -> -1 (never matches)
''   hFindAny     empty set     -> -1 (find one of nothing cannot succeed)
''   hVerify      empty set     -> `from` (find one NOT among nothing cannot fail)
''   hStartsWith  empty prefix  -> TRUE, and deliberately does NOT go through
''                hFind, so that it can disagree with it
''   hExtractSpan a miss returns THE WHOLE REMAINDER (PowerBASIC EXTRACT$)
''   hRemainSpan  a miss returns EMPTY
''
'' hExtract and hRemain are complements and their miss rules are opposites; each
'' is right on its own terms and neither follows from the other.

#include once "inc/descriptors.bi"
#include once "inc/ctx.bi"

extern "rtlib"
	declare function fb_hStrAllocTemp alias "fb_hStrAllocTemp" _
		( byval s as FBSTRING ptr, byval length as integer ) as FBSTRING ptr
	declare sub fb_hStrCopy alias "fb_hStrCopy" _
		( byval dst as zstring ptr, byval src as zstring ptr, byval bytes as integer )
	declare function tkrt_Utf16ToUtf8 alias "fb_hUtf16ToUtf8" _
		( byval src as ushort ptr, byval src_units as integer, _
		  byval dst as ubyte ptr, byval dst_bytes as integer ) as integer
end extern

'' ASCII fold, one unit in and one unit out -- so a fold never changes a length
'' and every offset stays valid.
#define SOP_FOLD( c )   cast( ubyte, iif( ((c) >= 97) andalso ((c) <= 122), (c) - 32, (c) ) )
#define SOP_LOWER( c )  cast( ubyte, iif( ((c) >= 65) andalso ((c) <= 90), (c) + 32, (c) ) )

'' A word character for title case: ASCII alphanumerics PLUS everything >= 0x80.
'' In a UTF-8 STRING those are the lead and continuation bytes of a letter, so
'' treating them as word characters stops a multi-byte letter being read as a
'' word boundary.
#macro SOP_ISWORD( c, r )
	r = 0
	if( ((c) >= 48) andalso ((c) <= 57) ) then r = 1
	if( ((c) >= 65) andalso ((c) <= 90) ) then r = 1
	if( ((c) >= 97) andalso ((c) <= 122) ) then r = 1
	if( (c) >= &h80 ) then r = 1
#endmacro

'' ============================================================ primitives

'' Compare two runs, honouring the fold flag.
private function hEq _
	( byval a as ubyte ptr, byval b as ubyte ptr, byval length as integer, byval ic as long ) as long

	if( ic = 0 ) then
		if( memcmp( a, b, length ) = 0 ) then return 1
		return 0
	end if

	for i as integer = 0 to length - 1
		if( SOP_FOLD( a[i] ) <> SOP_FOLD( b[i] ) ) then return 0
	next

	return 1

end function

'' Is c one of set[0..setlen-1]?
private function hInSet _
	( byval c as ubyte, byval st as ubyte ptr, byval setlen as integer, byval ic as long ) as long

	if( ic <> 0 ) then
		dim as ubyte fc = SOP_FOLD( c )
		for i as integer = 0 to setlen - 1
			if( SOP_FOLD( st[i] ) = fc ) then return 1
		next
	else
		for i as integer = 0 to setlen - 1
			if( st[i] = c ) then return 1
		next
	end if

	return 0

end function

'' First index >= from where pat occurs, or -1. AN EMPTY PATTERN RETURNS -1.
private function hFind _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval pat as ubyte ptr, byval patlen as integer, _
		byval from as integer, byval ic as long _
	) as integer

	if( patlen <= 0 ) then return -1
	if( slen <= 0 ) then return -1
	if( from < 0 ) then return -1

	dim as integer last = slen - patlen
	for i as integer = from to last
		if( hEq( @s[i], pat, patlen, ic ) <> 0 ) then return i
	next

	return -1

end function

'' First index >= from whose unit IS in set, or -1.
private function hFindAny _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval st as ubyte ptr, byval setlen as integer, _
		byval from as integer, byval ic as long _
	) as integer

	if( setlen <= 0 ) then return -1
	if( slen <= 0 ) then return -1
	if( from < 0 ) then return -1

	for i as integer = from to slen - 1
		if( hInSet( s[i], st, setlen, ic ) <> 0 ) then return i
	next

	return -1

end function

'' First index >= from whose unit is NOT in set, or -1. An EMPTY SET makes
'' `from` the answer -- the opposite of hFindAny's rule, and deliberately so.
private function hVerify _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval st as ubyte ptr, byval setlen as integer, _
		byval from as integer, byval ic as long _
	) as integer

	if( slen <= 0 ) then return -1
	if( from < 0 ) then return -1
	if( from >= slen ) then return -1

	for i as integer = from to slen - 1
		if( hInSet( s[i], st, setlen, ic ) = 0 ) then return i
	next

	return -1

end function

'' How many units from `from` onward are in set. Always >= 0.
private function hSpan _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval st as ubyte ptr, byval setlen as integer, _
		byval from as integer, byval ic as long _
	) as integer

	if( slen <= 0 ) then return 0
	if( from < 0 ) then return 0
	if( from >= slen ) then return 0

	dim as integer i = from
	while( i < slen )
		if( hInSet( s[i], st, setlen, ic ) = 0 ) then exit while
		i += 1
	wend

	return i - from

end function

'' Count of NON-OVERLAPPING occurrences: "aaaa" contains "aa" TWICE, not three
'' times. That is the count Replace and Split need -- the number of things that
'' would be replaced, or the number of separators.
private function hTally _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval pat as ubyte ptr, byval patlen as integer, byval ic as long _
	) as integer

	if( patlen <= 0 ) then return 0
	if( slen <= 0 ) then return 0

	dim as integer n = 0, i = 0, at = any
	do
		at = hFind( s, slen, pat, patlen, i, ic )
		if( at < 0 ) then exit do
		n += 1
		i = at + patlen
	loop

	return n

end function

private function hTallyAny _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval st as ubyte ptr, byval setlen as integer, byval ic as long _
	) as integer

	if( setlen <= 0 ) then return 0
	if( slen <= 0 ) then return 0

	dim as integer n = 0
	for i as integer = 0 to slen - 1
		if( hInSet( s[i], st, setlen, ic ) <> 0 ) then n += 1
	next

	return n

end function

'' An EMPTY affix is present in every string, including the empty one -- and
'' this deliberately does NOT go through hFind, whose empty pattern never
'' matches, so that the two can disagree.
private function hStartsWith _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval pre as ubyte ptr, byval prelen as integer, byval ic as long _
	) as long

	if( prelen <= 0 ) then return 1
	if( prelen > slen ) then return 0
	return hEq( s, pre, prelen, ic )

end function

private function hEndsWith _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval suf as ubyte ptr, byval suflen as integer, byval ic as long _
	) as long

	if( suflen <= 0 ) then return 1
	if( suflen > slen ) then return 0
	return hEq( @s[slen - suflen], suf, suflen, ic )

end function

'' ================================================================= spans
''
'' The extract family all answer the same question -- WHICH RUN of the input
'' comes back -- so they compute an (offset, count) span and leave only the
'' allocation to the wrapper. The index arithmetic, which is where these go
'' wrong, stays in one place.
''
'' Spans are 0-based and always valid to slice: a miss is (0, 0), never a
'' negative count.

'' Text BEFORE the first occurrence of pat at or after `from`.
''
'' A MISS RETURNS THE WHOLE REMAINDER, not the empty string -- the PowerBASIC
'' EXTRACT$ rule. It is what makes a parse loop terminate naturally: the last
'' field has no trailing delimiter, and this hands it back instead of losing it.
'' An empty pattern is a miss, so it too yields the whole remainder.
private sub hExtractSpan _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval pat as ubyte ptr, byval patlen as integer, _
		byval from as integer, byval ic as long, _
		byval off as integer ptr, byval cnt as integer ptr _
	)

	*off = 0
	*cnt = 0

	if( slen <= 0 ) then exit sub
	if( from < 0 ) then exit sub
	if( from >= slen ) then exit sub

	dim as integer at = hFind( s, slen, pat, patlen, from, ic )

	*off = from
	if( at < 0 ) then *cnt = slen - from else *cnt = at - from

end sub

private sub hExtractCharsSpan _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval st as ubyte ptr, byval setlen as integer, _
		byval from as integer, byval ic as long, _
		byval off as integer ptr, byval cnt as integer ptr _
	)

	*off = 0
	*cnt = 0

	if( slen <= 0 ) then exit sub
	if( from < 0 ) then exit sub
	if( from >= slen ) then exit sub

	dim as integer at = hFindAny( s, slen, st, setlen, from, ic )

	*off = from
	if( at < 0 ) then *cnt = slen - from else *cnt = at - from

end sub

'' Text AFTER the first occurrence of pat at or after `from`.
''
'' A MISS RETURNS EMPTY -- the opposite of hExtractSpan, deliberately. Nothing
'' followed the thing that was not there, and returning the whole remainder
'' would produce text that was never after anything.
private sub hRemainSpan _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval pat as ubyte ptr, byval patlen as integer, _
		byval from as integer, byval ic as long, _
		byval off as integer ptr, byval cnt as integer ptr _
	)

	*off = 0
	*cnt = 0

	if( slen <= 0 ) then exit sub
	if( patlen <= 0 ) then exit sub
	if( from < 0 ) then exit sub
	if( from >= slen ) then exit sub

	dim as integer at = hFind( s, slen, pat, patlen, from, ic )
	if( at < 0 ) then exit sub

	*off = at + patlen
	*cnt = slen - *off

end sub

private sub hRemainCharsSpan _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval st as ubyte ptr, byval setlen as integer, _
		byval from as integer, byval ic as long, _
		byval off as integer ptr, byval cnt as integer ptr _
	)

	*off = 0
	*cnt = 0

	if( slen <= 0 ) then exit sub
	if( setlen <= 0 ) then exit sub
	if( from < 0 ) then exit sub
	if( from >= slen ) then exit sub

	dim as integer at = hFindAny( s, slen, st, setlen, from, ic )
	if( at < 0 ) then exit sub

	*off = at + 1
	*cnt = slen - *off

end sub

'' Text between the first d1 at or after `from` and the first d2 after THAT.
''
'' d2 is searched from the END OF d1, never from `from`, so
'' Between( "(a)(b)", "(", ")" ) is "a" and cannot match the second ")" first.
'' Either delimiter missing yields empty -- there is no "between" without both
'' ends -- and an empty delimiter never matches, so it is a miss like any other.
private sub hBetweenSpan _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval d1 as ubyte ptr, byval d1len as integer, _
		byval d2 as ubyte ptr, byval d2len as integer, _
		byval from as integer, byval ic as long, _
		byval off as integer ptr, byval cnt as integer ptr _
	)

	*off = 0
	*cnt = 0

	if( slen <= 0 ) then exit sub
	if( from < 0 ) then exit sub
	if( from >= slen ) then exit sub

	dim as integer a = hFind( s, slen, d1, d1len, from, ic )
	if( a < 0 ) then exit sub

	dim as integer inner = a + d1len

	dim as integer b = hFind( s, slen, d2, d2len, inner, ic )
	if( b < 0 ) then exit sub

	*off = inner
	*cnt = b - inner

end sub

'' The next three are pure index arithmetic and never look at the text.
''
'' A count of 0 or less removes nothing and returns the whole string; a count at
'' or beyond the length removes all of it. Neither clamps into a negative span.
private sub hClipLeftSpan _
	( byval slen as integer, byval n as integer, byval off as integer ptr, byval cnt as integer ptr )

	if( (slen <= 0) orelse (n >= slen) ) then
		*off = 0 : *cnt = 0
		exit sub
	end if

	if( n <= 0 ) then
		*off = 0 : *cnt = slen
		exit sub
	end if

	*off = n
	*cnt = slen - n

end sub

private sub hClipRightSpan _
	( byval slen as integer, byval n as integer, byval off as integer ptr, byval cnt as integer ptr )

	*off = 0

	if( (slen <= 0) orelse (n >= slen) ) then
		*cnt = 0
	elseif( n <= 0 ) then
		*cnt = slen
	else
		*cnt = slen - n
	end if

end sub

'' DeleteAt: the run to REMOVE, given a 1-based start. A zero count removes
'' nothing and the whole string comes back -- which is what EVERY invalid
'' argument produces here. An out-of-range delete is a no-op, not an error and
'' not a truncation.
private sub hDeleteCut _
	( _
		byval slen as integer, byval start1 as integer, byval count as integer, _
		byval coff as integer ptr, byval clen as integer ptr _
	)

	*coff = 0
	*clen = 0

	if( slen <= 0 ) then exit sub
	if( start1 < 1 ) then exit sub
	if( count <= 0 ) then exit sub
	if( start1 > slen ) then exit sub

	*coff = start1 - 1
	*clen = count

	if( *clen > slen - *coff ) then *clen = slen - *coff

end sub

'' InsertAt: the 0-based offset to splice at, or -1 for "do not insert".
''
'' A position PAST THE END APPENDS -- the useful reading of "insert at position
'' 20 of a 5-character string". A position below 1 does NOT insert.
''
'' fbc's comment records that AfxStrInsert's own comment says a position <= 0
'' appends while its code returns the string unchanged, and that the CODE was
'' followed, because appending on a negative index is the kind of silent success
'' that hides a caller's off-by-one. Reproduced with the reasoning intact.
private function hInsertSplit _
	( byval slen as integer, byval pos1 as integer ) as integer

	if( pos1 < 1 ) then return -1
	if( pos1 > slen ) then return slen
	return pos1 - 1

end function

'' ============================================================ transforms
''
'' These build a new string rather than slicing the old one, so each is a FILL:
'' it writes into a caller-allocated buffer and returns how much it wrote. Every
'' one has a length the caller can compute in advance, so none needs a measure
'' pass:
''
''   Replace       slen + count * (replen - patlen), count from hTally
''   Remove* / Retain* / Shrink   at most slen
''   ReplaceChars / Reverse / MCase   exactly slen

private function hReplaceFill _
	( _
		byval dst as ubyte ptr, _
		byval s as ubyte ptr, byval slen as integer, _
		byval pat as ubyte ptr, byval patlen as integer, _
		byval rep as ubyte ptr, byval replen as integer, _
		byval ic as long _
	) as integer

	if( (patlen <= 0) orelse (slen <= 0) ) then
		if( slen > 0 ) then
			memcpy( dst, s, slen )
			return slen
		end if
		return 0
	end if

	dim as integer i = 0, w = 0, at = any

	do
		at = hFind( s, slen, pat, patlen, i, ic )
		if( at < 0 ) then exit do

		if( at > i ) then
			memcpy( @dst[w], @s[i], at - i )
			w += at - i
		end if

		if( replen > 0 ) then
			memcpy( @dst[w], rep, replen )
			w += replen
		end if

		i = at + patlen
	loop

	if( slen > i ) then
		memcpy( @dst[w], @s[i], slen - i )
		w += slen - i
	end if

	return w

end function

'' Drop every unit that is in `set`. An EMPTY SET DROPS NOTHING.
private function hRemoveCharsFill _
	( _
		byval dst as ubyte ptr, _
		byval s as ubyte ptr, byval slen as integer, _
		byval st as ubyte ptr, byval setlen as integer, byval ic as long _
	) as integer

	dim as integer w = 0

	for i as integer = 0 to slen - 1
		if( setlen <= 0 ) then
			dst[w] = s[i] : w += 1
		elseif( hInSet( s[i], st, setlen, ic ) = 0 ) then
			dst[w] = s[i] : w += 1
		end if
	next

	return w

end function

'' Keep only the units in `set`. An EMPTY SET KEEPS NOTHING -- the complement of
'' dropping nothing, and the reason this one returns early rather than falling
'' through the loop.
private function hRetainCharsFill _
	( _
		byval dst as ubyte ptr, _
		byval s as ubyte ptr, byval slen as integer, _
		byval st as ubyte ptr, byval setlen as integer, byval ic as long _
	) as integer

	if( setlen <= 0 ) then return 0

	dim as integer w = 0

	for i as integer = 0 to slen - 1
		if( hInSet( s[i], st, setlen, ic ) <> 0 ) then
			dst[w] = s[i] : w += 1
		end if
	next

	return w

end function

'' Map every unit in `set` to `unit`. LENGTH NEVER CHANGES -- a one-for-one
'' substitution, not a replacement, which is what keeps offsets into the result
'' lined up with the input.
private function hReplaceCharsFill _
	( _
		byval dst as ubyte ptr, _
		byval s as ubyte ptr, byval slen as integer, _
		byval st as ubyte ptr, byval setlen as integer, _
		byval unit as ubyte, byval ic as long _
	) as integer

	for i as integer = 0 to slen - 1
		if( setlen > 0 ) then
			if( hInSet( s[i], st, setlen, ic ) <> 0 ) then
				dst[i] = unit
			else
				dst[i] = s[i]
			end if
		else
			dst[i] = s[i]
		end if
	next

	return slen

end function

'' Reverse.
''
'' BYTES REVERSE AS BYTES here, and that asymmetry with the 16-bit width is
'' deliberate. A ustring is UTF-16 by definition, so blind reversal emits a low
'' surrogate before its high one -- invalid every time an astral character
'' appears -- and the wide instantiation keeps pairs together. A STRING is bytes
'' with no declared encoding, so there is no pair to preserve and no way to know
'' whether there would be one. It does corrupt multi-byte UTF-8, and it is the
'' only defensible answer for a type that does not say what it holds.
''
'' In C this is one function with FB_SOP_ISHIGH/ISLOW defined to constant 0 at
'' byte width, so the surrogate branch folds away. Here the branch is simply
'' absent -- the same code after constant folding, written once.
private sub hReverseFill _
	( byval dst as ubyte ptr, byval s as ubyte ptr, byval slen as integer )

	dim as integer w = 0
	for i as integer = slen - 1 to 0 step -1
		dst[w] = s[i] : w += 1
	next

end sub

'' Collapse runs of mask characters and strip them from both ends: every maximal
'' run becomes ONE copy of mask[0], and leading and trailing runs go entirely.
''
'' AN EMPTY MASK RETURNS THE INPUT UNCHANGED. fbc's comment records that
'' AfxStrShrink returns the EMPTY STRING for an empty mask, calls that a guard
'' clause that fell through to the wrong variable, and declines to preserve it.
'' Noted because it is a place where fbc deliberately does NOT match AfxNova.
''
'' The `pending` flag is what strips the trailing run without a second pass: a
'' mask run is remembered and only emitted once a word actually follows.
private function hShrinkFill _
	( _
		byval dst as ubyte ptr, _
		byval s as ubyte ptr, byval slen as integer, _
		byval mask as ubyte ptr, byval masklen as integer _
	) as integer

	if( masklen <= 0 ) then
		if( slen > 0 ) then
			memcpy( dst, s, slen )
			return slen
		end if
		return 0
	end if

	dim as integer w = 0
	dim as integer pending = 0

	for i as integer = 0 to slen - 1
		if( hInSet( s[i], mask, masklen, 0 ) <> 0 ) then
			'' Remember it, but emit only if a word follows.
			if( w > 0 ) then pending = 1
		else
			if( pending <> 0 ) then
				dst[w] = mask[0] : w += 1
				pending = 0
			end if
			dst[w] = s[i] : w += 1
		end if
	next

	return w

end function

'' Title case: the first letter of each word upper, everything else lower.
''
'' A WORD STARTS AFTER ANY NON-ALPHANUMERIC. fbc's comment contrasts this with
'' AfxNova's DWStrMCase, which tests a fixed list of punctuation and therefore
'' capitalises after "." and "-" but not after "/", "_" or a tab -- an omission
'' rather than a decision. "Not alphanumeric" needs no list and has no gaps.
''
'' Non-ASCII counts as a WORD character: an accented letter continues a word,
'' and a CJK character has no case to change anyway.
private function hMCaseFill _
	( byval dst as ubyte ptr, byval s as ubyte ptr, byval slen as integer ) as integer

	dim as integer startsWord = 1
	dim as ubyte c = any
	dim as integer isword = any

	for i as integer = 0 to slen - 1
		c = s[i]

		if( startsWord <> 0 ) then
			dst[i] = SOP_FOLD( c )
		else
			dst[i] = SOP_LOWER( c )
		end if

		SOP_ISWORD( c, isword )
		startsWord = iif( isword <> 0, 0, 1 )
	next

	return slen

end function

'' Remove from each `d1` through the matching `d2`, delimiters included.
''
'' EITHER DELIMITER MISSING STOPS THE WALK and copies the rest through, so an
'' unbalanced opener is left alone rather than swallowing the tail. d2 is
'' searched from the END of d1, so a pair cannot be crossed -- the same rule
'' hBetweenSpan follows.
private function hRemoveBetweenFill _
	( _
		byval dst as ubyte ptr, _
		byval s as ubyte ptr, byval slen as integer, _
		byval d1 as ubyte ptr, byval d1len as integer, _
		byval d2 as ubyte ptr, byval d2len as integer, _
		byval removeAll as long, byval from as integer, byval ic as long _
	) as integer

	if( slen <= 0 ) then return 0

	if( from < 0 ) then from = 0
	if( from > slen ) then from = slen

	dim as integer w = 0
	if( from > 0 ) then
		memcpy( dst, s, from )
		w = from
	end if

	dim as integer i = from
	dim as integer a = any, b = any

	do
		a = hFind( s, slen, d1, d1len, i, ic )
		if( a < 0 ) then exit do

		b = hFind( s, slen, d2, d2len, a + d1len, ic )
		if( b < 0 ) then exit do

		if( a > i ) then
			memcpy( @dst[w], @s[i], a - i )
			w += a - i
		end if

		i = b + d2len

		if( removeAll = 0 ) then exit do
	loop

	if( slen > i ) then
		memcpy( @dst[w], @s[i], slen - i )
		w += slen - i
	end if

	return w

end function

'' Justify into a field of EXACTLY `fieldw`.
''
'' The parameter is `fieldw`, not `width`: WIDTH is a FreeBASIC statement and is
'' error 59 as a parameter name. Sixth reserved word to collide with a natural
'' name here, after PRESERVE, POS, LEN, STR and MKD.
''
''   mode 0  left-justified  (PadRight -- the padding goes on the right)
''   mode 1  right-justified (PadLeft)
''   mode 2  centred
''
'' A string LONGER than the field is TRUNCATED, keeping its left, which is what
'' makes a column line up whatever is in it. A width of 0 or less gives empty.
''
'' CENTRING PUTS THE ODD UNIT ON THE RIGHT: a 1-unit string in a 4-unit field
'' gets 1 before and 2 after. Integer division decides it, the choice is
'' arbitrary, and fbc writes it down rather than leaving it to be discovered.
private function hPadFill _
	( _
		byval dst as ubyte ptr, _
		byval s as ubyte ptr, byval slen as integer, _
		byval fieldw as integer, byval pad as ubyte, byval mode as long _
	) as integer

	if( fieldw <= 0 ) then return 0

	if( slen >= fieldw ) then
		memcpy( dst, s, fieldw )
		return fieldw
	end if

	for i as integer = 0 to fieldw - 1
		dst[i] = pad
	next

	dim as integer keep = slen
	dim as integer at = any

	select case as const mode
	case 1
		at = fieldw - keep
	case 2
		at = (fieldw - keep) \ 2
	case else
		at = 0
	end select

	if( keep > 0 ) then memcpy( @dst[at], s, keep )

	return fieldw

end function

'' Unwrap: strip ONE leading `open` and ONE trailing `close`, and only if BOTH
'' are present and they do not overlap.
''
'' fbc's comment records a DELIBERATE DIVERGENCE from AfxStrUnWrap, which uses
'' LTRIM/RTRIM with the delimiter and therefore strips REPEATED occurrences and
'' does not require a pair: "'''x'''" loses all six quotes and "'x" loses its
'' opener with nothing matching it. Removing a delimiter that was never balanced
'' is how a quoted field containing a quote gets silently mangled.
private sub hUnwrapSpan _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval op as ubyte ptr, byval oplen as integer, _
		byval cl as ubyte ptr, byval cllen as integer, _
		byval ic as long, byval off as integer ptr, byval cnt as integer ptr _
	)

	*off = 0
	if( slen > 0 ) then *cnt = slen else *cnt = 0

	if( slen <= 0 ) then exit sub
	if( oplen <= 0 ) then exit sub
	if( cllen <= 0 ) then exit sub

	'' The two must fit WITHOUT OVERLAPPING -- "'" is not both ends of itself.
	if( slen < oplen + cllen ) then exit sub

	if( hStartsWith( s, slen, op, oplen, ic ) = 0 ) then exit sub
	if( hEndsWith( s, slen, cl, cllen, ic ) = 0 ) then exit sub

	*off = oplen
	*cnt = slen - oplen - cllen

end sub

'' ===================================================== escape / unescape
''
'' Backslash escaping -- the kind that makes a string safe to write inside
'' quotes in a config file or generated source, and reversible afterwards.
''
'' NOT AfxNova's DWStrEscape, which escapes REGULAR EXPRESSION metacharacters.
'' That one is only meaningful next to a regex engine (it is built on CRegExp,
'' a COM class) and there is none here, so it is not carried across.
''
''     \  "            ->  \  \"
''     LF CR TAB NUL   ->  \n \r \t \0
''     other < 32, 127 ->  \xHH
''     everything else, INCLUDING ALL NON-ASCII, passes through
''
'' Non-ASCII is left alone deliberately: escaping it would turn a UTF-8 STRING
'' into a wall of hex for no gain. The point is to neutralise what breaks
'' quoting, not to reduce the string to ASCII.
''
'' Unescape is the EXACT inverse for every input, including one that already
'' contains backslashes.

dim shared as ubyte tkort_hexDigit(0 to 15) = _
	{ asc("0"), asc("1"), asc("2"), asc("3"), asc("4"), asc("5"), asc("6"), asc("7"), _
	  asc("8"), asc("9"), asc("A"), asc("B"), asc("C"), asc("D"), asc("E"), asc("F") }

'' Measures when dst is NULL, fills otherwise. Returns the escaped length.
private function hEscapeFill _
	( byval dst as ubyte ptr, byval s as ubyte ptr, byval slen as integer ) as integer

	dim as integer w = 0
	dim as ubyte c = any

	#macro EMIT( u )
		if( dst <> 0 ) then dst[w] = cast( ubyte, u )
		w += 1
	#endmacro

	for i as integer = 0 to slen - 1
		c = s[i]

		select case as const c
		case asc("\")
			EMIT( asc("\") ) : EMIT( asc("\") )
		case asc("""")
			EMIT( asc("\") ) : EMIT( asc("""") )
		case 10
			EMIT( asc("\") ) : EMIT( asc("n") )
		case 13
			EMIT( asc("\") ) : EMIT( asc("r") )
		case 9
			EMIT( asc("\") ) : EMIT( asc("t") )
		case 0
			EMIT( asc("\") ) : EMIT( asc("0") )
		case else
			if( (c < 32) orelse (c = 127) ) then
				EMIT( asc("\") )
				EMIT( asc("x") )
				EMIT( tkort_hexDigit( (c shr 4) and &h0F ) )
				EMIT( tkort_hexDigit( c and &h0F ) )
			else
				EMIT( c )
			end if
		end select
	next

	return w

end function

'' One hex digit's value, or -1.
private function hHexVal( byval c as ubyte ) as long
	if( (c >= asc("0")) andalso (c <= asc("9")) ) then return c - asc("0")
	if( (c >= asc("a")) andalso (c <= asc("f")) ) then return c - asc("a") + 10
	if( (c >= asc("A")) andalso (c <= asc("F")) ) then return c - asc("A") + 10
	return -1
end function

'' The inverse. Output is never longer than the input, so one pass into a
'' buffer of slen is enough.
''
'' AN UNRECOGNISED ESCAPE YIELDS THE ESCAPED CHARACTER ITSELF, so "\q" becomes
'' "q" -- the backslash did its job of quoting and is consumed. A TRAILING LONE
'' BACKSLASH is kept as a backslash, the only choice that does not lose a
'' character.
private function hUnescapeFill _
	( byval dst as ubyte ptr, byval s as ubyte ptr, byval slen as integer ) as integer

	dim as integer i = 0, w = 0
	dim as ubyte c = any, e = any

	while( i < slen )
		c = s[i]

		if( c <> asc("\") ) then
			dst[w] = s[i] : w += 1 : i += 1
			continue while
		end if

		if( i + 1 >= slen ) then
			'' Trailing backslash: nothing follows it to unquote.
			dst[w] = s[i] : w += 1 : i += 1
			continue while
		end if

		e = s[i + 1]

		select case as const e
		case asc("n")
			dst[w] = 10 : w += 1 : i += 2
		case asc("r")
			dst[w] = 13 : w += 1 : i += 2
		case asc("t")
			dst[w] = 9 : w += 1 : i += 2
		case asc("0")
			dst[w] = 0 : w += 1 : i += 2
		case asc("x")
			dim as long done_ = 0
			if( i + 3 < slen ) then
				dim as long hi = hHexVal( s[i + 2] )
				dim as long lo = hHexVal( s[i + 3] )
				if( (hi >= 0) andalso (lo >= 0) ) then
					dst[w] = cast( ubyte, (hi shl 4) or lo )
					w += 1 : i += 4
					done_ = 1
				end if
			end if
			'' Not a well-formed \xHH: take the 'x' itself.
			if( done_ = 0 ) then
				dst[w] = s[i + 1] : w += 1 : i += 2
			end if
		case else
			'' \ and \" land here, as does any unknown escape.
			dst[w] = s[i + 1] : w += 1 : i += 2
		end select
	wend

	return w

end function

'' ============================================================ predicates

'' Whitespace: space, tab, LF, VT, FF, CR. The same six C's isspace() uses,
'' spelled out so it does not depend on a locale.
private function hIsSpace( byval c as ubyte ) as long
	if( c = 32 ) then return 1
	if( (c >= 9) andalso (c <= 13) ) then return 1
	return 0
end function

private function hIsBlank( byval s as ubyte ptr, byval slen as integer ) as long
	for i as integer = 0 to slen - 1
		if( hIsSpace( s[i] ) = 0 ) then return 0
	next
	return 1
end function

'' Does the WHOLE string parse as a decimal number?
''
''   [ws] [+|-] ( digits [ . [digits] ] | . digits ) [ (e|E|d|D) [+|-] digits ] [ws]
''
'' At least one digit is required, so "", "+", "." and "e5" are all false, and
'' trailing junk fails: "12abc" is not a number.
''
'' fbc's comment is explicit that THIS IS A DIFFERENT FUNCTION FROM AfxIsNumeric
'' rather than a port of it. That one asks whether every character is drawn from
'' "+-.0123456789", which makes "++--.." numeric and is really a character-set
'' test -- RetainChars already does that, and better.
''
'' RADIX LITERALS (&H, &O, &B) ARE NOT ACCEPTED, even though VAL takes them:
'' they are a FreeBASIC literal syntax rather than a numeric string, and
'' admitting them would make "&HZZ" a parse question with no good answer.
private function hIsNumeric( byval s as ubyte ptr, byval slen as integer ) as long

	dim as integer i = 0
	dim as integer digits = 0

	while( (i < slen) andalso (hIsSpace( s[i] ) <> 0) )
		i += 1
	wend

	if( i >= slen ) then return 0          '' empty or all whitespace

	if( (s[i] = asc("+")) orelse (s[i] = asc("-")) ) then i += 1

	while( i < slen )
		if( (s[i] < asc("0")) orelse (s[i] > asc("9")) ) then exit while
		digits += 1
		i += 1
	wend

	if( i < slen ) then
		if( s[i] = asc(".") ) then
			i += 1
			while( i < slen )
				if( (s[i] < asc("0")) orelse (s[i] > asc("9")) ) then exit while
				digits += 1
				i += 1
			wend
		end if
	end if

	'' A sign and a dot are not a number.
	if( digits = 0 ) then return 0

	if( i < slen ) then
		dim as ubyte e = s[i]
		if( (e = asc("e")) orelse (e = asc("E")) orelse (e = asc("d")) orelse (e = asc("D")) ) then
			dim as integer save_ = i
			dim as integer expDigits = 0

			i += 1
			if( i < slen ) then
				if( (s[i] = asc("+")) orelse (s[i] = asc("-")) ) then i += 1
			end if

			while( i < slen )
				if( (s[i] < asc("0")) orelse (s[i] > asc("9")) ) then exit while
				expDigits += 1
				i += 1
			wend

			'' An exponent marker with no digits is not an exponent, and what
			'' follows is then trailing junk.
			if( expDigits = 0 ) then i = save_
		end if
	end if

	while( (i < slen) andalso (hIsSpace( s[i] ) <> 0) )
		i += 1
	wend

	return iif( i = slen, 1, 0 )

end function

'' ================================================================= split
''
'' Split is the one operation whose result is not a string, so this stops at the
'' field BOUNDARIES and the caller turns them into an array. Writing spans keeps
'' it LINEAR: the other shape -- a count function plus an nth-field function --
'' rescans from the start for every field and is O(n^2), which is exactly the
'' AfxStrParseCount / AfxStrParse pair this replaces.
''
'' `spans` receives COUNT PAIRS of (offset, length), 0-based. Pass NULL to count
'' (the parameter is `spans` rather than fbc's `out` because OUT is a FreeBASIC
'' statement -- port I/O -- and is error 4 as a parameter name. Seventh reserved
'' word to collide here, after PRESERVE, POS, LEN, STR, MKD and WIDTH)
'' without writing, which is how a caller sizes its buffer; `maxpairs` bounds
'' the write, so a caller that guessed cannot overrun.
''
'' THE FIELD COUNT IS ALWAYS AT LEAST 1. N delimiters produce N+1 fields, always,
'' and no field is ever silently dropped:
''
''     "a,b,c" -> 3    "a,,c" -> 3    ",a" -> 2    "a," -> 2    "" -> 1
''
'' An EMPTY DELIMITER splits nothing and yields the whole input as one field --
'' consistent with hFind, where an empty pattern never matches.
private function hSplitSpans _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval pat as ubyte ptr, byval patlen as integer, _
		byval ic as long, byval spans as integer ptr, byval maxpairs as integer _
	) as integer

	if( slen < 0 ) then slen = 0

	if( patlen <= 0 ) then
		if( (spans <> 0) andalso (maxpairs >= 1) ) then
			spans[0] = 0
			spans[1] = slen
		end if
		return 1
	end if

	dim as integer i = 0, n = 0, at = any

	do
		at = hFind( s, slen, pat, patlen, i, ic )
		if( at < 0 ) then exit do

		if( (spans <> 0) andalso (n < maxpairs) ) then
			spans[n * 2] = i
			spans[n * 2 + 1] = at - i
		end if
		n += 1

		i = at + patlen
	loop

	'' The tail after the last delimiter -- always a field, even when empty.
	if( (spans <> 0) andalso (n < maxpairs) ) then
		spans[n * 2] = i
		spans[n * 2 + 1] = slen - i
	end if
	n += 1

	return n

end function

'' Same, but every unit in `set` is a separator in its own right.
private function hSplitCharsSpans _
	( _
		byval s as ubyte ptr, byval slen as integer, _
		byval st as ubyte ptr, byval setlen as integer, _
		byval ic as long, byval spans as integer ptr, byval maxpairs as integer _
	) as integer

	if( slen < 0 ) then slen = 0

	if( setlen <= 0 ) then
		if( (spans <> 0) andalso (maxpairs >= 1) ) then
			spans[0] = 0
			spans[1] = slen
		end if
		return 1
	end if

	dim as integer i = 0, n = 0, at = any

	do
		at = hFindAny( s, slen, st, setlen, i, ic )
		if( at < 0 ) then exit do

		if( (spans <> 0) andalso (n < maxpairs) ) then
			spans[n * 2] = i
			spans[n * 2 + 1] = at - i
		end if
		n += 1

		i = at + 1
	loop

	if( (spans <> 0) andalso (n < maxpairs) ) then
		spans[n * 2] = i
		spans[n * 2 + 1] = slen - i
	end if
	n += 1

	return n

end function

'' ==================================================== descriptor plumbing
''
'' ARGUMENTS ARE DESCRIPTORS, ALWAYS. These are reached from FreeBASIC through a
'' plain `extern "C" declare ... ( byref s as const string, ... )` and NOT
'' through the compiler's intrinsic path, so there is no (ptr, size)
'' discriminator to unpack. fbc's header records that a literal, a var-len
'' STRING, a STRING * N, a ZSTRING * N and a concatenation temporary all arrive
'' as descriptors -- measured, not assumed.
''
'' A NULL descriptor and one with a NULL data pointer both mean the empty string.
private sub hStrArg _
	( byval s as FBSTRING ptr, byval ptr_ as ubyte ptr ptr, byval length as integer ptr )

	if( s = 0 ) then
		*ptr_ = 0 : *length = 0
		exit sub
	end if
	if( s->data = 0 ) then
		*ptr_ = 0 : *length = 0
		exit sub
	end if

	*ptr_ = cptr( ubyte ptr, s->data )
	'' FB_STRSIZE, never ->len raw: the temp flag lives in the sign bit, so a
	'' temporary read raw comes back hugely negative and the string looks empty.
	*length = FB_STRSIZE( s )

end sub

'' THE PATTERN ARGUMENT IS A USTRING, EVEN HERE.
''
'' fbc resolves an overload on ALL of its parameters, so a set overloaded on the
'' first can only be disambiguated if every LATER parameter has one type shared
'' by all overloads. USTRING is that type, so a byte-family pattern arrives as
'' UTF-16 and is encoded back to bytes here.
''
'' Deliberately NOT through fb_UStrToStr: that allocates a temp descriptor and
'' takes the string lock, and a pattern is nearly always a handful of ASCII.
'' fb_hUtf16ToUtf8 measures first (dst = NULL), so a SHORT PATTERN ENCODES INTO
'' THE STACK and never allocates at all; only a long one reaches malloc.
''
'' OUT OF MEMORY BEHAVES AS THE EMPTY PATTERN rather than failing -- and given
'' the empty-argument rules above, that means Find misses and Verify succeeds.

const HPAT_STACK = 128

type HPAT
	as ubyte ptr  ptr_
	as integer    length
	as ubyte ptr  heap        '' non-NULL only when the stack buffer was too small
	as ubyte      buf(0 to HPAT_STACK - 1)
end type

private sub hPatArg( byval pat as FBUSTRING ptr, byval p as HPAT ptr )

	p->heap = 0
	p->ptr_ = 0
	p->length = 0

	if( pat = 0 ) then exit sub
	if( pat->data = 0 ) then exit sub
	if( FB_USTRSIZE( pat ) <= 0 ) then exit sub

	dim as ushort ptr up = pat->data
	dim as integer ulen = FB_USTRSIZE( pat )

	dim as integer nbytes = tkrt_Utf16ToUtf8( up, ulen, 0, 0 )
	if( nbytes <= 0 ) then exit sub

	if( nbytes < HPAT_STACK ) then
		tkrt_Utf16ToUtf8( up, ulen, @p->buf(0), nbytes )
		p->ptr_ = @p->buf(0)
		p->length = nbytes
	else
		p->heap = allocate( nbytes + 1 )
		if( p->heap = 0 ) then exit sub

		tkrt_Utf16ToUtf8( up, ulen, p->heap, nbytes )
		p->ptr_ = p->heap
		p->length = nbytes
	end if

end sub

private sub hPatRel( byval p as HPAT ptr )
	if( p->heap <> 0 ) then
		deallocate( p->heap )
		p->heap = 0
	end if
end sub

'' A temporary holding one run of the source.
private function hStrTempFrom _
	( byval src as ubyte ptr, byval n as integer ) as FBSTRING ptr

	if( n <= 0 ) then return TKORT_NULLSTR( )

	dim as FBSTRING ptr dst = fb_hStrAllocTemp( 0, n )
	if( dst = 0 ) then return TKORT_NULLSTR( )

	if( dst->data <> 0 ) then
		fb_hStrCopy( dst->data, cptr( zstring ptr, src ), n )
		dst->data[n] = 0
	end if

	return dst

end function

'' Two runs joined -- for DeleteAt, which keeps the text either side of the cut.
private function hStrTempFrom2 _
	( _
		byval a as ubyte ptr, byval alen as integer, _
		byval b as ubyte ptr, byval blen as integer _
	) as FBSTRING ptr

	dim as integer n = alen + blen
	if( n <= 0 ) then return TKORT_NULLSTR( )

	dim as FBSTRING ptr dst = fb_hStrAllocTemp( 0, n )
	if( dst = 0 ) then return TKORT_NULLSTR( )

	if( dst->data <> 0 ) then
		if( alen > 0 ) then fb_hStrCopy( dst->data, cptr( zstring ptr, a ), alen )
		if( blen > 0 ) then fb_hStrCopy( @dst->data[alen], cptr( zstring ptr, b ), blen )
		dst->data[n] = 0
	end if

	return dst

end function

'' ============================================================== wrappers
''
'' Every position argument and every position result is 1-BASED, and 0 means
'' "not found", matching INSTR. The conversion from the algorithms' 0-based,
'' -1-means-absent convention happens HERE AND NOWHERE ELSE.
''
'' NOTHING BELOW RELEASES ITS ARGUMENTS. These are reached through a plain
'' `declare`, not the compiler's intrinsic path, so the descriptors are the
'' caller's and fbc frees them -- unlike fb_StrInstr and the rest of the classic
'' entry points, every one of which consumes its temporaries. Two conventions in
'' one library, and the difference is which path the compiler took to get here.
''
'' The ones that RETURN TEXT hand back a temp FBSTRING the CALLER frees; the
'' shared empty descriptor is returned for an empty result and must not be freed
'' by anyone.

extern "rtlib"

function tkort_StrTally alias "fb_StrTally" _
	( byval s as FBSTRING ptr, byval pat as FBUSTRING ptr, byval ic as long ) as integer

	dim as ubyte ptr sp = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( pat, @p )

	dim as integer r = hTally( sp, sl, p.ptr_, p.length, ic )

	hPatRel( @p )
	return r

end function

function tkort_StrTallyChars alias "fb_StrTallyChars" _
	( byval s as FBSTRING ptr, byval st as FBUSTRING ptr, byval ic as long ) as integer

	dim as ubyte ptr sp = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( st, @p )

	dim as integer r = hTallyAny( sp, sl, p.ptr_, p.length, ic )

	hPatRel( @p )
	return r

end function

function tkort_StrInstrChars alias "fb_StrInstrChars" _
	( byval start as integer, byval s as FBSTRING ptr, byval st as FBUSTRING ptr, byval ic as long ) as integer

	if( start < 1 ) then return 0

	dim as ubyte ptr sp = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( st, @p )

	dim as integer at = hFindAny( sp, sl, p.ptr_, p.length, start - 1, ic )
	dim as integer r = iif( at < 0, 0, at + 1 )

	hPatRel( @p )
	return r

end function

function tkort_StrVerifySet alias "fb_StrVerifySet" _
	( byval start as integer, byval s as FBSTRING ptr, byval st as FBUSTRING ptr, byval ic as long ) as integer

	if( start < 1 ) then return 0

	dim as ubyte ptr sp = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( st, @p )

	dim as integer at = hVerify( sp, sl, p.ptr_, p.length, start - 1, ic )
	dim as integer r = iif( at < 0, 0, at + 1 )

	hPatRel( @p )
	return r

end function

function tkort_StrSpanOf alias "fb_StrSpanOf" _
	( byval start as integer, byval s as FBSTRING ptr, byval st as FBUSTRING ptr, byval ic as long ) as integer

	if( start < 1 ) then return 0

	dim as ubyte ptr sp = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( st, @p )

	dim as integer r = hSpan( sp, sl, p.ptr_, p.length, start - 1, ic )

	hPatRel( @p )
	return r

end function

function tkort_StrStartsWith alias "fb_StrStartsWith" _
	( byval s as FBSTRING ptr, byval pre as FBUSTRING ptr, byval ic as long ) as long

	dim as ubyte ptr sp = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( pre, @p )

	dim as long r = hStartsWith( sp, sl, p.ptr_, p.length, ic )

	hPatRel( @p )
	return r

end function

function tkort_StrEndsWith alias "fb_StrEndsWith" _
	( byval s as FBSTRING ptr, byval suf as FBUSTRING ptr, byval ic as long ) as long

	dim as ubyte ptr sp = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( suf, @p )

	dim as long r = hEndsWith( sp, sl, p.ptr_, p.length, ic )

	hPatRel( @p )
	return r

end function

'' CONSISTENT WITH StartsWith RATHER THAN WITH hFind: every string contains the
'' empty string, so this special-cases an empty pattern instead of letting hFind
'' answer -1 for it.
function tkort_StrContains alias "fb_StrContains" _
	( byval s as FBSTRING ptr, byval pat as FBUSTRING ptr, byval ic as long ) as long

	dim as ubyte ptr sp = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( pat, @p )

	dim as long r = any
	if( p.length <= 0 ) then
		r = 1
	else
		r = iif( hFind( sp, sl, p.ptr_, p.length, 0, ic ) >= 0, 1, 0 )
	end if

	hPatRel( @p )
	return r

end function

function tkort_StrIsNumeric alias "fb_StrIsNumeric" ( byval s as FBSTRING ptr ) as long
	dim as ubyte ptr sp = any
	dim as integer sl = any
	hStrArg( s, @sp, @sl )
	return hIsNumeric( sp, sl )
end function

function tkort_StrIsBlank alias "fb_StrIsBlank" ( byval s as FBSTRING ptr ) as long
	dim as ubyte ptr sp = any
	dim as integer sl = any
	hStrArg( s, @sp, @sl )
	return hIsBlank( sp, sl )
end function

end extern

'' ------------------------------------------------------- extract family
''
'' Each hands back a temp FBSTRING that the CALLER frees. A start below 1 is the
'' shared empty descriptor -- not an error, and not position 1.
''
'' Note `sp + off` is computed even when sp is NULL, because a NULL source gives
'' (0, 0) from every span helper and hStrTempFrom returns the shared empty for a
'' count of 0 without dereferencing. Reproduced as written.

extern "rtlib"

function tkort_StrExtract alias "fb_StrExtract" _
	( byval start as integer, byval s as FBSTRING ptr, byval pat as FBUSTRING ptr, byval ic as long ) as FBSTRING ptr

	if( start < 1 ) then return TKORT_NULLSTR( )

	dim as ubyte ptr sp = any
	dim as integer sl = any, off = any, cnt = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( pat, @p )

	hExtractSpan( sp, sl, p.ptr_, p.length, start - 1, ic, @off, @cnt )
	dim as FBSTRING ptr r = hStrTempFrom( sp + off, cnt )

	hPatRel( @p )
	return r

end function

function tkort_StrExtractChars alias "fb_StrExtractChars" _
	( byval start as integer, byval s as FBSTRING ptr, byval st as FBUSTRING ptr, byval ic as long ) as FBSTRING ptr

	if( start < 1 ) then return TKORT_NULLSTR( )

	dim as ubyte ptr sp = any
	dim as integer sl = any, off = any, cnt = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( st, @p )

	hExtractCharsSpan( sp, sl, p.ptr_, p.length, start - 1, ic, @off, @cnt )
	dim as FBSTRING ptr r = hStrTempFrom( sp + off, cnt )

	hPatRel( @p )
	return r

end function

'' NOTE THE ARGUMENT ORDER: Remain takes ( s, pat, start ) where Extract takes
'' ( start, s, pat ). Not a transcription slip -- fbc's declarations differ.
function tkort_StrRemain alias "fb_StrRemain" _
	( byval s as FBSTRING ptr, byval pat as FBUSTRING ptr, byval start as integer, byval ic as long ) as FBSTRING ptr

	if( start < 1 ) then return TKORT_NULLSTR( )

	dim as ubyte ptr sp = any
	dim as integer sl = any, off = any, cnt = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( pat, @p )

	hRemainSpan( sp, sl, p.ptr_, p.length, start - 1, ic, @off, @cnt )
	dim as FBSTRING ptr r = hStrTempFrom( sp + off, cnt )

	hPatRel( @p )
	return r

end function

function tkort_StrRemainChars alias "fb_StrRemainChars" _
	( byval s as FBSTRING ptr, byval st as FBUSTRING ptr, byval start as integer, byval ic as long ) as FBSTRING ptr

	if( start < 1 ) then return TKORT_NULLSTR( )

	dim as ubyte ptr sp = any
	dim as integer sl = any, off = any, cnt = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( st, @p )

	hRemainCharsSpan( sp, sl, p.ptr_, p.length, start - 1, ic, @off, @cnt )
	dim as FBSTRING ptr r = hStrTempFrom( sp + off, cnt )

	hPatRel( @p )
	return r

end function

function tkort_StrBetween alias "fb_StrBetween" _
	( _
		byval s as FBSTRING ptr, byval d1 as FBUSTRING ptr, byval d2 as FBUSTRING ptr, _
		byval start as integer, byval ic as long _
	) as FBSTRING ptr

	if( start < 1 ) then return TKORT_NULLSTR( )

	dim as ubyte ptr sp = any
	dim as integer sl = any, off = any, cnt = any
	dim as HPAT p1, p2

	hStrArg( s, @sp, @sl )
	hPatArg( d1, @p1 )
	hPatArg( d2, @p2 )

	hBetweenSpan( sp, sl, p1.ptr_, p1.length, p2.ptr_, p2.length, start - 1, ic, @off, @cnt )
	dim as FBSTRING ptr r = hStrTempFrom( sp + off, cnt )

	hPatRel( @p1 )
	hPatRel( @p2 )
	return r

end function

function tkort_StrClipLeft alias "fb_StrClipLeft" _
	( byval s as FBSTRING ptr, byval n as integer ) as FBSTRING ptr

	dim as ubyte ptr sp = any
	dim as integer sl = any, off = any, cnt = any

	hStrArg( s, @sp, @sl )
	hClipLeftSpan( sl, n, @off, @cnt )

	return hStrTempFrom( sp + off, cnt )

end function

function tkort_StrClipRight alias "fb_StrClipRight" _
	( byval s as FBSTRING ptr, byval n as integer ) as FBSTRING ptr

	dim as ubyte ptr sp = any
	dim as integer sl = any, off = any, cnt = any

	hStrArg( s, @sp, @sl )
	hClipRightSpan( sl, n, @off, @cnt )

	return hStrTempFrom( sp + off, cnt )

end function

end extern

'' ----------------------------------------------------- delete and insert

extern "rtlib"

function tkort_StrDeleteAt alias "fb_StrDeleteAt" _
	( byval s as FBSTRING ptr, byval start as integer, byval count as integer ) as FBSTRING ptr

	dim as ubyte ptr sp = any
	dim as integer sl = any, coff = any, clen = any

	hStrArg( s, @sp, @sl )
	hDeleteCut( sl, start, count, @coff, @clen )

	'' Nothing removed -- and every invalid argument lands here.
	if( clen <= 0 ) then return hStrTempFrom( sp, sl )

	return hStrTempFrom2( sp, coff, sp + coff + clen, sl - coff - clen )

end function

function tkort_StrInsertAt alias "fb_StrInsertAt" _
	( byval s as FBSTRING ptr, byval ins as FBUSTRING ptr, byval pos_ as integer ) as FBSTRING ptr

	dim as ubyte ptr sp = any
	dim as integer sl = any

	hStrArg( s, @sp, @sl )

	dim as integer at = hInsertSplit( sl, pos_ )
	'' Position below 1: the string comes back untouched.
	if( at < 0 ) then return hStrTempFrom( sp, sl )

	dim as HPAT p
	hPatArg( ins, @p )

	dim as integer n = sl + p.length
	if( n <= 0 ) then
		hPatRel( @p )
		return TKORT_NULLSTR( )
	end if

	dim as FBSTRING ptr dst = fb_hStrAllocTemp( 0, n )
	if( dst = 0 ) then
		hPatRel( @p )
		return TKORT_NULLSTR( )
	end if

	if( dst->data <> 0 ) then
		if( at > 0 ) then fb_hStrCopy( dst->data, cptr( zstring ptr, sp ), at )
		if( p.length > 0 ) then fb_hStrCopy( @dst->data[at], cptr( zstring ptr, p.ptr_ ), p.length )
		if( sl - at > 0 ) then fb_hStrCopy( @dst->data[at + p.length], cptr( zstring ptr, sp + at ), sl - at )
		dst->data[n] = 0
	end if

	hPatRel( @p )
	return dst

end function

end extern

'' ------------------------------------------------------ transform family
''
'' Each builds a new string whose length is known BEFORE it is written, so there
'' is no measure pass: the allocation is exact, or a safe upper bound where the
'' result can only shrink.

'' Allocate a temp of exactly n and hand back its buffer, or NULL.
private function hStrTempAlloc _
	( byval n as integer, byval outbuf as ubyte ptr ptr ) as FBSTRING ptr

	*outbuf = 0

	if( n <= 0 ) then return TKORT_NULLSTR( )

	dim as FBSTRING ptr dst = fb_hStrAllocTemp( 0, n )
	if( dst = 0 ) then return TKORT_NULLSTR( )

	*outbuf = cptr( ubyte ptr, dst->data )
	return dst

end function

'' Trim a temp whose fill wrote fewer units than were reserved. The descriptor
'' owns the block either way, so this only corrects the length -- and it uses
'' FB_STRSETLEN, which PRESERVES the temp bit that fb_hStrAllocTemp just set.
private sub hStrTempTrim( byval dst as FBSTRING ptr, byval written as integer )
	if( dst->data = 0 ) then exit sub
	FB_STRSETLEN( dst, written )
	dst->data[written] = 0
end sub

extern "rtlib"

'' The size is EXACT rather than an estimate: hTally walks with the same loop
'' hReplaceFill does, so the two agree by construction.
function tkort_StrReplace alias "fb_StrReplace" _
	( byval s as FBSTRING ptr, byval pat as FBUSTRING ptr, byval rep as FBUSTRING ptr, byval ic as long ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any
	dim as HPAT p, r

	hStrArg( s, @sp, @sl )
	hPatArg( pat, @p )
	hPatArg( rep, @r )

	dim as integer count = hTally( sp, sl, p.ptr_, p.length, ic )
	dim as integer n = sl + count * (r.length - p.length)

	dim as FBSTRING ptr dst = hStrTempAlloc( n, @outbuf )
	if( outbuf <> 0 ) then
		dim as integer w = hReplaceFill( outbuf, sp, sl, p.ptr_, p.length, r.ptr_, r.length, ic )
		hStrTempTrim( dst, w )
	end if

	hPatRel( @p )
	hPatRel( @r )
	return dst

end function

'' Remove is Replace with an empty replacement -- literally: it calls the same
'' fill with a NULL replacement pointer.
function tkort_StrRemove alias "fb_StrRemove" _
	( byval s as FBSTRING ptr, byval pat as FBUSTRING ptr, byval ic as long ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( pat, @p )

	dim as integer count = hTally( sp, sl, p.ptr_, p.length, ic )
	dim as integer n = sl - count * p.length

	dim as FBSTRING ptr dst = hStrTempAlloc( n, @outbuf )
	if( outbuf <> 0 ) then
		dim as integer w = hReplaceFill( outbuf, sp, sl, p.ptr_, p.length, 0, 0, ic )
		hStrTempTrim( dst, w )
	end if

	hPatRel( @p )
	return dst

end function

function tkort_StrRemoveChars alias "fb_StrRemoveChars" _
	( byval s as FBSTRING ptr, byval st as FBUSTRING ptr, byval ic as long ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( st, @p )

	dim as FBSTRING ptr dst = hStrTempAlloc( sl, @outbuf )
	if( outbuf <> 0 ) then
		dim as integer w = hRemoveCharsFill( outbuf, sp, sl, p.ptr_, p.length, ic )
		hStrTempTrim( dst, w )
	end if

	hPatRel( @p )
	return dst

end function

function tkort_StrRetainChars alias "fb_StrRetainChars" _
	( byval s as FBSTRING ptr, byval st as FBUSTRING ptr, byval ic as long ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( st, @p )

	dim as FBSTRING ptr dst = hStrTempAlloc( sl, @outbuf )
	if( outbuf <> 0 ) then
		dim as integer w = hRetainCharsFill( outbuf, sp, sl, p.ptr_, p.length, ic )
		hStrTempTrim( dst, w )
	end if

	hPatRel( @p )
	return dst

end function

end extern

extern "rtlib"

'' A replacement that is NOT EXACTLY ONE BYTE copies the input through
'' unchanged. `with` arrives as a ustring, so a non-ASCII replacement encodes to
'' two or more bytes and has no one-byte form -- and this is a one-for-one
'' substitution, so there is nothing sensible to substitute.
function tkort_StrReplaceChars alias "fb_StrReplaceChars" _
	( byval s as FBSTRING ptr, byval st as FBUSTRING ptr, byval wth as FBUSTRING ptr, byval ic as long ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any
	dim as HPAT p, r

	hStrArg( s, @sp, @sl )
	hPatArg( st, @p )
	hPatArg( wth, @r )

	dim as FBSTRING ptr dst = hStrTempAlloc( sl, @outbuf )
	if( outbuf <> 0 ) then
		if( r.length <> 1 ) then
			if( sl > 0 ) then memcpy( outbuf, sp, sl )
			hStrTempTrim( dst, sl )
		else
			hReplaceCharsFill( outbuf, sp, sl, p.ptr_, p.length, r.ptr_[0], ic )
			hStrTempTrim( dst, sl )
		end if
	end if

	hPatRel( @p )
	hPatRel( @r )
	return dst

end function

function tkort_StrReverse alias "fb_StrReverse" ( byval s as FBSTRING ptr ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any

	hStrArg( s, @sp, @sl )

	dim as FBSTRING ptr dst = hStrTempAlloc( sl, @outbuf )
	if( outbuf <> 0 ) then
		hReverseFill( outbuf, sp, sl )
		hStrTempTrim( dst, sl )
	end if

	return dst

end function

function tkort_StrRepeat alias "fb_StrRepeat" _
	( byval count as integer, byval s as FBSTRING ptr ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any

	hStrArg( s, @sp, @sl )

	if( count <= 0 ) then return TKORT_NULLSTR( )
	if( sl <= 0 ) then return TKORT_NULLSTR( )

	dim as integer n = count * sl
	dim as FBSTRING ptr dst = hStrTempAlloc( n, @outbuf )
	if( outbuf <> 0 ) then
		for i as integer = 0 to count - 1
			memcpy( outbuf + i * sl, sp, sl )
		next
		hStrTempTrim( dst, n )
	end if

	return dst

end function

function tkort_StrShrink alias "fb_StrShrink" _
	( byval s as FBSTRING ptr, byval mask as FBUSTRING ptr ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( mask, @p )

	dim as FBSTRING ptr dst = hStrTempAlloc( sl, @outbuf )
	if( outbuf <> 0 ) then
		dim as integer w = hShrinkFill( outbuf, sp, sl, p.ptr_, p.length )
		hStrTempTrim( dst, w )
	end if

	hPatRel( @p )
	return dst

end function

function tkort_StrMCase alias "fb_StrMCase" ( byval s as FBSTRING ptr ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any

	hStrArg( s, @sp, @sl )

	dim as FBSTRING ptr dst = hStrTempAlloc( sl, @outbuf )
	if( outbuf <> 0 ) then
		hMCaseFill( outbuf, sp, sl )
		hStrTempTrim( dst, sl )
	end if

	return dst

end function

function tkort_StrRemoveBetween alias "fb_StrRemoveBetween" _
	( _
		byval s as FBSTRING ptr, byval d1 as FBUSTRING ptr, byval d2 as FBUSTRING ptr, _
		byval removeAll as long, byval start as integer, byval ic as long _
	) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any

	hStrArg( s, @sp, @sl )

	'' A start below 1 returns the input, not the empty string.
	if( start < 1 ) then return hStrTempFrom( sp, sl )

	dim as HPAT p1, p2
	hPatArg( d1, @p1 )
	hPatArg( d2, @p2 )

	dim as FBSTRING ptr dst = hStrTempAlloc( sl, @outbuf )
	if( outbuf <> 0 ) then
		dim as integer w = hRemoveBetweenFill( outbuf, sp, sl, p1.ptr_, p1.length, _
		                                       p2.ptr_, p2.length, removeAll, start - 1, ic )
		hStrTempTrim( dst, w )
	end if

	hPatRel( @p1 )
	hPatRel( @p2 )
	return dst

end function

end extern

'' -------------------------------------------------------- pad and wrap
''
'' THE PAD CHARACTER IS ONE UNIT. `pad` arrives as a ustring, so it is encoded
'' to UTF-8 first -- and a non-ASCII pad is two or more bytes with no one-byte
'' form, so A SPACE IS USED rather than writing a lone lead byte. An empty pad
'' is a space for the same reason.
private function hStrPadUnit( byval p as HPAT ptr ) as ubyte
	if( p->length = 1 ) then return p->ptr_[0]
	return 32
end function

private function hStrPad _
	( byval s as FBSTRING ptr, byval fieldw as integer, byval pad as FBUSTRING ptr, byval mode as long ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( pad, @p )

	dim as FBSTRING ptr dst = hStrTempAlloc( fieldw, @outbuf )
	if( outbuf <> 0 ) then
		dim as integer w = hPadFill( outbuf, sp, sl, fieldw, hStrPadUnit( @p ), mode )
		hStrTempTrim( dst, w )
	end if

	hPatRel( @p )
	return dst

end function

extern "rtlib"

function tkort_StrPadRight alias "fb_StrPadRight" _
	( byval s as FBSTRING ptr, byval fieldw as integer, byval pad as FBUSTRING ptr ) as FBSTRING ptr
	return hStrPad( s, fieldw, pad, 0 )
end function

function tkort_StrPadLeft alias "fb_StrPadLeft" _
	( byval s as FBSTRING ptr, byval fieldw as integer, byval pad as FBUSTRING ptr ) as FBSTRING ptr
	return hStrPad( s, fieldw, pad, 1 )
end function

function tkort_StrPadCenter alias "fb_StrPadCenter" _
	( byval s as FBSTRING ptr, byval fieldw as integer, byval pad as FBUSTRING ptr ) as FBSTRING ptr
	return hStrPad( s, fieldw, pad, 2 )
end function

'' AN EMPTY `closing` MEANS "THE SAME AS `opening`", which is what lets Wrap(s)
'' quote and Wrap(s,"'") single-quote without a second overload. A genuinely
'' one-sided wrap is InsertAt's job. Unwrap uses the identical fallback.
function tkort_StrWrap alias "fb_StrWrap" _
	( byval s as FBSTRING ptr, byval op as FBUSTRING ptr, byval cl as FBUSTRING ptr ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any
	dim as HPAT a, b

	hStrArg( s, @sp, @sl )
	hPatArg( op, @a )
	hPatArg( cl, @b )

	dim as ubyte ptr clp = any
	dim as integer cll = any
	if( b.length > 0 ) then
		clp = b.ptr_ : cll = b.length
	else
		clp = a.ptr_ : cll = a.length
	end if

	dim as integer n = a.length + sl + cll
	dim as FBSTRING ptr dst = hStrTempAlloc( n, @outbuf )
	if( outbuf <> 0 ) then
		if( a.length > 0 ) then memcpy( outbuf, a.ptr_, a.length )
		if( sl > 0 ) then memcpy( outbuf + a.length, sp, sl )
		if( cll > 0 ) then memcpy( outbuf + a.length + sl, clp, cll )
		hStrTempTrim( dst, n )
	end if

	hPatRel( @a )
	hPatRel( @b )
	return dst

end function

function tkort_StrUnwrap alias "fb_StrUnwrap" _
	( byval s as FBSTRING ptr, byval op as FBUSTRING ptr, byval cl as FBUSTRING ptr, byval ic as long ) as FBSTRING ptr

	dim as ubyte ptr sp = any
	dim as integer sl = any, off = any, cnt = any
	dim as HPAT a, b

	hStrArg( s, @sp, @sl )
	hPatArg( op, @a )
	hPatArg( cl, @b )

	dim as ubyte ptr clp = any
	dim as integer cll = any
	if( b.length > 0 ) then
		clp = b.ptr_ : cll = b.length
	else
		clp = a.ptr_ : cll = a.length
	end if

	hUnwrapSpan( sp, sl, a.ptr_, a.length, clp, cll, ic, @off, @cnt )
	dim as FBSTRING ptr r = hStrTempFrom( sp + off, cnt )

	hPatRel( @a )
	hPatRel( @b )
	return r

end function

'' Escape MEASURES first (dst = NULL) because its output can grow by up to 4x;
'' Unescape can only shrink, so one pass into a buffer of slen is enough.
function tkort_StrEscape alias "fb_StrEscape" ( byval s as FBSTRING ptr ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any

	hStrArg( s, @sp, @sl )

	dim as integer n = hEscapeFill( 0, sp, sl )
	dim as FBSTRING ptr dst = hStrTempAlloc( n, @outbuf )
	if( outbuf <> 0 ) then
		hEscapeFill( outbuf, sp, sl )
		hStrTempTrim( dst, n )
	end if

	return dst

end function

function tkort_StrUnescape alias "fb_StrUnescape" ( byval s as FBSTRING ptr ) as FBSTRING ptr

	dim as ubyte ptr sp = any, outbuf = any
	dim as integer sl = any

	hStrArg( s, @sp, @sl )

	dim as FBSTRING ptr dst = hStrTempAlloc( sl, @outbuf )
	if( outbuf <> 0 ) then
		dim as integer w = hUnescapeFill( outbuf, sp, sl )
		hStrTempTrim( dst, w )
	end if

	return dst

end function

'' Call once with a NULL buffer to size it, once more to fill -- two linear
'' passes rather than the O(n^2) rescan a per-field accessor would force.
function tkort_StrSplitSpans alias "fb_StrSplitSpans" _
	( _
		byval s as FBSTRING ptr, byval delim as FBUSTRING ptr, byval ic as long, _
		byval spans as integer ptr, byval maxpairs as integer _
	) as integer

	dim as ubyte ptr sp = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( delim, @p )

	dim as integer r = hSplitSpans( sp, sl, p.ptr_, p.length, ic, spans, maxpairs )

	hPatRel( @p )
	return r

end function

function tkort_StrSplitCharsSpans alias "fb_StrSplitCharsSpans" _
	( _
		byval s as FBSTRING ptr, byval st as FBUSTRING ptr, byval ic as long, _
		byval spans as integer ptr, byval maxpairs as integer _
	) as integer

	dim as ubyte ptr sp = any
	dim as integer sl = any
	dim as HPAT p

	hStrArg( s, @sp, @sl )
	hPatArg( st, @p )

	dim as integer r = hSplitCharsSpans( sp, sl, p.ptr_, p.length, ic, spans, maxpairs )

	hPatRel( @p )
	return r

end function

end extern
