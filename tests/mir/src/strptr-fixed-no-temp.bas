'' STRPTR OF A FIXED-LENGTH STRING IS ITS STORAGE, not a borrowed descriptor. tracks'
'' socket thread calls 'recv( sock, strptr( temp_buffer ), ... )' on a local
'' 'string * 8192' in a loop; every call took a slot from the runtime's 256-slot
'' temporary-descriptor pool and none was given back, so live market data emptied every
'' temporary string within seconds and the TWS connection dropped. Measured, fbc passes
'' the address for all four spellings in Shapes, and for the direct argument as well.
function TakeZ( byval z as zstring ptr ) as long
    if( z = 0 ) then return -1
    return 0
end function

type Holder
    as long        n
    as string * 16 fs
end type

sub Shapes( )
    dim zs as zstring * 32
    dim fs as string * 32
    dim h as Holder
    print TakeZ( strptr( zs ) ); TakeZ( strptr( fs ) ); TakeZ( strptr( h.fs ) ); TakeZ( sadd( fs ) )
    print TakeZ( fs )
end sub

'' The tracks shape: one strptr per loop pass, far past the pool's 256 slots.
sub SocketLoop( )
    dim temp_buffer as string * 8192
    dim as long bad = 0
    for n as long = 1 to 3000
        if( TakeZ( strptr( temp_buffer ) ) < 0 ) then bad += 1
    next
    print "null buffers"; bad; " pool alive"; len( str( 12345 ) )
end sub

Shapes( )
SocketLoop( )
