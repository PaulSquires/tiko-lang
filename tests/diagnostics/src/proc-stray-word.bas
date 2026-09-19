'' A WORD BETWEEN A PROCEDURE'S NAME AND ITS PARAMETERS THAT IS NO MODIFIER is fbc's
'' error 3, "Expected End-of-Line". 'thiscall' and 'fastcall' are not conventions to
'' fbc -- '__thiscall' and '__fastcall' are -- so spelled plain they are a stray word like
'' any other. Each is refused on exactly the line fbc-modern 1.20 and 1.10.1 refuse it
'' (2026-09-19); tiko-lang accepted them all, and read the procedure as taking nothing.

declare sub sw1 thiscall( byval a as long )
declare sub sw2 fastcall( byval a as long )
declare sub sw3 junkword( byval a as long )
sub sw4 thiscall( byval a as long )
end sub
declare sub sw5 thiscall overload( byval a as long )
declare sub sw6 alias "sw6x" junk( byval a as long )
declare sub sw7 thiscall
type TSW
    x as long
    declare sub m thiscall( )
end type

'' ACCEPTED: the double-underscore conventions, NAKED, and OVERRIDE with no list.
declare sub ok1 __thiscall( byval a as long )
declare sub ok2 __fastcall( byval a as long )
sub ok3 __thiscall( byval a as long )
end sub
sub ok4 naked cdecl( )
end sub
type OkB extends object
    declare virtual sub m
end type
type OkD extends OkB
    declare sub m override
end type
