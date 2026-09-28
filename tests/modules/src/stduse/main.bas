'' A program using the standard package: 'std' always resolves to the toolchain's pkg/.
#import "std/strings"
#import "std/fs"
var parts = strings.Split( "a,b,,c", "," )
print parts.Count( ); " "; parts[0]; parts[1]; parts[3]
print strings.StartsWith( "module", "mod" ), strings.EndsWith( "module", "ule" ), strings.Contains( "module", "x" )
print strings.Replace( "a-b-c", "-", "+" ); " "; strings.Repeat( 3, "ab" )
print strings.Surround( 42, "[", "]" ); strings.Surround( 1.5, "<", ">" )
print fs.BaseName( "a/b/c.txt" ); " "; fs.Extension( "a/b/c.txt" ); " "; fs.DirName( "a/b/c.txt" )
print fs.IsAbsolute( "/x" ); " "; fs.IsAbsolute( "C:\x" ); " "; fs.JoinPath( "a", "b" )
