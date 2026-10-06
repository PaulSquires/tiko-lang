const CONSTZ1 = lcase( "XYZ123", 1 )
#if CONSTZ1 <> "xyz123"
print "fail1"
#endif
#if lcase( "ABC", 1 ) <> "abc"
print "fail2"
#endif
const CONSTW1 = lcase( wstr( "XYZ123" ), 1 )
#if CONSTW1 <> wstr( "xyz123" )
print "failw"
#endif
print CONSTZ1, CONSTW1
