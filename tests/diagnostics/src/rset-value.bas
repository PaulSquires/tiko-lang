'' LSET and RSET are statements: as a value, fbc's 3 "Expected End-of-Line, found 'rset'"
'' (fbc-modern 1.20, 2026-10-25), at lines 5 and 6. The statement forms are fine (7, 8).
dim as string s = space( 6 )
dim as string t
print rset( "abc", 6 )
t = lset( "abc", 6 )
rset s, "abc"
lset s, "abc"
