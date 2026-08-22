'' WIDE STRING COMPARISON, and subscripting a fixed-length string.
''
'' Both were silent, and together they were the largest hidden gap in the corpus: 6,300
'' conditional branches WITH NO CONDITION, emitted as 'condbr _, then, else' and counted
'' as fully lowered. That is only visible at all because a missing IF condition now
'' declines.
''
'' Three things had to change, and each was an ordering or an operand problem rather
'' than a missing feature:
''
''   - THE COMPARISON ASKED ONLY ITS LEFT OPERAND whether this was a string compare.
''     Check computes no type for an intrinsic call, so 'trim( w ) = b' looked numeric
''     and its operands were loaded as aggregates and compared as integers.
''   - IT ACCEPTED ONLY AN ADDRESSABLE WIDE VARIABLE. WideOperand_ already knew all
''     three spellings -- a variable, 'wstr( x )', the trim family -- and was not asked.
''   - A LITERAL COMPARED AGAINST A WSTRING IS A WIDE LITERAL. fbc writes
''     '(uint16*)L"x"', a genuinely wide global, not a narrow one widened at runtime.
''
'' And SUBSCRIPTING a fixed-length string had no case anywhere: 'a[i]' over a wstring is
'' its CHARACTER, stride 2, and UNSIGNED -- fbc writes '(int32)*(uint16*)(...)', so a
'' sign extension would turn a character above 0x7FFF negative. The byte-by-byte loop in
'' fbcunit's own CU_ASSERT_WSTRING_EQUAL is exactly this shape.

sub P( )
    dim as wstring * 8 a, b
    dim as zstring * 8 z
    dim as long n

    if a = b then n = 1
    if a = "x" then n = 2
    if a = wstr( 1 ) then n = 3
    if trim( a ) = b then n = 4

    '' THREE SPELLINGS, one meaning. The third derefs to the UNSIZED builtin and used to
    '' match neither the array test nor the pointer one, so it declined between two
    '' forms that worked.
    n = a[1]
    n = z[1]
    dim as zstring ptr pz = cast( zstring ptr, @z )
    n = pz[1]
    n = (*pz)[1]
    for i as integer = 0 to len( a ) - 1
        if a[i] <> b[i] then n = 5
    next
end sub

'' A WIDE 'iif' is NOT the narrow shape with wide entry points substituted. Each arm
'' MEASURES its operand, ALLOCATES that many characters and assigns into what it got
'' back -- fb_WstrAlloc is the only wide entry point that allocates -- so the temporary
'' is a POINTER rather than storage, and the destination length in the arm's assign is
'' 0, not -1 and not a count, because the target was just allocated to fit. It is
'' released with fb_WstrDelete on the pointer LOADED from the slot.
dim shared as integer ct

sub Q( )
    dim as wstring * 32 a, b, c
    c = iif( ct, a, b )
    c = iif( ct, wstr( 1 ), wstr( 2 ) )
end sub

'' A 'byref as wstring' PARAMETER IS A WIDE STRING WITH NO DECLARED LENGTH. Its element
'' count is 0 -- which is exactly the length fbc passes for one,
'' 'fb_WstrAssign( C$1, 0ll, ... )' -- and reading that 0 as "not a wide string" is what
'' made every operation on one decline. "Is it wide" and "how many characters" are
'' different questions and now have different functions.
sub R( byref a as wstring, byref b as wstring, byref c as wstring )
    c = a
    c = iif( ct, a, b )
    c = a + b
end sub

'' A WIDE CONCATENATION AS AN OPERAND. fb_WstrConcat takes the two POINTERS and gives
'' back a temporary of its own, released with fb_WstrDelete once the consuming statement
'' is done -- the same lifetime a wide iif's own temporary has, so it goes on the same
'' list. Recognised BEFORE the type test, because a wide concat IS wide-typed and the
'' addressable branch would claim it and then ask for an address it has not got. That is
'' the same ordering trap the narrow paths set four times.
sub S( )
    dim as wstring * 33 a, b, c, w0
    c = iif( ct, a + b, w0 )
end sub

'' PRINTING A WIDE CONCATENATION, and the chain rule behind it.
''
'' 'print w & c' declined while 'print w' beside it worked: Check gives a '&' chain NO
'' TYPE OF ITS OWN, so PRINT's wide branch -- which asks the node's type -- saw nothing
'' and fell through to the numeric one. Recognised by SHAPE instead.
''
'' And fb_WstrConcat takes exactly TWO operands, so a longer chain is LEFT-FOLDED with a
'' temporary per step and a delete for each: 'a & b & c' is
'' 'fb_WstrConcat( fb_WstrConcat( A, B ), C )'. Measured; that is what fbc emits.
sub T( )
    dim as wstring * 50 a, b, w
    print a & b
    print a & b & w
    print #(1), a & ", " & b
end sub
