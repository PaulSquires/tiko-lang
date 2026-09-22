'' WRITE TAKES NEITHER ';' NOR 'using'.
''
'' Measured against fbc-modern 1.20.0, 2026-09-22. WRITE's list is commas only, and even
'' a trailing comma is legal, while every ';' spelling and the USING form are refused:
''
''     write s;              error 3,  Expected End-of-Line, found ';'
''     write s; t            error 3,  Expected End-of-Line, found ';'
''     write #1, s;          error 3,  Expected End-of-Line, found ';'
''     write ;               error 3,  Expected End-of-Line, found ';'
''     write using "&"; s    error 3,  Expected End-of-Line, found 'using'
''     write #1; s           error 16, Expected ',', found ';'
''
'' tiko read WRITE's list with PRINT's grammar and accepted all six. The ';' forms wrote
'' a separator WRITE has no meaning for, and 'write using' was marked as a USING
'' statement, which lowering declines -- so that line vanished with nothing said.
''
'' The last one is fbc's error 16 rather than its error 3; it is reported here as the
'' same end-of-statement diagnostic as the others, on the same token.
''
'' ONE PER STATEMENT: the parser reports the first refusal in a statement and stays
'' silent for the rest of it, which is why each bad form is a line of its own.
dim as string s = "a", t = "b"
open cons for output as #1

write s;
write s; t
write #1, s;
write ;
write using "&"; s
write #1; s

'' -- ACCEPTED, all of them, and the PRINT forms beside them: a comma list, a trailing
'' comma, a bare WRITE, a file number, and PRINT's own ';' and USING.
write s
write s, t
write s,
write
write #1, s
print s;
print s,
print using "&"; s
print #1, s; t
