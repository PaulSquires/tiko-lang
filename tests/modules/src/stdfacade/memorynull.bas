'' A null SharedPtr dereferenced: std/memory raises error 1, and the site is its own file.
#import "std/memory"
dim as memory.SharedPtr( of long ) p
print p.Ref( )
