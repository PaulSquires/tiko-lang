[Home](Home) › [All Categories](Categories) › **Filesystem**

# Filesystem

```freebasic
#import "std/fs"
using FB

print PathJoin( "C:\dev", "tiko", "src" )    ' C:\dev\tiko\src
print PathExtension( "frmMain.tiko" )         ' .tiko
print PathStem( ".gitignore" )               ' .gitignore -- no extension

dim as FsResultInfo info = Stat( "C:\dev\tiko" )
if( info.IsOk( ) ) then
    print info.Value( ).Size( ), info.Value( ).IsDirectory( )
else
    print info.Failure( ).Message( ), info.Failure( ).Path( )
end if

for each entry in WalkDir( "C:\dev\tiko" )
    if( entry.IsOk( ) ) then
        print entry.Value( ).Path( )
    else
        print "skipped: "; entry.Failure( ).Path( )
    end if
next

dim as FsResultUStr text = ReadAllText( "config.ini" )
WriteAtomic( "config.ini", "[main]" & chr( 10 ) )
```

## Why It Exists

FreeBASIC's filesystem surface is the 1985 BASIC model plus a handful of additions: OPEN/GET/PUT, KILL, NAME, MKDIR, RMDIR, CHDIR, CURDIR, DIR/DIRNEXT, FileExists, FileLen, FileAttr, FileDateTime and FileCopy. Against that, every mainstream language ships a path algebra, a stat record, a reentrant directory iterator, a recursive walk and whole-file read and write. FreeBASIC ships none of them.

Three concrete defects, not a wish list:

There is NO PATH MANIPULATION AT ALL. The entire path layer is one internal function that flips slashes. No join, split, normalize, extension, parent, absolute or relative-to. Every program hand-rolls it, and every hand-rolled version is wrong on UNC paths and trailing separators.

DIR/DIRNEXT IS A PER-THREAD GLOBAL. One cursor per thread, so two interleaved directory scans silently corrupt each other. Recursion therefore requires collecting a whole level into an array before descending -- a workaround for a library defect, not a design.

FOUR CALLS TO LEARN FOUR FACTS. FileExists + FileAttr + FileLen + FileDateTime are four separate traversals of the same path with four separate race windows, and FileLen opens the file so it fails outright on a directory.

This library ships ALONGSIDE all of that. Nothing in inc/file.bi, inc/dir.bi or the runtime's existing file routines changed, and nothing here depends on them. A program using DIR compiles and behaves exactly as before; the only new consequence is that a better option now sits next to it.

NO COMPILER SUPPORT IS INVOLVED. This is a library: the runtime half is in tiko-rt (lib/rt/src/fs/), the FreeBASIC types in inc/fb/fs\*.bi. Nothing here is a keyword, and Stat, ReadDir, CopyFile and the rest stay available as your own identifiers until you write 'using FB'.

It is specified before it is implemented -- nine RFCs, one per area, each normative. Where the code and an RFC disagreed, the RFC was amended in the same change; several such corrections are recorded in them.

THE SPECIFICATION IS NOT IN THIS REPOSITORY. It lives in

```freebasic
C:\dev\docs\filesystem\
```

along with rationale.md (why each thing is shaped this way), comparison- matrix.md and ranked-gaps.md (what it was measured against), and README.md (what shipped, how it was verified, and what is and is not verified). Every bare filename below refers to that directory.

## The Shape, In One Table

Namespace     Everything is in NAMESPACE FB. Nothing is added to the global

```freebasic
namespace, so a program with its own Stat or CopyFile is
unaffected until it writes 'using FB'.
```

Errors        Every fallible call returns Result( of T, FsError ). No err( ),

```freebasic
no exceptions, no global status code.
```

Strings       USTRING is the kernel. STRING and WSTRING are accepted

```freebasic
everywhere by conversion; the path functions also RETURN the
width they were given.
```

Paths         Free functions over strings, Go-style. There is no Path type. Iteration     Conforms to the structural iterator protocol, so FOR EACH walks

```freebasic
a directory.
```

Platforms     win64 and linux-x86_64, both first-class.

One header pulls in everything:

```freebasic
#import "std/fs"
```

or include only what you use -- fb/fspath.bi, fb/fsinfo.bi, fb/fsdir.bi, fb/fsops.bi, fb/fsglob.bi, fb/fslink.bi, fb/fsvolume.bi, fb/fsadvanced.bi. fb/fserror.bi comes with all of them.

## Errors

EVERY FALLIBLE CALL RETURNS A Result. Every call that cannot fail returns its value directly. The split is visible in the signature, which is the point.

```freebasic
dim as FsResultUStr r = ReadAllText( "a.txt" )
if( r.IsOk( ) ) then
    print r.Value( )
else
    print r.Failure( ).Code( ), r.Failure( ).Message( )
end if
```

A DEFAULT-CONSTRUCTED RESULT IS A FAILURE, so a forgotten assignment reads as an error rather than as a silent success. Reading the wrong side --  Value( ) on a failure, Failure( ) on a success -- raises FB_RTERROR_ILLEGALFUNCTIONCALL. IsOk( ) is the guard and costs nothing.

There is no '?' operator and no must-use diagnostic. IGNORING A RESULT STAYS A CONVENTION. What the type buys is that the failure has a name and a shape, not that you are forced to look at it.

FsError

```freebasic
.Code( )        FsErrorCode -- the portable code. Branch on this.
.OsCode( )      GetLastError( ) / errno, VERBATIM and unmapped. Zero when
                the library synthesised the error itself.
.Path( )        the path the call was operating on. Empty if none.
.Path2( )       the second path, for CopyFile / MoveFile / CreateSymlink.
.Operation( )   "CreateFileW", "unlink", "CopyDir". For diagnostics, NEVER
                for branching.
.Message( )     a fixed English one-liner derived from Code( ).
```

FsErrorCode -- sixteen codes plus FS_OK, closed on purpose

```freebasic
FS_OK                (never appears inside a failure)
FS_NOT_FOUND         no such file or directory
FS_ACCESS_DENIED     permission, or in use by policy
FS_ALREADY_EXISTS    create refused because the target is there
FS_NOT_A_DIRECTORY   a component that must be a directory is not
FS_IS_A_DIRECTORY    a directory where a file is required
FS_DIR_NOT_EMPTY     RemoveDir on a populated directory
FS_INVALID_PATH      malformed, or a character the OS refuses
FS_NAME_TOO_LONG     component or whole path exceeds the OS limit
FS_LOOP              too many symbolic links resolving one path
FS_NO_SPACE          the volume is full, or a quota is exhausted
FS_READ_ONLY         the volume or the object is write-protected
FS_IN_USE            a sharing violation, or the file is locked
FS_CROSS_DEVICE      rename across volumes
FS_INTERRUPTED       a signal interrupted the call (POSIX EINTR)
FS_UNSUPPORTED       the platform or filesystem cannot do this AT ALL
FS_UNKNOWN           mapped to nothing; OsCode( ) is the real answer
```

