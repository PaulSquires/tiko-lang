'' arena.bi -- block-allocated byte arena.
''
'' The compiler's rule is that nothing in a hot path performs a small heap allocation
'' (docs/plan/14 section 1). Typed node storage uses FB.Array directly; this arena is
'' for variable-size blobs whose ADDRESS must stay stable: interned identifier bytes,
'' diagnostic message text, captured token spellings.
''
'' Invariants:
''   - A pointer returned by Alloc stays valid until Free( ). Blocks are never
''     reallocated, only appended, which is what makes stable addresses possible.
''   - Alloc never returns null; exhaustion is fatal, not a return code.

#ifndef __FBX_ARENA_BI__
#define __FBX_ARENA_BI__

#include once "fbx.bi"

namespace Fbx

    const ARENA_BLOCK_BYTES as long = 65536

    type BlockVec as FB.Array( of any ptr )

    type ByteArena
        as BlockVec  blocks
        as ubyte ptr cur           '' bump pointer into the newest block
        as long      remaining     '' bytes left in the newest block
        as longint   reserved      '' total bytes obtained from the allocator
        as longint   used          '' total bytes handed out, excluding padding

        declare destructor( )

        '' Alignment must be a power of two.
        declare function Alloc _
            ( byval n as long, byval alignment as long = 8 ) as ubyte ptr

        '' Copy n bytes into the arena and return the copy.
        declare function AllocCopy _
            ( byval src as const ubyte ptr, byval n as long ) as ubyte ptr

        declare sub Free( )
        declare function BlockCount( ) as long
    end type

end namespace

#endif
