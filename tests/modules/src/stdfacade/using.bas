'' A facade's names are exported macros, reached only as 'alias.NAME' (RFC-0009 §4):
'' 'using strings' does not make 'Replace' a name.
#import "std/strings"
using strings
print Replace( "ab", "a", "z" )