FS_UNSUPPORTED means THIS WILL NEVER WORK HERE, as distinct from FS_ACCESS_DENIED, which means try again with more privilege. A caller can branch on it once at startup instead of treating it as transient.

Message( ) is NOT FormatMessageW and NOT strerror. Those are locale-dependent, vary between Windows builds and libc versions, and produce text no test could assert. It is a fixed table, so the same code gives the same words on every machine. For the OS's own wording, use OsCode( ) and ask the OS.

The result aliases, one per returned type:

```freebasic
FsResultBool   FsResultLong   FsResultI64    FsResultUStr   FsResultStr
FsResultInfo   FsResultULong  FsResultSpace  FsResultVol    DirEntryResult
```

They are concrete typedefs rather than one generic alias because FreeBASIC has no generic typedef: 'type FsResult( of T ) as ...' is read as the opening of a generic TYPE BODY and does not compile.

## Strings -- Read This Once

THE KERNEL IS USTRING. Every entry point takes USTRING, and all four string types reach it: STRING, ZSTRING and WSTRING convert implicitly.

THE CONVERSION IS UTF-8, BOTH WAYS, ON BOTH PLATFORMS, AND IT IS LOSSY.

```freebasic
STRING  -> USTRING    decoded as UTF-8; invalid bytes become U+FFFD
USTRING -> STRING     encoded as UTF-8
```

It is not the ANSI codepage, and it does not fail. A lone &hE9 -- what a legacy Latin-1 or Windows codepage string holds for 'e-acute' -- becomes U+FFFD silently, with no error and no way to detect it afterwards. That path will not open, and the library does not pretend otherwise.

So: A WINDOWS PROGRAM HOLDING A LEGACY ANSI PATH IN A STRING CANNOT USE IT HERE. Decode it to USTRING yourself first.

PATHS THAT CAME FROM THE FILESYSTEM ARE USTRING AND SHOULD STAY THAT WAY. DirEntry.Name, ReadLink, CanonicalPath, CurrentDir and the rest return USTRING deliberately, and there are no STRING-returning versions -- adding them would offer a convenient, type-matching way to do the one thing this design exists to prevent. NTFS permits unpaired surrogates in file names; such a name does not survive a trip through STRING, which means afterwards you cannot open, delete or walk it.

The PATH functions are different, because they are pure string manipulation and nothing they touch came from the filesystem. They carry the full three-overload family and RETURN THE WIDTH THEY WERE GIVEN:

```freebasic
string, zstring  ->  string
wstring, ustring ->  ustring
```

so 'dim as string p = PathParent( someString )' involves no conversion at all.

## Paths

PURE. No syscalls, no filesystem access, no locale. Whether a path names anything is Stat's question. Every function takes an optional final \`gram\` argument selecting the path grammar; it defaults to the host's and ordinary code never passes it. It exists so the Windows rules can be tested on Linux and the POSIX rules on Windows.

Decompose

```freebasic
PathRoot( p )            "C:\", "\\srv\share\", "/", "" -- see below
PathParent( p )          "" for a root and for a float32 relative component
PathFileName( p )        the leaf; "" for a root
PathStem( p )            the leaf without its extension
PathExtension( p )       ".bas", WITH the dot; "" when there is none
PathSplit( p, comps )    fills an Array( of ustring ); returns the count
```

Compose

```freebasic
PathJoin( a, b )         also 3- and 4-argument forms
PathChangeExtension( p, ext )    ext with or without its dot; "" removes
```

Transform

```freebasic
PathNormalize( p )       collapses '.', resolves '..' LEXICALLY, removes
                         duplicate separators and a trailing one
PathToNative( p )        separators to native, duplicates collapsed, but
                         NO '.' or '..' resolution
PathRelativeTo( p, base )        FsResultUStr
```

Interrogate

```freebasic
PathIsAbsolute( p )      see the Windows note below
PathIsRoot( p )          the whole path is exactly its root
PathRootLen( p )         length of the root prefix, in code units
PathHasExtension( p )
PathEquals( a, b )       normalized, case-insensitive on Windows
PathStartsWith( p, pre ) WHOLE COMPONENTS -- see below
PathNextComponent( p, gram, from, outlen )     the cursor PathSplit uses
PathSeparator( )         "\" or "/"
PathIsCaseSensitive( )   compile-time, per platform -- NOT per volume
```

THE EIGHT WINDOWS PATH FORMS, because three of them are where hand-rolled path code dies:

```freebasic
C:\dev\tiko            root "C:\"                  ABSOLUTE
C:dev\tiko             root "C:"                   NOT absolute
\dev\tiko              root "\"                    NOT absolute
dev\tiko               root ""                     not absolute
\\srv\share\dev        root "\\srv\share\"         absolute
\\?\C:\dev             root "\\?\C:\"              absolute
\\?\UNC\srv\share\dev  root "\\?\UNC\srv\share\"   absolute
\\.\PhysicalDrive0     root "\\.\"                 absolute
```

DRIVE-RELATIVE "C:dev" IS NOT ABSOLUTE. It names a path relative to the PER-DRIVE current directory -- a DOS survival Windows still maintains. It is not "C:\\dev", and treating it as such is a real bug with real consequences. PathRoot tells them apart by the trailing separator: "C:" versus "C:\\".

ROOTED-NO-DRIVE "\\dev" IS NOT ABSOLUTE EITHER. It is on the current drive.

UNDER "\\\\?\\" THE OS DOES NO PARSING AT ALL. '.' and '..' are ORDINARY NAMES and '/' is not a separator, so PathNormalize deliberately leaves the interior of such a path alone -- collapsing it would change which file is named.

THE RULES, each of which has a defensible opposite:

1. PathJoin YIELDS b WHEN b IS ABSOLUTE OR ROOTED, discarding a. This matches

```freebasic
Go, Python, Rust and .NET. It also makes PathJoin( base, userInput ) a
SECURITY CONSIDERATION rather than a convenience -- if you need
containment, check PathStartsWith afterwards.
```

2. PathJoin inserts exactly one separator and never a leading one. An empty

```freebasic
argument contributes nothing.
```

3. PathJoin DOES NOT NORMALIZE. Join( "a/b", ".." ) is "a/b/..". A join that

```freebasic
quietly resolved '..' would be resolving it without knowing whether b is a
symlink.
```

4. PathNormalize( "" ) is ".". A root normalizes to itself. 5. '..' CLAMPS AT A ROOT and never escapes it: "/a/../.." is "/". A RELATIVE

```freebasic
path has no root to clamp to, so leading '..' survive: "a/../../b" is
"../b".
```

6. PathParent of a root is "", and of a single relative component is "".

```freebasic
A trailing separator does not create a phantom empty component.
```

7. PathFileName of a root is "". 8. THE EXTENSION IS THE FINAL '.' IN THE FILE NAME, and only when that dot is

```freebasic
neither the first character of the name nor the last:

    "a.bas"       -> ".bas"        "a.b.c"     -> ".c"
    ".gitignore"  -> ""            "a."        -> ""
    "C:\a.b\c"    -> ""

A DOTFILE HAS NO EXTENSION -- it is a name. PathStem( ".gitignore" ) is
".gitignore". Matches Python, Rust and Go.
```

