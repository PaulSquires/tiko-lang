'' arena.bas -- see arena.bi

#include once "support/arena.bi"

namespace Fbx

destructor ByteArena( )
    this.Free( )
end destructor

sub ByteArena.Free( )
    for each b as any ptr in this.blocks
        deallocate( b )
    next
    this.blocks.Clear( )
    this.cur = 0
    this.remaining = 0
    this.reserved = 0
    this.used = 0
end sub

function ByteArena.BlockCount( ) as long
    return this.blocks.Count
end function

function ByteArena.Alloc _
    ( byval n as long, byval alignment as long = 8 ) as ubyte ptr

    if n <= 0 then n = 1

    '' Round the bump pointer up to the requested alignment before measuring fit,
    '' so a request can never straddle the end of a block.
    dim as uinteger addr = cast( uinteger, this.cur )
    dim as uinteger misalign = addr and cast( uinteger, alignment - 1 )
    dim as long pad = 0
    if misalign <> 0 then pad = alignment - cast( long, misalign )

    if pad + n > this.remaining then
        dim as long blockBytes = ARENA_BLOCK_BYTES
        if n + alignment > blockBytes then blockBytes = n + alignment

        dim as ubyte ptr blk = callocate( blockBytes )
        if blk = 0 then
            print "fbx: internal error: out of memory allocating "; blockBytes; " bytes"
            end EXIT_ICE
        end if
        this.blocks.Push( blk )
        this.reserved += blockBytes
        this.cur = blk
        this.remaining = blockBytes

        addr = cast( uinteger, this.cur )
        misalign = addr and cast( uinteger, alignment - 1 )
        pad = 0
        if misalign <> 0 then pad = alignment - cast( long, misalign )
    end if

    dim as ubyte ptr result = this.cur + pad
    this.cur = result + n
    this.remaining -= (pad + n)
    this.used += n
    return result
end function

function ByteArena.AllocCopy _
    ( byval src as const ubyte ptr, byval n as long ) as ubyte ptr

    dim as ubyte ptr dst = this.Alloc( n, 1 )
    if n > 0 then memcpy( dst, src, n )
    return dst
end function

end namespace
