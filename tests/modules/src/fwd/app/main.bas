'' An importer of a module whose declarations are out of order: its interface, read in the
'' module's order, takes them too.
#import "acme/early"
print early.Go( )
print early.Go( )
