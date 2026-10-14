'' See tests/driver/const-ustring-out.test.
namespace NS
    const K as ustring = "ns"
end namespace
const G as ustring = "hi"
dim w as wstring * 8 = G
print str( w ); len( w ); (w = "hi")
dim x as wstring * 8
x = NS.K
print str( x )
x &= G
print str( x )
write G, 1
write NS.K
print using "[&]"; G
print using "& &"; G; NS.K
