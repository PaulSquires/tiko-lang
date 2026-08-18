'' manager.bas -- see manager.bi

#include once "source/manager.bi"
#include once "fb/filesystem.bi"

namespace Fbx

'' ------------------------------------------------------------------ location.bi

function MakeRange( byval f as SourceLoc, byval l as SourceLoc ) as SourceRange
    dim as SourceRange r
    r.first = f
    r.last = l
    return r
end function

function PointRange( byval at as SourceLoc ) as SourceRange
    return MakeRange( at, at )
end function

'' -------------------------------------------------------------------- lifetime

constructor SourceManager( )
    this.names = 0
    this.nextBase = 1               '' 0 stays reserved for LOC_NONE
end constructor

sub SourceManager.Attach( byval it as Interner ptr )
    this.names = it
end sub

destructor SourceManager( )
    for each f as SourceFile ptr in this.files
        delete f
    next
    this.files.Clear( )
end destructor

function SourceManager.Count( ) as long
    return this.files.Count
end function

function SourceManager.FileAt( byval id as FileId ) as SourceFile ptr
    if id = FILE_NONE then return 0
    dim as long idx = cast( long, id ) - 1
    if idx >= this.files.Count then return 0
    return this.files[idx]
end function

function SourceManager.PathOf( byval id as FileId ) as string
    dim as SourceFile ptr f = this.FileAt( id )
    if f = 0 then return "<none>"
    return this.names->Spelling( f->displayPath )
end function

function SourceManager.TotalBytes( ) as longint
    dim as longint total = 0
    for each f as SourceFile ptr in this.files
        total += f->text.Count
    next
    return total
end function

'' --------------------------------------------------------------------- loading

function SourceManager.Find( byref absPath as ustring ) as FileId
    dim as InternId want = this.names->GetString( Fbx.Text.UStringToUtf8( absPath ) )
    dim as long n = this.files.Count
    for i as long = 0 to n - 1
        if this.files[i]->path = want then return cast( FileId, i + 1 )
    next
    return FILE_NONE
end function

private sub BuildLineIndex( byval f as SourceFile ptr )
    f->lineStarts.Clear( )
    f->lineStarts.Push( 0 )

    dim as long n = f->text.Count
    dim as long i = 0
    while i < n
        if f->text[i] = 10 then                 '' LF ends a line; a preceding CR
            f->lineStarts.Push( i + 1 )         '' belongs to the line it terminates
        end if
        i += 1
    wend
end sub

function SourceManager.Adopt _
    ( byref absPath as ustring, byref shownPath as ustring, _
      byref raw as ByteBuf, byval isVirt as boolean ) as FileId

    dim as SourceFile ptr f = new SourceFile

    f->path = this.names->GetString( Fbx.Text.UStringToUtf8( absPath ) )
    f->displayPath = this.names->GetString( Fbx.Text.UStringToUtf8( shownPath ) )
    f->isVirtual = isVirt

    dim as long rawCount = raw.Count
    dim as const ubyte ptr rawPtr = 0
    if rawCount > 0 then rawPtr = @raw[0]

    f->encoding = Fbx.Text.DetectEncoding( rawPtr, rawCount )
    f->firstBadByte = -1
    if f->encoding = Fbx.Text.ENC_BYTES then
        f->firstBadByte = Fbx.Text.FirstInvalidUtf8( rawPtr, rawCount )
    end if
    Fbx.Text.NormalizeToUtf8( raw, f->text, f->encoding )

    dim as long n = f->text.Count
    if n > 0 then
        f->contentHash = HashBytes( @f->text[0], n )
    else
        f->contentHash = 0
    end if

    '' The index is built here rather than lazily: the bytes were just written and
    '' are still cache-warm, and it is one linear pass. (docs/plan/03 says lazily;
    '' this is a deliberate, measured deviation, recorded in docs/internals.)
    BuildLineIndex( f )

    f->locBase = this.nextBase
    '' +1 so the file owns a location one past its last byte, for "at end of file".
    this.nextBase += cast( SourceLoc, n + 1 )

    this.files.Push( f )
    return cast( FileId, this.files.Count )
end function

function SourceManager.LoadFile _
    ( byref path as ustring, byref errOut as ustring ) as FileId

    errOut = ""

    dim as FB.FsResultUStr abs_ = FB.AbsolutePath( path )
    dim as ustring absPath = path
    if abs_.IsOk( ) then absPath = FB.PathNormalize( abs_.Value( ) )

    dim as FileId already = this.Find( absPath )
    if already <> FILE_NONE then return already

    dim as ByteBuf raw
    dim as FB.FsResultI64 r = FB.ReadAllBytes( absPath, raw )
    if r.IsOk( ) = false then
        errOut = r.Failure( ).Message( )
        return FILE_NONE
    end if

    return this.Adopt( absPath, path, raw, false )
