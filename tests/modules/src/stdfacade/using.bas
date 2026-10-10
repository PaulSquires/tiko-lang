'' std/strings is a real module: 'using strings' makes its public 'Replace' a bare name.
#import "std/strings"
using strings
print Replace( "ab", "a", "z" )
