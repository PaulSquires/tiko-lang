'' 'for each v as double in b' where b holds LONGs.
''
'' The element is loaded at the ARRAY's width and has to be converted to the LOOP
'' VARIABLE's before it is stored. The store went out un-coerced, so an i32 landed in
'' an f64 slot -- a wrong VALUE, not just a wrong width, had it reached a backend.

dim b(3 to 5) as long = { 7, 8, 9 }
for each v as double in b
next

'' No conversion when the widths already agree.
for each w as long in b
next
