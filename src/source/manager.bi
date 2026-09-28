'' manager.bi -- the source manager: owns every byte of input.
''
'' Responsibilities (docs/plan/03 section 1): load files, detect and normalise their
'' encoding, hand out FileIds, own the location offset space, and answer the
'' (loc -> file/line/column) and (file/line -> text) questions diagnostics need.
''
'' Nothing else in the compiler opens a file for reading source.
''
'' Invariants:
''   - A SourceFile's address is stable for the manager's lifetime. Files are held by
''     pointer, not by value, so growing the file list never moves a buffer.
''   - lineStarts[0] is always 0, and lineStarts is strictly increasing.
''   - Every file's bytes are valid UTF-8 or preserved-verbatim bytes; nothing else.

#ifndef __TKO_SOURCE_MANAGER_BI__
#define __TKO_SOURCE_MANAGER_BI__

#include once "tko.bi"
#include once "source/location.bi"
#include once "support/intern.bi"
#include once "support/text.bi"

namespace Tko

    type LongVec as FB.Array( of long )

    '' ONE '#line' DIRECTIVE. It renumbers from its own physical line, so the line
    '' the directive sits on becomes 'shownLine' and the next is 'shownLine + 1' --
    '' measured, not assumed: '#line 100' on physical line 5 makes physical line 6
    '' report 101. 'shownName' is never INTERN_NONE; a '#line' with no string
    '' inherits the name in force, which is the previous mark's or the file's own.
    type LineMark
        as long     physLine
        as long     shownLine
        as InternId shownName
    end type

    type LineMarkVec as FB.Array( of LineMark )

    type SourceFile
        as InternId        path          '' absolute, normalised -- the identity
        as InternId        displayPath   '' as the user wrote it -- for diagnostics
        as ByteBuf         text          '' normalised UTF-8
        as LongVec         lineStarts    '' byte offset of each line; [0] = 0
        as Tko.Text.Encoding encoding
        as SourceLoc       locBase       '' first location owned by this file
        as ulong           contentHash   '' for future incremental compilation
        as boolean         isVirtual     '' created from memory, not from disk
        as long            firstBadByte  '' offset of the first invalid UTF-8 byte, or -1
        as LineMarkVec     lineMarks     '' '#line' directives, by increasing physLine
    end type

    type FileVec as FB.Array( of SourceFile ptr )

    type SourceManager
        as FileVec    files
        as SourceLoc  nextBase
        as Interner ptr names           '' borrowed; owned by CompilerContext

        '' Default-constructed, then attached. Members of CompilerContext need a
        '' default constructor, and Attach lets the context wire itself up in
        '' declaration order without pointers-to-heap.
        declare constructor( )
        declare destructor( )
        declare sub Attach( byval it as Interner ptr )

        '' Load from disk. Returns FILE_NONE on failure and fills errOut with a
        '' human-readable reason taken from FsError.
        declare function LoadFile _
            ( byref path as ustring, byref errOut as ustring ) as FileId

        '' Register in-memory content. Used by the test runner and by future
        '' generated sources; behaves identically to a loaded file thereafter.
        declare function AddVirtual _
            ( byref shownName as ustring, byref content as string ) as FileId

        '' A FILE'S UNSAVED TEXT, standing in for the file: loaded under the file's own
        '' absolute path and NOT virtual, so a same-directory '#include' resolves from its
        '' folder and a header including it by path finds this copy. What an editor scans.
        declare function AddBuffer _
            ( byref path as ustring, byref content as string ) as FileId

        declare function FileAt( byval id as FileId ) as SourceFile ptr
        declare function Count( ) as long

        '' Already-loaded lookup by absolute path; FILE_NONE if not loaded.
        declare function Find( byref absPath as ustring ) as FileId

        declare function LocFor( byval id as FileId, byval offset as long ) as SourceLoc
        declare function Decode( byval loc as SourceLoc ) as DecodedLoc

        declare function LineCount( byval id as FileId ) as long

        '' LineCount counts index entries, so a file ending in a newline has one
        '' more than it has lines of text. This is what a user should be shown.
        declare function ContentLineCount( byval id as FileId ) as long
        declare function LineStart( byval id as FileId, byval lineNo as long ) as long
        declare function LineLength( byval id as FileId, byval lineNo as long ) as long
        declare function LineText( byval id as FileId, byval lineNo as long ) as string

        declare function PathOf( byval id as FileId ) as string
        '' The ABSOLUTE, normalised path -- the file's identity, where PathOf is the
        '' path as the user wrote it. A tool that must OPEN the file (an editor
        '' reading --diagnostics-file) needs this one; "" for no file.
        declare function AbsPathOf( byval id as FileId ) as string

        '' Record a '#line'. Re-scanning a file (an include pulled in twice without a
        '' guard) must not stack duplicates, so a mark on a line already marked
        '' REPLACES it. Pass hasName = false to inherit the name in force.
        declare sub AddLineMark _
            ( byval id as FileId, byval physLine as long, byval shownLine as long, _
              byval shownName as InternId, byval hasName as boolean )

        '' The name a decoded location should be PRINTED under -- the file's own
        '' unless a '#line' renamed it.
        declare function ShownPathOf( byref d as DecodedLoc ) as string
        '' Did this come from the BUILTIN PRELUDE? The prelude is real source and is
        '' declared like everything else, but it is not what the user wrote, and a dump
        '' that listed its thirty declarations under every file would bury the file.
        declare function IsBuiltin( byval loc as SourceLoc ) as boolean
        declare function TotalBytes( ) as longint

        private:
        declare function Adopt _
            ( byref absPath as ustring, byref shownPath as ustring, _
              byref raw as ByteBuf, byval isVirt as boolean ) as FileId
    end type

end namespace

#endif
