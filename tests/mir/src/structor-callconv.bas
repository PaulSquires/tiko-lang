'' A CALLING CONVENTION SITS WHERE A CONSTRUCTOR'S NAME WOULD BE, and a constructor has
'' no name. 'declare constructor __thiscall ( )' is legal -- so are cdecl, stdcall and
'' pascal, all four measured against fbc -- and the name reader accepts ANY keyword, so
'' it took the convention as the name and then as the OWNER: '__thiscall does not name a
'' type here'. The file is lost from that line on.
''
'' ALIAS sits in the same place for the same reason, which is what
'' structs/ctor_alias.bas writes: 'declare constructor cdecl alias "init"( )'.
type A
    value as long
    declare constructor __thiscall ( )
    declare destructor __thiscall ( )
end type
constructor A ( ) : end constructor
destructor A ( ) : end destructor

type B
    value as long
    declare constructor cdecl alias "b_init" ( )
    declare destructor stdcall alias "b_done" ( )
end type
constructor B ( ) : end constructor
destructor B ( ) : end destructor

type C
    value as long
    declare constructor pascal ( )
end type
constructor C ( ) : end constructor

sub go( )
    dim as A va
    dim as B vb
    dim as C vc
    print va.value; vb.value; vc.value
end sub
go( )
