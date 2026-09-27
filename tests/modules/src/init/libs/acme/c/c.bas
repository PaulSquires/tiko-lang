#module "c"
#import "acme/d"
sub Gone( ) destructor
    print "~C"
end sub
'' d is initialised by now: its global is constructed.
print "C sees " & d.Name_( )
