'' The source root, linked with a.o and b.o: it imports util too.
#import "acme/util"
declare sub ShowA( )
declare sub ShowB( )
ShowA( )
ShowB( )
print "main:"; util.Twice( 5 )