9. PathChangeExtension takes the new extension with or without its dot; ""

```freebasic
removes the extension including the dot.
```

10. PathEquals compares NORMALIZED paths, case-insensitively under the Windows

```freebasic
grammar, treating '\' and '/' as equal there. It is a LEXICAL answer: two
paths naming one file through a symlink compare UNEQUAL. CanonicalPath is
the call that answers identity.
```

11. PathStartsWith compares WHOLE COMPONENTS. "C:\\abc" does not start with

```freebasic
"C:\ab". Anything else would make it useless for the containment check
rule 1 sends you here for.
```

12. PathSplit NORMALIZES FIRST and does not include the root. PathRoot joined

```freebasic
with its components reconstructs PathNormalize exactly.
```

13. PathRelativeTo FAILS with FS_INVALID_PATH when the two have different

```freebasic
roots -- different drives, one absolute and one relative, UNC versus
local. There is no relative path between C:\a and D:\b, and returning
"..\..\D:\b" would be a fabrication. Two equal paths give ".".
```

14. NUL is never valid in a path and is rejected everywhere.

NORMALIZE TO BUILD, CANONICALIZE TO COMPARE IDENTITY. PathNormalize resolves '..' lexically. If a/b is a symlink, a/b/.. is '/' to the OS but 'a' here. Both answers are correct for their question, and resolving properly would mean hitting the disk from a pure function -- making it fallible, slow, and dependent on whether the path exists yet, which is exactly wrong for something whose main use is BUILDING a path before creating it.

## Metadata

```freebasic
Stat( p )       FsResultInfo -- FOLLOWS symbolic links
LStat( p )      FsResultInfo -- does NOT follow

Exists( p )     boolean
IsFile( p )     boolean -- follows links
IsDir( p )      boolean -- follows links
```

ABSENCE IS AN ERROR, NOT AN EMPTY SUCCESS. Stat and LStat fail with FS_NOT_FOUND, so FS_NOT_FOUND and FS_ACCESS_DENIED stay distinguishable. That is the whole argument for Result over Optional here.

THE THREE PREDICATES COLLAPSE EVERY FAILURE TO FALSE. Exists( p ) is false when p is absent AND when the directory above it denies access. That is a real loss of information and it is deliberate -- it is what makes them usable in an IF. Call Stat when you need the distinction.

There is deliberately no IsSymlink( p ) predicate: the answer depends on whether you followed, a two-valued result cannot say which it did, and LStat( p ) is one line away.

FileInfo

```freebasic
.Exists( ) .IsFile( ) .IsDirectory( ) .IsSymlink( ) .IsOther( )
.Size( )                        uint64
.ModifiedUtc( )                 int64 -- ticks, see below
.CreatedUtc( ) .AccessedUtc( )
.HasCreated( ) .HasAccessed( )
.IsReadOnly( ) .IsHidden( )
.NativeAttributes( )            dwFileAttributes / st_mode
```

THE FOUR KINDS ARE EXCLUSIVE AND EXHAUSTIVE. Exactly one of IsFile, IsDirectory, IsSymlink and IsOther is true whenever Exists is true, and none is when it is false. IsOther covers devices, FIFOs, sockets and Windows reparse points that are not name surrogates -- things a program should notice and refuse rather than treat as files.

IsSymlink IS ONLY EVER TRUE FROM LStat. Stat follows, so it reports what the link points at; a Stat result with IsSymlink true would be a contradiction.

TIMES ARE TICKS OF 100 ns SINCE 0001-01-01 UTC -- the same unit fb/chrono.bi uses, so the two libraries interoperate without conversion.

NOT EVERY PLATFORM HAS EVERY TIME, and the library says so rather than inventing one:

```freebasic
            Windows                 Linux
Modified    always                  always
Created     always                  statx birth time WHERE AVAILABLE
Accessed    always                  always
```

HasCreated( ) and HasAccessed( ) report availability. When false the getter is exactly 0 and means nothing. There is no HasModified -- modification time is universal. st_ctime is the INODE CHANGE time, not a birth time, and is deliberately NOT reported as CreatedUtc.

Access time is often STALE on both platforms -- NTFS LastAccess updates are frequently disabled and Linux mounts default to relatime -- so a program that branches on AccessedUtc is building on sand.

IsReadOnly and IsHidden are the portable two, and they mean different things underneath:

```freebasic
            Windows                     Linux
IsReadOnly  FILE_ATTRIBUTE_READONLY     no write bit for this user
IsHidden    FILE_ATTRIBUTE_HIDDEN       the name begins with '.'
```

A dotfile is hidden on Linux and NOT on Windows. That divergence is real.

Resolvers

```freebasic
AbsolutePath( p )     FsResultUStr
CanonicalPath( p )    FsResultUStr
CurrentDir( )         FsResultUStr
SetCurrentDir( p )    FsResultBool

                 AbsolutePath        CanonicalPath
must exist       NO                  yes
resolves links   no                  yes
'..' semantics   lexical             filesystem
use it to        build a path        compare identity
```

AbsolutePath does not require the path to exist, which is the point -- the usual caller is about to create it. On Windows it delegates to GetFullPathNameW because "the relevant current directory" is not one thing: a drive-relative "C:foo" resolves against the per-drive current directory.

CanonicalPath on Windows returns a "\\\\?\\"-prefixed path and STRIPS the prefix unless the result exceeds MAX_PATH, where removing it would produce a path the OS cannot open. So COMPARE CANONICAL PATHS WITH PathEquals, not with '='.

SetCurrentDir changes a PROCESS-GLOBAL, so calling it from one thread races every other thread's relative paths. This library never calls it.

## Directories

```freebasic
ReadDir( p )                    one level
WalkDir( p )                    recursive, pre-order
WalkDir( p, opts )
ListDir( p, entries )           eager; fills an Array( of DirEntry )
```

EVERY ITERATOR OWNS ITS OWN HANDLE. Nesting, recursion, two concurrent scans on one thread and scans on many threads are all simply correct -- which is the whole reason this exists, since DIR/DIRNEXT cannot do any of it.

```freebasic
for each r in ReadDir( "C:\dev" )
    if( r.IsOk( ) ) then
        print r.Value( ).Name( )
    else
        print "skipped: "; r.Failure( ).Message( )
    end if
next
```

THE ELEMENT IS A Result. The iterator protocol has three members and none of them is an error channel, but a scan can fail partway -- permission denied, a device that went away. Making the failure an ELEMENT puts it where the loop already looks. The cost is that every loop body unwraps; the alternative is a walk that lies about its coverage.

Value( ) RETURNS BYREF, and the reference is INVALIDATED BY THE NEXT MoveNext. Copy the entry if you need to keep it.

'.' AND '..' ARE NEVER YIELDED. Not as an option, not ever.

AN UNOPENABLE DIRECTORY YIELDS EXACTLY ONE ELEMENT -- the failure -- rather than looking like an empty directory.

DirEntry

