'' count.bi -- the counting type for RFC 0018's move probes.
''
'' Every object gets a SERIAL at construction, so the trace says WHICH object was copied
'' or destroyed, deterministically (an address would differ per run and per compiler).
'' The STRING field is mandatory: all-scalar data hides a double free (Learnings, the
'' counting-type probe). Built by fbc as well as tiko, so it is written in fbc's dialect.

type T
    as long id
    as string s
    declare constructor( )
    declare constructor( byval n as long )
    declare constructor( byref rhs as T )
    declare operator let( byref rhs as T )
    declare destructor( )
end type

dim shared as long serial, nCtor, nCopy, nLet, nDtor

constructor T( )
    serial += 1 : id = serial : s = "t" & id : nCtor += 1
    print "  ctor #" & id
end constructor

constructor T( byval n as long )
    serial += 1 : id = serial : s = "t" & id : nCtor += 1
    print "  ctor #" & id & " (" & n & ")"
end constructor

constructor T( byref rhs as T )
    serial += 1 : id = serial : s = rhs.s : nCopy += 1
    print "  COPY #" & id & " <- #" & rhs.id
end constructor

operator T.let( byref rhs as T )
    s = rhs.s : nLet += 1
    print "  LET  #" & id & " <- #" & rhs.id
end operator

destructor T( )
    nDtor += 1
    print "  dtor #" & id
end destructor

'' One line per case: the four counts, and whether every object made was destroyed.
'' 'live' is how many the case leaves alive ON PURPOSE (a shared or static object,
'' destroyed at program end), so balance means made - destroyed = live.
sub Report( byref tag as string, byval live as long = 0 )
    dim as string bal = "ok"
    if nCtor + nCopy - nDtor <> live then bal = "UNBALANCED"
    print tag & ": ctor=" & nCtor & " copy=" & nCopy & " let=" & nLet & " dtor=" & nDtor & " balance=" & bal
    print
    nCtor = 0 : nCopy = 0 : nLet = 0 : nDtor = 0
end sub
