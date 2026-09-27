'' An import that is not 'public' does not leak.
#import "acme/plain"
print plain.core.MakeTag( "x" ).s
