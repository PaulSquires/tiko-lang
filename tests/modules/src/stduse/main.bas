'' A program using the standard package: 'std' always resolves to the toolchain's pkg/.
#import "std/strings"
#import "std/path"
dim as string parts( any )
dim as long n = strings.Split( "a,b,,c", ",", parts( ) )
print n; " "; parts( 0 ); parts( 1 ); parts( 3 )
print strings.StartsWith( "module", "mod" ), strings.EndsWith( "module", "ule" ), strings.Contains( "module", "x" )
print strings.Replace( "a-b-c", "-", "+" ); " "; strings.Repeat( "ab", 3 )
print strings.Surround( 42, "[", "]" ); strings.Surround( 1.5, "<", ">" )
print path.BaseName( "a/b/c.txt" ); " "; path.Extension( "a/b/c.txt" ); " "; path.DirName( "a/b/c.txt" )
print path.IsAbsolute( "/x" ); " "; path.JoinPath( "a", "b" )
