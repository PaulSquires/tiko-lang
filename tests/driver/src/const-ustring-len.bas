'' See tests/driver/const-ustring-len.test.
namespace NS
    const K as ustring = "hé"
end namespace
type T
    x as long
    const M as ustring = "hé"
end type
const G as ustring = "hé"
const S as string = "ab"
dim v as ustring = "hé"
print len( v ); len( G ); len( G & "" ); len( G & S ); len( NS.K ); len( T.M )
print len( S ); len( S & "c" )
