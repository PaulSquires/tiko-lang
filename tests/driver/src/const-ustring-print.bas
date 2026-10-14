'' See tests/driver/const-ustring-print.test.
namespace NS
    const K as ustring = "ns"
end namespace
const G as ustring = "hi"
sub R( byref s as const ustring )
    print "R:"; s
end sub
print G
print "["; G; "]"
R( G )
print ucase( G ); "|"; lcase( G )
print NS.K
print left( G, 1 ); "|"; right( G, 1 ); "|"; mid( G, 2, 1 )
print instr( G, "i" ); instr( "xhi", G )
print trim( G ); "|"; ltrim( G ); "|"; rtrim( G )
