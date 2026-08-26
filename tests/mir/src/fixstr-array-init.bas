'' A BRACE INITIALISER OVER AN ARRAY OF FIXED-LENGTH STRINGS, dropped whole.
''
'' 'zstring * 32' is itself modelled as an ARRAY of the char builtin -- which is what it
'' is -- so an array of them is an array of arrays, and it lowers as an aggregate like
'' every other array. The array-initialiser path rejected aggregates, so the whole
'' initialiser vanished and the elements read back as stack garbage.
''
'' Measured, and the destination length is the ELEMENT'S OWN character count, not -1:
''
''   fb_StrAssign( (void*)Z$0, 32ll, (void*)"abcdef", 7ll, 0 );
''   fb_StrAssign( (void*)((int64)(char*)Z$0 + 32ll), 32ll, (void*)"ghijkl", 7ll, 0 );
''
'' -- which is exactly what the SCALAR declaration of one already emitted, so each
'' element goes through the same routine with its own address.
dim as zstring * 32 z(0 to 1) = { "abcdef", "ghijkl" }
print z(0); z(1)

dim as string * 8 f(0 to 1) = { "ab", "cd" }
print f(0); "|"; f(1); "|"
