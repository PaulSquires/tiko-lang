'' POINTER ARITHMETIC IS SCALED BY THE POINTEE, and NONE of it was -- in either half of
'' the language. 'dim as short ptr q = p + 1' emitted 'add p, 1', one BYTE, and 'p += 1'
'' the same. Every pointer walk over anything wider than a byte was off, silently, and it
'' verified. Measured, five shapes from two probes:
''
''   p + 1     over 'short ptr'     (uint8*)P + 2
''   1 + p     the same                            -- either side scales
''   r -= 2    over 'integer ptr'   (uint8*)R + -16
''   a += 1    over 'any ptr'       (uint8*)A + 1  -- an ANY pointee is ONE, not its
''                                                    size, which is zero
''   q - p     both pointers        ((int64)Q - (int64)P) / 2
''
'' The last scales the RESULT rather than an operand, and only when BOTH sides are
'' pointers.
''
'' The compound form takes its element size from the ASSIGNMENT TARGET'S type, which is
'' what makes 'cptr( short ptr, pt ) += 1' advance by two even though pt is an 'any ptr'
'' -- fbc writes 'PT$0 = (void*)((uint8*)PT$0 + 2ll)' for it.
dim as short ptr p
dim as any ptr q
dim as integer ptr r
p += 1
q += 1
r -= 2
p += 3
print p, q, r

dim as integer i = 100
dim as any ptr pt = @i
cptr( short ptr, pt ) += 1
print ( pt = cast( any ptr, cast( byte ptr, @i ) + 2 ) )