```freebasic
.Name( )          the leaf
.Path( )          the full path, directly usable
.Depth( )         0 for the immediate children of the walk root
.IsFile( ) .IsDirectory( ) .IsSymlink( ) .IsOther( )
.Info( )          FsResultInfo -- MAY cost a stat
```

The kind predicates are FREE and are LStat-shaped: a symlink reports IsSymlink, not the kind of its target. Info( ) is free on Windows, where the enumeration record already carries size, times and attributes, and costs one lstat on Linux, where dirent carries neither.

WalkOptions            default

```freebasic
.FollowSymlinks      FALSE
.YieldDirectories    TRUE
.IncludeHidden       TRUE
.StopOnError         FALSE
.MaxDepth            0 = unbounded

dim as WalkOptions o        ' constructed, so the TRUE defaults are set
o.MaxDepth = 1
for each r in WalkDir( root, o ) : ... : next
```

THE WALK RULES:

1. PRE-ORDER. A directory is yielded before its contents. 2. THE ROOT ITSELF IS NOT YIELDED. Its immediate children are at depth 0. 3. DIRECTORY SYMLINKS ARE NOT FOLLOWED by default, and neither are Windows

```freebasic
junctions and mount points. This makes the traversal a tree BY
CONSTRUCTION: no cycle is possible and no visited set is needed. It is
also what makes RemoveDirAll safe.
```

4. With FollowSymlinks a visited set becomes mandatory and is used. It is

```freebasic
scoped to the CURRENT PATH, so a directory legitimately reachable twice by
different routes is visited twice and only a genuine cycle is cut.
```

5. HIDDEN ENTRIES ARE INCLUDED by default. Excluding them would silently omit

```freebasic
.git and every hidden system directory. Go, Rust and Python all include
them.
```

6. DEPTH IS UNBOUNDED by default. MaxDepth = 1 yields only the immediate

```freebasic
children.
```

7. AN ERROR YIELDS AN ELEMENT AND THE WALK CONTINUES. The failing subtree is

```freebasic
skipped; everything else is still visited. StopOnError makes the failure
the LAST thing yielded -- it is still yielded.
```

8. No directory handle is held across the descent; each level is listed and

```freebasic
its handle closed. The walk cannot exhaust a handle limit.
```

ListDir is eager and CLOSES ITS HANDLE before returning. Use it for the two things the iterator cannot do: produce a sorted listing, and let you delete or rename entries while working through them. Mutating a directory's structure during iteration invalidates the iterator, and on Windows is explicitly undefined.

Driving an iterator by hand

FOR EACH is the normal way, but the protocol types are public and can be driven directly -- which is what you want for two independent cursors over one directory, or to interleave two scans:

```freebasic
DirRange       what ReadDir returns; .GetIterator( ) as DirIterator
WalkRange      what WalkDir returns; .GetIterator( ) as WalkIterator

DirIterator / WalkIterator
  .IsValid( )        still on an element?
  .Value( )          BYREF DirEntryResult -- see the warning above
  .MoveNext( )       advance

dim as DirIterator a = ReadDir( "C:\dev" ).GetIterator( )
while( a.IsValid( ) )
    if( a.Value( ).IsOk( ) ) then print a.Value( ).Value( ).Name( )
    a.MoveNext( )
wend
```

A FRESHLY RETURNED ITERATOR IS ALREADY ON THE FIRST ELEMENT. There is no before-the-first state and MoveNext is not called before the first Value.

THE HANDLE OPENS LAZILY, on the first IsValid or Value. A copy taken BEFORE first use is therefore harmless -- which is the copy FOR EACH makes at loop entry. A copy taken mid-scan shares one cursor and is a bug. The destructor closes the handle if one was opened, including on EXIT FOR and while an error unwinds the scope.

## File Operations

Whole file

```freebasic
ReadAllText( p )                 FsResultUStr
ReadAllBytes( p, buf )           FsResultI64 -- fills Array( of uint8 )
ReadAllLines( p, lines )         FsResultLong -- fills Array( of ustring )
WriteAllText( p, s )             FsResultBool
WriteAllBytes( p, buf )          FsResultBool
AppendAllText( p, s )            FsResultBool
```

Directories

```freebasic
CreateDir( p )        fails with FS_ALREADY_EXISTS if the target is there
CreateDirAll( p )     mkdir -p; SUCCEEDS if it is already a directory
RemoveDir( p )        FS_DIR_NOT_EMPTY on a populated directory
RemoveDirAll( p )     rm -rf; FsResultI64, the number of objects removed
CopyDir( src, dst )   FsResultI64, the number created
CopyDir( src, dst, opts )
```

Files

```freebasic
CopyFile( src, dst [, overwrite ] )      overwrite defaults FALSE
MoveFile( src, dst [, overwrite ] )
RemoveFile( p )
```

Atomic

```freebasic
ReplaceFile( target, replacement )
WriteAtomic( p, s )
```

Temp

```freebasic
TempDir( )                       the system temp directory; creates nothing
CreateTempFile( [ prefix ] )     CREATES it and returns the path
CreateTempDir( [ prefix ] )      CREATES it and returns the path
```

TEXT ENCODING, five rules:

1. A BOM IS HONOURED AND CONSUMED -- UTF-8, UTF-16LE and UTF-16BE. It is not

```freebasic
part of the returned text.
```

2. NO BOM MEANS UTF-8. Not the ANSI codepage, not the console codepage, on

```freebasic
either platform -- a codepage default would make the same file read
differently on two machines.
```

3. INVALID INPUT IS REPLACED, NOT REJECTED. ReadAllText on a binary file

```freebasic
SUCCEEDS and returns mojibake. If you need to know, read bytes.
```

4. WriteAllText WRITES UTF-8 WITH NO BOM. Write one via WriteAllBytes if you

```freebasic
need it.
```

5. ReadAllLines SPLITS ON \\n AND STRIPS A PRECEDING \\r, so CRLF, LF and a

```freebasic
mixed file give the same lines. A final newline does NOT produce a
trailing empty line; an empty file gives zero lines. A LONE \r IS NOT A
TERMINATOR -- classic Mac endings are not supported.
```

Reading a directory is FS_IS_A_DIRECTORY on both platforms. A file too large to allocate is FS_NO_SPACE, not a truncation.

CreateDirAll tolerates another process creating the same tree concurrently: an FS_ALREADY_EXISTS on an intermediate component is re-checked and accepted if what is there is a directory. A FILE in the way is FS_NOT_A_DIRECTORY.

REMOVEDIRALL, three rules, and the second is the most important destructive behaviour in the library:

1. It lists each level with ListDir rather than iterating, because deleting

```freebasic
while enumerating is undefined.
```

2. A SYMLINK TO A DIRECTORY IS UNLINKED, NEVER DESCENDED. This is what stops

```freebasic
rm -rf on a tree containing a link to C:\ from doing what it sounds like.
```

3. The Windows read-only attribute is CLEARED before deleting, matching rm

```freebasic
-rf. Without it the call fails partway through a checked-out repository.
```

On failure it reports the first error and STOPS; it does not continue destructively past something it did not understand.

