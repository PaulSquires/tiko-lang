' COLOR as a parenthesised statement, and bare 'color' as a value. Output redirected, so the
' numbers are the runtime's defaults rather than a console's.
dim as integer before = color
dim as ulong c0 = color()
color(loword(c0), hiword(c0))
color(rgb(255, 255, 255) and 15, 0)
dim as integer after = color
print (before = c0); (after = color())
