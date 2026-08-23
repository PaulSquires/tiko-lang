'' A BYREF NUMERIC PARAMETER TAKES ITS OWN TYPE AND NOTHING ELSE. Measured: 'declare
'' sub F( byref x as long )' called with a SHORT or an INTEGER is fbc's error 58, not a
'' conversion -- there is nowhere for a converted value to live that the callee could
'' write back through. A constant is exempt: it has no address either way, and fbc
'' materialises a temporary.
''
'' It decides an OVERLOAD, which is why it is here rather than in a diagnostic test.
declare sub P overload alias "p32" ( byref a as long )
declare sub P overload alias "p64" ( byref a as integer )
dim as integer i
dim as long l
P i
P l
P( i )

'' A CALL WRITTEN AS A STATEMENT IS NOT AN N_CALL NODE, so nothing costed its arguments
'' and lowering used whatever Resolve had bound -- the HEAD of the overload chain. Both
'' spellings above must reach the same procedure.

'' The graphics outputs are the same rule: 'screeninfo' over INTEGERs is a DIFFERENT
'' ENTRY POINT taking int64*, and calling the 32-bit one with int64 pointers writes
'' four bytes into an eight-byte slot and leaves the rest as it was.
dim as integer a, b
dim as long la, lb
screeninfo la, lb
screeninfo a, b

'' IMAGEINFO is NOT overloaded -- an 'integer' output is fbc's error 58 -- so the long
'' form is the only one that binds.
dim as long r
r = imageinfo( 0, la )

'' An ALIAS on an OVERLOAD is still mangled: fbc emits _Z3p32Ri, not p32. Measured.