COPYDIR REFUSES WHEN THE DESTINATION IS INSIDE THE SOURCE, with FS_INVALID_PATH. Without that check CopyDir( "a", "a\\b" ) never terminates. The check is lexical, because the destination usually does not exist yet and CanonicalPath requires that it does.

CopyOptions            default

```freebasic
.PreserveTimestamps  FALSE
.PreservePermissions FALSE
.CopySymlinksAsLinks TRUE
.Overwrite           FALSE
```

WITHOUT PreserveTimestamps THE BEHAVIOUR IS PLATFORM-DEFINED: Windows CopyFileW carries the source's last-write time across on its own, and the POSIX read/write loop creates a file with the current time. If you care, pass the option. PreservePermissions is the platform's OWN model on each side -- POSIX mode bits or Windows attributes -- not a translation between them.

MOVEFILE HANDLES FS_CROSS_DEVICE, which NAME does not. On a cross-volume rename it copies then deletes. If the delete then fails the copy is NOT rolled back: the call reports the delete's error and the destination exists. Losing the destination to tidy up after a partial failure is worse than leaving both. The fallback is NOT atomic, and no API on either platform can make it so.

WHAT WriteAtomic ACTUALLY GUARANTEES, because the word is routinely oversold:

```freebasic
a reader sees the old file or the new one, never a partial       YES
survives a crash mid-call                                        YES
survives POWER LOSS without an explicit directory sync           NO
```

It writes to a temporary IN THE SAME DIRECTORY as the target -- not the system temp directory, which is often on another volume and would destroy the atomicity -- flushes it, then replaces. The temporary is cleaned up on every failure path.

CreateTempFile and CreateTempDir CREATE the object and return its path. They do not hand back a name for you to create: that is the classic tmpnam race, where the window between choosing and creating is an attacker's opportunity. Creation is atomic and the names come from the platform CSPRNG, never from RND. NEITHER IS DELETED AUTOMATICALLY -- FreeBASIC has no scope guard that would make that reliable.

## Glob

```freebasic
MatchPattern( s, pattern )    boolean. PURE -- no syscalls.
Glob( pattern, results )      FsResultLong; fills Array( of ustring )
GlobRoot( pattern )           the directory a pattern will be walked from
PatternWildcardAt( pattern )  offset of the first wildcard, or -1
PatternIsRecursive( pattern ) does it contain a '**' component
```

The grammar

```freebasic
?           exactly one character, NOT a separator
*           zero or more characters, NOT crossing a separator
**          zero or more WHOLE COMPONENTS, including none
[abc]       one character from the set
[a-z]       one from the range
[!abc]      one NOT in the set; [^abc] also works
\x          a literal x -- POSIX ONLY
```

1. '\*' DOES NOT CROSS A SEPARATOR. "a\*c" does not match "a/b/c". 2. '\*\*' is only special as a WHOLE COMPONENT. "a\*\*b" is a single '\*'. 3. '\*\*' MATCHES ZERO COMPONENTS, so "a/\*\*/c" matches "a/c". This is the

```freebasic
most-missed glob behaviour anywhere.
```

4. Case follows the grammar: insensitive on Windows, sensitive on POSIX. 5. Separators are equivalent under the Windows grammar, so a pattern written

```freebasic
with '/' matches a path written with '\'.
```

6. THERE IS NO ESCAPE CHARACTER ON WINDOWS, because '\\' is the separator. A

```freebasic
literal '[' is matched there by the class "[[]".
```

7. A MALFORMED CLASS IS A LITERAL. "\[abc" matches those four characters. A

```freebasic
glob that raised on a typo in a user-supplied pattern would be worse.
```

8. Matching is WHOLE-STRING. There is no implicit '\*' at either end. 9. The empty string is one empty component, so '\*' matches "".

Glob splits the pattern at the last component with no wildcard and walks from there, so "C:\\dev\\tiko\\src\\\*.bas" walks src and not the whole volume. A pattern without '\*\*' does a single ReadDir and never engages the walk.

RESULTS ARE NOT SORTED -- directory order is whatever the filesystem gives. ERRORS DURING THE WALK ARE SKIPPED: this is the one place in the library that swallows one, because Glob returns an array and has nowhere to put a per-entry failure. It fails as a whole only when the walk root cannot be opened. If you need per-entry errors, use WalkDir with MatchPattern -- which is what Glob itself does.

HIDDEN ENTRIES ARE MATCHED. Unlike a shell, '\*' here matches a leading dot.

## Links AND Permissions

```freebasic
CreateSymlink( target, lnk [, targetIsDir ] )    FsResultBool
CreateHardLink( target, lnk )                    FsResultBool
ReadLink( lnk )                                  FsResultUStr
IsLink( p )                                      boolean
LinkCount( p )                                   FsResultULong
```

ARGUMENT ORDER IS (target, link) -- the thing that EXISTS first, matching ln -s, symlink(2) and Python. It is the OPPOSITE of CreateSymbolicLinkW. Getting it backwards silently creates a dangling link pointing at the wrong place.

targetIsDir IS REQUIRED ON WINDOWS AND IGNORED ON POSIX. Windows encodes the target's kind IN THE LINK and needs it at creation time -- even when the target does not exist yet, which is exactly why it cannot be inferred. This is the ugliest portability seam in the library and it is not smoothable.

ON WINDOWS, CREATING A SYMLINK USUALLY NEEDS PRIVILEGE: expect FS_ACCESS_DENIED unless the process is elevated or Developer Mode is on.

ReadLink returns the target AS STORED -- unresolved, possibly relative, possibly dangling. It does NOT canonicalize; conflating the two would make a dangling link unreadable. FS_INVALID_PATH when the path is not a link, on both platforms. Junctions are READABLE but not creatable.

Permissions are THREE SEPARATE THINGS, not one

```freebasic
SetReadOnly( p, v )              portable
SetHidden( p, v )                portable IN NAME ONLY
GetPosixMode( p ) / SetPosixMode( p, mode )      FS_UNSUPPORTED on Windows
GetWin32Attributes( p ) / SetWin32Attributes( p, attrs )
                                                FS_UNSUPPORTED on POSIX
SetTimes( p, mtimeUtc [, atimeUtc ] )           0 leaves one alone
```

The two platforms have no common core worth the name: POSIX has nine mode bits plus setuid/setgid/sticky, an owner and a group; Windows has attribute flags plus a full discretionary ACL. Mapping either onto the other produces something wrong in both directions.

SetReadOnly is genuinely portable, but is NOT AN EXACT INVERSE on POSIX -- clearing restores the write bits subject to the current umask. Use GetPosixMode/SetPosixMode when you need exactness.

SetHidden is portable in name only: on POSIX hiddenness is a NAMING convention, so honouring it would mean RENAMING the file behind your back. It returns FS_UNSUPPORTED there instead.

THERE IS NO OWNER, GROUP OR ACL API. There is no portable subset beyond the read-only bit, and a partial ACL API is worse than none -- it invites code that looks portable and silently grants more than it meant to on one platform.

## Volumes

```freebasic
GetDiskSpace( p )      FsResultSpace
GetVolumeInfo( p )     FsResultVol
GetVolumes( vols )     FsResultLong; fills Array( of VolumeInfo )
```

