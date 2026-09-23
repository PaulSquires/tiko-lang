'' A PROCEDURE NAMED WITHOUT PARENTHESES INTO A WSTRING IS A CALL.
''
'' 'dim w as wstring * 260 = ExePath & "\Resources\FILECOPY.AVI"' segfaulted before the program
'' printed anything: the narrow-to-wide transfer asked for ExePath's ADDRESS, got the
'' function's, and fb_WstrAssignFromA read machine code as a string descriptor. Every
'' narrow destination already called it. fbc prints what this file prints, byte for
'' byte -- each form below, at module level and inside a SUB; goldenrun executes it.
dim as string s1 = ExePath
dim as wstring * 260 w1 = ExePath
dim as wstring * 260 w2 = ExePath & "\x"
dim as wstring * 260 w3
w3 = ExePath & "\x"
dim as wstring * 260 w4 = CurDir & "\x"
dim as wstring * 260 w5 = "[" & ExePath & "]"
dim as wstring * 260 w6 = w1 & ExePath
print len( w1 ) = len( s1 ), len( w2 ) = len( s1 ) + 2, len( w3 ) = len( w2 ), len( w4 ) > 2, len( w5 ) = len( s1 ) + 2, len( w6 ) = 2 * len( s1 )
print right( w2, 2 ), left( w5, 1 ), right( w5, 1 )
if w1 = ExePath then print "eq" else print "ne"
print len( wstr( ExePath ) ) = len( s1 )
sub inproc( )
    DIM wszName AS WSTRING * 260 = ExePath & "\Resources\FILECOPY.AVI"
    print right( wszName, 23 )
end sub
inproc( )
