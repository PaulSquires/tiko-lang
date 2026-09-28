'' std/fs (RFC-0009): a type, an enum member, procedures and std/path's folded names,
'' beside fb/filesystem.bi included directly -- an fs.FsError IS an FB.FsError.
#import "std/fs"
#include once "fb/filesystem.bi"
private function CodeOf( byref e as FB.FsError ) as long
    return e.Code( )
end function
dim as fs.FsError e = fs.FsError( fs.FS_NOT_FOUND, 0, "open", "x" )
print CodeOf( e ) = fs.FsErrorCode.FS_NOT_FOUND; " "; fs.Exists( "no-such-file.xyz" )
print fs.PathStem( "a/b/c.txt" ); " "; fs.PathExtension( "c.txt" ); " "; fs.BaseName( "a/b" ); " "; fs.DirName( "a/b" )
