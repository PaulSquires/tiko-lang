#module "b"
#import "acme/d"
sub Gone( ) destructor
    print "~B"
end sub
'' d is initialised by now: its global is constructed.
print "B sees " & d.Name_( )
'' A NUMBERED constructor keeps its FreeBASIC meaning: it runs before any module's.
sub Early( ) constructor 101
    print "B:101"
end sub
