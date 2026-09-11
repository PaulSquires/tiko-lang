#lang "fb"

'' A virtual override DECLARED and never defined still fills a vtable slot.
type T extends object
    declare virtual sub v( )
end type

sub T.v( )
end sub

type Q extends T
    declare virtual sub v( ) override
end type

dim as T obj
obj.v( )
