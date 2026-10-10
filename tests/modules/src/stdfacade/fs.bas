'' std/fs, a real module: a type, an enum member, procedures, a header #define that is a
'' public constant now, and std/path's folded names -- exported macros, used qualified.
#import "std/fs"
private function CodeOf( byref e as fs.FsError ) as long
    return e.Code( )
end function
dim as fs.FsError e = fs.FsError( fs.FS_NOT_FOUND, 0, "open", "x" )
print CodeOf( e ) = fs.FsErrorCode.FS_NOT_FOUND; " "; fs.Exists( "no-such-file.xyz" )
print fs.PathStem( "a/b/c.txt" ); " "; fs.PathExtension( "c.txt" ); " "; fs.BaseName( "a/b" ); " "; fs.DirName( "a/b" )
scope
    using fs
    print FB_FSKIND_DIR; " "; PathFileName( "x/y.z" )
end scope
