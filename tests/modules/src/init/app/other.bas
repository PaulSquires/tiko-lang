'' A second, classic root that is not main: its top-level code runs as a module
'' constructor, after every module has initialised, so d is ready here.
#import "acme/d"
print "other sees " & d.Name_( )
