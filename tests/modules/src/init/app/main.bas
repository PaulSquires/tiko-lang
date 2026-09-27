'' The root: its own code runs after every module has initialised, and its destructor
'' before any module finalises.
#import "acme/a"
sub Gone( ) destructor
    print "~main"
end sub
print "main"
