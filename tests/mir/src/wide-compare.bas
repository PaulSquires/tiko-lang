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

    n = a[1]
    n = z[1]
    for i as integer = 0 to len( a ) - 1
        if a[i] <> b[i] then n = 5
    next
end sub
