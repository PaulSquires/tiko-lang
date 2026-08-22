'' 'string * N' -- THE FIXED-LENGTH, SPACE-PADDED STRING.
''
'' A THIRD string flavour, not a spelling of either of the other two, and it was
'' resolved to the plain 'string' builtin: a 24-BYTE DESCRIPTOR where fbc has N raw
'' bytes. Every one was the wrong size and every access read the wrong thing.
''
'' Measured, and the differences from 'zstring * N' are the whole point:
''
''   storage        exactly N bytes, no terminator and no room reserved for one, so a
''                  'string * 8' holds EIGHT characters where 'zstring * 8' holds seven
''   initial value  N SPACES -- memset value 32 -- where a zstring gets NULs. Not
''                  incidental: with no terminator the N bytes ARE the value, so an
''                  unwritten one must read back as N blanks.
''   runtime length '&h8000000000000000 or N' on win64, '&h80000000 or N' on win32.
''                  THE SIGN BIT IS THE TAG. A plain 'string' passes -1 and a
''                  'zstring * N' passes N, so all three are told apart by this one
''                  argument rather than by separate entry points.
''   trailing arg   fb_StrAssign's fifth argument is -1 when the DESTINATION is one and
''                  0 otherwise -- it never depends on the source.
''   len()          a COMPILE-TIME CONSTANT N, never a call and never content-dependent.
''                  Every 'if len( a ) = 0' over a fixed string is dead code, in fbc too.
''   descriptor     fb_StrAllocTempDescF( ptr, taggedLen ) -- its own entry point, not
''                  the Z form, which strlen's a buffer this type does not terminate.
''
'' ONE MECHANICAL CONSEQUENCE worth recording: MV_CONST_INT's payload is 32 BITS, and
'' the tagged length does not fit. Pushed inline it truncated to plain N and silently
'' turned the fixed-length tag into an ordinary zstring count -- so it goes out as a
'' const INSTRUCTION instead.
''
'' NOT MODELLED, because fbc rejects it outright: 'string * N' is not a parameter type
'' and not a return type, in any mode -- 'error 324' for byref, 'error 59' for byval,
'' 'error 55' for a return.

sub P( )
    dim as string * 32 a, b
    dim as string * 7 c7
    dim as string s
    dim as zstring * 32 z
    dim as long n

    a = b : a = s : a = z : a = "literal"
    s = a : z = a

    if a = b then n = 1
    if a = "x" then n = 2
    if a = s then n = 3

    c7 = a + b        '' a temp descriptor, then an assign into the fixed destination
    s = a + b         '' assign + concat-assign, no temp: a 'string' destination

    n = len( a )      '' the constant 32
    n = a[1]          '' one byte, unsigned
    n = instr( a, s ) '' through fb_StrAllocTempDescF
    s = trim( a )
    print a
end sub
