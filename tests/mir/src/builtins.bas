'' THE PREDECLARED BUILTINS whose aliases had to be MEASURED, one name at a time, from
'' fbc's own generated C. None of them is guessable and several are traps:
''
''   POS AND CSRLIN ARE X AND Y THE OTHER WAY ROUND -- csrlin is the ROW and compiles
''   to fb_GetY, pos is the COLUMN and compiles to fb_GetX. Backwards links cleanly and
''   returns the wrong number.
''
''   POS IS TWO ENTRY POINTS, not one with a default: bare it is fb_GetX( ), with an
''   argument it is fb_Pos( n ). CSRLIN has no argument form at all -- fbc rejects
''   'csrlin( 0 )'.
''
''   RND's default argument is ONE, and its parameter is SINGLE while its result is
''   DOUBLE.
''
''   FRE is pointer-sized unsigned (uinteger), while LOC and LOF are LONGINT on BOTH
''   targets -- they do not narrow on win32, unlike the string-length family.
dim as long row_ = csrlin
dim as long col = pos
dim as long col2 = pos( 0 )
dim as double r1 = rnd
dim as double r2 = rnd( 5 )
dim as uinteger avail = fre
dim as long atEnd = eof( 1 )
dim as longint size_ = lof( 1 )
dim as longint here = loc( 1 )
dim as long lp = lpos( 1 )
dim as long port = inp( 888 )
print row_, col, col2, r1, r2, avail, atEnd, size_, here, lp, port