p is ANY PATH ON THE VOLUME, not a volume name. The path must exist.

DiskSpace

```freebasic
.TotalBytes        capacity
.FreeBytes         free, IGNORING quota -- for reporting
.AvailableBytes    free TO THIS USER -- the one to branch on
```

AVAILABLEBYTES IS THE ONE TO USE. FreeBytes counts space you may not be permitted to consume: reserved blocks on ext4, a per-user quota on either platform. Where there is no quota the two are equal, which is why the distinction is invisible on a developer machine and bites in production.

All three are snapshots and are stale on return. A program that checks free space and then writes is racing every other process on the machine; the write's FS_NO_SPACE is the real answer.

VolumeInfo

```freebasic
.RootPath          "C:\", "/", "\\srv\share\"
.Name              the label. MAY BE EMPTY -- always is on Linux
.FileSystem        "NTFS", "ext4", "exFAT". May be empty.
.MaxComponentLen
.IsReadOnly
.IsCaseSensitive
.SupportsLinks
```

IsCaseSensitive IS PER-VOLUME and is NOT the same question as PathIsCaseSensitive( ), which is a compile-time per-platform constant. They disagree in two real cases: an NTFS directory with per-directory case sensitivity enabled (WSL sets this), and a case-insensitive filesystem mounted on Linux. Use PathIsCaseSensitive for LEXICAL comparison, which must be deterministic and must not do IO; use this one for "will these two names collide on this disk".

SupportsLinks is ASYMMETRIC: a FALSE is reliable, a TRUE is best-effort. Windows reports the filesystem's own flag; Linux has no portable probe, so everything but the FAT family and ISO 9660 is assumed able.

GetVolumes on Windows is the logical drives, skipping any reporting no media. On Linux there are no drives, only mount points, so it reads /proc/self/mountinfo and reports only filesystems backed by a real block device -- which filters proc, sysfs, cgroup and tmpfs. That is a judgement call: it will occasionally omit something you wanted, such as a network mount.

## Locking, Mapping AND Watching

Three subsystems that share nothing but a header.

FileLock -- advisory, whole-file

```freebasic
.Acquire( p [, exclusive ] [, timeoutMs ] )    FsResultBool
.Release( )
.IsHeld( )

timeoutMs < 0 waits indefinitely, 0 tries once, > 0 gives up with
FS_IN_USE. The destructor releases.
```

This is NOT the legacy LOCK/UNLOCK, which lock byte ranges of a file already open on an FB file number and cannot express "hold this file against another process".

IT IS ADVISORY EVERYWHERE, AND THAT IS THE CONTRACT. Windows LockFileEx is MANDATORY -- the kernel enforces it against every process. POSIX flock is ADVISORY -- it binds only processes that also ask. The only promise both platforms can keep is the weaker one, so ALL PARTICIPANTS MUST USE THIS API. Code written against the Windows behaviour silently protects nothing on Linux.

MemoryMappedFile

```freebasic
.Open( p [, writable ] )    FsResultBool
.Close( )
.Data( )                    uint8 ptr
.Size( )                    uint64
.IsOpen( )
.Flush( )                   FsResultBool
```

Data( ) is a RAW POINTER, which is the point -- the alternative is a copy, and a copy is ReadAllBytes. Three things no library can protect you from:

the pointer is INVALID after Close or destruction; ANOTHER PROCESS TRUNCATING THE FILE turns reads into a FAULT -- SIGBUS on

```freebasic
POSIX, a structured exception on Windows -- not an error return, which is
why mapping is not a drop-in replacement for reading;
```

mapping a file on a network share is permitted and is a good way to hang.

A ZERO-LENGTH FILE CANNOT BE MAPPED and reports FS_INVALID_PATH on both platforms, rather than handing back a pointer that cannot be dereferenced.

FileWatcher

```freebasic
.Start( p [, recursive ] )              FsResultBool
.Stop( )
.IsWatching( )
.Poll( changes, [ timeoutMs ] )         FsResultLong -- the count
```

FsChange

```freebasic
.Kind( )      FsChangeKind
.Path( )      the FULL path, not a bare leaf
```

FsChangeKind

```freebasic
FS_CHANGE_CREATED  FS_CHANGE_DELETED  FS_CHANGE_MODIFIED
FS_CHANGE_RENAMED_FROM  FS_CHANGE_RENAMED_TO  FS_CHANGE_OVERFLOW
```

POLLING, NOT CALLBACKS. A callback fires on the watcher's own thread, so every user immediately needs a queue and a lock and most get the threading wrong. Poll puts the events on YOUR thread. FreeBASIC has no async model to deliver into anyway.

A TIMEOUT IS AN EMPTY SUCCESS, not a failure -- "nothing happened" and "the watch broke" are different answers.

FS_CHANGE_OVERFLOW IS AN EVENT, NOT AN ERROR. Both platforms drop events under load, and every correct consumer must respond by RESCANNING. Modelling it as an error would let you ignore it.

RENAMES ARE TWO EVENTS. RENAMED_FROM and RENAMED_TO arrive as a pair, and a rename OUT of the watched tree produces only the first -- a single event carrying both paths could not represent that.

A single change may produce more than one event: writing a new file yields both CREATED and MODIFIED on Windows. Do not assume a count.

## The Rules That Are Easy To Get Wrong

A default-constructed FsResult is a FAILURE, not a success. Value( ) on a failure RAISES. IsOk( ) is the guard. Exists( ) is false for "denied" as well as "absent". Stat tells them apart. "C:dev" is NOT absolute. Neither is "\\dev". ".gitignore" has no extension; its stem is ".gitignore". PathJoin discards the left side when the right is absolute -- check

```freebasic
PathStartsWith if you need containment.
```

PathEquals is LEXICAL. Two paths naming one file compare unequal. PathNormalize resolves '..' lexically, which is not what the OS does through

```freebasic
a symlink.
```

Compare canonical paths with PathEquals, not '=' -- of the "\\\\?\\" prefix. The walk's element is a Result. Unwrap it, or you are not checking. Value( ) byref dies at the next MoveNext. Copy to keep. WalkDir does not follow directory symlinks unless you ask. RemoveDirAll unlinks a directory symlink; it does not descend it. A STRING path is UTF-8 and lossy. Legacy ANSI paths do not work. Paths that came from the filesystem are USTRING. Keep them that way. There is no auto "\\\\?\\" prefixing: paths over MAX_PATH are refused on

```freebasic
Windows, with FS_NAME_TOO_LONG and the native code preserved.
```

Free space is a snapshot and is stale on return. A FileLock is ADVISORY even on Windows, as far as this API promises.

## What Is NOT Here

Each was considered and excluded; rationale.md argues them.

Async / overlapped / promise-based IO. FreeBASIC has no async model, and

```freebasic
introducing one inside a filesystem library would be a language project
wearing a library's clothes.
```

A Path value type. Free functions over strings, Go-style -- a Path type would

```freebasic
have to pick one of STRING and USTRING and force a conversion at every
boundary with the other. It remains additive later.
```

A virtual filesystem abstraction. It needs an interface feature independent