end function

function SourceManager.AddVirtual _
    ( byref shownName as ustring, byref content as string ) as FileId

    dim as ByteBuf raw
    dim as long n = len( content )
    raw.Reserve( n )
    for i as long = 0 to n - 1
        raw.Push( cast( ubyte, content[i] ) )
    next

    return this.Adopt( shownName, shownName, raw, true )
end function

'' ------------------------------------------------------------------- locations

function SourceManager.LocFor( byval id as FileId, byval offset as long ) as SourceLoc
    dim as SourceFile ptr f = this.FileAt( id )
    if f = 0 then return LOC_NONE
    if offset < 0 then offset = 0
    if offset > f->text.Count then offset = f->text.Count
    return f->locBase + cast( SourceLoc, offset )
end function

function SourceManager.Decode( byval loc as SourceLoc ) as DecodedLoc
    dim as DecodedLoc d
    d.file = FILE_NONE
    d.lineNo = 0
    d.column = 0
    d.offset = 0
    if loc = LOC_NONE then return d

    '' Binary search for the file whose range contains loc. Files are appended in
    '' increasing base order, so the array is already sorted.
    dim as long lo = 0, hi = this.files.Count - 1, found = -1
    while lo <= hi
        dim as long midIdx = (lo + hi) \ 2
        dim as SourceFile ptr f = this.files[midIdx]
        dim as SourceLoc last = f->locBase + cast( SourceLoc, f->text.Count )
        if loc < f->locBase then
            hi = midIdx - 1
        elseif loc > last then
            lo = midIdx + 1
        else
            found = midIdx
            exit while
        end if
    wend
    if found < 0 then return d

    dim as SourceFile ptr f = this.files[found]
    dim as long off = cast( long, loc - f->locBase )
    d.file = cast( FileId, found + 1 )
    d.offset = off

    '' Binary search the line index for the last start <= off.
    lo = 0
    hi = f->lineStarts.Count - 1
    dim as long lineIdx = 0
    while lo <= hi
        dim as long midIdx = (lo + hi) \ 2
        if f->lineStarts[midIdx] <= off then
            lineIdx = midIdx
            lo = midIdx + 1
        else
            hi = midIdx - 1
        end if
    wend

    d.lineNo = lineIdx + 1
    dim as const ubyte ptr textBase = 0
    if f->text.Count > 0 then textBase = @f->text[0]
    d.column = Fbx.Text.ColumnOf( textBase, f->lineStarts[lineIdx], off )
    return d
end function

'' ----------------------------------------------------------------------- lines

function SourceManager.LineCount( byval id as FileId ) as long
    dim as SourceFile ptr f = this.FileAt( id )
    if f = 0 then return 0
    return f->lineStarts.Count
end function

function SourceManager.ContentLineCount( byval id as FileId ) as long
    dim as SourceFile ptr f = this.FileAt( id )
    if f = 0 then return 0
    dim as long n = f->lineStarts.Count
    dim as boolean endsWithEol = (f->text.Count > 0) andalso _
                                 (f->text[f->text.Count - 1] = 10)
    if endsWithEol andalso (n > 1) then n -= 1
    return n
end function

function SourceManager.LineStart( byval id as FileId, byval lineNo as long ) as long
    dim as SourceFile ptr f = this.FileAt( id )
    if f = 0 then return 0
    dim as boolean bad = (lineNo < 1) orelse (lineNo > f->lineStarts.Count)
    if bad then return 0
    return f->lineStarts[lineNo - 1]
end function

function SourceManager.LineLength( byval id as FileId, byval lineNo as long ) as long
    dim as SourceFile ptr f = this.FileAt( id )
    if f = 0 then return 0
    dim as boolean bad = (lineNo < 1) orelse (lineNo > f->lineStarts.Count)
    if bad then return 0

    dim as long first = f->lineStarts[lineNo - 1]
    dim as long stop_ = f->text.Count
    if lineNo < f->lineStarts.Count then stop_ = f->lineStarts[lineNo]

    '' Trim the terminator so callers get the line, not the line plus its newline.
    while stop_ > first
        dim as ubyte b = f->text[stop_ - 1]
        dim as boolean isEol = (b = 10) orelse (b = 13)
        if isEol = false then exit while
        stop_ -= 1
    wend
    return stop_ - first
end function

function SourceManager.LineText( byval id as FileId, byval lineNo as long ) as string
    dim as SourceFile ptr f = this.FileAt( id )
    if f = 0 then return ""
    dim as long first = this.LineStart( id, lineNo )
    dim as long n = this.LineLength( id, lineNo )
    if n <= 0 then return ""

    dim as string r = space( n )
    memcpy( strptr( r ), @f->text[first], n )
    return r
end function

end namespace
