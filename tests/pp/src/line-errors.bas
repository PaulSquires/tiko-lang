'' WHAT '#line' REFUSES, all four measured against fbc:
''
''     #line                   error 17, "Syntax error in '#line'"
''     #line -3                error 17, and it points at the '-' -- so the number is
''                             a LITERAL, not an expression, and not a signed one
''     #line 10 foo.bas        error 3, "Expected End-of-Line, found 'foo'"
''     #line 10+2              error 3, at the '+'
''     #line 20 "a.bas" junk   error 3, at 'junk' -- and it reports it as a.bas(20),
''                             so the number AND the name are applied before the
''                             trailing token is rejected
''
'' The last of those is why the mark is still recorded on the error path here. It
'' looks like a detail and it is the difference between the next diagnostic in the
'' file landing where fbc puts it and landing three lines away.
#line
#line -3
#line 10 foo.bas
#line 10+2
#line 20 "a.bas" junk
