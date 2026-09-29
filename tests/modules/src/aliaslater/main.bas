#import "acme/parts"
dim as parts.Widget wd
wd.v = 14
dim as parts.User u
u.w = @wd
print u.Go( )
print u.Peek( @wd )
