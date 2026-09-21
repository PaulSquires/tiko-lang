'' A STRING CONSTANT NAMED THROUGH A NAMESPACE OR A TYPE IS ITS TEXT, exactly as a bare
'' one is. Every narrow string path but len( ) asked for the text of a bare N_IDENT only,
'' so these declined or read garbage -- measured against fbc64 1.20.0, output byte for
'' byte, 14 of 15 differed:
''
''     print NS.K                  fbc -dev     tiko (nothing)
''     s = NS.K                    fbc -dev     tiko (empty)
''     "x" & NS.K                  fbc x-dev    tiko x -- and the rest of the statement lost
''     @NS.K                       fbc -dev     tiko a stack address read as text
''     dim as zstring * 8 z = NS.K fbc -dev     tiko garbage
''
'' tiko-lang's own --version prints 'Tko.TKO_VERSION_SUFFIX' and 'Tko.TKO_FBC_COMPAT',
'' so the self-built compiler printed '0.1.0' and dropped the target line entirely.

namespace NS
	const K as string = "-dev"
end namespace

type T
	const Z as string = "tz"
	as long q
end type

dim as string s1 = NS.K
dim as string s2
s2 = NS.K
dim as string s3 = "x" & NS.K
dim as string s4 = NS.K & "x"
s4 &= NS.K
dim as zstring ptr p = @NS.K
dim as zstring * 8 z = NS.K
dim as wstring * 8 w = NS.K
dim as ustring u = NS.K & "u"

print NS.K
print "x" & NS.K
print T.Z; T.Z & "!"
print NS.K = "-dev", "-dev" = NS.K
print ucase( NS.K )
print len( NS.K )
