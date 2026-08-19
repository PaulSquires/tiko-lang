'' A REDIM target may be PARENTHESISED. Measured against fbc:
''
''   redim (a)(0 to 1)        legal on a var-len array
''   redim (1+1)(0 to 1)      PARSES, then fbc error 54 'Expected var-len array'
''   redim ns.arr(0 to 2)     legal, and already worked
''
'' The second has to get through the parser or the corpus's COMPILE_ONLY_FAIL files
'' fail for the wrong reason and their goldens can never match.
''
'' The parenthesised group is read explicitly, not through the postfix chain: that
'' would take '(a)(0 to 1)' as a CALL of '(a)' and swallow the bounds -- the target
'' parsed, the dimensions vanished, and the only sign was one leftover diagnostic.

namespace ns
	dim shared arr( ) as integer
end namespace

dim a( ) as integer

redim (a)(0 to 1)
redim (1+1)(0 to 1)
redim ns.arr(0 to 2)
redim a(0 to 3)