```freebasic
of inheritance, which FreeBASIC does not have.
```

Archives and compression. Zip and tar are file FORMATS, not filesystem

```freebasic
operations, and share no code with this.
```

Recycle Bin / trash deletion. Shell APIs, COM-dependent, no POSIX

```freebasic
counterpart worth the name.
```

Extended attributes, alternate data streams, full ACLs. No portable subset

```freebasic
that means anything; NativeAttributes( ) is the escape hatch.
```

CreateJunction. Readable but not creatable -- CreateSymlink with

```freebasic
targetIsDir covers the portable need.
```

Any change to inc/file.bi, inc/dir.bi or the runtime's existing file routines.

## Implementation

inc/fb/fserror.bi      FsError, the codes, the result aliases inc/fb/fspath.bi       the path family inc/fb/fsinfo.bi       FileInfo, Stat, the resolvers inc/fb/fsdir.bi        DirEntry, the iterators, ReadDir, WalkDir inc/fb/fsops.bi        whole-file, bulk, atomic, temp inc/fb/fsglob.bi       MatchPattern, Glob inc/fb/fslink.bi       links, permissions, SetTimes, CopyOptions inc/fb/fsvolume.bi     DiskSpace, VolumeInfo inc/fb/fsadvanced.bi   FileLock, MemoryMappedFile, FileWatcher inc/fb/filesystem.bi   the umbrella

lib/rt/src/fs/path.bas     the path algebra: pure, portable, ONE copy,

```freebasic
both grammars always compiled
```

lib/rt/src/fs/glob.bas     the matcher: pure, portable, ITERATIVE lib/rt/src/fs/text.bas     the BOM and encoding rules, portable lib/rt/src/fs/errmsg.bas   the message table lib/rt/src/fs/dirent.bas   record-to-USTRING accessors, ABI size hooks lib/rt/src/fs/{error,stat,dir,ops,link,volume,lock,mmap,watch}.bas   each split by platform with #if

THE UNIT IS FB_UCHAR (UTF-16), NOT FB_WCHAR, which is 4 bytes on Linux -- building the kernel on it would silently change the path encoding depending on the host. Every struct crossing the C/FB boundary uses FIXED-WIDTH fields for the same reason: 'unsigned long' is 4 bytes on Windows and 8 on Linux while FreeBASIC's ULONG is 32-bit everywhere, and getting that wrong shifts every field after it.

The glob matcher is ITERATIVE, not recursive. A recursive matcher on a hostile pattern such as "a\*a\*a\*a\*a\*b" is exponential and will blow the stack.

Platform code is split BY #if, one file per area. fbc keeps the same filename in win32/ and unix/, but tiko-rt's build has no per-target source selection, so error, stat, dir, ops, link, volume, lock, mmap and watch each hold a Windows half and a POSIX half. The path and glob grammars are the exception -- they take the grammar as a PARAMETER so both are testable on either host.

## Tests

tests/vendor/fbc-tests/filesystem/     fbc's own nine fbcunit suites, vendored in tiko-lang

```freebasic
fspath_core     one block per numbered path rule, every case run under
                BOTH grammars regardless of host
fserror_codes   the FB enum cross-checked against its C constants
fsinfo_dir      Stat, the kinds, and the interleaved-scan test the legacy
                DIR cannot pass
fsops_walk      the encoding rules, the bulk operations, the walk
fsglob          one block per glob rule, plus the pathological pattern
fslink          links, permissions, and the two destructive rules
fsvolume        invariants, plus the one ground-truth check
fsadvanced      locking, mapping, watching
fsstrings       the whole STRING overload layer
```

Under tiko, all 9 match fbc (build/suiterun.sh, which builds each suite with both compilers and compares the results tables; measured 2026-09-24 at origin/master 50c71751).

README.md records what is deliberately NOT asserted and why -- among them that a truncating writer faults a live mapping, and cross-process lock exclusion.

## Dialects

-lang fb only. The library uses namespaces, and fb/fserror.bi says so with an #error in the other dialects rather than failing obscurely later.

## API reference

One page per entry, 139 in all:

