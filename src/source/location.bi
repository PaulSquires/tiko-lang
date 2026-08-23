'' location.bi -- source locations.
''
'' A SourceLoc is ONE 32-bit integer indexing a global offset space that the
'' SourceManager partitions between loaded files (docs/plan/03 section 3). Every AST
'' node and every MIR instruction stores one, so 4 bytes versus a (file, line, column)
'' triple is the difference between a compact IR and a bloated one.
''
'' Decoding a location is a binary search over file ranges plus a binary search over
'' that file's line-start index -- paid only when a diagnostic is actually rendered.
''
'' Invariants:
''   - 0 is LOC_NONE and belongs to no file.
''   - Each file owns [base, base + size]; the extra final slot is its EOF position,
''     so a diagnostic can point one past the last byte.
''   - Offsets are into the NORMALISED UTF-8 buffer, never the original file bytes.

#ifndef __TKO_LOCATION_BI__
#define __TKO_LOCATION_BI__

#include once "tko.bi"

namespace Tko

    type SourceLoc as ulong

    const LOC_NONE as SourceLoc = 0

    type SourceRange
        as SourceLoc first
        as SourceLoc last          '' inclusive; equal to first for a point range
    end type

    type DecodedLoc
        as FileId file
        as long   lineNo           '' 1-based
        as long   column           '' 1-based, display columns (tabs expanded)
        as long   offset           '' byte offset within the file's buffer
    end type

    declare function MakeRange _
        ( byval f as SourceLoc, byval l as SourceLoc ) as SourceRange

    declare function PointRange( byval at as SourceLoc ) as SourceRange

end namespace

#endif
