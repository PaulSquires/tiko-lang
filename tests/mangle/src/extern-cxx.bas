#lang "fb"

extern "C++"
    sub g1 overload( byval p as function cdecl( ) as integer )
    end sub
    sub g1 overload( byval p as function cdecl( ) byref as integer )
    end sub
    sub g2( byval n as integer )
    end sub
    namespace nn
        sub g4( )
        end sub
    end namespace
end extern

sub h( byval n as integer )
end sub
