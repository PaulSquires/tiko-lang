'' LSET and RSET INTO A 'string * N'.
''
'' A fixed-length narrow string is not a descriptor and cannot borrow one, so it has
'' entry points of its own. Measured from fbc's C:
''
''     fb_StrLsetANA( (void*)F1, -9223372036854775800ll, (FBSTRING*)&S2 )
''
'' -- the bytes and the TAGGED length, where the constant is &h8000000000000000 or N
'' and the sign bit is what says "fixed-length". On win32 the same shape with an int32.
'' A SOURCE of that shape borrows a temporary descriptor from fb_StrAllocTempDescF.
''
'' Sending one through fb_StrLset instead would hand the runtime eight bytes of the
'' string's own PADDING as a descriptor pointer, so this declined rather than guess --
'' the nine 'string * N' rows of string/lrset.bas and every UDT wrapper around one.
''
'' Run under fbc the lines below print, in order:
''
''     [abc     ]   [     abc]   [xy      ]   [      xy]   [de      ]

dim s2 as string = "abc"
dim z2 as zstring * 9 = "xy"
dim f1 as string * 8, f2 as string * 8 = "de"

lset f1 = s2 : print "["; f1; "]"
rset f1 = s2 : print "["; f1; "]"
lset f1 = z2 : print "["; f1; "]"
rset f1 = z2 : print "["; f1; "]"
lset f1 = f2 : print "["; f1; "]"
