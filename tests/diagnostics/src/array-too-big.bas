'' AN ARRAY MUST FIT IN A SIGNED 32-BIT BYTE COUNT -- fbc error 50, "Array too big". The
'' limit is on TOTAL BYTES, not on the element count, and it is 2147483647 EXACTLY.
'' Measured on three element widths, each side of the boundary:
''
''     byte  t(0 to &h7FFFFFFE)   2147483647 bytes   accepted
''     byte  t(0 to &h7FFFFFFF)   2147483648         error 50
''     long  t(0 to 536870910)    2147483644         accepted
''     long  t(0 to 536870911)    2147483648         error 50
''     short t(0 to 1073741822)   2147483646         accepted
''     short t(0 to 1073741823)   2147483648         error 50
''
'' -- and the dimensions MULTIPLY.
''
'' UNDERNEATH IT was a second bug: the element count was accumulated in a LONG, so
'' 2147483648 elements overflowed to a negative and the 'total <= 0' test then turned the
'' whole declaration into a DYNAMIC array. Silently -- a fixed array became a descriptor.
dim shared as byte over1( 0 to &h7FFFFFFF )
dim shared as long over2( 0 to 536870911 )
dim shared as short over3( 0 to 1073741823 )
dim shared as byte over4( 0 to 5, 0 to 400000000 )
dim shared as zstring * 16 over5( 0 to 134217728 )

'' Each of these is one byte under the limit, or far under it, and is accepted.
dim shared as byte under1( 0 to &h7FFFFFFE )
dim shared as long under2( 0 to 536870910 )
dim shared as short under3( 0 to 1073741822 )
dim shared as byte under4( 0 to 100 )

'' -- AND THE 'sizeof' SPELLING ------------------------------------------------
''
'' The corpus writes an array at the size limit as 'LIMIT \ sizeof( zstring * 16 )'.
'' A BOUND IS FOLDED BEFORE ITS EXPRESSION IS WALKED, to build the array's type, so the
'' N_TYPEREF inside that sizeof was still untyped when ConstOf reached it and answered
'' nothing -- the array then had no constant size and became DYNAMIC, and the size check
'' had nothing to check.
''
'' A UDT'S sizeof STILL DOES NOT FOLD HERE: its layout is computed after Resolve, and
'' answering 0 would be a wrong number rather than no number.
const LIMIT2 = &h7FFFFFFF

dim shared as zstring * 16 zover( 0 to LIMIT2 \ sizeof( zstring * 16 ) )
dim shared as zstring * 16 zunder( 0 to (LIMIT2 \ sizeof( zstring * 16 )) - 1 )
