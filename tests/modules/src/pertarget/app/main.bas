'' Uses acme/sep, whose bodies differ per target.
#import "acme/sep"
print sep.Separator( ); " "; sep.IsAbsolute( "/x" ); " "; sep.IsAbsolute( "C:x" )
