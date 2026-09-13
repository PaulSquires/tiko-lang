'' A STRING ARGUMENT TO A 'byref as string' CONSTRUCTOR PARAMETER IS A DESCRIPTOR, in the
'' temporary a 'T( args )' expression builds as much as in a declaration. fbc-modern prints:
''
''    a[val2] b[x] c[x] d[x] e[y]
''
'' The declaration 'dim d as DS = DS( "x" )' was right. The TEMPORARY path wraps a byref
'' parameter's type in a reference, the descriptor test never matched, and the literal went
'' in as its raw characters: 'o = DS( "x" )' printed nothing, 'DS( "x" ).s' was empty,
'' a second such assignment crashed, and 'o = DS( "val" & 2 )' was not lowered at all.
type DS
    s as string
    declare constructor( )
    declare constructor( byref v as string )
    declare destructor( )
    declare operator let( byref o as DS )
end type
constructor DS( )
end constructor
constructor DS( byref v as string )
    s = v
end constructor
destructor DS( )
end destructor
operator DS.let( byref o as DS )
    s = o.s
end operator

dim as DS o
o = DS( "val" & 2 )
print "a[" & o.s & "]"
dim as DS d = DS( "x" )
print "b[" & d.s & "]"
print "c[" & DS( "x" ).s & "]"
dim as DS e
e = DS( "x" )
print "d[" & e.s & "]"
dim as string v = "y"
e = DS( v )
print "e[" & e.s & "]"