[AppendAllText](Modern-Fs-AppendAllText) · [CopyDir](Modern-Fs-CopyDir) · [CopyFile](Modern-Fs-CopyFile) · [CopySymlinksAsLinks](Modern-Fs-CopySymlinksAsLinks) · [CreateDir](Modern-Fs-CreateDir) · [CreateDirAll](Modern-Fs-CreateDirAll) · [CreateHardLink](Modern-Fs-CreateHardLink) · [CreateSymlink](Modern-Fs-CreateSymlink) · [CreateTempDir](Modern-Fs-CreateTempDir) · [CreateTempFile](Modern-Fs-CreateTempFile) · [DirEntry.Depth](Modern-Fs-DirEntry-Depth) · [DirEntry.DirIterator](Modern-Fs-DirEntry-DirIterator) · [DirEntry.FollowSymlinks](Modern-Fs-DirEntry-FollowSymlinks) · [DirEntry.IncludeHidden](Modern-Fs-DirEntry-IncludeHidden) · [DirEntry.Info](Modern-Fs-DirEntry-Info) · [DirEntry.IsDirectory](Modern-Fs-DirEntry-IsDirectory) · [DirEntry.IsFile](Modern-Fs-DirEntry-IsFile) · [DirEntry.IsOther](Modern-Fs-DirEntry-IsOther) · [DirEntry.IsSymlink](Modern-Fs-DirEntry-IsSymlink) · [DirEntry.IsValid](Modern-Fs-DirEntry-IsValid) · [DirEntry.MaxDepth](Modern-Fs-DirEntry-MaxDepth) · [DirEntry.MoveNext](Modern-Fs-DirEntry-MoveNext) · [DirEntry.Name](Modern-Fs-DirEntry-Name) · [DirEntry.Path](Modern-Fs-DirEntry-Path) · [DirEntry.StopOnError](Modern-Fs-DirEntry-StopOnError) · [DirEntry.Value](Modern-Fs-DirEntry-Value) · [DirEntry.WalkIterator](Modern-Fs-DirEntry-WalkIterator) · [DirEntry.YieldDirectories](Modern-Fs-DirEntry-YieldDirectories) · [DiskSpace.AvailableBytes](Modern-Fs-DiskSpace-AvailableBytes) · [DiskSpace.FreeBytes](Modern-Fs-DiskSpace-FreeBytes) · [DiskSpace.TotalBytes](Modern-Fs-DiskSpace-TotalBytes) · [Exists](Modern-Fs-Exists) · [FileInfo.AbsolutePath](Modern-Fs-FileInfo-AbsolutePath) · [FileInfo.AccessedUtc](Modern-Fs-FileInfo-AccessedUtc) · [FileInfo.CanonicalPath](Modern-Fs-FileInfo-CanonicalPath) · [FileInfo.CreatedUtc](Modern-Fs-FileInfo-CreatedUtc) · [FileInfo.CurrentDir](Modern-Fs-FileInfo-CurrentDir) · [FileInfo.Exists](Modern-Fs-FileInfo-Exists) · [FileInfo.HasAccessed](Modern-Fs-FileInfo-HasAccessed) · [FileInfo.HasCreated](Modern-Fs-FileInfo-HasCreated) · [FileInfo.IsDirectory](Modern-Fs-FileInfo-IsDirectory) · [FileInfo.IsFile](Modern-Fs-FileInfo-IsFile) · [FileInfo.IsHidden](Modern-Fs-FileInfo-IsHidden) · [FileInfo.IsOther](Modern-Fs-FileInfo-IsOther) · [FileInfo.IsReadOnly](Modern-Fs-FileInfo-IsReadOnly) · [FileInfo.IsSymlink](Modern-Fs-FileInfo-IsSymlink) · [FileInfo.ModifiedUtc](Modern-Fs-FileInfo-ModifiedUtc) · [FileInfo.NativeAttributes](Modern-Fs-FileInfo-NativeAttributes) · [FileInfo.SetCurrentDir](Modern-Fs-FileInfo-SetCurrentDir) · [FileInfo.Size](Modern-Fs-FileInfo-Size) · [FileLock.Acquire](Modern-Fs-FileLock-Acquire) · [FileLock.IsHeld](Modern-Fs-FileLock-IsHeld) · [FileLock.Release](Modern-Fs-FileLock-Release) · [FileWatcher.IsWatching](Modern-Fs-FileWatcher-IsWatching) · [FileWatcher.Poll](Modern-Fs-FileWatcher-Poll) · [FileWatcher.Start](Modern-Fs-FileWatcher-Start) · [FileWatcher.Stop](Modern-Fs-FileWatcher-Stop) · [FsChange.Kind](Modern-Fs-FsChange-Kind) · [FsChange.Path](Modern-Fs-FsChange-Path) · [FsError.Code](Modern-Fs-FsError-Code) · [FsError.Message](Modern-Fs-FsError-Message) · [FsError.Operation](Modern-Fs-FsError-Operation) · [FsError.OsCode](Modern-Fs-FsError-OsCode) · [FsError.Path](Modern-Fs-FsError-Path) · [FsError.Path2](Modern-Fs-FsError-Path2) · [GetDiskSpace](Modern-Fs-GetDiskSpace) · [GetPosixMode](Modern-Fs-GetPosixMode) · [GetVolumeInfo](Modern-Fs-GetVolumeInfo) · [GetVolumes](Modern-Fs-GetVolumes) · [GetWin32Attributes](Modern-Fs-GetWin32Attributes) · [Glob](Modern-Fs-Glob) · [GlobRoot](Modern-Fs-GlobRoot) · [IsDir](Modern-Fs-IsDir) · [IsFile](Modern-Fs-IsFile) · [IsLink](Modern-Fs-IsLink) · [LinkCount](Modern-Fs-LinkCount) · [ListDir](Modern-Fs-ListDir) · [LStat](Modern-Fs-LStat) · [MatchPattern](Modern-Fs-MatchPattern) · [MemoryMappedFile.Close](Modern-Fs-MemoryMappedFile-Close) · [MemoryMappedFile.Data](Modern-Fs-MemoryMappedFile-Data) · [MemoryMappedFile.Flush](Modern-Fs-MemoryMappedFile-Flush) · [MemoryMappedFile.IsOpen](Modern-Fs-MemoryMappedFile-IsOpen) · [MemoryMappedFile.Open](Modern-Fs-MemoryMappedFile-Open) · [MemoryMappedFile.Size](Modern-Fs-MemoryMappedFile-Size) · [MoveFile](Modern-Fs-MoveFile) · [NativeAttributes](Modern-Fs-NativeAttributes) · [Overwrite](Modern-Fs-Overwrite) · [PathChangeExtension](Modern-Fs-PathChangeExtension) · [PathEquals](Modern-Fs-PathEquals) · [PathExtension](Modern-Fs-PathExtension) · [PathFileName](Modern-Fs-PathFileName) · [PathHasExtension](Modern-Fs-PathHasExtension) · [PathIsAbsolute](Modern-Fs-PathIsAbsolute) · [PathIsCaseSensitive](Modern-Fs-PathIsCaseSensitive) · [PathIsRoot](Modern-Fs-PathIsRoot) · [PathJoin](Modern-Fs-PathJoin) · [PathNextComponent](Modern-Fs-PathNextComponent) · [PathNormalize](Modern-Fs-PathNormalize) · [PathParent](Modern-Fs-PathParent) · [PathRelativeTo](Modern-Fs-PathRelativeTo) · [PathRoot](Modern-Fs-PathRoot) · [PathRootLen](Modern-Fs-PathRootLen) · [PathSeparator](Modern-Fs-PathSeparator) · [PathSplit](Modern-Fs-PathSplit) · [PathStartsWith](Modern-Fs-PathStartsWith) · [PathStem](Modern-Fs-PathStem) · [PathToNative](Modern-Fs-PathToNative) · [PatternIsRecursive](Modern-Fs-PatternIsRecursive) · [PatternWildcardAt](Modern-Fs-PatternWildcardAt) · [PreservePermissions](Modern-Fs-PreservePermissions) · [PreserveTimestamps](Modern-Fs-PreserveTimestamps) · [ReadAllBytes](Modern-Fs-ReadAllBytes) · [ReadAllLines](Modern-Fs-ReadAllLines) · [ReadAllText](Modern-Fs-ReadAllText) · [ReadDir](Modern-Fs-ReadDir) · [ReadLink](Modern-Fs-ReadLink) · [RemoveDir](Modern-Fs-RemoveDir) · [RemoveDirAll](Modern-Fs-RemoveDirAll) · [RemoveFile](Modern-Fs-RemoveFile) · [ReplaceFile](Modern-Fs-ReplaceFile) · [SetHidden](Modern-Fs-SetHidden) · [SetPosixMode](Modern-Fs-SetPosixMode) · [SetReadOnly](Modern-Fs-SetReadOnly) · [SetTimes](Modern-Fs-SetTimes) · [SetWin32Attributes](Modern-Fs-SetWin32Attributes) · [Stat](Modern-Fs-Stat) · [TempDir](Modern-Fs-TempDir) · [VolumeInfo.FileSystem](Modern-Fs-VolumeInfo-FileSystem) · [VolumeInfo.IsCaseSensitive](Modern-Fs-VolumeInfo-IsCaseSensitive) · [VolumeInfo.IsReadOnly](Modern-Fs-VolumeInfo-IsReadOnly) · [VolumeInfo.MaxComponentLen](Modern-Fs-VolumeInfo-MaxComponentLen) · [VolumeInfo.Name](Modern-Fs-VolumeInfo-Name) · [VolumeInfo.RootPath](Modern-Fs-VolumeInfo-RootPath) · [VolumeInfo.SupportsLinks](Modern-Fs-VolumeInfo-SupportsLinks) · [WalkDir](Modern-Fs-WalkDir) · [WriteAllBytes](Modern-Fs-WriteAllBytes) · [WriteAllText](Modern-Fs-WriteAllText) · [WriteAtomic](Modern-Fs-WriteAtomic)

---

**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
