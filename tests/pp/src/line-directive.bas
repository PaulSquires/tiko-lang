'' '#line' RENUMBERS FROM ITS OWN LINE, and may rename the file with it.
''
'' Measured against fbc, which is the only reason any of the numbers below are what
'' they are. This same file compiled with fbc prints 1/l1.bas, 101/fake.bas, 102,
'' 6/fake.bas:
''
''     #line 100 "fake.bas"     the DIRECTIVE's line becomes 100, so the next is 101
''     #line 5                  no string, so 'fake.bas' STAYS -- it does not revert
''
'' A '#line' with no name inheriting the name in force is the half that is easy to
'' get wrong, and the probe was written before the code: reverting to the real file
'' would have looked right in every test that only ever writes one '#line'.
#line 100 "fake.bas"
dim as integer a = __LINE__
dim as string f = __FILE__

#line 5
dim as integer b = __LINE__
dim as string g = __FILE__

'' The counter is 32 bits, not saturating and not an error: fbc reports -1294967295
'' for the line after '#line 3000000000'.
#line 3000000000
dim as integer c = __LINE__

'' '&h10' is 16, so the next line is 17. The number is a LITERAL in any radix and not
'' an expression -- '#line 10+2' is an error, and has its own test.
#line &h10
dim as integer d = __LINE__
