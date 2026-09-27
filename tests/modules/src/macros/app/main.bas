'' An importer of exported macros: used qualified they expand, and CHECK's call to the
'' module's Fail_ is not captured by this file's own Fail_; bare, CHECK is not a macro at all,
'' so it can name a variable.
#import "acme/chk"
dim as long Fail_ = 99
chk.CHECK( 1 = 2 )
chk.CHECK( 2 = 2 )
chk.TWICE( "hi" )
print Fail_
#ifdef CHECK
print "bare CHECK is a macro"
#endif
dim as long CHECK = chk.Answer( )
print CHECK
